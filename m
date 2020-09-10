From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Thu, 10 Sep 2020 07:24:56 -0700
Message-ID: <CAKgT0Ucive3RreD3TJt1Fjch_BH2ygFfUnpAJ_1BhsHy74w88g@mail.gmail.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils> <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
 <alpine.LSU.2.11.2009081640070.7256@eggly.anvils> <CAKgT0Uc_L-Tz_rVJiHc5GUK_ZWOs2wRvez4QGf2wwEjx38qnbg@mail.gmail.com>
 <alpine.LSU.2.11.2009091640490.10087@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NJbG0wJxu+3OkwLFEOd0Ennw5o6VsPA/l71MgV2bL8A=;
        b=CsIlPa7kgf5QyQFS8hC4+hb0L/bF/jNeX8ymjdfPGndzk6+fjtb6UPlyyDOgn9T/Rj
         dcNmQZtqRILJ5b0WMWAc4ARCiPRsOwn3OAskLXH4wSnP6Fci/pDDyc9GoV3CkuB65CRE
         gCg/SteaRqwF7agvOR3wOsgUovXU4Sk9WMgkXj7yL2Q8Osfwx9Q9xYGiSHVOIpXEQ5A/
         yTEI8iUxit6bTdUVaNNcOqXYtIqzxR47TjMSxqbx8tT+xNLFdbC99+e8WoQz4furBy7G
         kgFpOOKohzSXDEmsL3JJgxTPGBG3JAgnQ2qg4iT0sUE0gv9NfreIR9dAMEP/R00EWqml
         ypGQ==
In-Reply-To: <alpine.LSU.2.11.2009091640490.10087-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vlastimil

On Wed, Sep 9, 2020 at 5:32 PM Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, 9 Sep 2020, Alexander Duyck wrote:
> > On Tue, Sep 8, 2020 at 4:41 PM Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > [PATCH v18 28/32] mm/compaction: Drop locked from isolate_migratepages_block
> > > Most of this consists of replacing "locked" by "lruvec", which is good:
> > > but please fold those changes back into 20/32 (or would it be 17/32?
> > > I've not yet looked into the relationship between those two), so we
> > > can then see more clearly what change this 28/32 (will need renaming!)
> > > actually makes, to use lruvec_holds_page_lru_lock(). That may be a
> > > good change, but it's mixed up with the "locked"->"lruvec" at present,
> > > and I think you could have just used lruvec for locked all along
> > > (but of course there's a place where you'll need new_lruvec too).
> >
> > I am good with my patch being folded in. No need to keep it separate.
>
> Thanks.  Though it was only the "locked"->"lruvec" changes I was
> suggesting to fold back, to minimize the diff, so that we could
> see your use of lruvec_holds_page_lru_lock() more clearly - you
> had not introduced that function at the stage of the earlier patches.
>
> But now that I stare at it again, using lruvec_holds_page_lru_lock()
> there doesn't look like an advantage to me: when it decides no, the
> same calculation is made all over again in mem_cgroup_page_lruvec(),
> whereas the code before only had to calculate it once.
>
> So, the code before looks better to me: I wonder, do you think that
> rcu_read_lock() is more expensive than I think it?  There can be
> debug instrumentation that makes it heavier, but by itself it is
> very cheap (by design) - not worth branching around.

Actually what I was more concerned with was the pointer chase that
required the RCU lock. With this function we are able to compare a
pair of pointers from the page and the lruvec and avoid the need for
the RCU lock. The way the old code was working we had to crawl through
the memcg to get to the lruvec before we could compare it to the one
we currently hold. The general idea is to use the data we have instead
of having to pull in some additional cache lines to perform the test.

> >
> > > [PATCH v18 29/32] mm: Identify compound pages sooner in isolate_migratepages_block
> > > NAK. I agree that isolate_migratepages_block() looks nicer this way, but
> > > take a look at prep_new_page() in mm/page_alloc.c: post_alloc_hook() is
> > > where set_page_refcounted() changes page->_refcount from 0 to 1, allowing
> > > a racing get_page_unless_zero() to succeed; then later prep_compound_page()
> > > is where PageHead and PageTails get set. So there's a small race window in
> > > which this patch could deliver a compound page when it should not.
> >
> > So the main motivation for the patch was to avoid the case where we
> > are having to reset the LRU flag.
>
> That would be satisfying.  Not necessary, but I agree satisfying.
> Maybe depends also on your "skip" change, which I've not looked at yet?

My concern is that we have scenarios where isolate_migratepages_block
could possibly prevent another page from being able to isolate a page.
I'm mostly concerned with us potentially creating something like an
isolation leak if multiple threads are doing something like clearing
and then resetting the LRU flag. In my mind if we clear the LRU flag
we should be certain we are going to remove the page as otherwise
another thread would have done it if it would have been allowed
access.

> > One question I would have is what if
> > we swapped the code block with the __isolate_lru_page_prepare section?
> > WIth that we would be taking a reference on the page, then verifying
> > the LRU flag is set, and then testing for compound page flag bit.
> > Would doing that close the race window since the LRU flag being set
> > should indicate that the allocation has already been completed has it
> > not?
>
> Yes, I think that would be safe, and would look better.  But I am
> very hesitant to give snap assurances here (I've twice missed out
> a vital PageLRU check from this sequence myself): it is very easy
> to deceive myself and only see it later.

I'm not looking for assurances, just sanity checks to make sure I am
not missing something obvious.

> If you can see a bug in what's there before these patches, certainly
> we need to fix it.  But adding non-essential patches to the already
> overlong series risks delaying it.

My concern ends up being that if we are clearing the bit and restoring
it while holding the LRU lock we can effectively cause pages to become
pseudo-pinned on the LRU. In my mind I would want us to avoid clearing
the LRU flag until we know we are going to be pulling the page from
the list once we take the lruvec lock. I interpret clearing of the
flag to indicate the page has already been pulled, it just hasn't left
the list yet. With us resetting the bit we are violating that which I
worry will lead to issues.
