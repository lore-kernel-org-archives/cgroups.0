From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/48] memcg: implement mem_cgroup_css_from_page()
Date: Mon, 23 Mar 2015 00:54:20 -0400
Message-ID: <1427086499-15657-10-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OLi+Jl8rAvTAmjC1jeZ+tLj5SIk308oHoDZJOBmgDYo=;
        b=hp1vH980rfvBIq9Izn0Ad8RvMoZuR8o+pk4USDXkC8bPpYpjmUPCcpHyPL+7WeNsPC
         XntxjIX0lzvK4LITDzQXU2EtjJ0aUwF7eqQTLrU1Xo0XNQGJlwaGDo2tEoBMwcwPP2Kg
         aKYgEqpiR4d96cavceBNDkW6gcAozy6V0aupxUkMYrBhqRsbir54m/LGxKYl2v607OXn
         Z7rWpztdBMEsa/uBV4nHHscrZGwV8cJRsgzAekrnp0j+PwVUJITK+JXZrKIVyW+Rrfob
         DIr7jOnaHXfoukUoCAxcR+0Z6qNro7UXJbFVS/xN4c9tpFM5D2AMjDe0n7w4U4nN5tYv
         k/zQ==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

Implement mem_cgroup_css_from_page() which returns the
cgroup_subsys_state of the memcg associated with a given page.  This
will be used by cgroup writeback support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 294498f..637ef62 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -115,6 +115,7 @@ static inline bool mm_match_cgroup(struct mm_struct *mm,
 }
 
 extern struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg);
+extern struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
 
 struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *,
 				   struct mem_cgroup *,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fda7025..74241b3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -591,6 +591,20 @@ struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
 	return &memcg->css;
 }
 
+/**
+ * mem_cgroup_css_from_page - css of the memcg associated with a page
+ * @page: page of interest
+ *
+ * This function is guaranteed to return a valid cgroup_subsys_state and
+ * the returned css remains accessible until @page is released.
+ */
+struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
+{
+	if (page->mem_cgroup)
+		return &page->mem_cgroup->css;
+	return &root_mem_cgroup->css;
+}
+
 static struct mem_cgroup_per_zone *
 mem_cgroup_page_zoneinfo(struct mem_cgroup *memcg, struct page *page)
 {
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
