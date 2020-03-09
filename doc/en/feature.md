# Functionality

## Download multiple attachments as single zip file

In the OTRS standard it's not possible to download multiple ticket or article attachments at once, each file has to get downloaded single handed. This package extends the system with the functionality to download all attachments of a ticket or article as a single zip file.

Ticket attachments can get downloaded via the new link 'Download ticket attachments (zip)' in the ticket menu of the ticket zoom view. The filename will have the following pattern: 'Attachments Ticket *TicketNummer*.zip'.

To download all attachments of an article as a single zip file the new link 'Download all (.zip)' is added on top of the attachment list in the article attachments box. The filename will have the following pattern: 'Attachments Ticket *TicketNummer* ArticleID *ArticleID*.zip'.