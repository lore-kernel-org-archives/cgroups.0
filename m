Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794960230;
	b=PayJ9QmxCJR9qUaGJ5nh05hkNByNLxPH4MxpTD8uxgy8vHRySVEudaXYabzAzaQyUMhE
	 Y+QPkdJgLpn2o70GnRIJUU/2+GAANeKX1Gw+umxWHFBVA1eM572Lwgoo9F9U400+tSl5n
	 nMimgMYumqqFN1cQr9Bc7dcZaIW6kJyyTFVKQ3iF/HXugrWEMNVS8u0HrTfIFkmvyZVA2
	 J4kyv7bG/IaMOa3qORDH/7ltK3rRMZVXh+T4wUNVtl9XhP2Csj+Q6ZAt84OuuZ9ombij6
	 MvDzIouYH83TOCSqPaj/ZRtR3UR8dqcdbQa/CPxNQ3qqUcgoEzZ+XaJ9HN51FRu5lqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794960230;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=HgUCjkwjNnVwNpG7C+Rc1zoxk9Eyoo4+LcOho9UT1no=;
	b=QSJJjN5E4B6/P/QH2YZtonh7r+BjAiQ7DVNy+gofqriz9JLDQHFg5SbXPGraStL8iyPz
	 2cKOxirgfEZlnGJk+FdhyX18iCjRp/8wH0U1hByxPVzbu3Xk4wBlNg4TnHnes/JzTtIf3
	 Ygz76R0VmgK/4OzJgZAooTF9LY290ppIJFx0N0l7nOopxM5uOOtgGFdwkDjt2G0n4dKwX
	 8DHuPxFGpj8xCSVWB06oYw6Ch34Lh5+R63Ycta6xijeHvWwdVf2++IoPU6LgYipcLSUhT
	 gmBVqLhk11M03D5rYQBajkVP7wifDbEVxWE9tjrltouM3fQe19RaF9jWQcEn//xrVCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pVjbsq71;
	arc=none smtp.remote-ip=95.215.58.51
