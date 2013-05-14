From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 2/3] memcg: alter mem_cgroup_{update,inc,dec}_page_stat()
 args to memcg pointer
Date: Tue, 14 May 2013 17:03:44 +0800
Message-ID: <CAFj3OHVGXrt+MjDJZfzumjf=vj5KtwePmssoqN+KwE3yc_U2FA@mail.gmail.com>
References: <1368421410-4795-1-git-send-email-handai.szj@taobao.com>
	<1368421524-4937-1-git-send-email-handai.szj@taobao.com>
	<51918221.6090402@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=VfpcFi1YNYFrVXViU0ZjhXZki/bSAYgLBOK9sAiz5XQ=;
        b=zgxQ381VO/lK7MDAtwaVWr/h/k/zRJ81M8cCXU2O1o4sp1Ocoi5ITyrlM+QqXMungr
         QSbMM7Ng3B78zAI1q3rR4qtJ6MxUArXa89ZbMKLYLBWnoWchKznYRfbclU3Xh7nbn36H
         a3dOk9SkcGexh+OlbYoxeZU3UC9Zy3IbjdD7U+FBN41j9bLThNKHJKNMLFedvH9n884q
         oLe06QoT7A5lReGaFfZuX+1mi5mtvjk/NawuLCuSNQmUukd1FVsUnNsBNYcFojU6pwgP
         a/ugfIUWJzMyiunHiDNUxUrj4rA8a6a2JlYd7KoXUZUWnAsjqTiYBI+1w2JbekMPuXxo
         ceDQ==
In-Reply-To: <51918221.6090402-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Hi Kame,

On Tue, May 14, 2013 at 8:15 AM, Kamezawa Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> (2013/05/13 14:05), Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> Change the first argument of mem_cgroup_{update,inc,dec}_page_stat() from
>> 'struct page *' to 'struct mem_cgroup *', and so move PageCgroupUsed(pc)
>> checking out of mem_cgroup_update_page_stat(). This is a prepare patch for
>> the following memcg page stat lock simplifying.
>>
>> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>
> Why we need to find page_cgroup and memcg and check pc->flags bit
> even if memcg is unused ? I think it's too slow.
>
> Sorry, NAK.

Yeah, it's my fault... my brain filter the !CONFIG_MEMCG automatically.
Sorry for the stupid mistake and thank you for reviewing!


Thanks,
Sha

