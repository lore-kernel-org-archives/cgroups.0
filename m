From: Xi Ruoyao <xry111@mengyan1223.wang>
Subject: [PATCH RFC] mm: memcontrol: add cgroup v2 interface to read memory
 watermark
Date: Sat, 15 Jun 2019 16:20:04 +0800
Message-ID: <0f1be041f8de95603753ffe989bd25069efa13bb.camel@mengyan1223.wang>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mengyan1223.wang;
        s=mail; t=1560586815;
        bh=bqks99JML0mByy8FjY6xU4G7QtZG+ZkGbWODY0s995M=;
        h=Subject:From:To:Cc:Date:From;
        b=X6WUvQ6Am7IOROADt2MULQT0N6H5XyrHdIjWhdgp66wkT9D8yJ03fRRJg/E8IzSug
         gP0aGKnrhRYQxaiRYYbPD+FNjl+mcGY+DcnnpYHZJat/mcn3+jv+6UuxSAFkQC/7Fm
         J6Yf0nJeFn/Rq0SXJrgMZDo0dMHERBp4NR1yps8ewLikCwHpT1K9ZW7KAC5AHOJDxE
         MmIP//2o1N12q/4eljFk+jD8otsc+oigSiisbEjPqxj+3G/Utn+HpXRQLdbZvtl5zs
         EYW60BWEROdja3ZcdxvD1EgO9YE768kPQwCJJCK/G5PEiAsYo1EaNILfCRAvT7uhUf
         eHr2f/ibTrg5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Introduce a control file memory.watermark showing the watermark
consumption of the cgroup and its descendants, in bytes.

Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
---
 mm/memcontrol.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ba9138a4a1de..b1d968f2adcd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5495,6 +5495,13 @@ static u64 memory_current_read(struct cgroup_subsys_state
*css,
 	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
 }
 
+static u64 memory_watermark_read(struct cgroup_subsys_state *css,
+				 struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	return (u64)memcg->memory.watermark * PAGE_SIZE;
+}
+
 static int memory_min_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
@@ -5771,6 +5778,11 @@ static struct cftype memory_files[] = {
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.read_u64 = memory_current_read,
 	},
+	{
+		.name = "watermark",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = memory_watermark_read,
+	},
 	{
 		.name = "min",
 		.flags = CFTYPE_NOT_ON_ROOT,
-- 
Xi Ruoyao <xry111@mengyan1223.wang>
School of Aerospace Science and Technology, Xidian University