Received: from mta1.migadu.com (out-51.mta1.migadu.com [95.215.58.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F561606A31C
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 00:03:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F561606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pVjbsq71
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8O2Z9i9XyyFs2NBWXPLqftjmKWFZwxaV3dOPhJ6/7fo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794960227; v=1; x=1795565027;
 b=pVjbsq71T9RBMDxDrGSDyKWPt759GyH808oSThBjQ2O0I/LTGIlSgSuZauL/vAn2Okk+9hGJ
 b3WQKYxGnnFNfbX8vW116HUGR9K3jKdP5T2IPoxP2LjAm3KgBDeXVa9c98XvHTi5RMOpFspC1bo
 ZaZi250aFnePlkYt5b+etqNQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id be12e469f8aa84fa;
	Wed, 18 Nov 2026 00:03:47 +0000
X-Mizu-Trace-ID: be12e469f8aa84fa
X-Migadu-Flow: FLOW_OUT
Message-ID: <4d3e46fb-a374-4a9b-a47e-1c661b7f0f37@linux.dev>
Date: Wed, 18 Nov 2026 08:03:35 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask under
 cpuset_mutex
To: Waiman Long <longman@redhat.com>, frederic@kernel.org, tj@kernel.org,
 peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, hannes@cmpxchg.org, mkoutny@suse.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 guopeng.zhang@linux.dev, mathieu.desnoyers@efficios.com,
 Ridong Chen <chenridong@xiaomi.com>
References: <054a53a3-c038-48fe-ac01-fc24fd8065d0@linux.dev>
 <20261117083915.2971979-1-ridong.chen@linux.dev>
 <36d49371-31de-4305-89c4-2ce64dd6848c@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <36d49371-31de-4305-89c4-2ce64dd6848c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/18/2026 12:15 AM, Waiman Long wrote:
> On 11/17/26 3:39 AM, Ridong wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Commit a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without
>> holding cpus_read_lock") calls housekeeping_update() after dropping
>> cpus_read_lock and cpuset_mutex, so the HK_TYPE_DOMAIN cpumask is now
>> switched and freed outside of those locks. But readers holding either
>> lock may still access it without rcu_read_lock() as allowed by
>> housekeeping_dereference_check(), and synchronize_rcu() doesn't wait
>> for them:
>>
>>    CPU A                                  CPU B
>>    rebuild_sched_domains()                cpuset_update_sd_hk_unlock()
>>                                             mutex_unlock(&cpuset_mutex)
>>                                             cpus_read_unlock()
>>      mutex_lock(&cpuset_mutex)
>>      p = housekeeping_cpumask(DOMAIN)
>>                                             housekeeping_update()
>>                                               rcu_assign_pointer()
>>                                               synchronize_rcu()
>>                                               kfree(old)
>>      access p <- UAF
>>
>> Fix it by moving the pointer switch into housekeeping_publish(), which
>> is called before dropping the locks. Then CPU A either finishes before
>> CPU B switches the pointer, or only sees the new cpumask:
>>
>>    CPU A                                  CPU B
>>                                           cpuset_update_sd_hk_unlock()
>>                                             housekeeping_publish()
>>                                               rcu_assign_pointer()
>>      mutex_lock(&cpuset_mutex) <- wait
>>                                             mutex_unlock(&cpuset_mutex)
>>                                             cpus_read_unlock()
>>      p = housekeeping_cpumask(DOMAIN)       housekeeping_update()
>>          <- new cpumask                       synchronize_rcu()
>>                                               kfree(old)
>>
>> The rest of housekeeping_update(), including the workqueue flushes,
>> still runs without those locks.
>>
>> Fixes: a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without 
>> holding cpus_read_lock")
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   include/linux/sched/isolation.h |  6 ++++--
>>   kernel/cgroup/cpuset.c          | 12 ++++++++----
>>   kernel/sched/isolation.c        | 23 ++++++++++++++++-------
>>   3 files changed, 28 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
>> index cf0fd03dd7a24..09fabf42e3224 100644
>> --- a/include/linux/sched/isolation.h
>> +++ b/include/linux/sched/isolation.h
>> @@ -43,7 +43,8 @@ extern const struct cpumask *housekeeping_cpumask(enum 
>> hk_type type);
>>   extern bool housekeeping_enabled(enum hk_type type);
>>   extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
>>   extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
>> -extern int housekeeping_update(struct cpumask *isol_mask);
>> +extern struct cpumask *housekeeping_publish(struct cpumask *isol_mask);
>> +extern void housekeeping_update(struct cpumask *isol_mask, struct cpumask *old);
>>   extern void __init housekeeping_init(void);
>>   #else
>> @@ -71,7 +72,8 @@ static inline bool housekeeping_test_cpu(int cpu, enum 
>> hk_type type)
>>       return true;
>>   }
>> -static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
>> +static inline struct cpumask *housekeeping_publish(struct cpumask *isol_mask) 
>> { return NULL; }
>> +static inline void housekeeping_update(struct cpumask *isol_mask, struct 
>> cpumask *old) { }
>>   static inline void housekeeping_init(void) { }
>>   #endif /* CONFIG_CPU_ISOLATION */
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 8a8a424a389f3..1673bb25a797b 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1472,17 +1472,21 @@ static void cpuset_update_sd_hk_unlock(void)
>>           rebuild_sched_domains_locked();
>>       if (update_housekeeping) {
>> +        struct cpumask *old;
>> +
>>           update_housekeeping = false;
>>           cpumask_copy(isolated_hk_cpus, isolated_cpus);
>>           /*
>> -         * housekeeping_update() is now called without holding
>> -         * cpus_read_lock and cpuset_mutex. Only cpuset_top_mutex
>> -         * is still being held for mutual exclusion.
>> +         * Publish the new cpumask with cpus_read_lock and cpuset_mutex
>> +         * held, but call housekeeping_update() without them. Only
>> +         * cpuset_top_mutex is still being held for mutual exclusion.
>>            */
>> +        old = housekeeping_publish(isolated_hk_cpus);
>>           mutex_unlock(&cpuset_mutex);
>>           cpus_read_unlock();
>> -        WARN_ON_ONCE(housekeeping_update(isolated_hk_cpus));
>> +        if (!WARN_ON_ONCE(IS_ERR(old)))
>> +            housekeeping_update(isolated_hk_cpus, old);
>>           mutex_unlock(&cpuset_top_mutex);
>>       } else {
>>           cpuset_full_unlock();
>> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
>> index 156025ef81b75..9e202269e42f6 100644
>> --- a/kernel/sched/isolation.c
>> +++ b/kernel/sched/isolation.c
>> @@ -120,23 +120,26 @@ bool housekeeping_test_cpu(int cpu, enum hk_type type)
>>   }
>>   EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
>> -int housekeeping_update(struct cpumask *isol_mask)
>> +/* Called with cpus_read_lock and cpuset_mutex held */
>> +struct cpumask *housekeeping_publish(struct cpumask *isol_mask)
>>   {
>>       struct cpumask *trial, *old = NULL;
>> -    int err;
>> +
>> +    lockdep_assert_cpus_held();
>> +    lockdep_assert_cpuset_lock_held();
>>       trial = kmalloc(cpumask_size(), GFP_KERNEL);
>>       if (!trial)
>> -        return -ENOMEM;
>> +        return ERR_PTR(-ENOMEM);
>>       cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), 
>> isol_mask);
>>       if (!cpumask_intersects(trial, cpu_online_mask)) {
>>           kfree(trial);
>> -        return -EINVAL;
>> +        return ERR_PTR(-EINVAL);
>>       }
>>       if (!housekeeping.flags)
>> -        static_branch_enable(&housekeeping_overridden);
>> +        static_branch_enable_cpuslocked(&housekeeping_overridden);
>>       if (housekeeping.flags & HK_FLAG_DOMAIN)
>>           old = housekeeping_cpumask_dereference(HK_TYPE_DOMAIN);
>> @@ -144,6 +147,14 @@ int housekeeping_update(struct cpumask *isol_mask)
>>           WRITE_ONCE(housekeeping.flags, housekeeping.flags | HK_FLAG_DOMAIN);
>>       rcu_assign_pointer(housekeeping.cpumasks[HK_TYPE_DOMAIN], trial);
>> +    return old;
>> +}
>> +
>> +/* Called without cpus_read_lock and cpuset_mutex held */
>> +void housekeeping_update(struct cpumask *isol_mask, struct cpumask *old)
>> +{
>> +    int err;
>> +
>>       synchronize_rcu();
>>       pci_probe_flush_workqueue();
>> @@ -160,8 +171,6 @@ int housekeeping_update(struct cpumask *isol_mask)
>>       WARN_ON_ONCE(err < 0);
>>       kfree(old);
>> -
>> -    return 0;
>>   }
>>   void __init housekeeping_init(void)
> 
> Yes, that should work too.
> 
> Acked-by: Waiman Long <longman@redhat.com>
> 
> I will let other decide which one do they want.
> 
Thanks.

-- 
Best regards
Ridong

