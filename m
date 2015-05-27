From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 11/51] memcg: implement mem_cgroup_css_from_page()
Date: Wed, 27 May 2015 12:13:44 -0400
Message-ID: <20150527161344.GO7099@htj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-12-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xjC8Ri06Hmk6Zcud8z7ioTcYxrtChXsXrvBwPEiXLYM=;
        b=HXk3+eKbm6Z/0QNkTgYq+rCr8y/ZUrTi5ydaaOKVkTG9xuzIMX+Yhodv+GzMFYuMbx
         QjvfHIPioHrHik6IFDrwQeAnJ3Fe0aZOld6W1Y0PIw6wIg3NtzYPs5UfEvM+QtnM2VZc
         apHXWVL5xkV+Hl+SUqf0YW2njDKsXwOjJtuebglkECz1t+Uwb1BgxY5uj/6PnPSp/dGN
         Isp9BabdZGtRRkdCrkJQYKMj+denY9gTcPZF14f+lk0O6V7mJsdVjI0S3BvzZT08V0Og
         WINeR15/0f5iaZEsDB90bW43NZx/7LPuGJUD2339tii9iPgUZAkWEhVL1HfXxpCR9kKh
         2Ang==
Content-Disposition: inline
In-Reply-To: <1432329245-5844-12-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

From 26bab580abfc441c841c1983469b8b86f5a8ef5c Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 27 May 2015 12:08:29 -0400

Implement mem_cgroup_css_from_page() which returns the
cgroup_subsys_state of the memcg associated with a given page.  This
will be used by cgroup writeback support.

This function assumes that page->mem_cgroup association doesn't change
until the page is released, which is true on the default hierarchy as
long as mem_cgroup_migrate() is not used.  As the only user of
mem_cgroup_migrate() is FUSE which won't support cgroup writeback for
the time being, this works for now, and mem_cgroup_migrate() will soon
be updated so that the invariant actually holds.

v2: Trigger WARN if the function is used on the traditional
    hierarchies and add comment about the assumed invariant.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
Added WARN and comments.  No functional change.  git branches updated
accordingly.

Thanks.

 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

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
index b22a92b..c76b85c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -598,6 +598,37 @@ struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
 	return &memcg->css;
 }
 
+/**
+ * mem_cgroup_css_from_page - css of the memcg associated with a page
+ * @page: page of interest
+ *
+ * This function is guaranteed to return a valid cgroup_subsys_state and
+ * the returned css remains associated with @page until it is released.
+ *
+ * This can only be used on the default hierarchy as @page's memcg
+ * association may change on the traditional hierarchies.  Use
+ * try_get_mem_cgroup_from_page() instead on the traditional hierarchies.
+ *
+ * XXX: The above comment isn't true yet as mem_cgroup_migrate() can modify
+ *      the association before @page is released even on the default
+ *      hierarchy; however, the current and planned usages don't mix the
+ *      the two functions and mem_cgroup_migrate() will soon be updated to
+ *      make the invariant actually true.
+ */
+struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
+{
+	struct cgroup_subsys_state *css;
+
+	if (page->mem_cgroup)
+		css = &page->mem_cgroup->css;
+	else
+		css = &root_mem_cgroup->css;
+
+	WARN_ON_ONCE(!cgroup_on_dfl(css->cgroup));
+
+	return css;
+}
+
 static struct mem_cgroup_per_zone *
 mem_cgroup_page_zoneinfo(struct mem_cgroup *memcg, struct page *page)
 {
-- 
2.4.0
