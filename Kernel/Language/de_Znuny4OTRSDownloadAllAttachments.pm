# --
# Kernel/Language/de_Znuny4OTRSDownloadAllAttachments.pm - the German translation of the texts of Znuny4OTRSDownloadAllAttachments
# Copyright (C) 2015 Znuny GmbH, http://znuny.com/
# --

package Kernel::Language::de_Znuny4OTRSDownloadAllAttachments;

use strict;
use warnings;
use utf8;
sub Data {
    my $Self = shift;

    # menu modules
    $Self->{Translation}->{"Download ticket attachments (zip)"} = "Ticket-Anhänge herunterladen (zip)";

    # SysConfigs
    $Self->{Translation}->{"This configuration registers a link in the ticket menu to download all ticket attachments."} = "Diese Konfiguration registriert einen Link im Ticket-Menü um alle Ticket-Anhänge herunterzuladen.";
    $Self->{Translation}->{"This configuration registers a link in the ticket menu to the ticket overviews of the agent interface to download all ticket attachments."} = "Diese Konfiguration registriert einen Link im Ticket-Menü in den Ticket-Übersichten um alle Ticket-Anhänge herunterzuladen.";
    $Self->{Translation}->{"This configuration registers an output filter that adds a 'Download all (zip)' link to the article attachment download box."} = "Diese Konfiguration registriert einen Outputfilter um einen 'Alle laden (zip)' Link in der Artikel-Attachment Download-Box.";
    $Self->{Translation}->{"Download ticket attachments"} = "Ticket-Anhänge herunterladen";
    $Self->{Translation}->{"Download all attachments as one zip file"} = "Alle Ticket-Anhänge in einer zip-Datei herunterladen";
    $Self->{Translation}->{"Download multiple attachments as one zip file"} = "Mehrere Ticket-Anhänge in einer zip-Datei herunterladen";

    # ZoomView attachment box link
    $Self->{Translation}->{"Download all (zip)"} = "Alle herunterladen (zip)";

    return 1;
}

1;
