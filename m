From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 3/3] cgroup/cpuset: Keep user set cpus affinity
Date: Tue, 16 Aug 2022 14:20:22 -0400
Message-ID: <ea5267dd-a6b7-83c1-1fdd-9567b55b7e74@redhat.com>
References: <20220816151119.29534-1-longman@redhat.com>
 <20220816151119.29534-4-longman@redhat.com>
 <YvvR2Sa6LxZLwXsJ@slm.duckdns.org>
 <349849aa-937d-8b08-a836-7c5c70168139@redhat.com>
 <YvvZc7KgZT/bRoKl@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660674027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zt00RDNEV7RZzMeybSvzEigJSmadOEJNQKxj71oBngw=;
        b=Rp4d8sOkVM6zIKKlNygnSLmIuyEf8MLTnnEL+95viZorCxGpmwXYi6sR7qskwZwqTd9JRU
        IkE/3QrDQK0dKtCQ8WhNBgeI5nAREJ3NXrpo37OSb1YEh9RkV1hq/VzTpYEYjVdEZUaZ1p
        gxeFKaoyw5wv/ITmWjOs/+O1G0SlXNE=
Content-Language: en-US
In-Reply-To: <YvvZc7KgZT/bRoKl-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 8/16/22 13:52, Tejun Heo wrote:
> Hello,
>
> On Tue, Aug 16, 2022 at 01:38:17PM -0400, Waiman Long wrote:
>> Yes, a race like this is possible. To completely eliminate the race may
>> require taking task_rq_lock() and then calling
>> __set_cpus_allowed_ptr_locked() which is internal to kernel/sched/core.c.
>>
>> Alternatively, we can check user_cpus_ptr again after the scond
>> set_cpus_allowed_ptr() and retry it with the other path if set. That will
>> probably address your concern. Please let me know if you are OK with that.
> I think this would look better if structured the other way around - make the
> scheduler side call out to cpuset to query the current restrictions and
> apply it atomically.

The sched_setaffinity() function does call cpuset_cpus_allowed() to 
apply the cpuset constraint. However, making set_cpus_allowed_ptr() call 
cpuset function is a major change. It will disturb the current locking 
sequences and may cause circular locking dependency problem. We 
certainly need more time to figure out if that is feasible.

In the mean time, I would prefer to do a retry if user_cpus_ptr status 
changes for now. We can then do a follow up patch to make this 
structural change if there is a consensus of doing so.

Cheers,
Longman

