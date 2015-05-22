From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/51] memcg: implement mem_cgroup_css_from_page()
Date: Fri, 22 May 2015 17:13:25 -0400
Message-ID: <1432329245-5844-12-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kJpXlRfTX1dXkKjU9FPeQrHJuZvk7IF4TfhUD672LRU=;
        b=jlJgI0RifMBv+5IIRlOZZSeRhym0eUQb0gDrSBGbDjcYhKh3/u8JoUmnRGQ/96e6f6
         GYdesQzMd6tpQ7SZMVtUcR0WpaTd6hMFmfqz93cOxLK0HrFrq5p1v0CAisYKY37mhCgU
         7Dtdvz6ZEN9O9Nt975pENG6AC1otEiuOpb4afTprYVevnewjAVe7j4tUdCrsKAr1ufNa
         U5uWbBOG/OL4EfzjucVBK4LAd2dGMH3tROUANPnmi3oi5SMShW7v1icbO9O0gsFuvlpL
         w2PAoAgBF7vaPKqvRqGmHXeg1Ka4oP7CvF5/dI0UozZq77+1lJZoLebgQRiQJzvJwVAH
         ez4w==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

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
index b22a92b..763f8f3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -598,6 +598,20 @@ struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
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
2.4.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