>
>
>
>> ---
>>   include/linux/memcontrol.h |   14 +++++++-------
>>   mm/memcontrol.c            |    9 ++-------
>>   mm/rmap.c                  |   28 +++++++++++++++++++++++++---
>>   3 files changed, 34 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index d6183f0..7af3ed3 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -163,20 +163,20 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
>>       rcu_read_unlock();
>>   }
>>
>> -void mem_cgroup_update_page_stat(struct page *page,
>> +void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
>>                                enum mem_cgroup_page_stat_item idx,
>>                                int val);
>>
>> -static inline void mem_cgroup_inc_page_stat(struct page *page,
>> +static inline void mem_cgroup_inc_page_stat(struct mem_cgroup *memcg,
>>                                           enum mem_cgroup_page_stat_item idx)
>>   {
>> -     mem_cgroup_update_page_stat(page, idx, 1);
>> +     mem_cgroup_update_page_stat(memcg, idx, 1);
>>   }
>>
>> -static inline void mem_cgroup_dec_page_stat(struct page *page,
>> +static inline void mem_cgroup_dec_page_stat(struct mem_cgroup *memcg,
>>                                           enum mem_cgroup_page_stat_item idx)
>>   {
>> -     mem_cgroup_update_page_stat(page, idx, -1);
>> +     mem_cgroup_update_page_stat(memcg, idx, -1);
>>   }
>>
>>   unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
>> @@ -347,12 +347,12 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
>>   {
>>   }
>>
>> -static inline void mem_cgroup_inc_page_stat(struct page *page,
>> +static inline void mem_cgroup_inc_page_stat(struct mem_cgroup *memcg,
>>                                           enum mem_cgroup_page_stat_item idx)
>>   {
>>   }
>>
>> -static inline void mem_cgroup_dec_page_stat(struct page *page,
>> +static inline void mem_cgroup_dec_page_stat(struct mem_cgroup *memcg,
>>                                           enum mem_cgroup_page_stat_item idx)
>>   {
>>   }
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index b31513e..a394ba4 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2367,18 +2367,13 @@ void __mem_cgroup_end_update_page_stat(struct page *page, unsigned long *flags)
>>       move_unlock_mem_cgroup(pc->mem_cgroup, flags);
>>   }
>>
>> -void mem_cgroup_update_page_stat(struct page *page,
>> +void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
>>                                enum mem_cgroup_page_stat_item idx, int val)
>>   {
>> -     struct mem_cgroup *memcg;
>> -     struct page_cgroup *pc = lookup_page_cgroup(page);
>> -     unsigned long uninitialized_var(flags);
>> -
>>       if (mem_cgroup_disabled())
>>               return;
>>
>> -     memcg = pc->mem_cgroup;
>> -     if (unlikely(!memcg || !PageCgroupUsed(pc)))
>> +     if (unlikely(!memcg))
>>               return;
>>
>>       switch (idx) {
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 6280da8..a03c2a9 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1109,12 +1109,24 @@ void page_add_file_rmap(struct page *page)
>>   {
>>       bool locked;
>>       unsigned long flags;
>> +     struct page_cgroup *pc;
>> +     struct mem_cgroup *memcg = NULL;
>>
>>       mem_cgroup_begin_update_page_stat(page, &locked, &flags);
>> +     pc = lookup_page_cgroup(page);
>> +
>> +     rcu_read_lock();
>> +     memcg = pc->mem_cgroup;
>> +     if (unlikely(!PageCgroupUsed(pc)))
>> +             memcg = NULL;
>> +
>>       if (atomic_inc_and_test(&page->_mapcount)) {
>>               __inc_zone_page_state(page, NR_FILE_MAPPED);
>> -             mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_MAPPED);
>> +             if (memcg)
>> +                     mem_cgroup_inc_page_stat(memcg, MEMCG_NR_FILE_MAPPED);
>>       }
>> +     rcu_read_unlock();
>> +
>>       mem_cgroup_end_update_page_stat(page, &locked, &flags);
>>   }
>>
>> @@ -1129,14 +1141,22 @@ void page_remove_rmap(struct page *page)
>>       bool anon = PageAnon(page);
>>       bool locked;
>>       unsigned long flags;
>> +     struct page_cgroup *pc;
>> +     struct mem_cgroup *memcg = NULL;
>>
>>       /*
>>        * The anon case has no mem_cgroup page_stat to update; but may
>>        * uncharge_page() below, where the lock ordering can deadlock if
>>        * we hold the lock against page_stat move: so avoid it on anon.
>>        */
>> -     if (!anon)
>> +     if (!anon) {
>>               mem_cgroup_begin_update_page_stat(page, &locked, &flags);
>> +             pc = lookup_page_cgroup(page);
>> +             rcu_read_lock();
>> +             memcg = pc->mem_cgroup;
>> +             if (unlikely(!PageCgroupUsed(pc)))
>> +                     memcg = NULL;
>> +     }
>>
>>       /* page still mapped by someone else? */
>>       if (!atomic_add_negative(-1, &page->_mapcount))
>> @@ -1157,7 +1177,9 @@ void page_remove_rmap(struct page *page)
>>                                             NR_ANON_TRANSPARENT_HUGEPAGES);
>>       } else {
>>               __dec_zone_page_state(page, NR_FILE_MAPPED);
>> -             mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_MAPPED);
>> +             if (memcg)
>> +                     mem_cgroup_dec_page_stat(memcg, MEMCG_NR_FILE_MAPPED);
>> +             rcu_read_unlock();
>>               mem_cgroup_end_update_page_stat(page, &locked, &flags);
>>       }
>>       if (unlikely(PageMlocked(page)))
>>
>
>
