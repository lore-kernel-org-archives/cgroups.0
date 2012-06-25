From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v4 07/25] memcg: Reclaim when more than one page needed.
Date: Mon, 25 Jun 2012 18:04:08 +0400
Message-ID: <4FE86FD8.6010000@parallels.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-8-git-send-email-glommer@parallels.com> <20120620134738.GG5541@tiehlicka.suse.cz> <4FE227F8.3000504@parallels.com> <20120621211923.GC31759@tiehlicka.suse.cz> <4FE86411.5020708@parallels.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------040608080709070303070003"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4FE86411.5020708@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Suleiman Souhlal <suleiman@google.com>

--------------040608080709070303070003
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 06/25/2012 05:13 PM, Glauber Costa wrote:
>
>>>>> +
>>>>>       ret = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
>>>>>       if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
>>>>>           return CHARGE_RETRY;
>>>>> @@ -2234,8 +2235,10 @@ static int mem_cgroup_do_charge(struct
>>>>> mem_cgroup *memcg, gfp_t gfp_mask,
>>>>>        * unlikely to succeed so close to the limit, and we fall back
>>>>>        * to regular pages anyway in case of failure.
>>>>>        */
>>>>> -    if (nr_pages == 1 && ret)
>>>>> +    if (nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER) && ret) {
>>>>> +        cond_resched();
>>>>>           return CHARGE_RETRY;
>>>>> +    }
>>>>
>>>> What prevents us from looping for unbounded amount of time here?
>>>> Maybe you need to consider the number of reclaimed pages here.
>>>
>>> Why would we even loop here? It will just return CHARGE_RETRY, it is
>>> up to the caller to decide whether or not it will retry.
>>
>> Yes, but the test was original to prevent oom when we managed to reclaim
>> something. And something might be enough for a single page but now you
>> have high order allocations so we can retry without any success.
>>
>
> So,
>
> Most of the kmem allocations are likely to be quite small as well. For
> the slab, we're dealing with the order of 2-3 pages, and for other
> allocations that may happen, like stack, they will be in the order of 2
> pages as well.
>
> So one thing I could do here, is define a threshold, say, 3, and only
> retry for that very low threshold, instead of following COSTLY_ORDER.
> I don't expect two or three pages to be much less likely to be freed
> than a single page.
>
> I am fine with ripping of the cond_resched as well.
>
> Let me know if you would be okay with that.
>
>

For the record, here's the patch I would propose.

At this point, I think it would be nice to Suleiman to say if he is 
still okay with the changes.



--------------040608080709070303070003
Content-Type: text/x-patch;
	name="0001-memcg-Reclaim-when-more-than-one-page-needed.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-memcg-Reclaim-when-more-than-one-page-needed.patch"

From 43bb259f5a0e3a73bc76f24d1b42000a95889015 Mon Sep 17 00:00:00 2001
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
Date: Fri, 9 Mar 2012 12:39:08 -0800
Subject: [PATCH] memcg: Reclaim when more than one page needed.

mem_cgroup_do_charge() was written before slab accounting, and expects
three cases: being called for 1 page, being called for a stock of 32 pages,
or being called for a hugepage.  If we call for 2 or 3 pages (and several
slabs used in process creation are such, at least with the debug options I
had), it assumed it's being called for stock and just retried without reclaiming.

Fix that by passing down a minsize argument in addition to the csize.

And what to do about that (csize == PAGE_SIZE && ret) retry?  If it's
needed at all (and presumably is since it's there, perhaps to handle
races), then it should be extended to more than PAGE_SIZE, yet how far?
And should there be a retry count limit, of what?  For now retry up to
COSTLY_ORDER (as page_alloc.c does), stay safe with a cond_resched(),
and make sure not to do it if __GFP_NORETRY.

[v4: fixed nr pages calculation pointed out by Christoph Lameter ]

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Glauber Costa <glommer@parallels.com>
Reviewed-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9304db2..8e601e8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2158,8 +2158,16 @@ enum {
 	CHARGE_OOM_DIE,		/* the current is killed because of OOM */
 };
 
+/*
+ * We need a number that is small enough to be likely to have been
+ * reclaimed even under pressure, but not too big to trigger unnecessary 
+ * retries
+ */
+#define NR_PAGES_TO_RETRY 2
+
 static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				unsigned int nr_pages, bool oom_check)
+				unsigned int nr_pages, unsigned int min_pages,
+				bool oom_check)
 {
 	unsigned long csize = nr_pages * PAGE_SIZE;
 	struct mem_cgroup *mem_over_limit;
@@ -2182,18 +2190,18 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	} else
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
 	/*
-	 * nr_pages can be either a huge page (HPAGE_PMD_NR), a batch
-	 * of regular pages (CHARGE_BATCH), or a single regular page (1).
-	 *
 	 * Never reclaim on behalf of optional batching, retry with a
 	 * single page instead.
 	 */
-	if (nr_pages == CHARGE_BATCH)
+	if (nr_pages > min_pages)
 		return CHARGE_RETRY;
 
 	if (!(gfp_mask & __GFP_WAIT))
 		return CHARGE_WOULDBLOCK;
 
+	if (gfp_mask & __GFP_NORETRY)
+		return CHARGE_NOMEM;
+
 	ret = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
 		return CHARGE_RETRY;
@@ -2206,7 +2214,7 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * unlikely to succeed so close to the limit, and we fall back
 	 * to regular pages anyway in case of failure.
 	 */
-	if (nr_pages == 1 && ret)
+	if (nr_pages <= NR_PAGES_TO_RETRY && ret)
 		return CHARGE_RETRY;
 
 	/*
@@ -2341,7 +2349,8 @@ again:
 			nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
 		}
 
-		ret = mem_cgroup_do_charge(memcg, gfp_mask, batch, oom_check);
+		ret = mem_cgroup_do_charge(memcg, gfp_mask, batch, nr_pages,
+		    oom_check);
 		switch (ret) {
 		case CHARGE_OK:
 			break;
-- 
1.7.10.2


--------------040608080709070303070003--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
