From: Waiman Long <longman@redhat.com>
Subject: [PATCH v4 2/4] mm/page_owner: Use scnprintf() to avoid excessive buffer overrun check
Date: Wed,  2 Feb 2022 15:30:34 -0500
Message-ID: <20220202203036.744010-3-longman@redhat.com>
References: <20220131192308.608837-5-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643834036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aswR5jLflKHAA/2KWO7s8HDPhJp/8ybDJLjB9qtlMrw=;
        b=MdeCq5j1htWObePAKRcyAaAJBSPWZrfBjH+gkdGjaq0+scBNHLQJIyA0wk5e+WKPB6Bp/N
        rAT88O9qRQs3zTJwqubIEvPvEIW5O1nsqts4WJtN1LapVMj/9EWhcTVwpte4gy+9X+vszO
        WtGaGK5W3P0ipfNLbwjFtIykdzN+8VE=
In-Reply-To: <20220131192308.608837-5-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Mike Rapoport <rppt@kernel.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <guro@fb.com>, Rafael Aquini <aquini@redhat.com>, Waiman Long <longman@redhat.com>

The snprintf() function can return a length greater than the given
input size. That will require a check for buffer overrun after each
invocation of snprintf(). scnprintf(), on the other hand, will never
return a greater length. By using scnprintf() in selected places, we
can avoid some buffer overrun checks except after stack_depot_snprint()
and after the last snprintf().

Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/page_owner.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 99e360df9465..28dac73e0542 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -338,19 +338,16 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 	if (!kbuf)
 		return -ENOMEM;
 
-	ret = snprintf(kbuf, count,
+	ret = scnprintf(kbuf, count,
 			"Page allocated via order %u, mask %#x(%pGg), pid %d, ts %llu ns, free_ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
 			&page_owner->gfp_mask, page_owner->pid,
 			page_owner->ts_nsec, page_owner->free_ts_nsec);
 
-	if (ret >= count)
-		goto err;
-
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
 	page_mt  = gfp_migratetype(page_owner->gfp_mask);
-	ret += snprintf(kbuf + ret, count - ret,
+	ret += scnprintf(kbuf + ret, count - ret,
 			"PFN %lu type %s Block %lu type %s Flags %pGp\n",
 			pfn,
 			migratetype_names[page_mt],
@@ -358,19 +355,14 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migratetype_names[pageblock_mt],
 			&page->flags);
 
-	if (ret >= count)
-		goto err;
-
 	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
 	if (ret >= count)
 		goto err;
 
 	if (page_owner->last_migrate_reason != -1) {
-		ret += snprintf(kbuf + ret, count - ret,
+		ret += scnprintf(kbuf + ret, count - ret,
 			"Page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
-		if (ret >= count)
-			goto err;
 	}
 
 	ret += snprintf(kbuf + ret, count - ret, "\n");
-- 
2.27.0

