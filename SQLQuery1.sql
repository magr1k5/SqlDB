CREATE TABLE [dbo].[status](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_status] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[posts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_posts] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[deps](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_deps] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[persons](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [nvarchar](100) NOT NULL,
	[second_name] [nvarchar](100) NOT NULL,
	[last_name] [nvarchar](100) NOT NULL,
	[date_employ] [datetime] NULL,
	[date_uneploy] [datetime] NULL,
	[status] [int] NOT NULL,
	[id_dep] [int] NOT NULL,
	[id_post] [int] NOT NULL,
 CONSTRAINT [PK_persons] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE dbo.persons
ADD CONSTRAINT FK_persons_status 
    FOREIGN KEY (status) REFERENCES dbo.status(id);

ALTER TABLE dbo.persons
ADD CONSTRAINT FK_persons_posts 
    FOREIGN KEY (id_post) REFERENCES dbo.posts(id);

ALTER TABLE dbo.persons
ADD CONSTRAINT FK_persons_deps 
    FOREIGN KEY (id_dep) REFERENCES dbo.deps(id);


	INSERT INTO dbo.status (name) VALUES
(N'��������'),
(N'������');

INSERT INTO dbo.posts (name) VALUES
(N'��������'),
(N'�����������'),
(N'���������');

INSERT INTO dbo.deps (name) VALUES
(N'�������'),
(N'��'),
(N'�����������');

select * from status;
select * from posts;
select * from deps;
select * from persons;

INSERT INTO dbo.persons (first_name, second_name, last_name, date_employ, date_uneploy, status, id_dep, id_post) VALUES
(N'����', N'����������', N'���������', '2025-06-27', NULL, 9, 2, 2),
(N'���������', N'���������', N'��������', '2013-05-11', NULL, 9, 1, 1), 
(N'��������', N'����������', N'������', '2021-07-12', '2025-05-08', 10, 2, 2),
(N'���������', N'���������', N'�������', '2012-09-01', '2025-04-30', 10, 2, 2),
(N'�������', N'�������������', N'���������', '2024-10-02', '2025-02-28', 10, 2, 2),
(N'���������', N'�����������', N'�������', '2025-02-02', '2025-06-28', 10, 2, 2),
(N'����������', N'���������', N'��������', '2022-02-02', '2025-08-08', 10, 1, 2),
(N'���', N'����������', N'���������', '2022-02-02', '2025-11-11', 10, 2, 2),
(N'�����', N'���������', N'���������', '2021-01-12', '2025-12-31', 10, 1, 2),
(N'������ ', N'����������', N'�������', '2002-07-04', '2025-01-07', 10, 1, 2),
(N'�������', N'��������', N'�����', '2022-07-20', NULL, 9, 2, 2);

SELECT 
    p.id,
    p.last_name + ' ' + p.first_name + ' ' + p.second_name AS full_name,
    d.name AS department,
    po.name AS post,
    s.name AS status,
    p.date_employ,
    p.date_uneploy
FROM dbo.persons p
JOIN dbo.deps d ON p.id_dep = d.id
JOIN dbo.posts po ON p.id_post = po.id
JOIN dbo.status s ON p.status = s.id
WHERE d.name = N'��';
