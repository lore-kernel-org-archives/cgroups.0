From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] selftests: memcg: uninitialized variable in
 test_memcg_reclaim()
Date: Tue, 19 Jul 2022 12:46:10 +0300
Message-ID: <YtZ9Yu6HSQ2sT+O/@kili>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=tYhTDaiKvaCpdj5IormPKDV/QN7a5o8gORfTDx4gHiA=;
 b=wTBV7qcz62YZV8EyYrUyp8M3I2XtLVKsLylPCEF8jlj5Ted5M+46GV6jayTGW2z2nqIz
 aFGt+v20AHpxCTP2Ok+Z+kBJTaLC4ZA5NQ8hqKDQbAy4Aow1K1HD0ayde9KX4aiSj1J1
 k7dmpjxDzo3GBNX7zAORNmZlyKMydSxtkG9QJkDpC/nhmmNZkPCaFrrezCJUhffQcqUE
 YLc0jNnb12LSOptHhi7+R6WY6HcZhMBiNPDle31jk1BF8irKD/ikXStvvuFpVY1SOs6o
 UIjxtmfOQuL4ktfY90OWCXX6yfkrQJ1i5jOzyeNdOp5iaypmRQ41fMNG7hAEkLx8fi1c RA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYhTDaiKvaCpdj5IormPKDV/QN7a5o8gORfTDx4gHiA=;
 b=hLBXK37Deydb06HR5uTiyNGbyLNFRhGauxxMSXS8Sx5llEVVVr8+RoGtdkMsiCHaVnU7vt7PnduzhHZS+8K5cGPyVRNje+Cgw7Kz2N+Q4xyKe8wdh1f/UZ6/zZeJJVQFqUbJvYDTMxnukg0LD9h2WctRs1JWLmOq+8rTL74c/H8=
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The "fd" is used on the clean up path without ever being initialized.

Fixes: eae3cb2e87ff ("selftests: cgroup: add a selftest for memory.reclaim")
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
I kind of went over kill on fixing this as if it were real code which
matters.  :P

 .../selftests/cgroup/test_memcontrol.c        | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 8833359556f3..08681699c2f9 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -658,18 +658,18 @@ static int test_memcg_reclaim(const char *root)
 
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
-		goto cleanup;
+		return KSFT_FAIL;
 
 	if (cg_create(memcg))
-		goto cleanup;
+		goto free_memcg;
 
 	current = cg_read_long(memcg, "memory.current");
 	if (current != 0)
-		goto cleanup;
+		goto destroy_memcg;
 
 	fd = get_temp_fd();
 	if (fd < 0)
-		goto cleanup;
+		goto destroy_memcg;
 
 	cg_run_nowait(memcg, alloc_pagecache_50M_noexit, (void *)(long)fd);
 
@@ -697,7 +697,7 @@ static int test_memcg_reclaim(const char *root)
 			fprintf(stderr,
 				"failed to allocate %ld for memcg reclaim test\n",
 				expected_usage);
-			goto cleanup;
+			goto close;
 		}
 	}
 
@@ -717,7 +717,7 @@ static int test_memcg_reclaim(const char *root)
 		 * not reclaim the full amount.
 		 */
 		if (to_reclaim <= 0)
-			goto cleanup;
+			goto close;
 
 
 		snprintf(buf, sizeof(buf), "%ld", to_reclaim);
@@ -729,7 +729,7 @@ static int test_memcg_reclaim(const char *root)
 			 */
 			current = cg_read_long(memcg, "memory.current");
 			if (!values_close(current, MB(30), 3) && current > MB(30))
-				goto cleanup;
+				goto close;
 			break;
 		}
 
@@ -738,14 +738,17 @@ static int test_memcg_reclaim(const char *root)
 			continue;
 
 		/* We got an unexpected error or ran out of retries. */
-		goto cleanup;
+		goto close;
 	}
 
 	ret = KSFT_PASS;
-cleanup:
+
+close:
+	close(fd);
+destroy_memcg:
 	cg_destroy(memcg);
+free_memcg:
 	free(memcg);
-	close(fd);
 
 	return ret;
 }
-- 
2.35.1

