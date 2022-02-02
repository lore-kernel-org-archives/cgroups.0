From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 4/4] mm/page_owner: Record task command name
Date: Wed,  2 Feb 2022 15:30:36 -0500
Message-ID: <20220202203036.744010-5-longman@redhat.com>
References: <20220131192308.608837-5-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643834044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9zS1/+E6LbgkmQXXirvHhlSIzu5z9ShRmVZP1k7+Qso=;
        b=Tw3sMPEyIQ3HZj5du6TO5PPFwRlAorVqAKg8Kl9TToUQD/CJZOexCOn+PFtNt0Aga2/qX3
        uc6tlPn7G9M+4SnbOii64VBOBGFKR5UifDFJKE3yXzcdcH99NQImxdqzn8Yt1PYRP2jLTw
        XLcM1zivDg2Xpjcvy2Ni6P+R0drBC6Y=
In-Reply-To: <20220131192308.608837-5-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The page_owner information currently includes the pid of the calling
task. That is useful as long as the task is still running. Otherwise,
the number is meaningless. To have more information about the allocating
tasks that had exited by the time the page_owner information is
retrieved, we need to store the command name of the task.

Add a new comm field into page_owner structure to store the command name
and display it when the page_owner information is retrieved.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/page_owner.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index f7820357e4d4..d56afa9c792e 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -29,6 +29,7 @@ struct page_owner {
 	depot_stack_handle_t free_handle;
 	u64 ts_nsec;
 	u64 free_ts_nsec;
+	char comm[TASK_COMM_LEN];
 	pid_t pid;
 };
 
@@ -165,6 +166,8 @@ static inline void __set_page_owner_handle(struct page_ext *page_ext,
 		page_owner->last_migrate_reason = -1;
 		page_owner->pid = current->pid;
 		page_owner->ts_nsec = local_clock();
+		strlcpy(page_owner->comm, current->comm,
+			sizeof(page_owner->comm));
 		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 		__set_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 
@@ -232,6 +235,7 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 	new_page_owner->pid = old_page_owner->pid;
 	new_page_owner->ts_nsec = old_page_owner->ts_nsec;
 	new_page_owner->free_ts_nsec = old_page_owner->ts_nsec;
+	strcpy(new_page_owner->comm, old_page_owner->comm);
 
 	/*
 	 * We don't clear the bit on the old folio as it's going to be freed
@@ -379,10 +383,11 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		return -ENOMEM;
 
 	ret = scnprintf(kbuf, count,
-			"Page allocated via order %u, mask %#x(%pGg), pid %d, ts %llu ns, free_ts %llu ns\n",
+			"Page allocated via order %u, mask %#x(%pGg), pid %d (%s), ts %llu ns, free_ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
 			&page_owner->gfp_mask, page_owner->pid,
-			page_owner->ts_nsec, page_owner->free_ts_nsec);
+			page_owner->comm, page_owner->ts_nsec,
+			page_owner->free_ts_nsec);
 
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
@@ -449,9 +454,10 @@ void __dump_page_owner(const struct page *page)
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, ts %llu, free_ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d (%s), ts %llu, free_ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
-		 page_owner->pid, page_owner->ts_nsec, page_owner->free_ts_nsec);
+		 page_owner->pid, page_owner->comm, page_owner->ts_nsec,
+		 page_owner->free_ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle)
-- 
2.27.0

