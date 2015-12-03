From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm/memcontrol.c: use list_{first,next}_entry
Date: Thu, 3 Dec 2015 14:27:50 -0500
Message-ID: <20151203192750.GA19242@cmpxchg.org>
References: <9e62e3006561653fcbf0c49cf0b9c2b653a8ed0e.1449152124.git.geliangtang@163.com>
 <20151203162718.GK9264@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151203162718.GK9264@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Geliang Tang <geliangtang@163.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Dec 03, 2015 at 05:27:18PM +0100, Michal Hocko wrote:
> On Thu 03-12-15 22:16:55, Geliang Tang wrote:
> > To make the intention clearer, use list_{first,next}_entry instead
> > of list_entry.
> 
> Does this really help readability? This function simply uncharges the
> given list of pages. Why cannot we simply use list_for_each_entry
> instead...

You asked the same thing when reviewing the patch for the first
time. :-) I think it's time to add a comment.

From e8ba3f31bb43ed4091b997b6ee8857dc8bbcd349 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 3 Dec 2015 14:21:45 -0500
Subject: [PATCH] mm: memcontrol: clarify the uncharge_list() loop

uncharge_list() does an unusual list walk because the function can
take regular lists with dedicated list_heads as well as singleton
lists where a single page is passed via its page->lru list node.

This can sometimes lead to confusion, as well as suggestions to
replace the loop with a list_for_each_entry(), which wouldn't work.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9acfb16..f7ee1c0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5422,6 +5422,10 @@ static void uncharge_list(struct list_head *page_list)
 	struct list_head *next;
 	struct page *page;
 
+	/*
+	 * Note that the list can be a single page->lru; hence the
+	 * do-while loop instead of a simple list_for_each_entry().
+	 */
 	next = page_list->next;
 	do {
 		unsigned int nr_pages = 1;
-- 
2.6.3
