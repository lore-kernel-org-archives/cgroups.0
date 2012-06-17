From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: remove MEMCG_NR_FILE_MAPPED
Date: Sun, 17 Jun 2012 14:56:15 +0800
Message-ID: <CAFj3OHVs4dLAZUPVFaadp3PPH15fU8RpOeciU5rZs9-xutDgsg@mail.gmail.com>
References: <1339761611-29033-1-git-send-email-handai.szj@taobao.com>
	<4FDC2834.7010705@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=uROpletZ7oda238T8iNC4Nap0pKoW4HN3nf9Iuwm/9g=;
        b=yFOTUf8owsdYE0bovtUqP1c+bdPXNt3L7TcfgwfJNqU/vrQbE2R6TWFPv0N/sVB4U5
         1W8SJ6EDX3SI430UfQUcs9Otfk2/nFlG264xOxoG2IEtL9+gsVgtzaLdMrYczGa2RyL9
         MuQYZqZJZMzSagoiAB19QhOw41f09lvW064gWdJp+nsY9e8WAyJ+/KusxW8tWL3/1sKU
         E8u6bemwXyJ8Kc397FvQZi7L5wNNCg70xXEYKT02KyEKG0YvZh5ASFmaZR459txso3l0
         unKtPxnxBvAYVX7BzmRJobmgHrS4SXu++DeBi2+g/BLDTHgq/HodwI+MoDBcamqvPg4H
         LaMw==
In-Reply-To: <4FDC2834.7010705-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Sat, Jun 16, 2012 at 2:31 PM, Kamezawa Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> (2012/06/15 21:00), Sha Zhengju wrote:
>> While doing memcg page stat accounting, there's no need to use MEMCG=
_NR_FILE_MAPPED
>> as an intermediate, we can use MEM_CGROUP_STAT_FILE_MAPPED directly.
>>
>> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>
> I'm sorry but my recent patch modified mem_cgroup_stat_index and this=
 will hunk with
> mm tree. (not visible in linux-next yet.)
>
> I have no objection to the patch. I'm grad if you'll update this and =
repost, later.
>


Okay, I'll repost one based on mm tree.

Thanks,
Sha


