From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/49] memcg: add mem_cgroup_root_css
Date: Mon,  6 Apr 2015 15:57:54 -0400
Message-ID: <1428350318-8215-6-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bHqj6E7r4XRleyXuSZzlziLO3+6aJJq6uAl0SY9Xp04=;
        b=pvLPHyioE+yVtLZZTWNxMaIFyLiu3+cvHGzAQtw/w/quIOeyh+ZvozJ1Ya1c2Dff65
         /kP/2SOEm4P7CoKS3sTQa24WDP0bZhI8JV+IzfH1Y/x+XIniRX1RMzrqiw0UlXnFJp5n
         zMulK80pUCvGolMjYBNSAkIpyzGBYVb5ehduHTSZNUBYTOEmJ1K1IZQJIKnMTDKKkppu
         YUw0SVSUofGF6YpOlkpTHnmCs/2uge1gemSYLEOYNa6CMya4f2empPnbVmtRzKSJXKG0
         aoPNRUa9YtOEgKwqZ/fqMlhUvSUynXrs8TlGFWJDp3A9XXtA8klqJpaDaEZNVKwe3Hcr
         qZCA==
In-Reply-To: <1428350318-8215-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

Add global mem_cgroup_root_css which points to the root memcg css.
This will be used by cgroup writeback support.  If memcg is disabled,
it's defined as ERR_PTR(-EINVAL).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
aCc: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h | 4 ++++
 mm/memcontrol.c            | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5fe6411..294498f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -68,6 +68,8 @@ enum mem_cgroup_events_index {
 };
 
 #ifdef CONFIG_MEMCG
+extern struct cgroup_subsys_state *mem_cgroup_root_css;
+
 void mem_cgroup_events(struct mem_cgroup *memcg,
 		       enum mem_cgroup_events_index idx,
 		       unsigned int nr);
@@ -196,6 +198,8 @@ void mem_cgroup_split_huge_fixup(struct page *head);
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
+#define mem_cgroup_root_css ((struct cgroup_subsys_state *)ERR_PTR(-EINVAL))
+
 static inline void mem_cgroup_events(struct mem_cgroup *memcg,
 				     enum mem_cgroup_events_index idx,
 				     unsigned int nr)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cf25d1a..fda7025 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -71,6 +71,7 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
 
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 static struct mem_cgroup *root_mem_cgroup __read_mostly;
+struct cgroup_subsys_state *mem_cgroup_root_css __read_mostly;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
@@ -4551,6 +4552,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	/* root ? */
 	if (parent_css == NULL) {
 		root_mem_cgroup = memcg;
+		mem_cgroup_root_css = &memcg->css;
 		page_counter_init(&memcg->memory, NULL);
 		memcg->high = PAGE_COUNTER_MAX;
 		memcg->soft_limit = PAGE_COUNTER_MAX;
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
