From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/13] mm: clean up some lru related pieces
Date: Fri, 18 Sep 2020 15:01:26 -0600
Message-ID: <20200918210126.GA1118730@google.com>
References: <20200918030051.650890-1-yuzhao@google.com>
 <alpine.LSU.2.11.2009181317350.11298@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gK5XsFJwjR3oBOvG/qkXacDHUsWYEbBlXXhB7nU1Ags=;
        b=pcN7Q//IQygz5FJBITdJVrxJvWq0Vm0gpULffWDjradPmXmYqjFqKoWw5t5ym2b7WF
         5JwcUs9TGqqN+OKKYQOm7jmsFNoZTsG4999NWYiG1ZduRlD77SAh7ijt3RZoAYnJEU4c
         nGEQ2urcqmq68lZxEHpgpfGGRC5HISEn+1orSu9d/3bwgdZ9iYImNwTG+rrmnJBRoCrs
         pwZOYq55fGt4kJen3gnpAOUJ0GLWS7rFcbW3aOuYQnl/6jpxy/KSviHHupyLJ6sdyzws
         iy8uqFFL6WbcHU7//Cme8yFxA/phGZ4gbCrDmXiJ84kbRWOfRnSTaA9CJ0bsQZlsCXVW
         K67A==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2009181317350.11298-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 18, 2020 at 01:46:59PM -0700, Hugh Dickins wrote:
> On Thu, 17 Sep 2020, Yu Zhao wrote:
> 
> > Hi Andrew,
> > 
> > I see you have taken this:
> >   mm: use add_page_to_lru_list()/page_lru()/page_off_lru()
> > Do you mind dropping it?
> > 
> > Michal asked to do a bit of additional work. So I thought I probably
> > should create a series to do more cleanups I've been meaning to.
> > 
> > This series contains the change in the patch above and goes a few
> > more steps farther. It's intended to improve readability and should
> > not have any performance impacts. There are minor behavior changes in
> > terms of debugging and error reporting, which I have all highlighted
> > in the individual patches. All patches were properly tested on 5.8
> > running Chrome OS, with various debug options turned on.
> > 
> > Michal,
> > 
> > Do you mind taking a looking at the entire series?
> > 
> > Thank you.
> > 
> > Yu Zhao (13):
> >   mm: use add_page_to_lru_list()
> >   mm: use page_off_lru()
> >   mm: move __ClearPageLRU() into page_off_lru()
> >   mm: shuffle lru list addition and deletion functions
> >   mm: don't pass enum lru_list to lru list addition functions
> >   mm: don't pass enum lru_list to trace_mm_lru_insertion()
> >   mm: don't pass enum lru_list to del_page_from_lru_list()
> >   mm: rename page_off_lru() to __clear_page_lru_flags()
> >   mm: inline page_lru_base_type()
> >   mm: VM_BUG_ON lru page flags
> >   mm: inline __update_lru_size()
> >   mm: make lruvec_lru_size() static
> >   mm: enlarge the int parameter of update_lru_size()
> > 
> >  include/linux/memcontrol.h     |  14 ++--
> >  include/linux/mm_inline.h      | 115 ++++++++++++++-------------------
> >  include/linux/mmzone.h         |   2 -
> >  include/linux/vmstat.h         |   2 +-
> >  include/trace/events/pagemap.h |  11 ++--
> >  mm/compaction.c                |   2 +-
> >  mm/memcontrol.c                |  10 +--
> >  mm/mlock.c                     |   2 +-
> >  mm/swap.c                      |  53 ++++++---------
> >  mm/vmscan.c                    |  28 +++-----
> >  10 files changed, 95 insertions(+), 144 deletions(-)
> > 
> > -- 
> > 2.28.0.681.g6f77f65b4e-goog
> 
> Sorry, Yu, I may be out-of-line in sending this: but as you know,
> Alex Shi has a long per-memcg lru_lock series playing in much the
> same area (particularly conflicting in mm/swap.c and mm/vmscan.c):
> a patchset that makes useful changes, that I'm very keen to help
> into mmotm a.s.a.p (but not before I've completed diligence).
> 
> We've put a lot of effort into its testing, I'm currently reviewing
> it patch by patch (my general silence indicating that I'm busy on that,
> but slow as ever): so I'm a bit discouraged to have its stability
> potentially undermined by conflicting cleanups at this stage.
> 
> If there's general agreement that your cleanups are safe and welcome
> (Michal's initial reaction sheds some doubt on that), great: I hope
> that Andrew can fast-track them into mmotm, then Alex rebase on top
> of them, and I then re-test and re-review.
> 
> But if that quick agreement is not forthcoming, may I ask you please
> to hold back, and resend based on top of Alex's next posting?

The per-memcg lru lock series seems a high priority, and I have
absolutely no problem accommodate your request.

In return, may I ask you or Alex to review this series after you
have finished with per-memcg lru lock (to make sure that I resolve
all the conflicts correctly at least)?
