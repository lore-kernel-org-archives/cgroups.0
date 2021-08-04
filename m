From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Disable task obj_stock for PREEMPT_RT
Date: Tue, 3 Aug 2021 21:40:35 -0400
Message-ID: <8953e099-356e-ee09-a701-f4c7f4cda487@redhat.com>
References: <20210803175519.22298-1-longman@redhat.com> <87h7g62jxm.ffs@tglx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628041239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=prEBRZoKY0mhe0m86DgKhDz/qFG3iaSQj/eiWjJyZK8=;
        b=AeGb706gsOlnqpA0U6aFrZxBFoVossX+31dgBxHLzYFamSRzwlO+hpZngv5dSN+EbSjzFe
        Pw0M03Zs+Ihvk34/txxBq4raI0TEIv+tpwPkjcKC9DHnRJ3VC3Zg3M7YUakbHRoQAFU4zU
        /K85QhFBnFU5HlIws9mwLiGpEc0NlWM=
In-Reply-To: <87h7g62jxm.ffs@tglx>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Luis Goncalves <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 8/3/21 7:21 PM, Thomas Gleixner wrote:
> Waiman,
>
> On Tue, Aug 03 2021 at 13:55, Waiman Long wrote:
>
> please Cc RT people on RT related patches.
>
>> For PREEMPT_RT kernel, preempt_disable() and local_irq_save()
>> are typically converted to local_lock() and local_lock_irqsave()
>> respectively.
> That's just wrong. local_lock has a clear value even on !RT kernels. See
>
>    https://www.kernel.org/doc/html/latest/locking/locktypes.html#local-lock
>
I understand what local_lock is for. For !RT kernel, local_lock() still 
requires the use of a pseudo_lock which is not the goal of this patch to 
put one there.
>> These two variants of local_lock() are essentially
>> the same.
> Only on RT kernels.
That is right. So this is a change aimed for easier integration with RT 
kernel.
>
>> + * For PREEMPT_RT kernel, preempt_disable() and local_irq_save() may have
>> + * to be changed to variants of local_lock(). This eliminates the
>> + * performance advantage of using preempt_disable(). Fall back to always
>> + * use local_irq_save() and use only irq_obj for simplicity.
> Instead of adding that comment you could have just done the full
> conversion, but see below.
Well, I can do that if you want me to.
>
>>    */
>> +static inline bool use_task_obj_stock(void)
>> +{
>> +	return !IS_ENABLED(CONFIG_PREEMPT_RT) && likely(in_task());
>> +}
>> +
>>   static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
>>   {
>>   	struct memcg_stock_pcp *stock;
>>   
>> -	if (likely(in_task())) {
>> +	if (use_task_obj_stock()) {
>>   		*pflags = 0UL;
>>   		preempt_disable();
>>   		stock = this_cpu_ptr(&memcg_stock);
> This is clearly the kind of conditional locking which is frowned upon
> rightfully.
>
> So if we go to reenable memcg for RT we end up with:
>
> 	if (use_task_obj_stock()) {
>             preempt_disable();
>          } else {
>             local_lock_irqsave(memcg_stock_lock, flags);
>          }
>          
> and further down we end up with:
The purpose of this series is to improve kmem_cache allocation and free 
performance for non-RT kernel. So not disabling/enabling interrupt help 
a bit in this regard.
>
>> @@ -2212,7 +2222,7 @@ static void drain_local_stock(struct work_struct *dummy)
>>   
>>   	stock = this_cpu_ptr(&memcg_stock);
>>   	drain_obj_stock(&stock->irq_obj);
>> -	if (in_task())
>> +	if (use_task_obj_stock())
>>   		drain_obj_stock(&stock->task_obj);
>>   	drain_stock(stock);
>>   	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
>> Thanks,
>>
>>          tglx
>>
>
> 	/*
> 	 * The only protection from memory hotplug vs. drain_stock races is
> 	 * that we always operate on local CPU stock here with IRQ disabled
> 	 */
> -	local_irq_save(flags);
> +	local_lock_irqsave(memcg_stock_lock, flags);
>          ...
> 	if (use_task_obj_stock())
>    		drain_obj_stock(&stock->task_obj);
>
> which is incomprehensible garbage.
>
> The comment above the existing local_irq_save() is garbage w/o any local
> lock conversion already today (and even before the commit which
> introduced stock::task_obj) simply because that comment does not explain
> the why.
That comment was added by commit 72f0184c8a00 ("mm, memcg: remove 
hotplug locking from try_charge"). It was there before my commits.

>
> I can just assume that for stock->task_obj the IRQ protection is
> completely irrelevant. If not and _all_ members of stock have to be
> protected against memory hotplug by disabling interrupts then any other
> function which just disables preemption is broken.
That is correct specifically for task_obj, but not for other data.
>
> To complete the analysis of drain_local_stock(). AFAICT that function
> can only be called from task context. So what is the purpose of this
> in_task() conditional there?
>
> 	if (in_task())
>    		drain_obj_stock(&stock->task_obj);
I haven't done a full analysis to see if it can be called from task 
context only. Maybe in_task() check isn't needed, but having it there 
provides the safety that it will still work in case it can be called 
from interrupt context.
>
> I assume it's mechanical conversion of:
>
> -       drain_obj_stock(stock);
> +       drain_obj_stock(&stock->irq_obj);
> +       if (in_task())
> +               drain_obj_stock(&stock->task_obj);
>
> all over the place without actually looking at the surrounding code,
> comments and call sites.
>
> This patch is certainly in line with that approach, but it's just adding
> more confusion.

What is your suggestion for improving this patch?

Cheers,
Longman

