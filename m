From: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since this
 will not happen
Date: Fri, 17 Jan 2020 21:30:45 -0800
Message-ID: <25e1226a-9cce-6a75-f0e9-b42f5afa22da@linux.alibaba.com>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com>
 <e73272a8-87e9-5e22-4f78-588b640f4fc4@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e73272a8-87e9-5e22-4f78-588b640f4fc4-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 1/17/20 4:57 PM, Yang Shi wrote:
>
>
> On 1/17/20 3:38 PM, Wei Yang wrote:
>> If compound is true, this means it is a PMD mapped THP. Which implies
>> the page is not linked to any defer list. So the first code chunk will
>> not be executed.
>>
>> Also with this reason, it would not be proper to add this page to a
>> defer list. So the second code chunk is not correct.
>>
>> Based on this, we should remove the defer list related code.
>>
>> Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg 
>> aware")
>>
>> Signed-off-by: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> Suggested-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>    [5.4+]
>>
>> ---
>> v4:
>>    * finally we identified the related code is not necessary and not
>>      correct, just remove it
>>    * thanks to Kirill T first spot some problem
>
> Thanks for debugging and figuring this out. Acked-by: Yang Shi 
> <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

BTW, the patch itself is fine, but the subject looks really confusing. 
It sounds like we would remove all deferred list code. I'd suggest 
rephrase it to:

mm: thp: don't need care deferred split queue in memcg charge move path

>
>> v3:
>>    * remove all review/ack tag since rewrite the changelog
>>    * use deferred_split_huge_page as the example of race
>>    * add cc stable 5.4+ tag as suggested by David Rientjes
>>
>> v2:
>>    * move check on compound outside suggested by Alexander
>>    * an example of the race condition, suggested by Michal
>> ---
>>   mm/memcontrol.c | 18 ------------------
>>   1 file changed, 18 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 6c83cf4ed970..27c231bf4565 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5340,14 +5340,6 @@ static int mem_cgroup_move_account(struct page 
>> *page,
>>           __mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
>>       }
>>   -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -    if (compound && !list_empty(page_deferred_list(page))) {
>> - spin_lock(&from->deferred_split_queue.split_queue_lock);
>> -        list_del_init(page_deferred_list(page));
>> -        from->deferred_split_queue.split_queue_len--;
>> - spin_unlock(&from->deferred_split_queue.split_queue_lock);
>> -    }
>> -#endif
>>       /*
>>        * It is safe to change page->mem_cgroup here because the page
>>        * is referenced, charged, and isolated - we can't race with
>> @@ -5357,16 +5349,6 @@ static int mem_cgroup_move_account(struct page 
>> *page,
>>       /* caller should have done css_get */
>>       page->mem_cgroup = to;
>>   -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -    if (compound && list_empty(page_deferred_list(page))) {
>> - spin_lock(&to->deferred_split_queue.split_queue_lock);
>> -        list_add_tail(page_deferred_list(page),
>> - &to->deferred_split_queue.split_queue);
>> -        to->deferred_split_queue.split_queue_len++;
>> - spin_unlock(&to->deferred_split_queue.split_queue_lock);
>> -    }
>> -#endif
>> -
>>       spin_unlock_irqrestore(&from->move_lock, flags);
>>         ret = 0;
>

