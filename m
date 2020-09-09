From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Wed, 9 Sep 2020 09:11:28 -0700
Message-ID: <CAKgT0Uc_L-Tz_rVJiHc5GUK_ZWOs2wRvez4QGf2wwEjx38qnbg@mail.gmail.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils> <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
 <alpine.LSU.2.11.2009081640070.7256@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fi6EPOk4V99JFbqYmEhNPN5TNg8BdROS9o2xQ3RBg5E=;
        b=rlfBLzoK50AdGuXYFUe5sFCgGZuO8AeB+DJLXTpOd98w2tONPNvWw7PRN8UwfX1kcB
         qpaUWzVXxXFCR4QS6X1eKPXKlVCOw84PnHMfRJcwucgm7MCtrONclkv3c2KGz6NKRWF6
         bIpuGEl92zf3lDES3mrCY0o9yN5bbmlesde/nSjHgaz11aqQZJE94l16lobir7khJp1G
         cAcR6z9rG4oAj+dPwZ9HPfHvbwf3BM1FGFuYK/NIxWfxS1rSM4FBiuz2BiSu5KXeaOPw
         QTce2zDZfvrieGVGSjHvcdTXGqtBQ81gE7ZOjeMSmma7RQZoOn1sEkpUSmqsZ5lAvgfp
         /a4A==
In-Reply-To: <alpine.LSU.2.11.2009081640070.7256-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vlastimil

On Tue, Sep 8, 2020 at 4:41 PM Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>

<snip>

> [PATCH v18 28/32] mm/compaction: Drop locked from isolate_migratepages_block
> Most of this consists of replacing "locked" by "lruvec", which is good:
> but please fold those changes back into 20/32 (or would it be 17/32?
> I've not yet looked into the relationship between those two), so we
> can then see more clearly what change this 28/32 (will need renaming!)
> actually makes, to use lruvec_holds_page_lru_lock(). That may be a
> good change, but it's mixed up with the "locked"->"lruvec" at present,
> and I think you could have just used lruvec for locked all along
> (but of course there's a place where you'll need new_lruvec too).

I am good with my patch being folded in. No need to keep it separate.

> [PATCH v18 29/32] mm: Identify compound pages sooner in isolate_migratepages_block
> NAK. I agree that isolate_migratepages_block() looks nicer this way, but
> take a look at prep_new_page() in mm/page_alloc.c: post_alloc_hook() is
> where set_page_refcounted() changes page->_refcount from 0 to 1, allowing
> a racing get_page_unless_zero() to succeed; then later prep_compound_page()
> is where PageHead and PageTails get set. So there's a small race window in
> which this patch could deliver a compound page when it should not.

So the main motivation for the patch was to avoid the case where we
are having to reset the LRU flag. One question I would have is what if
we swapped the code block with the __isolate_lru_page_prepare section?
WIth that we would be taking a reference on the page, then verifying
the LRU flag is set, and then testing for compound page flag bit.
Would doing that close the race window since the LRU flag being set
should indicate that the allocation has already been completed has it
not?

> [PATCH v18 30/32] mm: Drop use of test_and_set_skip in favor of just setting skip
> I haven't looked at this yet (but recall that per-memcg lru_lock can
> change the point at which compaction should skip a contended lock: IIRC
> the current kernel needs nothing extra, whereas some earlier kernels did
> need extra; but when I look at 30/32, may find these remarks irrelevant).
>
> [PATCH v18 31/32] mm: Add explicit page decrement in exception path for isolate_lru_pages
> The title of this patch is definitely wrong: there was an explicit page
> decrement there before (put_page), now it's wrapping it up inside a
> WARN_ON().  We usually prefer to avoid doing functional operations
> inside WARN/BUGs, but I think I'll overlook that - anyone else worried?
> The comment is certainly better than what was there before: yes, this
> warning reflects the difficulty we have in thinking about the
> TestClearPageLRU protocol: which I'm still not sold on, but
> agree we should proceed with.  With a change in title, perhaps
> "mm: add warning where TestClearPageLRU failed on freeable page"?
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I can update that and resubmit it if needed. I know there were also
some suggestions from Matthew.
