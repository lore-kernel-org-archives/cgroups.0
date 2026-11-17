Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794888402;
	b=fB5ecVy5Uw1P//HJioxysSA60vUVaYFRlqTj1WEe90r7jdvTFOl+WfeyuD4hmylqyOke
	 67MfSWLb7dmWrgW3mrPSv7rXyC4AD4ifJWn4WoLrN+Kh0rrohPL7eIIWa+ma28wgUN0RL
	 zRqONAoa48kQTLgSjTEZFsZaklSwgEqIvW+e7T71U0Jkq+wcAPOexL7OHuPbd+L/HI3Mp
	 gzz76R5M5nRccvQX8+zd3XeBa1PgadwMOZuOOggsgHuQkTudECp6D6PzVEK5V3y3UKyqf
	 VtUsUNVQHKfmWpZ/gsr6PyBnE7VdxadJ2hwT0MsCYI8qooUPFVrwTDCSsGL2GDkEK5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794888402;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=va/mnMTqx710thSJTM0Z8CocDpxShRf7Hl6EIOOUmGE=;
	b=wOuYrkL7KkfS2ndmU91izekQ+R3Yq57tryVjtXagD4Pk7CaYUoGmHnuPKqG6eAxJA2dN
	 Tb6C8DK8tjXTyvocVLHdJ3snLc63WcOCjlIDbAq8cpFUimf6oF5gKCtJdb9ltCN/tmTz8
	 S+hxyl+leaS/0HWglX0Ov1MiA/d3EdZB9WfF4I2wCVkYNlcMHWsIird4XIpIMI1b7jFra
	 RAhlTcZ98orr5ldFDskUgJiHaShBtAfaZy6VfmLpgnLlx+2hFiGLVoQ6ETsCEpbx+vVQP
	 9b31qsxovKDOX/5guX5VzyvplcjB6nwhsVVmlMrOlIaLD5/acNLRjrGuZEehbwrGaPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=V3euVlpn;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99399606A330
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 04:06:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99399606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=V3euVlpn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794888400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=va/mnMTqx710thSJTM0Z8CocDpxShRf7Hl6EIOOUmGE=;
	b=V3euVlpn6td8Nynoxddx60zh4BegjQu5NJ/dl/zoLHuQ0oUcDZZwEb941feU8OrykCiEVg
	fV+cYb84C/iHtpl+xnWbMdIS4M/F0WPP45+cTKKf4ojvOi0gBKB+dqkWL9iYL58O9siJjo
	4bOwTqTU5DLU2Hnag7ZtP4gmazTO8lk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362-CViUN3KmOXme1qAmpHQ0cQ-1; Mon,
 16 Nov 2026 23:06:37 -0500
X-MC-Unique: CViUN3KmOXme1qAmpHQ0cQ-1
X-Mimecast-MFC-AGG-ID: CViUN3KmOXme1qAmpHQ0cQ_1794888395
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12CA818001EF;
	Tue, 17 Nov 2026 04:06:35 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6EFCD180055C;
	Tue, 17 Nov 2026 04:06:33 +0000 (UTC)
Message-ID: <ec27406c-5e30-400a-bfde-f88752ec73be@redhat.com>
Date: Mon, 16 Nov 2026 23:06:32 -0500
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
Subject: Re: [PATCH-next v4 6/6] cgroup/cpuset: Fix lockdep_is_cpuset_held()
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20261116012330.2271010-1-longman@redhat.com>
 <20261116012330.2271010-7-longman@redhat.com>
 <f5f1ecf6-d33a-4245-a522-34b986a3d7c2@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <f5f1ecf6-d33a-4245-a522-34b986a3d7c2@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 11/16/26 2:24 AM, Ridong Chen wrote:
