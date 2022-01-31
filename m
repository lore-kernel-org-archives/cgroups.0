From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] mm, memcg: Don't put offlined memcg into local stock
Date: Sun, 30 Jan 2022 22:55:56 -0500
Message-ID: <f7026256-4086-6632-569e-5b13594cb3fc@redhat.com>
References: <20211001190938.14050-1-longman@redhat.com>
 <20211001190938.14050-2-longman@redhat.com>
 <YVefHLo1+6lgw3aB@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643601367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B7pCh7cso6UhMDVYM0raa9qRlRsS2NwAWhyuB/0+4Xk=;
        b=b1H/jZIDR2vTP0htoS7tp5ltlwrNe/h9UoOr8t1QSnNBYREs5Jgq8WuGLING19lqmgcntK
        YS38p18eiFxVK527hbbH7ehR9X67ZN2qZO8ri1OUJOjDaD2olskt1LxtbQisItQ47IUWMS
        Jo7IV33ClP/8KioUbjWHsaHNG0rcRSQ=
Content-Language: en-US
In-Reply-To: <YVefHLo1+6lgw3aB-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On 10/1/21 19:51, Roman Gushchin wrote:
> On Fri, Oct 01, 2021 at 03:09:36PM -0400, Waiman Long wrote:
>> When freeing a page associated with an offlined memcg, refill_stock()
>> will put it into local stock delaying its demise until another memcg
>> comes in to take its place in the stock. To avoid that, we now check
>> for offlined memcg and go directly in this case to the slowpath for
>> the uncharge via the repurposed cancel_charge() function.
> Hi Waiman!
>
> I'm afraid it can make a cleanup of a dying cgroup slower: for every
> released page we'll potentially traverse the whole cgroup tree and
> decrease atomic page counters.
>
> I'm not sure I understand the benefits we get from this change which
> do justify the slowdown on the cleanup path.
>
> Thanks!

I was notified of a lockdep splat that this patch may help to prevent.

[18073.102101] ======================================================
[18073.102101] WARNING: possible circular locking dependency detected
[18073.102101] 5.14.0-42.el9.x86_64+debug #1 Not tainted
[18073.102101] ------------------------------------------------------
[18073.102101] bz1567074_bin/420270 is trying to acquire lock:
[18073.102101] ffffffff9bdfc478 (css_set_lock){..-.}-{2:2}, at: 
obj_cgroup_release+0x79/0x210
[18073.102101]
[18073.102101] but task is already holding lock:
[18073.102101] ffff88806ba4ef18 (&sighand->siglock){-...}-{2:2}, at: 
force_sig_info_to_task+0x6c/0x370
[18073.102101]
[18073.102101] which lock already depends on the new lock.
[18073.102101]
[18073.102101]
[18073.102101] the existing dependency chain (in reverse order) is:
[18073.102101]
[18073.102101] -> #1 (&sighand->siglock){-...}-{2:2}:
[18073.102101]        __lock_acquire+0xb72/0x1870
[18073.102101]        lock_acquire.part.0+0x117/0x340
[18073.102101]        _raw_spin_lock_irqsave+0x43/0x90
[18073.102101]        __lock_task_sighand+0xa0/0x210
[18073.102101]        cgroup_freeze_task+0x6f/0x150
[18073.102101]        cgroup_migrate_execute+0x25f/0xf90
[18073.102101]        cgroup_update_dfl_csses+0x417/0x4f0
[18073.102101]        cgroup_subtree_control_write+0x67b/0xa10
[18073.102101]        cgroup_file_write+0x1ef/0x6a0
[18073.102101]        kernfs_fop_write_iter+0x2c7/0x460
[18073.102101]        new_sync_write+0x36f/0x610
[18073.102101]        vfs_write+0x5c6/0x890
[18073.102101]        ksys_write+0xf9/0x1d0
[18073.102101]        do_syscall_64+0x3b/0x90
[18073.102101]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[18073.102101]
[18073.102101] -> #0 (css_set_lock){..-.}-{2:2}:
[18073.102101]        check_prev_add+0x15e/0x20f0
[18073.102101]        validate_chain+0xac6/0xde0
[18073.102101]        __lock_acquire+0xb72/0x1870
[18073.102101]        lock_acquire.part.0+0x117/0x340
[18073.102101]        _raw_spin_lock_irqsave+0x43/0x90
[18073.102101]        obj_cgroup_release+0x79/0x210
[18073.102101]        percpu_ref_put_many.constprop.0+0x16b/0x1a0
[18073.102101]        drain_obj_stock+0x1a8/0x310
[18073.102101]        refill_obj_stock+0xa4/0x480
[18073.102101]        obj_cgroup_charge+0x104/0x240
[18073.102101]        kmem_cache_alloc+0x94/0x400
[18073.102101]        __sigqueue_alloc+0x1b9/0x460
[18073.102101]        __send_signal+0x4b2/0xf60
[18073.102101]        force_sig_info_to_task+0x226/0x370
[18073.102101]        force_sig_fault+0xb0/0xf0
[18073.102101]        noist_exc_debug+0xec/0x110
[18073.102101]        asm_exc_debug+0x2b/0x30
[18073.102101]
[18073.102101] other info that might help us debug this:
[18073.102101]
[18073.102101]  Possible unsafe locking scenario:
[18073.102101]
[18073.102101]        CPU0                    CPU1
[18073.102101]        ----                    ----
[18073.102101]   lock(&sighand->siglock);
[18073.102101]                                lock(css_set_lock);
[18073.102101] lock(&sighand->siglock);
[18073.102101]   lock(css_set_lock);
[18073.102101]
[18073.102101]  *** DEADLOCK ***
[18073.102101]
[18073.102101] 2 locks held by bz1567074_bin/420270:
[18073.102101]  #0: ffff88806ba4ef18 (&sighand->siglock){-...}-{2:2}, 
at: force_sig_info_to_task+0x6c/0x370
[18073.102101]  #1: ffffffff9bd0ea00 (rcu_read_lock){....}-{1:2}, at: 
percpu_ref_put_many.constprop.0+0x0/0x1a0
[18073.102101]
[18073.102101] stack backtrace:
[18073.102101] CPU: 0 PID: 420270 Comm: bz1567074_bin Kdump: loaded Not 
tainted 5.14.0-42.el9.x86_64+debug #1
[18073.102101] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[18073.102101] Call Trace:
[18073.102101]  dump_stack_lvl+0x57/0x7d
[18073.102101]  check_noncircular+0x26a/0x310
[18073.102101]  ? pvclock_clocksource_read+0x2b8/0x520
[18073.102101]  ? print_circular_bug+0x1f0/0x1f0
[18073.102101]  ? alloc_chain_hlocks+0x1de/0x530
[18073.102101]  check_prev_add+0x15e/0x20f0
[18073.102101]  validate_chain+0xac6/0xde0
[18073.102101]  ? check_prev_add+0x20f0/0x20f0
[18073.102101]  __lock_acquire+0xb72/0x1870
[18073.102101]  ? __lock_acquire+0xb72/0x1870
[18073.102101]  lock_acquire.part.0+0x117/0x340
[18073.102101]  ? obj_cgroup_release+0x79/0x210
[18073.102101]  ? rcu_read_unlock+0x40/0x40
[18073.102101]  ? rcu_read_lock_sched_held+0x3f/0x70
[18073.102101]  ? lock_acquire+0x224/0x2d0
[18073.102101]  ? obj_cgroup_release+0x79/0x210
[18073.102101]  _raw_spin_lock_irqsave+0x43/0x90
[18073.102101]  ? obj_cgroup_release+0x79/0x210
[18073.102101]  obj_cgroup_release+0x79/0x210
[18073.102101]  percpu_ref_put_many.constprop.0+0x16b/0x1a0
[18073.102101]  drain_obj_stock+0x1a8/0x310
[18073.102101]  refill_obj_stock+0xa4/0x480
[18073.102101]  obj_cgroup_charge+0x104/0x240
[18073.102101]  ? __sigqueue_alloc+0x1b9/0x460
[18073.102101]  kmem_cache_alloc+0x94/0x400
[18073.102101]  ? __sigqueue_alloc+0x129/0x460
[18073.102101]  __sigqueue_alloc+0x1b9/0x460
[18073.102101]  __send_signal+0x4b2/0xf60
[18073.102101]  ? send_signal+0x9f/0x580
[18073.102101]  force_sig_info_to_task+0x226/0x370
[18073.102101]  force_sig_fault+0xb0/0xf0
[18073.102101]  ? force_sig_fault_to_task+0xe0/0xe0
[18073.102101]  ? asm_exc_debug+0x23/0x30
[18073.102101]  ? notify_die+0x88/0x100
[18073.102101]  ? asm_exc_debug+0x23/0x30
[18073.102101]  noist_exc_debug+0xec/0x110
[18073.102101]  asm_exc_debug+0x2b/0x30

