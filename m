From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] mm, thp: make deferred_split_shrinker memcg-aware
Date: Mon, 23 Oct 2017 13:33:15 +0200
Message-ID: <20171023113315.jfu75pl4hytakjog@dhcp22.suse.cz>
References: <20171019200323.42491-1-nehaagarwal@google.com>
 <20171020071250.ftqn2d356yekkp5k@dhcp22.suse.cz>
 <CAEvLuNbH0azyfSydbu3yNZ-_xY-G_5YrDDneCwcFbv+NgYd10w@mail.gmail.com>
 <CAEvLuNbo=zf1aC9k7sitZgYPD=P1Awwne4mmUSRtJc0EF1xcAA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAEvLuNbo=zf1aC9k7sitZgYPD=P1Awwne4mmUSRtJc0EF1xcAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neha Agarwal <nehaagarwal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Kemi Wang <kemi.wang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 20-10-17 10:47:57, Neha Agarwal wrote:
> On Fri, Oct 20, 2017 at 9:47 AM, Neha Agarwal <nehaagarwal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > [Sorry for multiple emails, it wasn't in plain text before, thus resending.]
> >
> > On Fri, Oct 20, 2017 at 12:12 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >> On Thu 19-10-17 13:03:23, Neha Agarwal wrote:
> >>> deferred_split_shrinker is NUMA aware. Making it memcg-aware if
> >>> CONFIG_MEMCG is enabled to prevent shrinking memory of memcg(s) that are
> >>> not under memory pressure. This change isolates memory pressure across
> >>> memcgs from deferred_split_shrinker perspective, by not prematurely
> >>> splitting huge pages for the memcg that is not under memory pressure.
> >>
> >> Why do we need this? THP pages are usually not shared between memcgs. Or
> >> do you have a real world example where this is not the case? Your patch
> >> is adding quite a lot of (and to be really honest very ugly) code so
> >> there better should be a _very_ good reason to justify it. I haven't
> >> looked very closely to the code, at least all those ifdefs in the code
> >> are too ugly to live.
> >> --
> >> Michal Hocko
> >> SUSE Labs
> >
> > Hi Michal,
> >
> > Let me try to pitch the motivation first:
> > In the case of NUMA-aware shrinker, memory pressure may lead to
> > splitting and freeing subpages within a THP, irrespective of whether
> > the page belongs to the memcg that is under memory pressure. THP
> > sharing between memcgs is not a pre-condition for above to happen.
> 
> I think I got confused here. The point I want to make is that when a
> memcg is under memory pressure, only memcg-aware shrinkers are called.
> However, a memcg with partially-mapped THPs (which can be split and
> thus free up subpages) should be be able to split such THPs, to avoid
> oom-kills under memory pressure. By making this shrinker memcg-aware,
> we will be able to free up subpages by splitting partially-mapped THPs
> under memory pressure.

I still do not understand, sorry. How can we result in OOM due to THP
splitting. Please make sure to describe user visible effects that you
are seeing and why you think they need fixing along with a description
on how the fix works.

So far I am kinda lost to see what you are trying to achieve and why.
-- 
Michal Hocko
SUSE Labs
