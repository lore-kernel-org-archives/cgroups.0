From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: add per cgroup dirty pages accounting
Date: Sat, 16 Jun 2012 15:34:24 +0900
Message-ID: <4FDC28F0.8050805@jp.fujitsu.com>
References: <1339761611-29033-1-git-send-email-handai.szj@taobao.com> <1339761717-29070-1-git-send-email-handai.szj@taobao.com> <xr93k3z8twtg.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <xr93k3z8twtg.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

(2012/06/16 0:32), Greg Thelen wrote:
> On Fri, Jun 15 2012, Sha Zhengju wrote:
>
>> This patch adds memcg routines to count dirty pages. I notice that
>> the list has talked about per-cgroup dirty page limiting
>> (http://lwn.net/Articles/455341/) before, but it did not get merged.
>
> Good timing, I was just about to make another effort to get some of
> these patches upstream.  Like you, I was going to start with some basic
> counters.
>
> Your approach is similar to what I have in mind.  While it is good to
> use the existing PageDirty flag, rather than introducing a new
> page_cgroup flag, there are locking complications (see below) to handle
> races between moving pages between memcg and the pages being {un}marked
> dirty.
>
>> I've no idea how is this going now, but maybe we can add per cgroup
>> dirty pages accounting first. This allows the memory controller to
>> maintain an accurate view of the amount of its memory that is dirty
>> and can provide some infomation while group's direct reclaim is working.
>>
>> After commit 89c06bd5 (memcg: use new logic for page stat accounting),
>> we do not need per page_cgroup flag anymore and can directly use
>> struct page flag.
>>
>>
>> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>> ---
>>   include/linux/memcontrol.h |    1 +
>>   mm/filemap.c               |    1 +
>>   mm/memcontrol.c            |   32 +++++++++++++++++++++++++-------
>>   mm/page-writeback.c        |    2 ++
>>   mm/truncate.c              |    1 +
>>   5 files changed, 30 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index a337c2e..8154ade 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -39,6 +39,7 @@ enum mem_cgroup_stat_index {
>>   	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
>>   	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
>>   	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
>> +	MEM_CGROUP_STAT_FILE_DIRTY,  /* # of dirty pages in page cache */
>>   	MEM_CGROUP_STAT_NSTATS,
>>   };
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 79c4b2b..5b5c121 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -141,6 +141,7 @@ void __delete_from_page_cache(struct page *page)
>>   	 * having removed the page entirely.
>>   	 */
>>   	if (PageDirty(page)&&  mapping_cap_account_dirty(mapping)) {
>> +		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_DIRTY);
>
> You need to use mem_cgroup_{begin,end}_update_page_stat around critical
> sections that:
> 1) check PageDirty
> 2) update MEM_CGROUP_STAT_FILE_DIRTY counter
>
> This protects against the page from being moved between memcg while
> accounting.  Same comment applies to all of your new calls to
> mem_cgroup_{dec,inc}_page_stat.  For usage pattern, see
> page_add_file_rmap.
>

If you feel some difficulty with mem_cgroup_{begin,end}_update_page_stat(),
please let me know...I hope they should work enough....

Thanks,
-Kame


