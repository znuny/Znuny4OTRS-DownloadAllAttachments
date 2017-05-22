# --
# Kernel/Modules/AgentTicketDownloadAllAttachments.pm - to download multiple attachments as one zip file
# Copyright (C) 2012-2015 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketDownloadAllAttachments;

use strict;
use warnings;

use Encode;
use Archive::Zip qw( :ERROR_CODES );
use Kernel::System::FileTemp;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # check all needed objects
    for (qw(TicketObject ParamObject LayoutObject ConfigObject LogObject EncodeObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %GetParam;
    for my $Param (qw(TicketID ArticleID Subaction)) {

        $GetParam{$Param} = $Self->{ParamObject}->GetParam( Param => $Param );
    }

    if (
        !$GetParam{TicketID}
        && !$GetParam{ArticleID}
        )
    {
        $Self->{LayoutObject}->FatalError(
            Message => "Need TicketID or ArticleID!",
        );
    }

    my %Article;
    my $TicketID;

    #Article ID passed, but no TicketID. Use this API call to get the TicketID
    if (
        $GetParam{ArticleID}
        && !$GetParam{TicketID}
        )
    {
        %Article = $Self->{TicketObject}->ArticleGet(
            ArticleID     => $GetParam{ArticleID},
            DynamicFields => 0,
            UserID        => $Self->{UserID},
        );
        $TicketID = $Article{TicketID};
    }
    else {
        $TicketID = $GetParam{TicketID};
    }

    # Found no Article ID and no Ticket ID was passed to the Method.
    # Throw an error.
    if (
        !$Article{TicketID}
        && !$GetParam{TicketID}
        )
    {
        $Self->{LogObject}->Log(
            Message  => "No TicketID for ArticleID ($Self->{ArticleID})!",
            Priority => 'error',
        );
        return $Self->{LayoutObject}->ErrorScreen();
    }

    my @ArticleIDs = $Self->{TicketObject}->ArticleIndex(
        TicketID => $TicketID,
    );

    my $TicketNumber = $Self->{TicketObject}->TicketNumberLookup(
        TicketID => $TicketID,
        UserID   => $Self->{UserID},
    );

    my $ZipFilename = 'Attachments Ticket ' . $TicketNumber;

    # validate ArticleID parameter
    if ( $GetParam{ArticleID} ) {

        if ( !scalar grep { $GetParam{ArticleID} eq $_ } @ArticleIDs ) {

            $Self->{LayoutObject}->FatalError(
                Message => "Can't find ArticleID '$GetParam{ArticleID}' of ticket with TicketID '$TicketID'!",
            );
        }

        $ZipFilename .= ' - ArticleID ' . $GetParam{ArticleID};

        # only use the article requested
        @ArticleIDs = ( $GetParam{ArticleID} );
    }

    # create zip object
    my $Zip = Archive::Zip->new();

    # strip html and ascii attachments of content
    my $StripPlainBodyAsAttachment = 1;

    # check if rich text is enabled, if not only strip ascii attachments
    if ( !$Self->{LayoutObject}->{BrowserRichText} ) {
        $StripPlainBodyAsAttachment = 2;
    }

    my %AttachmentNames;

    # collect attachments
    ARTICLE:
    for my $ArticleID ( sort @ArticleIDs ) {

        my %Article = $Self->{TicketObject}->ArticleGet(
            ArticleID => $ArticleID,
        );

        if ( !%Article ) {
            $Self->{LayoutObject}->FatalError(
                Message => "Error while article with ArticleID '$ArticleID'!",
            );
        }

        # get attachment index (without attachments)
        my %AttachmentIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
            ArticleID                  => $ArticleID,
            StripPlainBodyAsAttachment => $StripPlainBodyAsAttachment,
            Article                    => \%Article,
            UserID                     => $Self->{UserID},
        );

        FILEID:
        for my $FileID ( sort keys %AttachmentIndex ) {

            # get a attachment
            my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                ArticleID => $ArticleID,
                FileID    => $FileID,
                UserID    => $Self->{UserID},
            );

            if ( !%Attachment ) {
                $Self->{LayoutObject}->FatalError(
                    Message =>
                        "Error while getting attachment with FileID '$FileID' of article with ArticleID '$ArticleID'!",
                );
            }

            my $Filename = $Attachment{Filename};

            # remove bad chars like e.g. newline from filename
            $Filename =~ s{\n}{ }xmsg;
            $Filename =~ s{\r}{ }xmsg;

            # check if filename is already present in zip archive
            # to avoid conflicts add ' (*counter*)' suffix to filename
            if ( !$AttachmentNames{$Filename} ) {
                $AttachmentNames{$Filename} = 1;
            }
            else {
                # add before file extension
                $Filename =~ s{(\.)([^\.]+)\z}{ ($AttachmentNames{ $Filename })$1$2}xms;

                # check if the suffix was added correctly
                # otherwise add it to the end
                if ( $Filename eq $Attachment{Filename} ) {
                    $Filename .= " ($AttachmentNames{ $Filename })";
                }

                # increase counter for this filename
                $AttachmentNames{$Filename}++;
            }

            # encode filename and content
            # otherwise it may break the zip file
            Encode::_utf8_on($Filename);
            $Self->{EncodeObject}->EncodeOutput( \$Filename );

            Encode::_utf8_on( $Attachment{Content} );
            $Self->{EncodeObject}->EncodeOutput( \$Attachment{Content} );

            # add to zip file
            $Zip->addString( $Attachment{Content}, $Filename );
        }
    }

    # write tmp file
    my $FileTempObject = Kernel::System::FileTemp->new( %{$Self} );
    my ( $FH, $Filename ) = $FileTempObject->TempFile();

    if ( open( my $ZipFH, '>', $Filename ) ) {    ##no critic

        if ( $Zip->writeToFileHandle($ZipFH) != AZ_OK ) {    ## nofilter(TidyAll::Plugin::OTRS::Perl::SyntaxCheck)
            $Self->{LayoutObject}->FatalError(
                Message => "Cant write temporary zip file '$Filename': $!!",
            );
        }
        close $ZipFH;
    }
    else {
        $Self->{LayoutObject}->FatalError(
            Message => "Cant write temporary zip file '$Filename': $!!",
        );
    }

    my $Content = '';
    if ( open( my $ZipFH, "<", $Filename ) ) {    ##no critic
        while (<$ZipFH>) {
            $Content .= $_;
        }
        close $ZipFH;
    }
    else {
        return $Self->{LayoutObject}->FatalError(
            Message => "Can't open temporary zip file '$Filename': $!",
        );
    }

    if ( !$Content ) {
        return $Self->{LayoutObject}->FatalError(
            Message => "Error while reading from temporary zip file handle!",
        );
    }

    # return new page
    return $Self->{LayoutObject}->Attachment(
        Filename    => $ZipFilename . '.zip',
        ContentType => 'application/zip',
        Content     => $Content,
        NoCache     => 1,
    );
}

1;
