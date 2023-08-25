From: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] mm: vmscan: reclaim anon pages if there are
 swapcache pages
Date: Fri, 25 Aug 2023 08:47:15 +0800
Message-ID: <87sf8854oc.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20230822024901.2412520-1-liushixin2@huawei.com>
        <CAJD7tkZkYsopuqGH_Lo=kE4=HO33wmvK6mXhuq4p_KZ6pYuXtw@mail.gmail.com>
        <87wmxk6d1m.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <CAJD7tkbRyDt6cCo6_UJgt_51BznbTVQx+qX9LmSM7ThLfU+hQg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692924567; x=1724460567;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version:content-transfer-encoding;
  bh=SC3CeduAi6sdHjQnC1nP/afnUY7oCpZu6CQrcY684L0=;
  b=nZxl6YtDq6oe0vMJi7aRlBXzoHjP0srbA25AzSUuH/FuHV+26KDbn5eC
   paG64ifPJDzUQc8sGP+FIYWeSE5pbp5QFWow70v65A6T6Eh/cTDNbWJld
   /sUfax1lOD/X28O2mWB9AOf9lU0WxhJ+qWx68HFjrkv11zsztcyY0KNrW
   cPBPiOePtztZ4c+VQl5yiPpEoteVBmMiToblYWbjc6qC/JNGaJbteT0CK
   ytbe2uGuldUyyZPV5XjLfY4rQxDNZ2JqFwxIIWiL0aIaJNwmSJhsmuKd+
   9iNAJvmrNXpt/c1ApgqN5EzyAlWk479QDSlXQZIpRS2X8QjMn4OOiKMpj
   A==;
In-Reply-To: <CAJD7tkbRyDt6cCo6_UJgt_51BznbTVQx+qX9LmSM7ThLfU+hQg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Yosry Ahmed's message of "Thu, 24 Aug 2023 11:31:47 -0700")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

> On Thu, Aug 24, 2023 at 1:51=E2=80=AFAM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org=
> wrote:
>>
>> Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
>>
>> > On Mon, Aug 21, 2023 at 6:54=E2=80=AFPM Liu Shixin <liushixin2@huawei.=
com> wrote:
>> >>
>> >> When spaces of swap devices are exhausted, only file pages can be rec=
laimed.
>> >> But there are still some swapcache pages in anon lru list. This can l=
ead
>> >> to a premature out-of-memory.
>> >>
>> >> This problem can be fixed by checking number of swapcache pages in
>> >> can_reclaim_anon_pages(). For memcg v2, there are swapcache stat that=
 can
