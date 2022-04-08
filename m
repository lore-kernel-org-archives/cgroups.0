From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 4/4] selftests: cgroup: add a selftest for memory.reclaim
Date: Fri,  8 Apr 2022 04:57:43 +0000
Message-ID: <20220408045743.1432968-5-yosryahmed@google.com>
References: <20220408045743.1432968-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3pTs/VmZPxq5q5wYSF5wNcPHcga+GtsVQl1Ey1cMTYA=;
        b=rvhnsrqMv4sgVKJh1vywJDwJ5U1YIrm4qeZ+xvYMN5iNrp3UBtoPAwLYGST3GoaiMm
         WHOaYmhgN89ZSkqq/rrlyrpsoAk9snev93OB3iD6xwnbay5f9TY/LZvY0DCAezc6XBkq
         xL4SfAAQ1Asd+mUQruSX/RHQfET7mMtUa5hZPgL9lbYKPNV6DK0EbhmuK9i82PR/5pAt
         /NhixDWU/pG6CKN2oFTyr8dDewwdERP0qYAzylJbweyHFeoMsu6trfoKBuDfsepu7Rek
         a8aShEUZ343hISjyHiMcMdIBoVEqcQ1IoADLU9STJVAAr7sxoIvQ8281ix2aOcgAz9HZ
         /kVw==
In-Reply-To: <20220408045743.1432968-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add a new test for memory.reclaim that verifies that the interface
correctly reclaims memory as intended, from both anon and file pages.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 .../selftests/cgroup/test_memcontrol.c        | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index f2ffb3a30194..75ae441c01c3 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -760,6 +760,90 @@ static int test_memcg_max(const char *root)
 	return ret;
 }
 
+/*
+ * This test checks that memory.reclaim reclaims the given
+ * amount of memory (from both anon and file).
+ */
+static int test_memcg_reclaim(const char *root)
+{
+	int ret = KSFT_FAIL, fd;
+	char *memcg;
+	long current, to_reclaim;
+	char buf[64];
+
+	memcg = cg_name(root, "memcg_test");
+	if (!memcg)
+		goto cleanup;
+
+	if (cg_create(memcg))
+		goto cleanup;
+
+	current = cg_read_long(memcg, "memory.current");
+	if (current != 0)
+		goto cleanup;
+
+	cg_run_nowait(memcg, alloc_anon_noexit, (void *) MB(50));
+	sleep(1);
+
+	fd = get_temp_fd();
+	if (fd < 0)
+		goto cleanup;
+
+	cg_run_nowait(memcg, alloc_pagecache_50M_noexit, (void *)(long)fd);
+	sleep(1);
+
+	current = cg_read_long(memcg, "memory.current");
+	if (!values_close(current, MB(100), 10))
+		goto cleanup;
+
+	/*
+	 * Reclaim until current reaches 30M, make sure to reclaim over 50M to
+	 * hit both anon and file.
+	 */
+	while (true) {
+		int err;
+
+		current = cg_read_long(memcg, "memory.current");
+		to_reclaim = current - MB(30);
+
+		/*
+		 * We only keep looping if we get EAGAIN, which means we could
+		 * not reclaim the full amount.
+		 */
+		if (to_reclaim <= 0)
+			goto cleanup;
+
+
+		snprintf(buf, sizeof(buf), "%ld", to_reclaim);
+		err = cg_write(memcg, "memory.reclaim", buf);
+		if (!err) {
+			/*
+			 * If writing succeeds, then the written amount should have been
+			 * fully reclaimed (and maybe more).
+			 */
+			current = cg_read_long(memcg, "memory.current");
+			if (!values_close(current, MB(30), 3) && current > MB(30))
+				goto cleanup;
+			break;
+		}
+
+		/* The kernel could not reclaim the full amount, try again. */
+		if (err == EAGAIN)
+			continue;
+
+		/* We got an unexpected error. */
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+cleanup:
+	cg_destroy(memcg);
+	free(memcg);
+	close(fd);
+
+	return ret;
+}
+
 static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 {
 	long mem_max = (long)arg;
@@ -1263,6 +1347,7 @@ struct memcg_test {
 	T(test_memcg_high),
 	T(test_memcg_high_sync),
 	T(test_memcg_max),
+	T(test_memcg_reclaim),
 	T(test_memcg_oom_events),
 	T(test_memcg_swap_max),
 	T(test_memcg_sock),
-- 
2.35.1.1178.g4f1659d476-goog

