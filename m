From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH 2/2] memcg: add per cgroup dirty pages accounting
Date: Sun, 17 Jun 2012 15:44:23 +0800
Message-ID: <CAFj3OHVKpKwxJMgkr18oQ8PMcyP1MOBXyyQqYxyHF_zqKuE8VQ@mail.gmail.com>
References: <1339761611-29033-1-git-send-email-handai.szj@taobao.com>
	<1339761717-29070-1-git-send-email-handai.szj@taobao.com>
	<xr93k3z8twtg.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=v9jhPoQK5ahWa3is3iDkpzqK1wlRddyErcC/frLjz14=;
        b=rbKYAOq1rewalxGISoBctYRcmE1rMUtUu7l7YH5T3zzuqai+lm0/cDYM9SbvqF/B3k
         MexGW8KuyCZpWvM3zHFokwkHgMIh+/RamUPB2ktmB+3O1VifjcpgxtDQfepffBjFnpyG
         rsKf3zi0kActnC5h6LXrmKSoxMGyF5ybGT5xlPLQTcS8vMQEBucQOk03zvH+9Tn5qBpG
         Ox/iYqx8Dv00niRk+Z0oMR41PiK4MTrPI2wQLivAzXyS4mzA2ReZXhijtuEienbeYayr
         ocbv+BRhI/HAGx0bvGKSBb5r9rXrAytGwgHbmt8TfrA9RxjOvt1JVS7hlhw9ocdpGEGU
         bd3A==
In-Reply-To: <xr93k3z8twtg.fsf@gthelen.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Greg Thelen <gthelen@google.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, yinghan@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>

On Fri, Jun 15, 2012 at 11:32 PM, Greg Thelen <gthelen@google.com> wrot=
e:
> On Fri, Jun 15 2012, Sha Zhengju wrote:
>
>> This patch adds memcg routines to count dirty pages. I notice that
>> the list has talked about per-cgroup dirty page limiting
>> (http://lwn.net/Articles/455341/) before, but it did not get merged.
>
> Good timing, I was just about to make another effort to get some of
> these patches upstream. =A0Like you, I was going to start with some b=
asic
> counters.
>
> Your approach is similar to what I have in mind. =A0While it is good =
to
> use the existing PageDirty flag, rather than introducing a new
> page_cgroup flag, there are locking complications (see below) to hand=
le
> races between moving pages between memcg and the pages being {un}mark=
ed
> dirty.
>
>> I've no idea how is this going now, but maybe we can add per cgroup
>> dirty pages accounting first. This allows the memory controller to
>> maintain an accurate view of the amount of its memory that is dirty
>> and can provide some infomation while group's direct reclaim is work=
ing.
>>
>> After commit 89c06bd5 (memcg: use new logic for page stat accounting=
),
>> we do not need per page_cgroup flag anymore and can directly use
>> struct page flag.
>>
>>
>> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
>> ---
>> =A0include/linux/memcontrol.h | =A0 =A01 +
>> =A0mm/filemap.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A01 +
>> =A0mm/memcontrol.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 32 +++++++++++++++++=
++++++++-------
>> =A0mm/page-writeback.c =A0 =A0 =A0 =A0| =A0 =A02 ++
>> =A0mm/truncate.c =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A01 +
>> =A05 files changed, 30 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index a337c2e..8154ade 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -39,6 +39,7 @@ enum mem_cgroup_stat_index {
>> =A0 =A0 =A0 MEM_CGROUP_STAT_FILE_MAPPED, =A0/* # of pages charged as=
 file rss */
>> =A0 =A0 =A0 MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
>> =A0 =A0 =A0 MEM_CGROUP_STAT_DATA, /* end of data requires synchroniz=
ation */
>> + =A0 =A0 MEM_CGROUP_STAT_FILE_DIRTY, =A0/* # of dirty pages in page=
 cache */
>> =A0 =A0 =A0 MEM_CGROUP_STAT_NSTATS,
>> =A0};
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 79c4b2b..5b5c121 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -141,6 +141,7 @@ void __delete_from_page_cache(struct page *page)
>> =A0 =A0 =A0 =A0* having removed the page entirely.
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 if (PageDirty(page) && mapping_cap_account_dirty(mapping=
)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_dec_page_stat(page, MEM_CGROUP_=
STAT_FILE_DIRTY);
>
> You need to use mem_cgroup_{begin,end}_update_page_stat around critic=
al
> sections that:
> 1) check PageDirty
> 2) update MEM_CGROUP_STAT_FILE_DIRTY counter
>
> This protects against the page from being moved between memcg while
> accounting. =A0Same comment applies to all of your new calls to
> mem_cgroup_{dec,inc}_page_stat. =A0For usage pattern, see
> page_add_file_rmap.


It seems I should call mem_cgroup_{begin,end}_update_page_stat to preve=
nt race
while modifying struct page info.
Thanks for patiently explaining!


