From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 1/5] cgroups: Refactor children cgroups in memcg tests
Date: Fri, 22 Apr 2022 08:57:25 -0700
Message-ID: <20220422155728.3055914-2-void@manifault.com>
References: <20220422155728.3055914-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220422155728.3055914-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org

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

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 6b5259394e68..aa50eaa8b157 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
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

