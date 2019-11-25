From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v4 3/9] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 25 Nov 2019 09:27:25 -0800
Message-ID: <CALvZod4ZKh3HbDWJz5-tD9Q0gcMUjWmqzBGUD-ejOLCoS7ga2w@mail.gmail.com>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
 <1574166203-151975-4-git-send-email-alex.shi@linux.alibaba.com>
 <20191119160456.GD382712@cmpxchg.org> <bcf6a952-5b92-50ad-cfc1-f4d9f8f63172@linux.alibaba.com>
 <20191121220613.GB487872@cmpxchg.org> <d3bbbbf5-52c5-374c-0897-899e787cecb4@linux.alibaba.com>
 <20191122161652.GA489821@cmpxchg.org> <e629f595-df0a-71b2-35b4-b266ba1d0431@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ehtg0LDgFByK5WRliTFTt8kMCURVP50x4sdG0deprfY=;
        b=MsGNoi87guRmgvoKPI/D/lOK0M/mezTFZNaBeRkMe12Xdy9kJ4sQT0icrrtk/cQ7I+
         XoOUItIX1FSBnkYcrZNSLWVdkvbyYY40szlADlj3lWhFlS5quaL3NVAC+VY+2TVDe7jI
         KJ+irc2cGqgmeHCwls2VTypiKNL4znvvZVBq7mEG+h2OaXeYPNK1I5f176snrGp3GBXx
         B8P0Z1NJcl6VH8gT+6fWXSAYEvX+5xYGf7Dpzb4m5qVgjkm4VYf1mvMik/y5MBs39Mlc
         IptXJd/rvAlz7G/M0cIit1TcxUUhwgZJZwIepPVz//Hd5W1aQ7RNB1qVciD6Jo0S4AlO
         3PJQ==
In-Reply-To: <e629f595-df0a-71b2-35b4-b266ba1d0431@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Kirill A. Shu

On Mon, Nov 25, 2019 at 1:26 AM Alex Shi <alex.shi@linux.alibaba.com> wrote:
>
>
> >
> > But that leaves me with one more worry: compaction. We locked out
> > charge moving now, so between that and knowing that the page is alive,
> > we have page->mem_cgroup stable. But compaction doesn't know whether
> > the page is alive - it comes from a pfn and finds out using PageLRU.
> >
> > In the current code, pgdat->lru_lock remains the same before and after
> > the page is charged to a cgroup, so once compaction has that locked
> > and it observes PageLRU, it can go ahead and isolate the page.
> >
> > But lruvec->lru_lock changes during charging, and then compaction may
> > hold the wrong lock during isolation:
> >
> > compaction:                           generic_file_buffered_read:
> >
> >                                       page_cache_alloc()
> >
> > !PageBuddy()
> >
> > lock_page_lruvec(page)
> >   lruvec = mem_cgroup_page_lruvec()
> >   spin_lock(&lruvec->lru_lock)
> >   if lruvec != mem_cgroup_page_lruvec()
> >     goto again
> >
> >                                       add_to_page_cache_lru()
> >                                         mem_cgroup_commit_charge()
> >                                           page->mem_cgroup = foo
> >                                         lru_cache_add()
> >                                           __pagevec_lru_add()
> >                                             SetPageLRU()
> >
> > if PageLRU(page):
> >   __isolate_lru_page()
> >
> > I don't see what prevents the lruvec from changing under compaction,
> > neither in your patches nor in Hugh's. Maybe I'm missing something?
> >
>
> Hi Johannes,
>
> It looks my patch do the lruvec recheck/relock after PageLRU in compaction.c.
> It should be fine for your question. So I will try more testing after all changes.

Actually no, unless PageLRU check and taking lruvec lock are atomic,
the race mentioned by Johannes still exist.

Shakeel
