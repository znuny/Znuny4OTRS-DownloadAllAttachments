# --
# Kernel/Output/HTML/OutputFilterZnuny4OTRSDownloadAllAttachments.pm - adds a 'Download all (.zip)' link to the article attachment download box
# Copyright (C) 2012-2015 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterZnuny4OTRSDownloadAllAttachments;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LinkHTML = <<'HTML';
            <div class="AttachmentElement">
                <h3 style="text-align: center;">
                    <a target="_blank" href="[% Env("Baselink") %]Action=AgentTicketDownloadAllAttachments;ArticleID=[% Data.ArticleID| uri %]">[% Translate("Download all \(zip\)", "String") | html %]</a>
                </h3>
            </div>
HTML

    ${ $Param{Data} } =~ s/(\<div class="Attachment InnerContent"\>)/$LinkHTML$1/ms;

    return 1;
}

1;
