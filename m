From: Ivan Orlov <ivan.orlov0322-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] selftests: cgroup: Add 'malloc' failures checks in test_memcontrol
Date: Sun, 26 Feb 2023 16:16:33 +0300
Message-ID: <20230226131634.34366-1-ivan.orlov0322@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677417420;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4MQkzTFY7oFLk7HS5mTlDP6H3MWtlVl305nioGoqUIs=;
        b=Cw96/L1RHzMm7Iwoev/iq9NQQD4j4GnUH9LI9hf0FsI7wpXOyF7SPk8t4sj26swyzx
         NoiuVoyttuLYzz6AkKaKAxzFsgN9YUejX+v/ekVf8Lt3h7MJYwNVH1SqG2XSo8NYCdlg
         OtUI1WZf2hD8ndAhpOM+BAOjCp10hXvhXrVmiwWsI7LnC3kwhrcVfsTa/u9vbkTGukNL
         Htl/vGkWLNa/aPzZOaw1WBlsiOeVy5wJ9T0+Tr+uWMisrEBBZ5Wqwfr6tsnjga9Los6O
         x4PJoNWIOeFMjvXEP+/GvphKdLQcqlNsifDVayI5uePvFO70xyMmJC2L/mb0Wagx6bHh
         vIBw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Ivan Orlov <ivan.orlov0322-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org

There are several 'malloc' calls in test_memcontrol, which can be
unsuccessful. This patch will add 'malloc' failures checking to
give more details about test's fail reasons and avoid possible
undefined behavior during the future null dereference (like the
one in alloc_anon_50M_check_swap function).

Signed-off-by: Ivan Orlov <ivan.orlov0322-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 1e616a8c6a9c..f4f7c0aef702 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -98,6 +98,11 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 	int ret = -1;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
@@ -211,6 +216,11 @@ static int alloc_anon_noexit(const char *cgroup, void *arg)
 	char *buf, *ptr;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
@@ -778,6 +788,11 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 	int ret = -1;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
-- 
2.34.1

