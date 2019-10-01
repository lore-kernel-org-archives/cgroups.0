From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] mm/memcontrol.c: fix another unused function warning
Date: Tue,  1 Oct 2019 16:22:12 +0200
Message-ID: <20191001142227.1227176-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Qian Cai <cai@lca.pw>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com

Removing the mem_cgroup_id_get() stub function introduced a new warning
of the same kind when CONFIG_MMU is disabled:

mm/memcontrol.c:4929:13: error: unused function 'mem_cgroup_id_get_many' [-Werror,-Wunused-function]

Address this using a __maybe_unused annotation.

Note: alternatively, this could be moved into an #ifdef block.  Marking it
'static inline' would not work here as that would still produce the
warning on clang, which only ignores unused inline functions declared
in header files instead of .c files.

Fixes: 4d0e3230a56a ("mm/memcontrol.c: fix a -Wunused-function warning")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c313c49074ca..5f9f90e3cef8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4921,7 +4921,8 @@ static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
 	}
 }
 
-static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
+static void __maybe_unused
+mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
 {
 	refcount_add(n, &memcg->id.ref);
 }
-- 
2.20.0

