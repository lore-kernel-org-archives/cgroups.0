From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 3/3] cgroup/cpuset: Keep user set cpus affinity
Date: Tue, 16 Aug 2022 13:38:17 -0400
Message-ID: <349849aa-937d-8b08-a836-7c5c70168139@redhat.com>
References: <20220816151119.29534-1-longman@redhat.com>
 <20220816151119.29534-4-longman@redhat.com>
 <YvvR2Sa6LxZLwXsJ@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660671504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gdnOT0e5CEKzDOC4PBc+9OuYz+K252RaUVT9XjoI0RA=;
        b=FaOFm2F4M7N0ML7xSdIGS9j54j10/RRUVdsfyLraeT5pwAzCJq5dQu11MDXfHnhusp+1HP
        K+lO9zZMjRrn7vgNeklKIQ1f76MifN7Ywo8fhyLrgR8rCK+16XVLQrOM4IyPDYmPQx/brt
        yNlV3SluzuDE+LhhqPSWNwDyhHSiXhI=
Content-Language: en-US
In-Reply-To: <YvvR2Sa6LxZLwXsJ-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 8/16/22 13:20, Tejun Heo wrote:
> Hello,
>
> So, overall I think this is the right direction.
>
>> +static int cpuset_set_cpus_allowed_ptr(struct task_struct *p,
>> +				       const struct cpumask *mask)
>> +{
>> +	if (p->user_cpus_ptr) {
>> +		cpumask_var_t new_mask;
>> +
>> +		if (alloc_cpumask_var(&new_mask, GFP_KERNEL) &&
>> +		    copy_user_cpus_mask(p, new_mask) &&
>> +		    cpumask_and(new_mask, new_mask, mask)) {
>> +			int ret = set_cpus_allowed_ptr(p, new_mask);
>> +
>> +			free_cpumask_var(new_mask);
>> +			return ret;
>> +		}
>> +		free_cpumask_var(new_mask);
>> +	}
>> +
>> +	return set_cpus_allowed_ptr(p, mask);
>> +}
> But this seems racy to me. Let's say attach and setaffinity race. The
> expectation should be that we'd end up with the same eventual mask no matter
> what the operation order may be. The above code wouldn't do that, right?
> There's nothing synchronizing the two and if setaffinity takes place between
> the user_cpus_ptr test and set_cpus_allowed_ptr(), it'd get ignored.

Yes, a race like this is possible. To completely eliminate the race may 
require taking task_rq_lock() and then calling 
__set_cpus_allowed_ptr_locked() which is internal to kernel/sched/core.c.

Alternatively, we can check user_cpus_ptr again after the scond 
set_cpus_allowed_ptr() and retry it with the other path if set. That 
will probably address your concern. Please let me know if you are OK 
with that.

Cheers,
Longman

>
> This gotta be more integrated. There is what the user requested and there
> are restrictions from CPU hotplug state and cpuset. All three should be
> synchronized so that there is one synchronzied way to obtain and apply the
> current effective mask.
>
> Thanks.
>