The &sighand->siglock => css_set_lock locking sequence is caused by a 
task holding sighand->siglock and call kmem_cache_alloc(GFP_ATOMIC) and 
the release of the obj_cgroup originally from an offlined memcg in 
percpu stock leading to the call of obj_cgroup_release() which takes the 
cs_set_lock. The chance of hitting that is very small, but it can still 
happen. So do you think addressing this possible deadlock scenario is 
worth the possible slower release of an offlined memcg?

Cheers,
Longman

>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>   mm/memcontrol.c | 16 +++++++++++-----
>>   1 file changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 4b32896d87a2..4568363062c1 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2167,6 +2167,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>>   	return ret;
>>   }
>>   
>> +static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
>> +
>>   /*
>>    * Returns stocks cached in percpu and reset cached information.
>>    */
>> @@ -2178,9 +2180,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
>>   		return;
>>   
>>   	if (stock->nr_pages) {
>> -		page_counter_uncharge(&old->memory, stock->nr_pages);
>> -		if (do_memsw_account())
>> -			page_counter_uncharge(&old->memsw, stock->nr_pages);
>> +		cancel_charge(old, stock->nr_pages);
>>   		stock->nr_pages = 0;
>>   	}
>>   
>> @@ -2219,6 +2219,14 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>>   	struct memcg_stock_pcp *stock;
>>   	unsigned long flags;
>>   
>> +	/*
>> +	 * An offlined memcg shouldn't be put into stock.
>> +	 */
>> +	if (unlikely(memcg->kmem_state != KMEM_ONLINE)) {
>> +		cancel_charge(memcg, nr_pages);
>> +		return;
>> +	}
>> +
>>   	local_irq_save(flags);
>>   
>>   	stock = this_cpu_ptr(&memcg_stock);
>> @@ -2732,7 +2740,6 @@ static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>   	return try_charge_memcg(memcg, gfp_mask, nr_pages);
>>   }
>>   
>> -#if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MMU)
>>   static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
>>   {
>>   	if (mem_cgroup_is_root(memcg))
>> @@ -2742,7 +2749,6 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
>>   	if (do_memsw_account())
>>   		page_counter_uncharge(&memcg->memsw, nr_pages);
>>   }
>> -#endif
>>   
>>   static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
>>   {
>> -- 
>> 2.18.1
>>