>> >> be used directly. For memcg v1, use total_swapcache_pages() instead, =
which
>> >> may not accurate but can solve the problem.
>> >
>> > Interesting find. I wonder if we really don't have any handling of
>> > this situation.
>> >
>> >>
>> >> Signed-off-by: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> >> ---
>> >>  include/linux/swap.h |  6 ++++++
>> >>  mm/memcontrol.c      |  8 ++++++++
>> >>  mm/vmscan.c          | 12 ++++++++----
>> >>  3 files changed, 22 insertions(+), 4 deletions(-)
>> >>
>> >> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> >> index 456546443f1f..0318e918bfa4 100644
>> >> --- a/include/linux/swap.h
>> >> +++ b/include/linux/swap.h
>> >> @@ -669,6 +669,7 @@ static inline void mem_cgroup_uncharge_swap(swp_e=
ntry_t entry, unsigned int nr_p
>> >>  }
>> >>
>> >>  extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
>> >> +extern long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *mem=
cg);
>> >>  extern bool mem_cgroup_swap_full(struct folio *folio);
>> >>  #else
>> >>  static inline void mem_cgroup_swapout(struct folio *folio, swp_entry=
_t entry)
>> >> @@ -691,6 +692,11 @@ static inline long mem_cgroup_get_nr_swap_pages(=
struct mem_cgroup *memcg)
>> >>         return get_nr_swap_pages();
>> >>  }
>> >>
>> >> +static inline long mem_cgroup_get_nr_swapcache_pages(struct mem_cgro=
up *memcg)
>> >> +{
>> >> +       return total_swapcache_pages();
>> >> +}
>> >> +
>> >>  static inline bool mem_cgroup_swap_full(struct folio *folio)
>> >>  {
>> >>         return vm_swap_full();
>> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> >> index e8ca4bdcb03c..3e578f41023e 100644
>> >> --- a/mm/memcontrol.c
>> >> +++ b/mm/memcontrol.c
>> >> @@ -7567,6 +7567,14 @@ long mem_cgroup_get_nr_swap_pages(struct mem_c=
group *memcg)
>> >>         return nr_swap_pages;
>> >>  }
>> >>
>> >> +long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
>> >> +{
>> >> +       if (mem_cgroup_disabled() || do_memsw_account())
>> >> +               return total_swapcache_pages();
>> >> +
>> >> +       return memcg_page_state(memcg, NR_SWAPCACHE);
>> >> +}
>> >
>> > Is there a reason why we cannot use NR_SWAPCACHE for cgroup v1? Isn't
>> > that being maintained regardless of cgroup version? It is not exposed
>> > in cgroup v1's memory.stat, but I don't think there is a reason we
>> > can't do that -- if only to document that it is being used with cgroup
>> > v1.
>> >
>> >
>> >> +
>> >>  bool mem_cgroup_swap_full(struct folio *folio)
>> >>  {
>> >>         struct mem_cgroup *memcg;
>> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> >> index 7c33c5b653ef..bcb6279cbae7 100644
>> >> --- a/mm/vmscan.c
>> >> +++ b/mm/vmscan.c
>> >> @@ -609,13 +609,17 @@ static inline bool can_reclaim_anon_pages(struc=
t mem_cgroup *memcg,
>> >>         if (memcg =3D=3D NULL) {
>> >>                 /*
>> >>                  * For non-memcg reclaim, is there
>> >> -                * space in any swap device?
>> >> +                * space in any swap device or swapcache pages?
>> >>                  */
>> >> -               if (get_nr_swap_pages() > 0)
>> >> +               if (get_nr_swap_pages() + total_swapcache_pages() > 0)
>> >>                         return true;
>> >>         } else {
>> >> -               /* Is the memcg below its swap limit? */
>> >> -               if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
>> >> +               /*
>> >> +                * Is the memcg below its swap limit or is there swap=
cache
>> >> +                * pages can be freed?
>> >> +                */
>> >> +               if (mem_cgroup_get_nr_swap_pages(memcg) +
>> >> +                   mem_cgroup_get_nr_swapcache_pages(memcg) > 0)
>> >>                         return true;
>> >>         }
>> >
>> > I wonder if it would be more efficient to set a bit in struct
>> > scan_control if we only are out of swap spaces but have swap cache
>> > pages, and only isolate anon pages that are in the swap cache, instead
>> > of isolating random anon pages. We may end up isolating pages that are
>> > not in the swap cache for a few iterations and wasting cycles.
>>
>> Scanning swap cache directly will make the code more complex.  IIUC, the
>> possibility for the swap device to be used up isn't high.  If so, I
>> prefer the simpler implementation as that in this series.
>
> I did not mean that, sorry if I wasn't clear. I meant to set a bit in
> struct scan_control, and then in isolate_lru_folios() for anon lrus,
> we can skip isolating folios that are not in the swapcache if that bit
> is set.
>
> My main concern was that if we have a few pages in the swapcache we
> may end up wasting cycles scanning through a lot of other anonymous
> pages until we reach them. If that's too much complexity that's
> understandable.

Sorry, I misunderstood your idea.  This sounds reasonable to me.  We can
check swap space and swap cache in isolate_lru_folios(), either in
isolate_lru_folios() directly, or via a bit in scan_control.
