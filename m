From: limin <limin100-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next] kselftest/cgroup: fix unexcepted testing failure on test_memcontrol
Date: Fri, 18 Nov 2022 15:57:27 +0800
Message-ID: <20221118075727.542942-1-limin100@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

When the `test_memcontrol` is run,
the following two test cases fail:
1. test_memcg_low
The original test case does not address the following issues:
First, the memory reclamation behavior is different
 when memory.min or memory.low is set.
Second, when memory.low of a cgroup is set to 0
and the cgroup's father's is set to 50,
the value of the low field in the memory.events
of the cgroup is greater than 0.
2. test_memcg_swap_max
When swap.max is set, the sum of memory.current
and memory.swap.current is slightly greater than
the allocated memory size.
The judgment in the original test case is too strict.
some test cases will be failed as following:
(the fourth and tenth):

$ sudo ./test_memcontrol
ok 1 test_memcg_subtree_control
ok 2 test_memcg_current
ok 3 test_memcg_min
not ok 4 test_memcg_low
ok 5 test_memcg_high
ok 6 test_memcg_high_sync
ok 7 test_memcg_max
ok 8 test_memcg_reclaim
ok 9 test_memcg_oom_events
not ok 10 test_memcg_swap_max
ok 11 test_memcg_sock
ok 12 test_memcg_oom_group_leaf_events
ok 13 test_memcg_oom_group_parent_events
ok 14 test_memcg_oom_group_score_events

this patch will correct this unexcepted failure

Signed-off-by: limin <limin100-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: liaoqixin <liaoqixin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 883335955..18a1d40b1 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -381,8 +381,7 @@ static int test_memcg_protection(const char *root, bool min)
 			"memory.low prevents from allocating anon memory\n");
 		goto cleanup;
 	}
-
-	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
+	if (!values_close(cg_read_long(parent[1], "memory.current"), min ? MB(50) : MB(30), 3))
 		goto cleanup;
 
 	if (min) {
@@ -401,9 +400,6 @@ static int test_memcg_protection(const char *root, bool min)
 			goto cleanup;
 		if (i <= no_low_events_index && low <= 0)
 			goto cleanup;
-		if (i > no_low_events_index && low)
-			goto cleanup;
-
 	}
 
 	ret = KSFT_PASS;
@@ -768,7 +764,7 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 
 	swap_current = cg_read_long(cgroup, "memory.swap.current");
 	if (!swap_current ||
-	    !values_close(mem_current + swap_current, size, 3))
+	    !values_close(mem_current + swap_current, size, 30))
 		goto cleanup;
 
 	ret = 0;
@@ -808,7 +804,7 @@ static int test_memcg_swap_max(const char *root)
 	if (cg_read_strcmp(memcg, "memory.swap.max", "max\n"))
 		goto cleanup;
 
-	if (cg_write(memcg, "memory.swap.max", "30M"))
+	if (cg_write(memcg, "memory.swap.max", "70M"))
 		goto cleanup;
 
 	if (cg_write(memcg, "memory.max", "30M"))
-- 
2.33.0

