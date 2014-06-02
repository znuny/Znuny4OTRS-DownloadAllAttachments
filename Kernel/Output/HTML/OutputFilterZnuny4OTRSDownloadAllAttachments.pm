# --
# Kernel/Output/HTML/OutputFilterZnuny4OTRSDownloadAllAttachments.pm - adds a 'Download all (.zip)' link to the article attachment download box
# Copyright (C) 2014 Znuny GmbH, http://znuny.com/
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
                    <a target="_blank" href="$Env{"Baselink"}Action=AgentTicketDownloadAllAttachments;TicketID=$LQData{"TicketID"};ArticleID=$LQData{"ArticleID"}">$Text{"Download all (.zip)"}</a>
                </h3>
            </div>
HTML

    ${ $Param{Data} } =~ s{(<!-- \s+ dtl:block:TreeItemAttachmentItem \s+ -->)}{$LinkHTML$1}xms;

    return 1;
}

1;
