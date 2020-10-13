From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/13] mm: clean up some lru related pieces
Date: Mon, 12 Oct 2020 19:30:03 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2010121910200.11039@eggly.anvils>
References: <20200918030051.650890-1-yuzhao@google.com> <alpine.LSU.2.11.2009181317350.11298@eggly.anvils> <20200918210126.GA1118730@google.com> <alpine.LSU.2.11.2009181406410.11531@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=bnow7E0NdAgjP24uVGPtsFmB33v0oAbeU6I6hhEmdgc=;
        b=KrUvpd/NgSTDTdOcGQLuHHaZU0xD55DjswJ8khTx2pSoboXy93Jxf2qHywUyjFDyrL
         eJQUerC2H2GL4jTguLveYvjUixN4gsg3qBA/m+K5Dfe6h4qUtsz7Vzxttb55XV+X07yB
         kfJsUhqTIm7vY9XRgP0As0lJu4QCGjFfWbyvTvKwuQN9Ol1pXyvIXfZ0yCe+cDXpIBz0
         NktjqctuKy/KaU5U0Jzy7+/tIpw0pkGlOhP2aiJ/dnkqcmgDetRZb/OomuI7G4yUVnsK
         bQwYA/vsGGaELvLzBIJMzUE0z3E9wAmmRH21fVOl6c2nyipuA/AhCfzP0wGJoCU0LAAQ
         PArg==
In-Reply-To: <alpine.LSU.2.11.2009181406410.11531-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel@vger

On Fri, 18 Sep 2020, Hugh Dickins wrote:
> On Fri, 18 Sep 2020, Yu Zhao wrote:
> > On Fri, Sep 18, 2020 at 01:46:59PM -0700, Hugh Dickins wrote:
> > > On Thu, 17 Sep 2020, Yu Zhao wrote:
> > > 
> > > > Hi Andrew,
> > > > 
> > > > I see you have taken this:
> > > >   mm: use add_page_to_lru_list()/page_lru()/page_off_lru()
> > > > Do you mind dropping it?
> > > > 
> > > > Michal asked to do a bit of additional work. So I thought I probably
> > > > should create a series to do more cleanups I've been meaning to.
> > > > 
> > > > This series contains the change in the patch above and goes a few
> > > > more steps farther. It's intended to improve readability and should
> > > > not have any performance impacts. There are minor behavior changes in
> > > > terms of debugging and error reporting, which I have all highlighted
> > > > in the individual patches. All patches were properly tested on 5.8
> > > > running Chrome OS, with various debug options turned on.
> > > > 
> > > > Michal,
> > > > 
> > > > Do you mind taking a looking at the entire series?
> > > > 
> > > > Thank you.
> > > > 
> > > > Yu Zhao (13):
> > > >   mm: use add_page_to_lru_list()
> > > >   mm: use page_off_lru()
> > > >   mm: move __ClearPageLRU() into page_off_lru()
> > > >   mm: shuffle lru list addition and deletion functions
> > > >   mm: don't pass enum lru_list to lru list addition functions
> > > >   mm: don't pass enum lru_list to trace_mm_lru_insertion()
> > > >   mm: don't pass enum lru_list to del_page_from_lru_list()
> > > >   mm: rename page_off_lru() to __clear_page_lru_flags()
> > > >   mm: inline page_lru_base_type()
> > > >   mm: VM_BUG_ON lru page flags
> > > >   mm: inline __update_lru_size()
> > > >   mm: make lruvec_lru_size() static
> > > >   mm: enlarge the int parameter of update_lru_size()
> > > > 
> > > >  include/linux/memcontrol.h     |  14 ++--
> > > >  include/linux/mm_inline.h      | 115 ++++++++++++++-------------------
> > > >  include/linux/mmzone.h         |   2 -
> > > >  include/linux/vmstat.h         |   2 +-
> > > >  include/trace/events/pagemap.h |  11 ++--
> > > >  mm/compaction.c                |   2 +-
> > > >  mm/memcontrol.c                |  10 +--
> > > >  mm/mlock.c                     |   2 +-
> > > >  mm/swap.c                      |  53 ++++++---------
> > > >  mm/vmscan.c                    |  28 +++-----
> > > >  10 files changed, 95 insertions(+), 144 deletions(-)
> > > > 
> > > > -- 
> > > > 2.28.0.681.g6f77f65b4e-goog
> > > 
> > > Sorry, Yu, I may be out-of-line in sending this: but as you know,
> > > Alex Shi has a long per-memcg lru_lock series playing in much the
> > > same area (particularly conflicting in mm/swap.c and mm/vmscan.c):
> > > a patchset that makes useful changes, that I'm very keen to help
> > > into mmotm a.s.a.p (but not before I've completed diligence).
> > > 
> > > We've put a lot of effort into its testing, I'm currently reviewing
> > > it patch by patch (my general silence indicating that I'm busy on that,
> > > but slow as ever): so I'm a bit discouraged to have its stability
> > > potentially undermined by conflicting cleanups at this stage.
> > > 
> > > If there's general agreement that your cleanups are safe and welcome
> > > (Michal's initial reaction sheds some doubt on that), great: I hope
> > > that Andrew can fast-track them into mmotm, then Alex rebase on top
> > > of them, and I then re-test and re-review.
> > > 
> > > But if that quick agreement is not forthcoming, may I ask you please
> > > to hold back, and resend based on top of Alex's next posting?
> > 
> > The per-memcg lru lock series seems a high priority, and I have
> > absolutely no problem accommodate your request.
> 
> Many thanks!
> 
> > 
> > In return, may I ask you or Alex to review this series after you
> > have finished with per-memcg lru lock (to make sure that I resolve
> > all the conflicts correctly at least)?
> 
> Fair enough: I promise to do so.
> 
> And your rebasing will necessarily lead you to review some parts
> of Alex's patchset, which will help us all too.
> 
> Andrew, Yu asked at the start:
> > > > I see you have taken this:
> > > >   mm: use add_page_to_lru_list()/page_lru()/page_off_lru()
> > > > Do you mind dropping it?
> Dropping that for now will help too.

Andrew, please drop Yu Zhao's
mm-use-add_page_to_lru_list-page_lru-page_off_lru.patch
from the mmotm tree.

Yu wants to replace it by this cleanup series, and he has graciously
agreed to rebase his series on top of Alex Shi's per-memcg lru_lock
series; but mm-use-add_page_to_lru_list-page_lru-page_off_lru.patch
is getting in the way of adding them to mmotm.  The three of us are
all hoping that Alex's v19 series can go into mmotm when the merge
window closes, then I'll review Yu's series rebased on top of it.

Thanks,
Hugh
