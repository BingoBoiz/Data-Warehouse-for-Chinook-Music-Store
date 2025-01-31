IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Database1')
BEGIN
	ALTER DATABASE Database1 SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE Database1 SET ONLINE;
	DROP DATABASE Database1;
END

GO

/*******************************************************************************
   Create database
********************************************************************************/
CREATE DATABASE Database1;
GO

USE Database1;
GO
CREATE TABLE [dbo].[Album]
(
    [AlbumId] INT NOT NULL,
    [Title] NVARCHAR(160) NOT NULL,
    [ArtistId] INT NOT NULL,
    CONSTRAINT [PK_Album] PRIMARY KEY CLUSTERED ([AlbumId])
);
GO
CREATE TABLE [dbo].[Artist]
(
    [ArtistId] INT NOT NULL,
    [Name] NVARCHAR(120),
    [LastName] NVARCHAR(120),
    [Gender] NVARCHAR(10),
    [Email] NVARCHAR(120),
    [Nationality] NVARCHAR(60),
    CONSTRAINT [PK_Artist] PRIMARY KEY CLUSTERED ([ArtistId])
);
GO
CREATE TABLE [dbo].[Customer] --SCD
(
    [CustomerId] INT NOT NULL,
    [FirstName] NVARCHAR(40) NOT NULL,
    [LastName] NVARCHAR(20) NOT NULL,
    [Company] NVARCHAR(80),
    [Address] NVARCHAR(70),
    [City] NVARCHAR(40),
    [State] NVARCHAR(40),
    [Country] NVARCHAR(40),
    [PostalCode] NVARCHAR(10),
    [Phone] NVARCHAR(24),
    [Fax] NVARCHAR(24),
    [Email] NVARCHAR(60) NOT NULL,
    [SupportRepId] INT,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerId])
);
GO
CREATE TABLE [dbo].[Employee] --SCD
(
    [EmployeeId] INT NOT NULL,
    [LastName] NVARCHAR(20) NOT NULL,
    [FirstName] NVARCHAR(20) NOT NULL,
    [Title] NVARCHAR(30),
    [ReportsTo] INT,
    [BirthDate] DATETIME,
    [HireDate] DATETIME,
    [Address] NVARCHAR(70),
    [City] NVARCHAR(40),
    [State] NVARCHAR(40),
    [Country] NVARCHAR(40),
    [PostalCode] NVARCHAR(10),
    [Phone] NVARCHAR(24),
    [Fax] NVARCHAR(24),
    [Email] NVARCHAR(60),
    CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED ([EmployeeId])
);
GO
CREATE TABLE [dbo].[Genre]
(
    [GenreId] INT NOT NULL,
    [Name] NVARCHAR(120),
    CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED ([GenreId])
);
GO
CREATE TABLE [dbo].[Invoice]
(
    [InvoiceId] INT NOT NULL,
    [CustomerId] INT NOT NULL,
	[EmployeeId] INT NOT NULL,
    [InvoiceDate] DATETIME NOT NULL,
    [BillingAddress] NVARCHAR(70),
    [BillingCity] NVARCHAR(40),
    [BillingState] NVARCHAR(40),
    [BillingCountry] NVARCHAR(40),
    [BillingPostalCode] NVARCHAR(10),
    [Total] NUMERIC(10,2) NOT NULL,
    CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED ([InvoiceId])
);
GO
CREATE TABLE [dbo].[InvoiceLine]
(
    [InvoiceLineId] INT NOT NULL,
    [InvoiceId] INT NOT NULL,
    [TrackId] INT NOT NULL,
    [UnitPrice] NUMERIC(10,2) NOT NULL,
    [Quantity] INT NOT NULL,
    CONSTRAINT [PK_InvoiceLine] PRIMARY KEY CLUSTERED ([InvoiceLineId])
);
GO
CREATE TABLE [dbo].[MediaType]
(
    [MediaTypeId] INT NOT NULL,
    [Name] NVARCHAR(120),
    CONSTRAINT [PK_MediaType] PRIMARY KEY CLUSTERED ([MediaTypeId])
);
GO
CREATE TABLE [dbo].[Playlist]
(
    [PlaylistId] INT NOT NULL,
    [Name] NVARCHAR(120),
    CONSTRAINT [PK_Playlist] PRIMARY KEY CLUSTERED ([PlaylistId])
);
GO
CREATE TABLE [dbo].[PlaylistTrack]
(
    [PlaylistId] INT NOT NULL,
    [TrackId] INT NOT NULL,
    CONSTRAINT [PK_PlaylistTrack] PRIMARY KEY NONCLUSTERED ([PlaylistId], [TrackId])
);
GO
CREATE TABLE [dbo].[Track]
(
    [TrackId] INT NOT NULL,
    [Name] NVARCHAR(200) NOT NULL,
    [AlbumId] INT,
    [MediaTypeId] INT NOT NULL,
    [GenreId] INT,
    [Composer] NVARCHAR(220),
    [Milliseconds] INT NOT NULL,
    [Bytes] INT,
    [UnitPrice] NUMERIC(10,2) NOT NULL,
    CONSTRAINT [PK_Track] PRIMARY KEY CLUSTERED ([TrackId])
);
GO


