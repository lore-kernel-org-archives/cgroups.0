From: David Vernet <void@manifault.com>
Subject: [PATCH v2 1/5] cgroups: Refactor children cgroups in memcg tests
Date: Sat, 23 Apr 2022 08:56:17 -0700
Message-ID: <20220423155619.3669555-2-void@manifault.com>
References: <20220423155619.3669555-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20220423155619.3669555-1-void@manifault.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org
Cc: tj@kernel.org, roman.gushchin@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, shakeelb@google.com, kernel-team@fb.com, void@manifault.com

In test_memcg_min() and test_memcg_low(), there is an array of four sibling
cgroups. All but one of these sibling groups does a 50MB allocation, and
the group that does no allocation is the third of four in the array.  This
is not a problem per se, but makes it a bit tricky to do some assertions in
test_memcg_low(), as we want to make assertions on the siblings based on
whether or not they performed allocations. Having a static index before
which all groups have performed an allocation makes this cleaner.

This patch therefore reorders the sibling groups so that the group that
performs no allocations is the last in the array. A follow-on patch will
leverage this to fix a bug in the test that incorrectly asserts that a
sibling group that had performed an allocation, but only had protection
from its parent, will not observe any memory.events.low events during
reclaim.

Signed-off-by: David Vernet <void@manifault.com>
---
 .../selftests/cgroup/test_memcontrol.c        | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 6b5259394e68..284d912e7d3e 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -244,8 +244,8 @@ static int cg_test_proc_killed(const char *cgroup)
  * A/B     memory.min = 50M,  memory.current = 50M
  * A/B/C   memory.min = 75M,  memory.current = 50M
  * A/B/D   memory.min = 25M,  memory.current = 50M
- * A/B/E   memory.min = 500M, memory.current = 0
- * A/B/F   memory.min = 0,    memory.current = 50M
+ * A/B/E   memory.min = 0,    memory.current = 50M
+ * A/B/F   memory.min = 500M, memory.current = 0
  *
  * Usages are pagecache, but the test keeps a running
  * process in every leaf cgroup.
@@ -255,7 +255,7 @@ static int cg_test_proc_killed(const char *cgroup)
  * A/B    memory.current ~= 50M
  * A/B/C  memory.current ~= 33M
  * A/B/D  memory.current ~= 17M
- * A/B/E  memory.current ~= 0
+ * A/B/F  memory.current ~= 0
  *
  * After that it tries to allocate more than there is
  * unprotected memory in A available, and checks
@@ -321,7 +321,7 @@ static int test_memcg_min(const char *root)
 		if (cg_create(children[i]))
 			goto cleanup;
 
-		if (i == 2)
+		if (i > 2)
 			continue;
 
 		cg_run_nowait(children[i], alloc_pagecache_50M_noexit,
@@ -336,9 +336,9 @@ static int test_memcg_min(const char *root)
 		goto cleanup;
 	if (cg_write(children[1], "memory.min", "25M"))
 		goto cleanup;
-	if (cg_write(children[2], "memory.min", "500M"))
+	if (cg_write(children[2], "memory.min", "0"))
 		goto cleanup;
-	if (cg_write(children[3], "memory.min", "0"))
+	if (cg_write(children[3], "memory.min", "500M"))
 		goto cleanup;
 
 	attempts = 0;
@@ -364,7 +364,7 @@ static int test_memcg_min(const char *root)
 	if (!values_close(c[1], MB(17), 20))
 		goto cleanup;
 
-	if (!values_close(c[2], 0, 1))
+	if (c[3] != 0)
 		goto cleanup;
 
 	if (!cg_run(parent[2], alloc_anon, (void *)MB(170)))
@@ -401,8 +401,8 @@ static int test_memcg_min(const char *root)
  * A/B     memory.low = 50M,  memory.current = 50M
  * A/B/C   memory.low = 75M,  memory.current = 50M
  * A/B/D   memory.low = 25M,  memory.current = 50M
- * A/B/E   memory.low = 500M, memory.current = 0
- * A/B/F   memory.low = 0,    memory.current = 50M
+ * A/B/E   memory.low = 0,    memory.current = 50M
+ * A/B/F   memory.low = 500M, memory.current = 0
  *
  * Usages are pagecache.
  * Then it creates A/G an creates a significant
@@ -412,7 +412,7 @@ static int test_memcg_min(const char *root)
  * A/B    memory.current ~= 50M
  * A/B/   memory.current ~= 33M
  * A/B/D  memory.current ~= 17M
- * A/B/E  memory.current ~= 0
+ * A/B/F  memory.current ~= 0
  *
  * After that it tries to allocate more than there is
  * unprotected memory in A available,
@@ -476,7 +476,7 @@ static int test_memcg_low(const char *root)
 		if (cg_create(children[i]))
 			goto cleanup;
 
-		if (i == 2)
+		if (i > 2)
 			continue;
 
 		if (cg_run(children[i], alloc_pagecache_50M, (void *)(long)fd))
@@ -491,9 +491,9 @@ static int test_memcg_low(const char *root)
 		goto cleanup;
 	if (cg_write(children[1], "memory.low", "25M"))
 		goto cleanup;
-	if (cg_write(children[2], "memory.low", "500M"))
+	if (cg_write(children[2], "memory.low", "0"))
 		goto cleanup;
-	if (cg_write(children[3], "memory.low", "0"))
+	if (cg_write(children[3], "memory.low", "500M"))
 		goto cleanup;
 
 	if (cg_run(parent[2], alloc_anon, (void *)MB(148)))
@@ -511,7 +511,7 @@ static int test_memcg_low(const char *root)
 	if (!values_close(c[1], MB(17), 20))
 		goto cleanup;
 
-	if (!values_close(c[2], 0, 1))
+	if (c[3] != 0)
 		goto cleanup;
 
 	if (cg_run(parent[2], alloc_anon, (void *)MB(166))) {
-- 
2.30.2