>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_zone_page_state(page, NR_FILE_DIRTY)=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_bdi_stat(mapping->backing_dev_info, =
BDI_RECLAIMABLE);
>> =A0 =A0 =A0 }
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 9102b8c..d200ad1 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2548,6 +2548,18 @@ void mem_cgroup_split_huge_fixup(struct page =
*head)
>> =A0}
>> =A0#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>
>> +static inline
>> +void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 struct mem_cgroup *to,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 enum mem_cgroup_stat_index idx)
>> +{
>> + =A0 =A0 /* Update stat data for mem_cgroup */
>> + =A0 =A0 preempt_disable();
>> + =A0 =A0 __this_cpu_dec(from->stat->count[idx]);
>> + =A0 =A0 __this_cpu_inc(to->stat->count[idx]);
>> + =A0 =A0 preempt_enable();
>> +}
>> +
>> =A0/**
>> =A0 * mem_cgroup_move_account - move account of the page
>> =A0 * @page: the page
>> @@ -2597,13 +2609,14 @@ static int mem_cgroup_move_account(struct pa=
ge *page,
>>
>> =A0 =A0 =A0 move_lock_mem_cgroup(from, &flags);
>>
>> - =A0 =A0 if (!anon && page_mapped(page)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* Update mapped_file data for mem_cgroup =
*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 preempt_disable();
>> - =A0 =A0 =A0 =A0 =A0 =A0 __this_cpu_dec(from->stat->count[MEM_CGROU=
P_STAT_FILE_MAPPED]);
>> - =A0 =A0 =A0 =A0 =A0 =A0 __this_cpu_inc(to->stat->count[MEM_CGROUP_=
STAT_FILE_MAPPED]);
>> - =A0 =A0 =A0 =A0 =A0 =A0 preempt_enable();
>> - =A0 =A0 }
>> + =A0 =A0 if (!anon && page_mapped(page))
>> + =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_move_account_page_stat(from, to=
,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 MEM_CGROUP_STAT_FILE_MAPPED);
>> +
>> + =A0 =A0 if (PageDirty(page))
>> + =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_move_account_page_stat(from, to=
,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 MEM_CGROUP_STAT_FILE_DIRTY);
>> +
>> =A0 =A0 =A0 mem_cgroup_charge_statistics(from, anon, -nr_pages);
>> =A0 =A0 =A0 if (uncharge)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This is not "cancel", but cancel_char=
ge does all we need. */
>> @@ -4023,6 +4036,7 @@ enum {
>> =A0 =A0 =A0 MCS_SWAP,
>> =A0 =A0 =A0 MCS_PGFAULT,
>> =A0 =A0 =A0 MCS_PGMAJFAULT,
>> + =A0 =A0 MCS_FILE_DIRTY,
>> =A0 =A0 =A0 MCS_INACTIVE_ANON,
>> =A0 =A0 =A0 MCS_ACTIVE_ANON,
>> =A0 =A0 =A0 MCS_INACTIVE_FILE,
>> @@ -4047,6 +4061,7 @@ struct {
>> =A0 =A0 =A0 {"swap", "total_swap"},
>> =A0 =A0 =A0 {"pgfault", "total_pgfault"},
>> =A0 =A0 =A0 {"pgmajfault", "total_pgmajfault"},
>> + =A0 =A0 {"dirty", "total_dirty"},
>
> Please add something to Documentation/cgroups/memory.txt describing t=
his
> new user visible data. =A0See my previous patch
> http://thread.gmane.org/gmane.linux.kernel.mm/67114 for example text.
>


Got it. I'll add it in next version.

Thanks,
Sha


>> =A0 =A0 =A0 {"inactive_anon", "total_inactive_anon"},
>> =A0 =A0 =A0 {"active_anon", "total_active_anon"},
>> =A0 =A0 =A0 {"inactive_file", "total_inactive_file"},
>> @@ -4080,6 +4095,9 @@ mem_cgroup_get_local_stat(struct mem_cgroup *m=
emcg, struct mcs_total_stat *s)
>> =A0 =A0 =A0 val =3D mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_=
PGMAJFAULT);
>> =A0 =A0 =A0 s->stat[MCS_PGMAJFAULT] +=3D val;
>>
>> + =A0 =A0 val =3D mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_FILE_D=
IRTY);
>> + =A0 =A0 s->stat[MCS_FILE_DIRTY] +=3D val * PAGE_SIZE;
>> +
>> =A0 =A0 =A0 /* per zone stat */
>> =A0 =A0 =A0 val =3D mem_cgroup_nr_lru_pages(memcg, BIT(LRU_INACTIVE_=
ANON));
>> =A0 =A0 =A0 s->stat[MCS_INACTIVE_ANON] +=3D val * PAGE_SIZE;
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index 26adea8..b17c692 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -1936,6 +1936,7 @@ int __set_page_dirty_no_writeback(struct page =
*page)
>> =A0void account_page_dirtied(struct page *page, struct address_space=
 *mapping)
>> =A0{
>> =A0 =A0 =A0 if (mapping_cap_account_dirty(mapping)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_inc_page_stat(page, MEM_CGROUP_=
STAT_FILE_DIRTY);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 __inc_zone_page_state(page, NR_FILE_DIRT=
Y);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 __inc_zone_page_state(page, NR_DIRTIED);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 __inc_bdi_stat(mapping->backing_dev_info=
, BDI_RECLAIMABLE);
>> @@ -2155,6 +2156,7 @@ int clear_page_dirty_for_io(struct page *page)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* for more comments.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (TestClearPageDirty(page)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_dec_page_stat(p=
age, MEM_CGROUP_STAT_FILE_DIRTY);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_zone_page_state(page=
, NR_FILE_DIRTY);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_bdi_stat(mapping->ba=
cking_dev_info,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 BDI_RECLAIMABLE);
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index 61a183b..fe8363e 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -76,6 +76,7 @@ void cancel_dirty_page(struct page *page, unsigned=
 int account_size)
>> =A0 =A0 =A0 if (TestClearPageDirty(page)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct address_space *mapping =3D page->=
mapping;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mapping && mapping_cap_account_dirty=
(mapping)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_dec_page_stat(p=
age, MEM_CGROUP_STAT_FILE_DIRTY);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_zone_page_state(page=
, NR_FILE_DIRTY);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_bdi_stat(mapping->ba=
cking_dev_info,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 BDI_RECLAIMABLE);
