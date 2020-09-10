From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Wed, 9 Sep 2020 17:32:37 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009091640490.10087@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org> <alpine.LSU.2.11.2008241231460.1065@eggly.anvils> <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
 <alpine.LSU.2.11.2009081640070.7256@eggly.anvils> <CAKgT0Uc_L-Tz_rVJiHc5GUK_ZWOs2wRvez4QGf2wwEjx38qnbg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=a2Gw2QTQELKkuv4WuRMTiaWGDMDx+OUJI/W2YlhQu1g=;
        b=hXt2sJaDB69f3HSWBntMKHKu2u6GbGPI56g1GWVWgEWffWRmRF/46fjhjzr4y+kjSS
         olae3KV2INU6xY+5nmScaQwuyflGf/29D3hqz+AwidEpBRlgxwyecVGF+cVfQPTtLVoI
         FqlW4hqo2j4lAXBkqf4P7uucl5pqZpkaibL/ASfdbjENd1k5Lj2lQAZYgMjhdfrXfQ/G
         yabuHDKWP5Zd+KUB09u+iw39GatHXuF+7hFxQmBrzlDN1pJSILYoaj+goqHr9cPUO2WX
         oeenuvj38miM7TkbMjGFMmJyXDGvcmQoD8deSnstcoxJQk/SZIv/p9q8mFYHuaIS0uc8
         Sg6g==
In-Reply-To: <CAKgT0Uc_L-Tz_rVJiHc5GUK_ZWOs2wRvez4QGf2wwEjx38qnbg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Alex Shi <alex.shi@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, kbuild test robot <lkp@intel.com>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Wei Yang <richard.weiyang@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Rong Chen <rong.a.chen@intel.com>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, sh

On Wed, 9 Sep 2020, Alexander Duyck wrote:
> On Tue, Sep 8, 2020 at 4:41 PM Hugh Dickins <hughd@google.com> wrote:
> > [PATCH v18 28/32] mm/compaction: Drop locked from isolate_migratepages_block
> > Most of this consists of replacing "locked" by "lruvec", which is good:
> > but please fold those changes back into 20/32 (or would it be 17/32?
> > I've not yet looked into the relationship between those two), so we
> > can then see more clearly what change this 28/32 (will need renaming!)
> > actually makes, to use lruvec_holds_page_lru_lock(). That may be a
> > good change, but it's mixed up with the "locked"->"lruvec" at present,
> > and I think you could have just used lruvec for locked all along
> > (but of course there's a place where you'll need new_lruvec too).
> 
> I am good with my patch being folded in. No need to keep it separate.

Thanks.  Though it was only the "locked"->"lruvec" changes I was
suggesting to fold back, to minimize the diff, so that we could
see your use of lruvec_holds_page_lru_lock() more clearly - you
had not introduced that function at the stage of the earlier patches.

But now that I stare at it again, using lruvec_holds_page_lru_lock()
there doesn't look like an advantage to me: when it decides no, the
same calculation is made all over again in mem_cgroup_page_lruvec(),
whereas the code before only had to calculate it once.

So, the code before looks better to me: I wonder, do you think that
rcu_read_lock() is more expensive than I think it?  There can be
debug instrumentation that makes it heavier, but by itself it is
very cheap (by design) - not worth branching around.

> 
> > [PATCH v18 29/32] mm: Identify compound pages sooner in isolate_migratepages_block
> > NAK. I agree that isolate_migratepages_block() looks nicer this way, but
> > take a look at prep_new_page() in mm/page_alloc.c: post_alloc_hook() is
> > where set_page_refcounted() changes page->_refcount from 0 to 1, allowing
> > a racing get_page_unless_zero() to succeed; then later prep_compound_page()
> > is where PageHead and PageTails get set. So there's a small race window in
> > which this patch could deliver a compound page when it should not.
> 
> So the main motivation for the patch was to avoid the case where we
> are having to reset the LRU flag.

That would be satisfying.  Not necessary, but I agree satisfying.
Maybe depends also on your "skip" change, which I've not looked at yet?

> One question I would have is what if
> we swapped the code block with the __isolate_lru_page_prepare section?
> WIth that we would be taking a reference on the page, then verifying
> the LRU flag is set, and then testing for compound page flag bit.
> Would doing that close the race window since the LRU flag being set
> should indicate that the allocation has already been completed has it
> not?

Yes, I think that would be safe, and would look better.  But I am
very hesitant to give snap assurances here (I've twice missed out
a vital PageLRU check from this sequence myself): it is very easy
to deceive myself and only see it later.

If you can see a bug in what's there before these patches, certainly
we need to fix it.  But adding non-essential patches to the already
overlong series risks delaying it.

Hugh
