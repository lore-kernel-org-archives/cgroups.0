From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v4 11/51] memcg: implement mem_cgroup_css_from_page()
Date: Wed, 27 May 2015 20:00:02 -0400
Message-ID: <20150528000002.GT7099@htj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-12-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=8yYZ91jAaKSuIcB2ZBTuvFGqCqsjtSeDK90ismeVuz4=;
        b=ZpTlR8K9WytVsLld2I8Xx960pFEhv5VfzjMlh268CKDqkcxmevyGo3OwC3qDR7fsB7
         4XgTKSSM5K8gkfCPXjXpFxtDS55ovjHXNuyaaxldjD/bmTRzfpng22HaRMVlU0mv+wLb
         0QVavRt3nNDEVXPLEdYLyttXRzsohnYIrNqAIoW9kKtiiuVjAqMyYtNzBqYS98zQM3Me
         7Op6PUiyATvCSyiM/kcuynp4zaww1lrN2r8t3bKkNy+qJF67xFhdnkSznM3IxzPPnzJ7
         4pZ+qymv7dBBKHv4yLh5k4eTAIiIDPQ3UXqzUT332bV21/XZGreF/YaCVeRcsbgxATRR
         2Plw==
Content-Disposition: inline
In-Reply-To: <1432329245-5844-12-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

From 7cdfc9bd2cafd3f87f9e771fef25630a81c65886 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 27 May 2015 19:53:39 -0400

Implement mem_cgroup_css_from_page() which returns the
cgroup_subsys_state of the memcg associated with a given page on the
default hierarchy.  This will be used by cgroup writeback support.

This function assumes that page->mem_cgroup association doesn't change
until the page is released, which is true on the default hierarchy as
long as replace_page_cache_page() is not used.  As the only user of
replace_page_cache_page() is FUSE which won't support cgroup writeback
for the time being, this works for now, and replace_page_cache_page()
will soon be updated so that the invariant actually holds.

Note that the RCU protected page->mem_cgroup access is consistent with
other usages across memcg but ultimately incorrect.  These unlocked
accesses are missing required barriers.  page->mem_cgroup should be
made an RCU pointer and updated and accessed using RCU operations.

v4: Instead of triggering WARN, return the root css on the traditional
    hierarchies.  This makes the function a lot easier to deal with
    especially as there's no light way to synchronize against
    hierarchy rebinding.

v3: s/mem_cgroup_migrate()/mem_cgroup_css_from_page()/

v2: Trigger WARN if the function is used on the traditional
    hierarchies and add comment about the assumed invariant.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
---
Hello,

Heh, this is turning out to be more tricker than I expected.  Because
memcg may be moved between traditional and default hierarchies and
there's no cheap way to synchronize against such rebinding, we can't
simply require the caller to not use this function if memcg is not
associated with the default hierarchy.  Instead, the function now
returns root css if the associated css is not on the default
hierarchy.

While working on this, I noticed that some read accesses to
page->mem_cgroup is RCU protected but the accesses themselves aren't
RCU.  This patch follows the same pattern but this is broken.  These
are missing the requisite barriers.  We'll need to make
page->mem_cgroup an RCU pointer and use rcu accessors to deref it when
accessing locklessly.

Thanks.

 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

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
index b22a92b..5c270a0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -598,6 +598,39 @@ struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
 	return &memcg->css;
 }
 
+/**
+ * mem_cgroup_css_from_page - css of the memcg associated with a page
+ * @page: page of interest
+ *
+ * If memcg is bound to the default hierarchy, css of the memcg associated
+ * with @page is returned.  The returned css remains associated with @page
+ * until it is released.
+ *
+ * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
+ * is returned.
+ *
+ * XXX: The above description of behavior on the default hierarchy isn't
+ * strictly true yet as replace_page_cache_page() can modify the
+ * association before @page is released even on the default hierarchy;
+ * however, the current and planned usages don't mix the the two functions
+ * and replace_page_cache_page() will soon be updated to make the invariant
+ * actually true.
+ */
+struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+
+	memcg = page->mem_cgroup;
+
+	if (!memcg || !cgroup_on_dfl(memcg->css.cgroup))
+		memcg = root_mem_cgroup;
+
+	rcu_read_unlock();
+	return &memcg->css;
+}
+
 static struct mem_cgroup_per_zone *
 mem_cgroup_page_zoneinfo(struct mem_cgroup *memcg, struct page *page)
 {
-- 
2.4.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