/*******************************************************************************
   Create Primary Key Unique Indexes
********************************************************************************/

/*******************************************************************************
   Create Foreign Keys
********************************************************************************/
ALTER TABLE [dbo].[Album] ADD CONSTRAINT [FK_AlbumArtistId]
    FOREIGN KEY ([ArtistId]) REFERENCES [dbo].[Artist] ([ArtistId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_AlbumArtistId] ON [dbo].[Album] ([ArtistId]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_CustomerSupportRepId]
    FOREIGN KEY ([SupportRepId]) REFERENCES [dbo].[Employee] ([EmployeeId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_CustomerSupportRepId] ON [dbo].[Customer] ([SupportRepId]);
GO
ALTER TABLE [dbo].[Employee] ADD CONSTRAINT [FK_EmployeeReportsTo]
    FOREIGN KEY ([ReportsTo]) REFERENCES [dbo].[Employee] ([EmployeeId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_EmployeeReportsTo] ON [dbo].[Employee] ([ReportsTo]);
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_InvoiceCustomerId]
    FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_InvoiceCustomerId] ON [dbo].[Invoice] ([CustomerId]);
GO
ALTER TABLE [dbo].[InvoiceLine] ADD CONSTRAINT [FK_InvoiceLineInvoiceId]
    FOREIGN KEY ([InvoiceId]) REFERENCES [dbo].[Invoice] ([InvoiceId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_InvoiceLineInvoiceId] ON [dbo].[InvoiceLine] ([InvoiceId]);
GO
ALTER TABLE [dbo].[InvoiceLine] ADD CONSTRAINT [FK_InvoiceLineTrackId]
    FOREIGN KEY ([TrackId]) REFERENCES [dbo].[Track] ([TrackId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_InvoiceLineTrackId] ON [dbo].[InvoiceLine] ([TrackId]);
GO
ALTER TABLE [dbo].[PlaylistTrack] ADD CONSTRAINT [FK_PlaylistTrackPlaylistId]
    FOREIGN KEY ([PlaylistId]) REFERENCES [dbo].[Playlist] ([PlaylistId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
ALTER TABLE [dbo].[PlaylistTrack] ADD CONSTRAINT [FK_PlaylistTrackTrackId]
    FOREIGN KEY ([TrackId]) REFERENCES [dbo].[Track] ([TrackId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_PlaylistTrackTrackId] ON [dbo].[PlaylistTrack] ([TrackId]);
GO
ALTER TABLE [dbo].[Track] ADD CONSTRAINT [FK_TrackAlbumId]
    FOREIGN KEY ([AlbumId]) REFERENCES [dbo].[Album] ([AlbumId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_TrackAlbumId] ON [dbo].[Track] ([AlbumId]);
GO
ALTER TABLE [dbo].[Track] ADD CONSTRAINT [FK_TrackGenreId]
    FOREIGN KEY ([GenreId]) REFERENCES [dbo].[Genre] ([GenreId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_TrackGenreId] ON [dbo].[Track] ([GenreId]);
GO
ALTER TABLE [dbo].[Track] ADD CONSTRAINT [FK_TrackMediaTypeId]
    FOREIGN KEY ([MediaTypeId]) REFERENCES [dbo].[MediaType] ([MediaTypeId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_TrackMediaTypeId] ON [dbo].[Track] ([MediaTypeId]);
GO