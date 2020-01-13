From: Qiang Yu <qiang.yu@amd.com>
Subject: [PATCH RFC 2/3] mm: memcontrol: record driver memory statistics
Date: Mon, 13 Jan 2020 23:35:42 +0800
Message-ID: <20200113153543.24957-3-qiang.yu@amd.com>
References: <20200113153543.24957-1-qiang.yu@amd.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DlwxaZntIBVeSDvPKOD4vQ85k2mF4dXbT5Z/W5r0bA=;
 b=ns5+RP/uMpMArt9jZ20SH0ISwxA9/Hgtpl3dnrJxiZ+2McgZ6W7lioaMyNrCi32UvMTX3VQc1GAypcglJtHvZujGMXzxkjgMQJ1bcAq8CMJxToz/4qpego9/ZfK6x+3Px5UWQ3Ssg47OQiBPrRgVYA9B5LBrNulyxGeqACwkLTY=
In-Reply-To: <20200113153543.24957-1-qiang.yu@amd.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Kenny Ho <kenny.ho@amd.com>, Qiang Yu <qiang.yu@amd.com>

Signed-off-by: Qiang Yu <qiang.yu@amd.com>
---
 include/linux/memcontrol.h | 1 +
 mm/memcontrol.c            | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d76977943265..6518b4b5ee07 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -36,6 +36,7 @@ enum memcg_stat_item {
 	MEMCG_SOCK,
 	/* XXX: why are these zone and not node counters? */
 	MEMCG_KERNEL_STACK_KB,
+	MEMCG_DRV,
 	MEMCG_NR_STAT,
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 28595c276e6b..cdd3f3401598 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1413,6 +1413,9 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 	seq_buf_printf(&s, "sock %llu\n",
 		       (u64)memcg_page_state(memcg, MEMCG_SOCK) *
 		       PAGE_SIZE);
+	seq_buf_printf(&s, "driver %llu\n",
+		       (u64)memcg_page_state(memcg, MEMCG_DRV) *
+		       PAGE_SIZE);
 
 	seq_buf_printf(&s, "shmem %llu\n",
 		       (u64)memcg_page_state(memcg, NR_SHMEM) *
@@ -6947,6 +6950,9 @@ EXPORT_SYMBOL(mem_cgroup_driver_get_from_current);
 int mem_cgroup_charge_drvmem(struct mem_cgroup *memcg, gfp_t gfp,
 			     unsigned long nr_pages)
 {
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		mod_memcg_state(memcg, MEMCG_DRV, nr_pages);
+
 	return try_charge(memcg, gfp, nr_pages);
 }
 EXPORT_SYMBOL(mem_cgroup_charge_drvmem);
@@ -6958,6 +6964,9 @@ EXPORT_SYMBOL(mem_cgroup_charge_drvmem);
  */
 void mem_cgroup_uncharge_drvmem(struct mem_cgroup *memcg, unsigned long nr_pages)
 {
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		mod_memcg_state(memcg, MEMCG_DRV, -nr_pages);
+
 	refill_stock(memcg, nr_pages);
 }
 EXPORT_SYMBOL(mem_cgroup_uncharge_drvmem);
-- 
2.17.1


