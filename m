From: Waiman Long <longman@redhat.com>
Subject: [PATCH] memcg: Add kmem.slabinfo to v2 for debugging purpose
Date: Wed, 26 Jun 2019 12:56:14 -0400
Message-ID: <20190626165614.18586-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Waiman Long <longman@redhat.com>

With memory cgroup v1, there is a kmem.slabinfo file that can be
used to view what slabs are allocated to the memory cgroup. There
is currently no such equivalent in memory cgroup v2. This file can
be useful for debugging purpose.

This patch adds an equivalent kmem.slabinfo to v2 with the caveat that
this file will only show up as ".__DEBUG__.memory.kmem.slabinfo" when the
"cgroup_debug" parameter is specified in the kernel boot command line.
This is to avoid cluttering the cgroup v2 interface with files that
are seldom used by end users.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 mm/memcontrol.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ba9138a4a1de..236554a23f8f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5812,6 +5812,22 @@ static struct cftype memory_files[] = {
 		.seq_show = memory_oom_group_show,
 		.write = memory_oom_group_write,
 	},
+#ifdef CONFIG_MEMCG_KMEM
+	{
+		/*
+		 * This file is for debugging purpose only and will show
+		 * up as ".__DEBUG__.memory.kmem.slabinfo" when the
+		 * "cgroup_debug" parameter is specified in the kernel
+		 * boot command line.
+		 */
+		.name = "kmem.slabinfo",
+		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_DEBUG,
+		.seq_start = memcg_slab_start,
+		.seq_next = memcg_slab_next,
+		.seq_stop = memcg_slab_stop,
+		.seq_show = memcg_slab_show,
+	},
+#endif
 	{ }	/* terminate */
 };
 
-- 
2.18.1