>
>
> On 11/16/2026 9:23 AM, Waiman Long wrote:
>> Commit a84097e625f2 ("cgroup/cpuset: Call housekeeping_update()
>> without holding cpus_read_lock") changes lockdep_is_cpuset_held()
>> to return true if either cpuset_mutex or cpuset_top_mutex is held.
>> lockdep_is_cpuset_held() is used by housekeeping_dereference_check()
>> as one of the conditions that rcu_read_lock() is not needed to
>> access HK_TYPE_DOMAIN cpumask that can be changed at run time.
>> In reality, it should return true only if cpuset_top_mutex is held as
>> housekeeping_update() is called with only cpuset_top_mutex held.
>>
>> If only cpuset_mutex is held, it is possible that there can be a 
>> parallel
>> housekeeping_update() call leading to a potential use-after-free 
>> situation
>> when HK_TYPE_DOMAIN housekeeping cpumask is being accessed. It also
>> means that rcu_read_lock will be required if only cpuset_mutex is being
>> held like when calling from hotplug, scheduler or cgroup.
>>
>> Fixes: a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() 
>> without holding cpus_read_lock")
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset-v1.c | 16 ++++++++++------
>>   kernel/cgroup/cpuset.c    |  9 +++++++--
>>   2 files changed, 17 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset-v1.c b/kernel/cgroup/cpuset-v1.c
>> index 7c7f2887dfaf..6bf6da639fec 100644
>> --- a/kernel/cgroup/cpuset-v1.c
>> +++ b/kernel/cgroup/cpuset-v1.c
>> @@ -686,6 +686,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t 
>> **domains,
>>       int csn;        /* how many cpuset ptrs in csa so far */
>>       int i, j;        /* indices for partition finding loops */
>>       cpumask_var_t *doms;    /* resulting partition; i.e. sched 
>> domains */
>> +    cpumask_var_t hk_cpus;    /* HK_TYPE_DOMAIN housekeeping CPUs */
>>       struct sched_domain_attr *dattr;  /* attributes for custom 
>> domains */
>>       int ndoms = 0;        /* number of sched domains in result */
>>       int nslot;        /* next empty doms[] struct cpumask slot */
>> @@ -698,6 +699,11 @@ int cpuset1_generate_sched_domains(cpumask_var_t 
>> **domains,
>>       dattr = NULL;
>>       csa = NULL;
>>   +    alloc_cpumask_var(&hk_cpus, GFP_KERNEL);
>> +    scoped_guard(rcu) {
>> +        cpumask_copy(hk_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN));
>> +    }
>> +
>
> The return value of alloc_cpumask_var() isn't checked. With
> CONFIG_CPUMASK_OFFSTACK=y, hk_cpus is NULL on failure. Maybe goto done
> like the other allocation failures here?
>
> Also, rebuild_sched_domains() can be called from outside cpuset, e.g.
> arch_topology and the energy model, with only cpus_read_lock and
> cpuset_mutex held. partition_sched_domains_locked() reads
> HK_TYPE_DOMAIN in asym_cpu_capacity_scan() and in its fallback path.
> Will these trigger a lockdep warning after this change? If so, do they
> need an RCU read lock as well?
>
>
Yes, I realize that some additional scheduler functions will need to be 
updated as well for this to work. I am planning to have an alternative 
solution to work around this problem. I am going to drop this patch and 
send out another patch soon.

Cheers,
Longman

>>       /* Special case for the 99% of systems with one, full, sched 
>> domain */
>>       if (is_sched_load_balance(&top_cpuset)) {
>>           ndoms = 1;
>> @@ -710,9 +716,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t 
>> **domains,
>>               *dattr = SD_ATTR_INIT;
>>               update_domain_attr_tree(dattr, &top_cpuset);
>>           }
>> -        cpumask_and(doms[0], top_cpuset.effective_cpus,
>> -                housekeeping_cpumask(HK_TYPE_DOMAIN));
>> -
>> +        cpumask_and(doms[0], top_cpuset.effective_cpus, hk_cpus);
>>           goto done;
>>       }
>>   @@ -736,8 +740,7 @@ int 
>> cpuset1_generate_sched_domains(cpumask_var_t **domains,
>>            */
>>           if (!cpumask_empty(cp->cpus_allowed) &&
>>               !(is_sched_load_balance(cp) &&
>> -              cpumask_intersects(cp->cpus_allowed,
>> -                     housekeeping_cpumask(HK_TYPE_DOMAIN))))
>> +              cpumask_intersects(cp->cpus_allowed, hk_cpus)))
>>               continue;
>>             if (is_sched_load_balance(cp) &&
>> @@ -794,7 +797,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t 
>> **domains,
>>                           *(dattr + nslot) = SD_ATTR_INIT;
>>                   }
>>                   cpumask_or(dp, dp, csa[j]->effective_cpus);
>> -                cpumask_and(dp, dp, 
>> housekeeping_cpumask(HK_TYPE_DOMAIN));
>> +                cpumask_and(dp, dp, hk_cpus);
>>                   if (dattr)
>>                       update_domain_attr_tree(dattr + nslot, csa[j]);
>>               }
>> @@ -806,6 +809,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t 
>> **domains,
>>     done:
>>       kfree(csa);
>> +    free_cpumask_var(hk_cpus);
>>         /*
>>        * Fallback to the default domain if kmalloc() failed.
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 64cbcbdbf6da..d18439e13bce 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -343,10 +343,13 @@ void cpuset_full_unlock(void)
>>   }
>>     #ifdef CONFIG_LOCKDEP
>> +/*
>> + * Holding cpuset_top_mutex will guarantee that a parallel
>> + * housekeeping_update() call modifying housekeeping cpumasks is not 
>> possible.
>> + */
>>   bool lockdep_is_cpuset_held(void)
>>   {
>> -    return lockdep_is_held(&cpuset_mutex) ||
>> -           lockdep_is_held(&cpuset_top_mutex);
>> +    return lockdep_is_held(&cpuset_top_mutex);
>>   }
>>   #endif
>>   @@ -1416,8 +1419,10 @@ static bool 
>> prstate_housekeeping_conflict(int new_prs, int parent_prs,
>>           }
>>       }
>>   +    rcu_read_lock();
>>       cpumask_and(full_hk_cpus, 
>> housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
>>               housekeeping_cpumask(HK_TYPE_DOMAIN));
>> +    rcu_read_unlock();
>>       cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
>>       cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
>>       res = !cpumask_weight_andnot(full_hk_cpus, new_cpus);
>

