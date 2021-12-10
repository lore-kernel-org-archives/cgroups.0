From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-next v2] mm/memcg: Properly handle memcg_stock access for
 PREEMPT_RT
Date: Fri, 10 Dec 2021 11:29:31 -0500
Message-ID: <80ee87bb-f36c-4a16-9095-43ea84818375@redhat.com>
References: <20211210025228.158196-1-longman@redhat.com>
 <YbNPrGEjtKjzEjQa@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639153776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5El+Q3eIgzJBovVYIEGNnx5wIrj3Zs25homqjZk9cI=;
        b=M7CmYHBWRLhriYQ0LHhJbSUVAEtpRMKDgEdTr6TRTA/ZHD6UUcDpElbhYp5ZEOQNazTWns
        XDlAl7VIrXCoCjnxc0vg5vrD9D36ydvUcsiZkyijyLO8dTaHQZBiJs6Iw5JxymtD1ePqNk
        Fe+4D/aW/xM9/NRwVUHJMrlQ0GG17ig=
Content-Language: en-US
In-Reply-To: <YbNPrGEjtKjzEjQa-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>


On 12/10/21 08:01, Sebastian Andrzej Siewior wrote:
> On 2021-12-09 21:52:28 [-0500], Waiman Long wrote:
> …
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
> …
>> @@ -2210,7 +2211,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>>   	struct memcg_stock_pcp *stock;
>>   	unsigned long flags;
>>   
>> -	local_irq_save(flags);
>> +	local_lock_irqsave(&memcg_stock.lock, flags);
> Why is this one using the lock? It isn't accessing irq_obj, right?
Well, the lock isn't just for irq_obj. It protects the whole memcg_stock 
structure which include irq_obj. Sometimes, data in irq_obj (or 
task_obj) will get transfer to nr_pages and vice versa. So it is easier 
to use one single lock for the whole thing.
>
>>   	stock = this_cpu_ptr(&memcg_stock);
>>   	if (stock->cached != memcg) { /* reset if necessary */
>> @@ -2779,29 +2780,28 @@ static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
>>    * which is cheap in non-preempt kernel. The interrupt context object stock
>>    * can only be accessed after disabling interrupt. User context code can
>>    * access interrupt object stock, but not vice versa.
>> + *
>> + * This task and interrupt context optimization is disabled for PREEMPT_RT
>> + * as there is no performance gain in this case.
>>    */
>>   static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
>>   {
>> -	struct memcg_stock_pcp *stock;
>> -
>> -	if (likely(in_task())) {
>> +	if (likely(in_task()) && !IS_ENABLED(CONFIG_PREEMPT_RT)) {
>>   		*pflags = 0UL;
>>   		preempt_disable();
>> -		stock = this_cpu_ptr(&memcg_stock);
>> -		return &stock->task_obj;
>> +		return this_cpu_ptr(&memcg_stock.task_obj);
>>   	}
> We usually add the local_lock_t to the object it protects, struct
> obj_stock it this case.
> That would give you two different locks (instead of one) so you wouldn't
> have to use preempt_disable() to avoid lockdep's complains. Also it
> would warn you if you happen to use that obj_stock in !in_task() which
> is isn't possible now.
> The only downside would be that drain_local_stock() needs to acquire two
> locks.
>
As said above, having separate locks will complicate the interaction 
between irq_obj and the broader memcg_stock fields. Besides throughput 
is a less important matrix for PREEMPT_RT, so I am not trying to 
optimize throughput performance for PREEMPT_RT here.

Cheers,
Longman

