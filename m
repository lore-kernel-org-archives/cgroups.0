From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] selftests: cgroup: fix unexpected failure on test_memcg_sock
Date: Mon, 19 Jun 2023 12:47:35 +0000
Message-ID: <20230619124735.2124-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1687178928; x=1689770928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zkvtgJhNiAhlhE/5X9KIzqXme2yxIHOQ4aJAd2h6f9c=;
        b=Sy4BZQSQxGMw6NONjzbcq2N7RyjpWRHbA6AvoFZp8NRVHtp783fyfgNtZaScvfKhMq
         6KVatXhq782lhFz5kt4R8SHgs3hbFpvVxWm1daPJds0XiUCcY/EeGoEciKB9xofPWt66
         JXuOF9+OspCQ0j5tjiOMTFPPxsu7Q4j0y2G+eazqGvqqjbYr4uEGMBYBGnQuEhDHSeo7
         iMKwKmjOxJj/nJBwMDF3ZHBclzTjYVRukgbfIPUb+BxtzacxWRMKd7RUjgz0YmtOd3Fy
         FVk5qmlxKAHp/4omdq9Ei3HsZX6yEwLpA3jTjIaADA+P/mP4WazNN694252yL4sU0wnM
         ya9w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

Before server got a client connection, there were some memory allocation
in the test memcg, such as user stack. So do not count those memory not
related to socket when checking socket memory accounting.

Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index f4f7c0aef702..9e0d6d315826 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -987,7 +987,9 @@ static int tcp_client(const char *cgroup, unsigned short port)
 	char servport[6];
 	int retries = 0x10; /* nice round number */
 	int sk, ret;
+	long allocated;
 
+	allocated = cg_read_long(cgroup, "memory.current");
 	snprintf(servport, sizeof(servport), "%hd", port);
 	ret = getaddrinfo(server, servport, NULL, &ai);
 	if (ret)
@@ -1015,7 +1017,8 @@ static int tcp_client(const char *cgroup, unsigned short port)
 		if (current < 0 || sock < 0)
 			goto close_sk;
 
-		if (values_close(current, sock, 10)) {
+		/* exclude the memory not related to socket connection */
+		if (values_close(current - allocated, sock, 10)) {
 			ret = KSFT_PASS;
 			break;
 		}
-- 
2.25.1

