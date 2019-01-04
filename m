From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] mm: memcontrol: use struct_size() in kmalloc()
Date: Fri, 4 Jan 2019 12:37:26 -0600
Message-ID: <20190104183726.GA6374@embeddedor>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
    int stuff;
    void *entry[];
};

instance = kmalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kmalloc(struct_size(instance, entry, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 mm/memcontrol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index af7f18b32389..ad256cf7da47 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3626,8 +3626,7 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	size = thresholds->primary ? thresholds->primary->size + 1 : 1;
 
 	/* Allocate memory for new array of thresholds */
-	new = kmalloc(sizeof(*new) + size * sizeof(struct mem_cgroup_threshold),
-			GFP_KERNEL);
+	new = kmalloc(struct_size(new, entries, size), GFP_KERNEL);
 	if (!new) {
 		ret = -ENOMEM;
 		goto unlock;
-- 
2.20.1

