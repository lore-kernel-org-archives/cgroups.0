From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup
 in cpuset_init_smp()
Date: Wed, 27 Apr 2022 10:33:04 -0400
Message-ID: <3791e950-d997-23c0-07ff-909fd170d0a7@redhat.com>
References: <20220425155505.1292896-1-longman@redhat.com>
 <20220427135324.GB9823@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651069991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCszdxGtpE1ozcn4mZloZJWxhovKrd6sE3m0QUQcezY=;
        b=KHM522vAqW5YlYhVROlL1ykFj+obrSloZko7efXqFHscQrykt4p4gtkEG+nresV7Ktd/QU
        MIlstMabkI/VKMAaQipYcEJMfCzIewYiMEctaZffEmD7WxIW+MF6eWV+KVj0kmuxVRsWn2
        ICHvwwtPceQCzFTZuFyOVvAgueGGb1k=
Content-Language: en-US
In-Reply-To: <20220427135324.GB9823@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Dave Hansen <dave.hansen@intel.com>, ying.huang@intel.com, stable@vger.kernel.org

On 4/27/22 09:53, Michal Koutný wrote:
> Hello.
>
> On Mon, Apr 25, 2022 at 11:55:05AM -0400, Waiman Long <longman@redhat.com> wrote:
>> smp_init() is called after the first two init functions.  So we don't
>> have a complete list of active cpus and memory nodes until later in
>> cpuset_init_smp() which is the right time to set up effective_cpus
>> and effective_mems.
> Yes.
>
> 	setup_arch
> 	  prefill_possible_map
> 	cpuset_init (1)
> 	cgroup_init
> 	  cpuset_bind (2a)
> 	...
> 	kernel_init
> 	  kernel_init_freeable
> 	    ...
> 	      cpuset_init_smp (3)
> 	...
> 	...
> 	cpuset_bind (2b)
>
>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 9390bfd9f1cd..6bd8f5ef40fe 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -3390,8 +3390,9 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
>>    */
>>   void __init cpuset_init_smp(void)
>>   {
>> -	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
>> -	top_cpuset.mems_allowed = node_states[N_MEMORY];
>> +	/*
>> +	 * cpus_allowd/mems_allowed will be properly set up in cpuset_bind().
>> +	 */
> IIUC, the comment should say
>
>> +	 * cpus_allowed/mems_allowed were (v2) or will be (v1) properly set up in cpuset_bind().
> (nit)
>
> Reviewed-by: Michal Koutný <mkoutny@suse.com>
>
Thanks for the review. I plan to post v3 with updated commit log and 
comment soon.

Cheers,
Longman

