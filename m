From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 3/3] selftests: cgroup: make sure reclaim target memcg is unprotected
Date: Fri,  2 Dec 2022 03:15:12 +0000
Message-ID: <20221202031512.1365483-4-yosryahmed@google.com>
References: <20221202031512.1365483-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bNyz6y2Y8+pcZcYRhDrKnevmtY0/xVh2JMC54suzd2M=;
        b=c5bVHWOVWFxZh/IsKMqBecLiB8RmgVwYrX1GzaIQJrvdCmfUyfs8qg0W9hhScf5hH4
         mG1HkIkP0USGP4r6R6YG/H5u+ozhVJBPbINAptVF+p7iL7Zdme2Si3JoPCUQg5PnuM8i
         9sgrk6G5d9YLX23J/vJ2Mgm92LjuGfj+UUMBTfr4WknUpFkwvTonc3miyBG+12r8p9WO
         rKEJGNGnV/+QeTnBLn5B4wArNPSCesKqvyX6p+9fULbYoMK0hz3Mmtd+Zort4W8lRQ75
         zHRyiG+ShUvq2dHWqAQo/BfIP9kKzWFVg6HrESVMYli7xM6bVzIBYa/ChJND9QG28tZc
         zf6A==
In-Reply-To: <20221202031512.1365483-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Make sure that we ignore protection of a memcg that is the target of
memcg reclaim.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index a8f4700353a4..1e616a8c6a9c 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -238,6 +238,8 @@ static int cg_test_proc_killed(const char *cgroup)
 	return -1;
 }
 
+static bool reclaim_until(const char *memcg, long goal);
+
 /*
  * First, this test creates the following hierarchy:
  * A       memory.min = 0,    memory.max = 200M
@@ -266,6 +268,12 @@ static int cg_test_proc_killed(const char *cgroup)
  * unprotected memory in A available, and checks that:
  * a) memory.min protects pagecache even in this case,
  * b) memory.low allows reclaiming page cache with low events.
+ *
+ * Then we try to reclaim from A/B/C using memory.reclaim until its
+ * usage reaches 10M.
+ * This makes sure that:
+ * (a) We ignore the protection of the reclaim target memcg.
+ * (b) The previously calculated emin value (~29M) should be dismissed.
  */
 static int test_memcg_protection(const char *root, bool min)
 {
@@ -385,6 +393,9 @@ static int test_memcg_protection(const char *root, bool min)
 	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
 		goto cleanup;
 
+	if (!reclaim_until(children[0], MB(10)))
+		goto cleanup;
+
 	if (min) {
 		ret = KSFT_PASS;
 		goto cleanup;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

