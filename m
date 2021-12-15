From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 2/7] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Tue, 14 Dec 2021 22:24:22 -0500
Message-ID: <810204ce-7967-e470-1267-7c3cfb521c89@redhat.com>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-3-longman@redhat.com>
 <Ybew7d2oE2gLcLNO@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639538682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wHvqWA9pCAW9hO772UCEPBtSbiKtXLn9xS2Zet02foU=;
        b=D7XpqjJxZk1k/LrdSMz/4bLf2yxhg23ndlYStXLLubyHq36HkRjzH3ePi6cmypQHrBKjwm
        VHKrsTeH9XiILdS8JDJfYy9BIjchp2OymSpx8k6cYGoQDDX0gx4bB8f4JcXQCu1KzLtpCd
        uIWGkDBtlnxYbqFjPADZJW5SieXGrbM=
Content-Language: en-US
In-Reply-To: <Ybew7d2oE2gLcLNO-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 12/13/21 15:45, Tejun Heo wrote:
> On Sun, Dec 05, 2021 at 01:32:15PM -0500, Waiman Long wrote:
>>   	adding = deleting = false;
>>   	old_prs = new_prs = cpuset->partition_root_state;
>>   	if (cmd == partcmd_enable) {
>> +		/*
>> +		 * Enabling partition root is not allowed if not all the CPUs
>> +		 * can be granted from parent's effective_cpus.
>> +		 */
>> +		if (!cpumask_subset(cpuset->cpus_allowed, parent->effective_cpus))
>> +			return -EINVAL;
>> +
>> +		/*
>> +		 * A parent can be left with no CPU as long as there is no
>> +		 * task directly associated with the parent partition. For
>> +		 * such a parent, no new task can be moved into it.
>> +		 */
>> +		if (partition_is_populated(parent, cpuset) &&
>> +		    cpumask_equal(cpuset->cpus_allowed, parent->effective_cpus))
>> +			return -EINVAL;
> So, given that this only happens with threaded domains, can we just not
> allow partitions within threaded domains? The combination doesn't make whole
> lot of sense to me anyway.
AFAICS, there are code in cpuset.c that disallows the an non-child node 
to hold tasks, but the check doesn't cover all the possible cases. I 
remembered that I was able to create such a scenario without using 
threaded domains. That is why I put in this conditional check. It has 
nothing to do with the use of threaded domains.
>> +	/*
>> +	 * On default hierarchy, task cannot be moved to a cpuset with empty
>> +	 * effective cpus.
>> +	 */
>> +	if (is_in_v2_mode() && cpumask_empty(cs->effective_cpus))
>> +		goto out_unlock;
> And then we can avoid this extra restriction too, right?

This check is supposed to prevent a task to be moved to a leaf cpuset 
partition with just offlined cpus and hence no effective cpu. A possible 
alternative is to force the partition to become invalid, but I think not 
allowing the move is easier until one or more offlined cpus are onlined.

Cheers,
Longman

