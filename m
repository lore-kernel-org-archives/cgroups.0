From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/3] sched: Provide copy_user_cpus_mask() to copy out
 user mask
Date: Mon, 15 Aug 2022 09:37:02 -0400
Message-ID: <a7eb96cd-1d4b-65a5-6213-a2f0df2d9ccc@redhat.com>
References: <20220812203929.364341-1-longman@redhat.com>
 <20220812203929.364341-3-longman@redhat.com>
 <YvoKy6OdJIkNXbtq@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660570627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=32k6I+/xYZGpQQqB1hUqbRU4UEx2mYMpvxUY9GY4ewM=;
        b=fNtzhiu8kOwvx9XmbFm4YOgsQha1aKsOaWfSU8PyHHTFKuxdPpjm5LX904Etw9YAvcOwYP
        yXHBQWlNU6kGKj1w73B7m+hQXFbxNMIeJ4fFGSEbmNi5ICxvvXtoGYmaKXXRRF62lGiVpG
        knFAs5Fab5Seh8AEc4gjZ92pUhvXjmY=
Content-Language: en-US
In-Reply-To: <YvoKy6OdJIkNXbtq-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 8/15/22 04:58, Peter Zijlstra wrote:
> On Fri, Aug 12, 2022 at 04:39:28PM -0400, Waiman Long wrote:
>> Since accessing the content of the user_cpus_ptr requires lock protection
>> to ensure its validity, provide a helper function copy_user_cpus_mask()
>> to facilitate its reading.
> Sure, but this is atrocious.
>
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2619,6 +2619,24 @@ void release_user_cpus_ptr(struct task_struct *p)
>>   	kfree(clear_user_cpus_ptr(p));
>>   }
>>   
>> +/*
>> + * Return the copied mask pointer or NULL if user mask not available.
>> + */
>> +struct cpumask *copy_user_cpus_mask(struct task_struct *p,
>> +				    struct cpumask *user_mask)
>> +{
>> +	struct rq_flags rf;
>> +	struct rq *rq = task_rq_lock(p, &rf);
>> +	struct cpumask *mask = NULL;
>> +
>> +	if (p->user_cpus_ptr) {
>> +		cpumask_copy(user_mask, p->user_cpus_ptr);
>> +		mask = user_mask;
>> +	}
>> +	task_rq_unlock(rq, p, &rf);
>> +	return mask;
>> +}
> For reading the mask you only need one of those locks, and I would
> suggest p->pi_lock is much less contended than rq->lock.
>
Right. pi_lock should be enough for read access. Will make the change.

Thanks,
Longman

