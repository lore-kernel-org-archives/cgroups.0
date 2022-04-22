From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 5/5] cgroup: Fix racy check in alloc_pagecache_max_30M() helper function
Date: Fri, 22 Apr 2022 08:57:29 -0700
Message-ID: <20220422155728.3055914-6-void@manifault.com>
References: <20220422155728.3055914-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220422155728.3055914-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org

alloc_pagecache_max_30M() in the cgroup memcg tests performs a 50MB
pagecache allocation, which it expects to be capped at 30MB due to the
calling process having a memory.high setting of 30MB. After the allocation,
the function contains a check that verifies that MB(29) < memory.current <=
MB(30). This check can actually fail non-deterministically.

The testcases that use this function are test_memcg_high() and
test_memcg_max(), which set memory.min and memory.max to 30MB respectively
for the cgroup under test. The allocation can slightly exceed this number
in both cases, and for memory.max, the process performing the allocation
will not have the OOM killer invoked as it's performing a pagecache
allocation.  This patchset therefore updates the above check to instead use
the verify_close() helper function.

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index c4735fa36a3d..088850f01ae7 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -564,9 +564,14 @@ static int alloc_pagecache_max_30M(const char *cgroup, void *arg)
 {
 	size_t size = MB(50);
 	int ret = -1;
-	long current;
+	long current, high, max;
 	int fd;
 
+	high = cg_read_long(cgroup, "memory.high");
+	max = cg_read_long(cgroup, "memory.max");
+	if (high != MB(30) && max != MB(30))
+		goto cleanup;
+
 	fd = get_temp_fd();
 	if (fd < 0)
 		return -1;
@@ -575,7 +580,7 @@ static int alloc_pagecache_max_30M(const char *cgroup, void *arg)
 		goto cleanup;
 
 	current = cg_read_long(cgroup, "memory.current");
-	if (current <= MB(29) || current > MB(30))
+	if (!values_close(current, MB(30), 5))
 		goto cleanup;
 
 	ret = 0;
-- 
2.30.2

