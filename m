From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm: memcontrol: remove rcu_read_lock from get_mem_cgroup_from_page
Date: Fri,  5 Feb 2021 14:27:19 +0800
Message-ID: <20210205062719.74431-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QF0he1VW/PCEQZ3zvHTH+OFfohkfMVY0GDe6DZx57Hw=;
        b=mj7FWoJGFrcDOyAz41eFXfoppM9M6PPJ32NbJyxstX+ZDQjXJigyQZplmJkH1qTaAI
         tm89hJvYutfGv0GWNXUUQeCzoJ4C1a7kocoby20QK3xTwDOYU/yJA0TF1WaRDHIUUUdC
         0EWmCqXSeA0fyGWqsNXnOD836itIMNkR8oUG61F/cNHeTPby+jkXrI5RCBcFZzO81HU8
         BN1Tb9aUvc0GqHGTD/r/CFvwf9C+OvZYdrFV4VIhdqahmaktNx4YjXoYrf4mTytMSB+O
         rtJ4q/JfOEKmZiEiZ6H65IwVAg6QM2ai3mfUyEUMJMhZ7LKuc7hL/E3I8Uwbj2NN4jIy
         JCNQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>

The get_mem_cgroup_from_page() is called under page lock, so the page
memcg cannot be changed under us. Also, css_get is enough because page
has a reference to the memcg.

If we really want to make the get_mem_cgroup_from_page() suitable for
arbitrary page, we should use page_memcg_rcu() instead of page_memcg()
and call it after rcu_read_lock().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memcontrol.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 87f01bc05d1f..6c7f1ea3955e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1063,16 +1063,15 @@ EXPORT_SYMBOL(get_mem_cgroup_from_mm);
  */
 struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
 {
-	struct mem_cgroup *memcg = page_memcg(page);
+	struct mem_cgroup *memcg;
 
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	rcu_read_lock();
 	/* Page should not get uncharged and freed memcg under us. */
-	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
-		memcg = root_mem_cgroup;
-	rcu_read_unlock();
+	memcg = page_memcg(page) ? : root_mem_cgroup;
+	css_get(&memcg->css);
+
 	return memcg;
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_page);
-- 
2.11.0

