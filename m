From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] cgroup: Fix an error handling path in alloc_pagecache_max_30M()
Date: Sun, 22 May 2022 16:18:51 +0200
Message-ID: <628312312eb40e0e39463a2c06415fde5295c716.1653229120.git.christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dan.carpenter@oracle.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Shuah Khan <shuah@kernel.org>, David Vernet <void@manifault.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org

If the first goto is taken, 'fd' is not opened yet (and is un-initialized).
So a direct return is safer.

Fixes: c1a31a2f7a9c ("cgroup: fix racy check in alloc_pagecache_max_30M() helper function")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index c3d0d5f7b19c..8833359556f3 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -448,7 +448,7 @@ static int alloc_pagecache_max_30M(const char *cgroup, void *arg)
 	high = cg_read_long(cgroup, "memory.high");
 	max = cg_read_long(cgroup, "memory.max");
 	if (high != MB(30) && max != MB(30))
-		goto cleanup;
+		return -1;
 
 	fd = get_temp_fd();
 	if (fd < 0)
-- 
2.34.1

