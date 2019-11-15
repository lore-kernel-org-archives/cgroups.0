From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/3] mm: vmscan: detect file thrashing at the reclaim root
Date: Fri, 15 Nov 2019 11:07:22 -0500
Message-ID: <20191115160722.GA309754@cmpxchg.org>
References: <20191107205334.158354-1-hannes@cmpxchg.org>
 <20191107205334.158354-3-hannes@cmpxchg.org>
 <CALvZod5y2NPPg=24q33=ktQqwyUsH1gpwHgROe5z_P+tW74SDw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1MDIj/Ne5pWo+qodnUOYNjkosiDdOXlcWKy8+ElVdyg=;
        b=HzFBCREP8wXPZZXgWF27J4qUzWH5xoBUAuAtElEVPcSC+Ki7U/c5SUXGvYZa01flfV
         YDHshfhjrztIe8xP8xPhd0nx9YE4eVyuCblRCwS1pg7oij+8FE1TrEk6Jj+fNx6W+AHI
         IYJZHmpNmtsc6G8iFGqUHRz8muPDmz4HrNqZ0zvq6vfgirhS0QoZnsj8w6jFmfHkfh7U
         4+cd6pqvCvowO/FlGZ1B/OCnQxWPbEIlFGrWe1Ss8FEf4VixRWYaqnJ/T8tNNgV4NOiC
         GIYUSUi39Pu5pVdEbudq/SadJ+Hy2Pg2kisrZ/lT3gydRjxhPK7Lg+wUJrhxZoUP8mHx
         qhhg==
Content-Disposition: inline
In-Reply-To: <CALvZod5y2NPPg=24q33=ktQqwyUsH1gpwHgROe5z_P+tW74SDw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Rik van Riel <riel@surriel.com>, Michal Hocko <mhocko@suse.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Thu, Nov 14, 2019 at 03:47:59PM -0800, Shakeel Butt wrote:
> On Thu, Nov 7, 2019 at 12:53 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > We use refault information to determine whether the cache workingset
> > is stable or transitioning, and dynamically adjust the inactive:active
> > file LRU ratio so as to maximize protection from one-off cache during
> > stable periods, and minimize IO during transitions.
> >
> > With cgroups and their nested LRU lists, we currently don't do this
> > correctly. While recursive cgroup reclaim establishes a relative LRU
> > order among the pages of all involved cgroups, refaults only affect
> > the local LRU order in the cgroup in which they are occuring. As a
> > result, cache transitions can take longer in a cgrouped system as the
> > active pages of sibling cgroups aren't challenged when they should be.
> >
> > [ Right now, this is somewhat theoretical, because the siblings, under
> >   continued regular reclaim pressure, should eventually run out of
> >   inactive pages - and since inactive:active *size* balancing is also
> >   done on a cgroup-local level, we will challenge the active pages
> >   eventually in most cases. But the next patch will move that relative
> >   size enforcement to the reclaim root as well, and then this patch
> >   here will be necessary to propagate refault pressure to siblings. ]
> >
> > This patch moves refault detection to the root of reclaim. Instead of
> > remembering the cgroup owner of an evicted page, remember the cgroup
> > that caused the reclaim to happen. When refaults later occur, they'll
> > correctly influence the cross-cgroup LRU order that reclaim follows.
> 
> Can you please explain how "they'll correctly influence"? I see that
> if the refaulted page was evicted due to pressure in some ancestor,
> then that's ancestor's refault distance and active file size will be
> used to decide to activate the refaulted page but how that is
> influencing cross-cgroup LRUs?

I take it the next patch answered your question: Activating a page
inside a cgroup has an effect on how it's reclaimed relative to pages
in sibling cgroups. So the influence part isn't new with this change -
it's about recognizing that an activation has an effect on a wider
scope than just the local cgroup, and considering that scope when
making the decision whether to activate or not.

> > @@ -302,6 +330,17 @@ void workingset_refault(struct page *page, void *shadow)
> >          */
> >         refault_distance = (refault - eviction) & EVICTION_MASK;
> >
> > +       /*
> > +        * The activation decision for this page is made at the level
> > +        * where the eviction occurred, as that is where the LRU order
> > +        * during page reclaim is being determined.
> > +        *
> > +        * However, the cgroup that will own the page is the one that
> > +        * is actually experiencing the refault event.
> > +        */
> > +       memcg = get_mem_cgroup_from_mm(current->mm);
> 
> Why not page_memcg(page)? page is locked.

Nice catch! Indeed, the page is charged and locked at this point, so
we don't have to do another lookup and refcounting dance here.

Delta patch:

---

From 8984f37f3e88b1b39c7d6470b313730093b24474 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Fri, 15 Nov 2019 09:14:04 -0500
Subject: [PATCH] mm: vmscan: detect file thrashing at the reclaim root fix

Shakeel points out that the page is locked and already charged by the
time we call workingset_refault(). Instead of doing another cgroup
lookup and reference from current->mm we can simply use page_memcg().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/workingset.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index f0885d9f41cd..474186b76ced 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -338,7 +338,7 @@ void workingset_refault(struct page *page, void *shadow)
 	 * However, the cgroup that will own the page is the one that
 	 * is actually experiencing the refault event.
 	 */
-	memcg = get_mem_cgroup_from_mm(current->mm);
+	memcg = page_memcg(page);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	inc_lruvec_state(lruvec, WORKINGSET_REFAULT);
@@ -349,7 +349,7 @@ void workingset_refault(struct page *page, void *shadow)
 	 * the memory was available to the page cache.
 	 */
 	if (refault_distance > active_file)
-		goto out_memcg;
+		goto out;
 
 	SetPageActive(page);
 	advance_inactive_age(memcg, pgdat);
@@ -360,9 +360,6 @@ void workingset_refault(struct page *page, void *shadow)
 		SetPageWorkingset(page);
 		inc_lruvec_state(lruvec, WORKINGSET_RESTORE);
 	}
-
-out_memcg:
-	mem_cgroup_put(memcg);
 out:
 	rcu_read_unlock();
 }
-- 
2.24.0

