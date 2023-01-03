# --
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ZnunyDownloadAllAttachments;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;


    # SysConfigs
    $Self->{Translation}->{"This configuration registers a link in the ticket menu to download all ticket attachments."} = "Diese Konfiguration registriert einen Link im Ticket-Menü, um alle Ticket-Anhänge herunterzuladen.";
    $Self->{Translation}->{"This configuration registers a link in the ticket menu to the ticket overviews of the agent interface to download all ticket attachments."} = "Diese Konfiguration registriert einen Link im Ticket-Menü in den Ticket-Übersichten, um alle Ticket-Anhänge herunterzuladen.";

    $Self->{Translation}->{"Download all (zip)"} = "Alle herunterladen (Zip)";
    $Self->{Translation}->{"Download ticket attachments"} = "Ticket-Anhänge herunterladen";
    $Self->{Translation}->{"Download all attachments as one zip file"} = "Alle Ticket-Anhänge in einer Zip-Datei herunterladen";
    $Self->{Translation}->{"Download multiple attachments as one zip file"} = "Mehrere Ticket-Anhänge in einer Zip-Datei herunterladen";

    return 1;
}

1;
