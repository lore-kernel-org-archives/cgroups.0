From: Wang Weiyang <wangweiyang2@huawei.com>
Subject: [PATCH -next] mm/memcg: Use struct_size() helper in kzalloc()
Date: Thu, 16 Dec 2021 10:20:24 +0800
Message-ID: <20211216022024.127375-1-wangweiyang2@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version, in
order to avoid any potential type mistakes or integer overflows that, in
the worst scenario, could lead to heap overflows.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Wang Weiyang <wangweiyang2@huawei.com>
---
 mm/memcontrol.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 54afa29145e8..ec4b677cdcad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5129,15 +5129,11 @@ static void mem_cgroup_free(struct mem_cgroup *memcg)
 static struct mem_cgroup *mem_cgroup_alloc(void)
 {
 	struct mem_cgroup *memcg;
-	unsigned int size;
 	int node;
 	int __maybe_unused i;
 	long error = -ENOMEM;
 
-	size = sizeof(struct mem_cgroup);
-	size += nr_node_ids * sizeof(struct mem_cgroup_per_node *);
-
-	memcg = kzalloc(size, GFP_KERNEL);
+	memcg = kzalloc(struct_size(memcg, nodeinfo, nr_node_ids), GFP_KERNEL);
 	if (!memcg)
 		return ERR_PTR(error);
 
-- 
2.17.1

