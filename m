From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 5/7] memcg: add per cgroup dirty pages accounting
Date: Thu, 19 Jul 2012 15:33:05 +0900
Message-ID: <5007AA21.3050707@jp.fujitsu.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>	<1340881486-5770-1-git-send-email-handai.szj@taobao.com> <xr937guc1wdp.fsf@gthelen.mtv.corp.google.com> <4FFD4822.4020300@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FFD4822.4020300-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

(2012/07/11 18:32), Sha Zhengju wrote:
> On 07/10/2012 05:02 AM, Greg Thelen wrote:
>> On Thu, Jun 28 2012, Sha Zhengju wrote:
>>
>>> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>>
>>> This patch adds memcg routines to count dirty pages, which allows memory controller
>>> to maintain an accurate view of the amount of its dirty memory and can provide some
>>> info for users while group's direct reclaim is working.
>>>
>>> After Kame's commit 89c06bd5(memcg: use new logic for page stat accounting), we can
>>> use 'struct page' flag to test page state instead of per page_cgroup flag. But memcg
>>> has a feature to move a page from a cgroup to another one and may have race between
>>> "move" and "page stat accounting". So in order to avoid the race we have designed a
>>> bigger lock:
>>>
>>>           mem_cgroup_begin_update_page_stat()
>>>           modify page information    -->(a)
>>>           mem_cgroup_update_page_stat()  -->(b)
>>>           mem_cgroup_end_update_page_stat()
>>>
>>> It requires (a) and (b)(dirty pages accounting) can stay close enough.
>>>
>>> In the previous two prepare patches, we have reworked the vfs set page dirty routines
>>> and now the interfaces are more explicit:
>>>     incrementing (2):
>>>         __set_page_dirty
>>>         __set_page_dirty_nobuffers
>>>     decrementing (2):
>>>         clear_page_dirty_for_io
>>>         cancel_dirty_page
>>>
>>>
>>> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>   fs/buffer.c                |   17 ++++++++++++++---
>>>   include/linux/memcontrol.h |    1 +
>>>   mm/filemap.c               |    5 +++++
>>>   mm/memcontrol.c            |   28 +++++++++++++++++++++-------
>>>   mm/page-writeback.c        |   30 ++++++++++++++++++++++++------
>>>   mm/truncate.c              |    6 ++++++
>>>   6 files changed, 71 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/fs/buffer.c b/fs/buffer.c
>>> index 55522dd..d3714cc 100644
>>> --- a/fs/buffer.c
>>> +++ b/fs/buffer.c
>>> @@ -613,11 +613,19 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
>>>   int __set_page_dirty(struct page *page,
>>>           struct address_space *mapping, int warn)
>>>   {
>>> +    bool locked;
>>> +    unsigned long flags;
>>> +    int ret = 0;
>> '= 0' and 'ret = 0' change (below) are redundant.  My vote is to remove
>> '= 0' here.
>>
>
> Nice catch. :-)
>
>>> +
>>>       if (unlikely(!mapping))
>>>           return !TestSetPageDirty(page);
>>>
>>> -    if (TestSetPageDirty(page))
>>> -        return 0;
>>> +    mem_cgroup_begin_update_page_stat(page,&locked,&flags);
>>> +
>>> +    if (TestSetPageDirty(page)) {
>>> +        ret = 0;
>>> +        goto out;
>>> +    }
>>>
>>>       spin_lock_irq(&mapping->tree_lock);
>>>       if (page->mapping) {    /* Race with truncate? */
>>> @@ -629,7 +637,10 @@ int __set_page_dirty(struct page *page,
>>>       spin_unlock_irq(&mapping->tree_lock);
>>>       __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>>>
>>> -    return 1;
>>> +    ret = 1;
>>> +out:
>>> +    mem_cgroup_end_update_page_stat(page,&locked,&flags);
>>> +    return ret;
>>>   }
>>>
>>>   /*
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index 20b0f2d..ad37b59 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -38,6 +38,7 @@ enum mem_cgroup_stat_index {
>>>       MEM_CGROUP_STAT_RSS,       /* # of pages charged as anon rss */
>>>       MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
>>>       MEM_CGROUP_STAT_SWAP, /* # of pages, swapped out */
>>> +    MEM_CGROUP_STAT_FILE_DIRTY,  /* # of dirty pages in page cache */
>>>       MEM_CGROUP_STAT_NSTATS,
>>>   };
>>>
>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>> index 1f19ec3..5159a49 100644
>>> --- a/mm/filemap.c
>>> +++ b/mm/filemap.c
>>> @@ -140,6 +140,11 @@ void __delete_from_page_cache(struct page *page)
>>>        * having removed the page entirely.
>>>        */
>>>       if (PageDirty(page)&&  mapping_cap_account_dirty(mapping)) {
>>> +        /*
>>> +         * Do not change page state, so no need to use mem_cgroup_
>>> +         * {begin, end}_update_page_stat to get lock.
>>> +         */
>>> +        mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_DIRTY);
>> I do not understand this comment.  What serializes this function and
>> mem_cgroup_move_account()?
>>
>
> The race is exist just because the two competitors share one
> public variable and one reads it and the other writes it.
> I thought if both sides(accounting and cgroup_move) do not
> change page flag, then risks like doule-counting(see below)
> will not happen.
>
>               CPU-A                                   CPU-B
>          Set PG_dirty
>          (delay)                                move_lock_mem_cgroup()
>                                                     if (PageDirty(page))
> new_memcg->nr_dirty++
>                                                     pc->mem_cgroup = new_memcg;
>                                                     move_unlock_mem_cgroup()
>          move_lock_mem_cgroup()
>          memcg = pc->mem_cgroup
>          new_memcg->nr_dirty++
>
>
> But after second thoughts, it does have problem if without lock:
>
>               CPU-A                                   CPU-B
>          if (PageDirty(page)) {
>                                                     move_lock_mem_cgroup()
> TestClearPageDirty(page))
>                                                              memcg = pc->mem_cgroup
> new_memcg->nr_dirty --
>                                                     move_unlock_mem_cgroup()
>
>          memcg = pc->mem_cgroup
>          new_memcg->nr_dirty--
>          }
>
>
> It may occur race between clear_page_dirty() operation.
> So this time I think we need the lock again...
>
> Kame, what about your opinion...
>
I think Dirty bit is cleared implicitly here...So, having lock will be good.
  
Thanks,
-Kame


