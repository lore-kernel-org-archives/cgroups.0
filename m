From: "Yakunin, Dmitry (Nebius)" <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 3/3] tools/mm/page-types: add flag for showing inodes of
 offline cgroups
Date: Mon, 11 Sep 2023 07:55:23 +0000
Message-ID: <20230911075437.74027-4-zeil@nebius.com>
References: <20230911075437.74027-1-zeil@nebius.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nebius.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djIfp3mP/EaWX+nVlS1KCxNUabPAfr87Moa3tT7pOBI=;
 b=WhbBLQeEOyvzsdmhSh4D9X4EVIOvGwUplB9RcpcNRz7ONfTJ2sqnBcn8htUdIbXqC4klOgrdbajGO7hF96ht5rUy1LxyXzrQBkkZcVH9HR5d+0w9s3h8ldgKBJJwM1YKg4JZWESHK7KjNx1+aAVGyBTWokjDY4y2lM4UyQMWgeuGfvcKEi8QmhFlmo+YKp2/iHXdaQ4zJZVUYQg+NIo0t8nPz+rkzxmTSsbm4b9yTvzxRGy/BlxYl9Nf3vKFE07smHIY7qabntYKhcMclw4pfADwCZFh2TmAj3Zu9NQ+Yq6mEBqOHPtEF0/aLG4VVntX7y5bFRJTcNpSeLi+PAFITQ==
In-Reply-To: <20230911075437.74027-1-zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: NB-Core Team <NB-CoreTeam-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Yakunin, Dmitry (Nebius)" <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>

With flag -R|--real-cgroup page-types will report real owner.=0A=
=0A=
Link: https://lore.kernel.org/lkml/153414349419.737150.8224164787883146532.=
stgit@buzz=0A=
Suggested-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>=0A=
Reviewed-by: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>=0A=
Signed-off-by: Dmitry Yakunin <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>=0A=
---=0A=
 tools/mm/page-types.c | 18 ++++++++++++++++--=0A=
 1 file changed, 16 insertions(+), 2 deletions(-)=0A=
=0A=
diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c=0A=
index 8d5595b6c59f..f26035b362d2 100644=0A=
--- a/tools/mm/page-types.c=0A=
+++ b/tools/mm/page-types.c=0A=
@@ -161,6 +161,7 @@ static pid_t		opt_pid;	/* process to walk */=0A=
 const char		*opt_file;	/* file or directory path */=0A=
 static uint64_t		opt_cgroup;	/* cgroup inode */=0A=
 static int		opt_list_cgroup;/* list page cgroup */=0A=
+static int		opt_real_cgroup;/* list page cgroup */=0A=
 static int		opt_list_mapcnt;/* list page map count */=0A=
 static const char	*opt_kpageflags;/* kpageflags file to parse */=0A=
 =0A=
@@ -837,6 +838,7 @@ static void usage(void)=0A=
 "            -l|--list                  Show page details in ranges\n"=0A=
 "            -L|--list-each             Show page details one by one\n"=0A=
 "            -C|--list-cgroup           Show cgroup inode for pages\n"=0A=
+"            -R|--real-cgroup           Show real offline cgroups\n"=0A=
 "            -M|--list-mapcnt           Show page map count\n"=0A=
 "            -N|--no-summary            Don't show summary info\n"=0A=
 "            -X|--hwpoison              hwpoison pages\n"=0A=
@@ -1257,6 +1259,7 @@ static const struct option opts[] =3D {=0A=
 	{ "list"      , 0, NULL, 'l' },=0A=
 	{ "list-each" , 0, NULL, 'L' },=0A=
 	{ "list-cgroup", 0, NULL, 'C' },=0A=
+	{ "real-cgroup", 0, NULL, 'R' },=0A=
 	{ "list-mapcnt", 0, NULL, 'M' },=0A=
 	{ "no-summary", 0, NULL, 'N' },=0A=
 	{ "hwpoison"  , 0, NULL, 'X' },=0A=
@@ -1273,7 +1276,7 @@ int main(int argc, char *argv[])=0A=
 	page_size =3D getpagesize();=0A=
 =0A=
 	while ((c =3D getopt_long(argc, argv,=0A=
-				"rp:f:a:b:d:c:CilLMNXxF:h",=0A=
+				"rp:f:a:b:d:c:CRilLMNXxF:h",=0A=
 				opts, NULL)) !=3D -1) {=0A=
 		switch (c) {=0A=
 		case 'r':=0A=
@@ -1297,6 +1300,9 @@ int main(int argc, char *argv[])=0A=
 		case 'C':=0A=
 			opt_list_cgroup =3D 1;=0A=
 			break;=0A=
+		case 'R':=0A=
+			opt_real_cgroup =3D 1;=0A=
+			break;=0A=
 		case 'd':=0A=
 			describe_flags(optarg);=0A=
 			exit(0);=0A=
@@ -1338,7 +1344,15 @@ int main(int argc, char *argv[])=0A=
 	if (!opt_kpageflags)=0A=
 		opt_kpageflags =3D PROC_KPAGEFLAGS;=0A=
 =0A=
-	if (opt_cgroup || opt_list_cgroup)=0A=
+	if (opt_real_cgroup) {=0A=
+		uint64_t flags =3D 1;=0A=
+=0A=
+		kpagecgroup_fd =3D checked_open(PROC_KPAGECGROUP, O_RDWR);=0A=
+		if (write(kpagecgroup_fd, &flags, sizeof(flags)) < 0) {=0A=
+			perror(PROC_KPAGECGROUP);=0A=
+			exit(EXIT_FAILURE);=0A=
+		}=0A=
+	} else if (opt_cgroup || opt_list_cgroup)=0A=
 		kpagecgroup_fd =3D checked_open(PROC_KPAGECGROUP, O_RDONLY);=0A=
 =0A=
 	if (opt_list && opt_list_mapcnt)=0A=
-- =0A=
2.25.1=0A=
=0A=
