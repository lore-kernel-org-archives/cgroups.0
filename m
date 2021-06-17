From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] cgroup/cpuset: Allow non-top parent partition root to
 distribute out all CPUs
Date: Thu, 17 Jun 2021 16:45:35 -0400
Message-ID: <7f0a0f23-3fcd-a1a3-341a-2dbbde1f25ec@redhat.com>
References: <20210603212416.25934-1-longman@redhat.com>
 <20210603212416.25934-4-longman@redhat.com>
 <YMplzNzg7mMCU4JJ@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623962738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vpTnIUemqOshEpd//f5xMntFtlQkGOaInP6j17WpXWI=;
        b=iTflhj/coDAw8So9pBsifMvIWEP4HGtkRlNesWPk36aeADUcubbNOKRbiv6yjd2rpDgf8j
        Scf7FcxGWql1ds1GoqgKR4LsU8OFoCW0GTJ5DhHJ1nAMFqN2q5V5S4l4zFC9FV2zNov9F2
        bZJ97k2LjCfyv8vpJFXjsa/gEsLQ75o=
In-Reply-To: <YMplzNzg7mMCU4JJ-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 6/16/21 4:57 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Jun 03, 2021 at 05:24:14PM -0400, Waiman Long wrote:
>> @@ -2181,6 +2192,13 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>>   	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
>>   		goto out_unlock;
>>   
>> +	/*
>> +	 * On default hierarchy, task cannot be moved to a cpuset with empty
>> +	 * effective cpus.
>> +	 */
>> +	if (is_in_v2_mode() && cpumask_empty(cs->effective_cpus))
>> +		goto out_unlock;
>> +
> This is inconsistent with how other events which leave a root partition
> empty is handled. Woudln't it be more consistent to switch the parent to
> PRS_ERROR and behave accordingly but allow it to have valid child roots?

 From my point of view, PRS_ERROR is used when cpus are gone because of 
cpu hotplug (offline). It can be a temporary condition that will be 
corrected later on. I don't want to use PRS_ERROR for the particular 
case that the users have explicitly distributed out all the cpus to 
child partitions. I will clarify it in the next version and double check 
to make sure that this rule is consistently apply.

Thanks,
Longman

