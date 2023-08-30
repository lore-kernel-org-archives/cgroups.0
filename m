From: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] mm: vmscan: try to reclaim swapcache pages if no swap
 space
Date: Wed, 30 Aug 2023 09:51:09 +0800
Message-ID: <a2a237a7-aff5-cf7e-d72f-67537c950448@huawei.com>
References: <20230829024104.1505530-1-liushixin2@huawei.com>
 <CAJD7tkZafahYbBs9=HNy4QtFZ4aGTcECvvCt3bQgXaNPUYTOUg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJD7tkZafahYbBs9=HNy4QtFZ4aGTcECvvCt3bQgXaNPUYTOUg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org



On 2023/8/29 23:23, Yosry Ahmed wrote:
> On Mon, Aug 28, 2023 at 6:46=E2=80=AFPM Liu Shixin <liushixin2-hv44wF8Li9=
3QT0dZR+AlfA@public.gmane.org> wrote:
>> When spaces of swap devices are exhausted, only file pages can be reclai=
med.
>> But there are still some swapcache pages in anon lru list. This can lead
>> to a premature out-of-memory.
>>
>> The problem is found with such step:
>>
>>  Firstly, set a 9MB disk swap space, then create a cgroup with 10MB
>>  memory limit, then runs an program to allocates about 15MB memory.
>>
>> The problem occurs occasionally, which may need about 100 times.
> The reproducer I used in v2 reproduces this very reliably and simply,
> could you link to it instead?
>
> https://lore.kernel.org/lkml/CAJD7tkZAfgncV+KbKr36=3DeDzMnT=3D9dZOT0dpMWc=
urHLr6Do+GA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
OK
>
>> Fix it by checking number of swapcache pages in can_reclaim_anon_pages().
>> If the number is not zero, return true either. Moreover, add a new bit
>> swapcache_only in struct scan_control to skip isolating anon pages that
>> are not swapcache when only swapcache pages can be reclaimed to accelera=
te
>> reclaim efficiency.
>>
>> Link: https://lore.kernel.org/linux-mm/14e15f31-f3d3-4169-8ed9-fb36e57cf=
578-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
>> Signed-off-by: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gman=
e.org>
>> Tested-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.o=
rg>
> Usually people add the difference from the previous version to make it
> easy to know what changed.
>
> I still prefer to add NR_SWAPCACHE to memcg1_stats. Anyway, the code
> looks good to me. With the updated reproducer link feel free to add:
>
> Reviewed-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.=
org>
Thanks,
>
>> ---
>>  include/linux/swap.h |  6 ++++++
>>  mm/memcontrol.c      |  8 ++++++++
>>  mm/vmscan.c          | 29 +++++++++++++++++++++++++++--
>>  3 files changed, 41 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 456546443f1f..0318e918bfa4 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -669,6 +669,7 @@ static inline void mem_cgroup_uncharge_swap(swp_entr=
y_t entry, unsigned int nr_p
>>  }
>>
>>  extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
>> +extern long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg);
>>  extern bool mem_cgroup_swap_full(struct folio *folio);
>>  #else
>>  static inline void mem_cgroup_swapout(struct folio *folio, swp_entry_t =
entry)
>> @@ -691,6 +692,11 @@ static inline long mem_cgroup_get_nr_swap_pages(str=
uct mem_cgroup *memcg)
>>         return get_nr_swap_pages();
>>  }
>>
>> +static inline long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup =
*memcg)
>> +{
>> +       return total_swapcache_pages();
>> +}
>> +
>>  static inline bool mem_cgroup_swap_full(struct folio *folio)
>>  {
>>         return vm_swap_full();
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index e8ca4bdcb03c..c465829db92b 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -7567,6 +7567,14 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgro=
up *memcg)
>>         return nr_swap_pages;
>>  }
>>
>> +long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
>> +{
>> +       if (mem_cgroup_disabled())
>> +               return total_swapcache_pages();
>> +
>> +       return memcg_page_state(memcg, NR_SWAPCACHE);
>> +}
>> +
>>  bool mem_cgroup_swap_full(struct folio *folio)
>>  {
>>         struct mem_cgroup *memcg;
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 1080209a568b..e73e2df8828d 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -137,6 +137,9 @@ struct scan_control {
>>         /* Always discard instead of demoting to lower tier memory */
>>         unsigned int no_demotion:1;
>>
>> +       /* Swap space is exhausted, only reclaim swapcache for anon LRU =
*/
>> +       unsigned int swapcache_only:1;
>> +
>>         /* Allocation order */
>>         s8 order;
>>
>> @@ -613,10 +616,20 @@ static inline bool can_reclaim_anon_pages(struct m=
em_cgroup *memcg,
>>                  */
>>                 if (get_nr_swap_pages() > 0)
>>                         return true;
>> +               /* Is there any swapcache pages to reclaim? */
>> +               if (total_swapcache_pages() > 0) {
>> +                       sc->swapcache_only =3D 1;
>> +                       return true;
>> +               }
>>         } else {
>>                 /* Is the memcg below its swap limit? */
>>                 if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
>>                         return true;
>> +               /* Is there any swapcache pages in memcg to reclaim? */
>> +               if (mem_cgroup_get_nr_swapcache_pages(memcg) > 0) {
>> +                       sc->swapcache_only =3D 1;
>> +                       return true;
>> +               }
>>         }
>>
>>         /*
>> @@ -2280,6 +2293,19 @@ static bool skip_cma(struct folio *folio, struct =
scan_control *sc)
>>  }
>>  #endif
>>
>> +static bool skip_isolate(struct folio *folio, struct scan_control *sc,
>> +                        enum lru_list lru)
>> +{
>> +       if (folio_zonenum(folio) > sc->reclaim_idx)
>> +               return true;
>> +       if (skip_cma(folio, sc))
>> +               return true;
>> +       if (unlikely(sc->swapcache_only && !is_file_lru(lru) &&
>> +           !folio_test_swapcache(folio)))
>> +               return true;
>> +       return false;
>> +}
>> +
>>  /*
>>   * Isolating page from the lruvec to fill in @dst list by nr_to_scan ti=
mes.
>>   *
>> @@ -2326,8 +2352,7 @@ static unsigned long isolate_lru_folios(unsigned l=
ong nr_to_scan,
>>                 nr_pages =3D folio_nr_pages(folio);
>>                 total_scan +=3D nr_pages;
>>
>> -               if (folio_zonenum(folio) > sc->reclaim_idx ||
>> -                               skip_cma(folio, sc)) {
>> +               if (skip_isolate(folio, sc, lru)) {
>>                         nr_skipped[folio_zonenum(folio)] +=3D nr_pages;
>>                         move_to =3D &folios_skipped;
>>                         goto move;
>> --
>> 2.25.1
>>
> .
>