> Thanks,
> -Kame
>
>
>> ---
>> =A0 include/linux/memcontrol.h | =A0 22 ++++++++++++++++------
>> =A0 mm/memcontrol.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 25 +---------------=
---------
>> =A0 mm/rmap.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A04 ++--
>> =A0 3 files changed, 19 insertions(+), 32 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index f94efd2..a337c2e 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -27,9 +27,19 @@ struct page_cgroup;
>> =A0 struct page;
>> =A0 struct mm_struct;
>>
>> -/* Stats that can be updated by kernel. */
>> -enum mem_cgroup_page_stat_item {
>> - =A0 =A0 MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
>> +/*
>> + * Statistics for memory cgroup.
>> + */
>> +enum mem_cgroup_stat_index {
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* For MEM_CONTAINER_TYPE_ALL, usage =3D pagecache + rss=
=2E
>> + =A0 =A0 =A0*/
>> + =A0 =A0 MEM_CGROUP_STAT_CACHE, =A0 =A0 /* # of pages charged as ca=
che */
>> + =A0 =A0 MEM_CGROUP_STAT_RSS, =A0 =A0 =A0 /* # of pages charged as =
anon rss */
>> + =A0 =A0 MEM_CGROUP_STAT_FILE_MAPPED, =A0/* # of pages charged as f=
ile rss */
>> + =A0 =A0 MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
>> + =A0 =A0 MEM_CGROUP_STAT_DATA, /* end of data requires synchronizat=
ion */
>> + =A0 =A0 MEM_CGROUP_STAT_NSTATS,
>> =A0 };
>>
>> =A0 struct mem_cgroup_reclaim_cookie {
>> @@ -170,17 +180,17 @@ static inline void mem_cgroup_end_update_page_=
stat(struct page *page,
>> =A0 }
>>
>> =A0 void mem_cgroup_update_page_stat(struct page *page,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0enum me=
m_cgroup_page_stat_item idx,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0enum me=
m_cgroup_stat_index idx,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int v=
al);
>>
>> =A0 static inline void mem_cgroup_inc_page_stat(struct page *page,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 enum mem_cgroup_page_stat_item idx)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 enum mem_cgroup_stat_index idx)
>> =A0 {
>> =A0 =A0 =A0 mem_cgroup_update_page_stat(page, idx, 1);
>> =A0 }
>>
>> =A0 static inline void mem_cgroup_dec_page_stat(struct page *page,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 enum mem_cgroup_page_stat_item idx)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 enum mem_cgroup_stat_index idx)
>> =A0 {
>> =A0 =A0 =A0 mem_cgroup_update_page_stat(page, idx, -1);
>> =A0 }
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 7685d4a..9102b8c 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -77,21 +77,6 @@ static int really_do_swap_account __initdata =3D =
0;
>> =A0 #endif
>>
>>
>> -/*
>> - * Statistics for memory cgroup.
>> - */
>> -enum mem_cgroup_stat_index {
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* For MEM_CONTAINER_TYPE_ALL, usage =3D pagecache + rss=
=2E
>> - =A0 =A0 =A0*/
>> - =A0 =A0 MEM_CGROUP_STAT_CACHE, =A0 =A0 /* # of pages charged as ca=
che */
>> - =A0 =A0 MEM_CGROUP_STAT_RSS, =A0 =A0 =A0 /* # of pages charged as =
anon rss */
>> - =A0 =A0 MEM_CGROUP_STAT_FILE_MAPPED, =A0/* # of pages charged as f=
ile rss */
>> - =A0 =A0 MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
>> - =A0 =A0 MEM_CGROUP_STAT_DATA, /* end of data requires synchronizat=
ion */
>> - =A0 =A0 MEM_CGROUP_STAT_NSTATS,
>> -};
>> -
>> =A0 enum mem_cgroup_events_index {
>> =A0 =A0 =A0 MEM_CGROUP_EVENTS_PGPGIN, =A0 =A0 =A0 /* # of pages page=
d in */
>> =A0 =A0 =A0 MEM_CGROUP_EVENTS_PGPGOUT, =A0 =A0 =A0/* # of pages page=
d out */
>> @@ -1958,7 +1943,7 @@ void __mem_cgroup_end_update_page_stat(struct =
page *page, unsigned long *flags)
>> =A0 }
>>
>> =A0 void mem_cgroup_update_page_stat(struct page *page,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0enum me=
m_cgroup_page_stat_item idx, int val)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0enum me=
m_cgroup_stat_index idx, int val)
>> =A0 {
>> =A0 =A0 =A0 struct mem_cgroup *memcg;
>> =A0 =A0 =A0 struct page_cgroup *pc =3D lookup_page_cgroup(page);
>> @@ -1971,14 +1956,6 @@ void mem_cgroup_update_page_stat(struct page =
*page,
>> =A0 =A0 =A0 if (unlikely(!memcg || !PageCgroupUsed(pc)))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>>
>> - =A0 =A0 switch (idx) {
>> - =A0 =A0 case MEMCG_NR_FILE_MAPPED:
>> - =A0 =A0 =A0 =A0 =A0 =A0 idx =3D MEM_CGROUP_STAT_FILE_MAPPED;
>> - =A0 =A0 =A0 =A0 =A0 =A0 break;
>> - =A0 =A0 default:
>> - =A0 =A0 =A0 =A0 =A0 =A0 BUG();
>> - =A0 =A0 }
>> -
>> =A0 =A0 =A0 this_cpu_add(memcg->stat->count[idx], val);
>> =A0 }
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 5b5ad58..7e4e481 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1154,7 +1154,7 @@ void page_add_file_rmap(struct page *page)
>> =A0 =A0 =A0 mem_cgroup_begin_update_page_stat(page,&locked,&flags);
>> =A0 =A0 =A0 if (atomic_inc_and_test(&page->_mapcount)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 __inc_zone_page_state(page, NR_FILE_MAPP=
ED);
>> - =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_inc_page_stat(page, MEMCG_NR_FI=
LE_MAPPED);
>> + =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_inc_page_stat(page, MEM_CGROUP_=
STAT_FILE_MAPPED);
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 mem_cgroup_end_update_page_stat(page,&locked,&flags);
>> =A0 }
>> @@ -1208,7 +1208,7 @@ void page_remove_rmap(struct page *page)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 NR_ANON_TRANSPARENT_HUGEPAGES);
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 __dec_zone_page_state(page, NR_FILE_MAPP=
ED);
>> - =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_dec_page_stat(page, MEMCG_NR_FI=
LE_MAPPED);
>> + =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_dec_page_stat(page, MEM_CGROUP_=
STAT_FILE_MAPPED);
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* It would be tidy to reset the PageAnon mapping here=
,
>
>
