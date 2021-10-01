From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH 3/3] mm, memcg: Ensure valid memcg from objcg within a RCU
 critical section
Date: Fri, 1 Oct 2021 16:34:09 -0400
Message-ID: <1d1dd020-e86e-8478-5fea-0e4a97100667@redhat.com>
References: <20211001190938.14050-1-longman@redhat.com>
 <20211001190938.14050-4-longman@redhat.com>
 <CALvZod42VDSMy4E47snF-8yToSkt7no1h=KnYmQnH2dz2CDPLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633120452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YyOwgV/Jf4YIPqbyFfxrS4OFgtbN1vjUsbHPDDzmHEg=;
        b=BtJTGMmKr3NI2CxhL3rDsnw4Y7qPNQOlF5OgB4qljxhh7Ice8eejflr/9ho5skMI4cAReF
        DQqzG7MObSqKLYQgZtegWm+ViIgN+NWmJHJ1pff/0Jzhx66vY31RGE1GOcUpQI6JEDoxLV
        Lp+iJhJGiGdSKCVruqLvwXBfNSm5XmI=
In-Reply-To: <CALvZod42VDSMy4E47snF-8yToSkt7no1h=KnYmQnH2dz2CDPLQ@mail.gmail.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Muchun Song <songmuchun@bytedance.com>

On 10/1/21 4:24 PM, Shakeel Butt wrote:
> On Fri, Oct 1, 2021 at 12:10 PM Waiman Long <longman@redhat.com> wrote:
>> To ensure that a to-be-offlined memcg fetched from objcg remains
>> valid (has non-zero reference count) within a RCU critical section,
>> a synchronize_rcu() call is inserted at the end of memcg_offline_kmem().
>>
>> With that change, we no longer need to use css_tryget()
>> in get_mem_cgroup_from_objcg() as the final css_put() in
>> css_killed_work_fn() would not have been called yet.
>>
>> The obj_cgroup_uncharge_pages() function is simplifed to perform
>> the whole uncharge operation within a RCU critical section saving a
>> css_get()/css_put() pair.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   mm/memcontrol.c | 16 +++++++++++-----
>>   1 file changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 8177f253a127..1dbb37d96e49 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2769,10 +2769,8 @@ static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
>>          struct mem_cgroup *memcg;
>>
>>          rcu_read_lock();
>> -retry:
>>          memcg = obj_cgroup_memcg(objcg);
>> -       if (unlikely(!css_tryget(&memcg->css)))
>> -               goto retry;
>> +       css_get(&memcg->css);
>>          rcu_read_unlock();
>>
>>          return memcg;
>> @@ -2947,13 +2945,14 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
>>   {
>>          struct mem_cgroup *memcg;
>>
>> -       memcg = get_mem_cgroup_from_objcg(objcg);
>> +       rcu_read_lock();
>> +       memcg = obj_cgroup_memcg(objcg);
>>
>>          if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>>                  page_counter_uncharge(&memcg->kmem, nr_pages);
>>          refill_stock(memcg, nr_pages);
>>
>> -       css_put(&memcg->css);
>> +       rcu_read_unlock();
>>   }
>>
>>   /*
>> @@ -3672,6 +3671,13 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
>>          memcg_drain_all_list_lrus(kmemcg_id, parent);
>>
>>          memcg_free_cache_id(kmemcg_id);
>> +
>> +       /*
>> +        * To ensure that a to-be-offlined memcg fetched from objcg remains
>> +        * valid within a RCU critical section, we need to wait here until
>> +        * the a grace period has elapsed.
>> +        */
>> +       synchronize_rcu();
> This is called with cgroup_mutex held from css_offline path and
> synchronize_rcu() can be very expensive on a busy system, so, this
> will indirectly impact all the code paths which take cgroup_mutex.
>
Yes, you are right. Just don't consider this patch for the time being. I 
will need to find a way to work around that.

Thanks,
Longman

