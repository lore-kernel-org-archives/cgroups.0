From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/3] sched: Use user_cpus_ptr for saving user provided
 cpumask in sched_setaffinity()
Date: Mon, 15 Aug 2022 09:52:27 -0400
Message-ID: <401bae73-3063-e0ab-c288-2c6e3be75fc5@redhat.com>
References: <20220812203929.364341-1-longman@redhat.com>
 <20220812203929.364341-2-longman@redhat.com>
 <YvoKa3tbOaszsp1y@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660571553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A0Oy07t9HeUyM/chaHP6TWWJCl778sh8kflz1rnE6aw=;
        b=eDnA3d+heaobCI949ZPWjhndOz0O/Zl8eOVMDAXSAtrjy/EoNPOAiSbGKMmnRrjAs6suSb
        0KQjM+7Xe46x09zLDxYxV/7ywTdqNpWqzSAGT/m2XOe5LKW9SOwsnRPQHbNcgUbO6r3oHh
        dKo1P/9I9rMxTsG3nzfuw1MDDIImuh8=
Content-Language: en-US
In-Reply-To: <YvoKa3tbOaszsp1y-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


On 8/15/22 04:57, Peter Zijlstra wrote:
> On Fri, Aug 12, 2022 at 04:39:27PM -0400, Waiman Long wrote:
>> The user_cpus_ptr field is added by commit b90ca8badbd1 ("sched:
>> Introduce task_struct::user_cpus_ptr to track requested affinity"). It
>> is currently used only by arm64 arch due to possible asymmetric cpu
>> setup. This patch extends its usage to save user provided cpumask when
>> sched_setaffinity() is called for all arches.
>>
>> To preserve the existing arm64 use case, a new cpus_affinity_set flag is
>> added to differentiate if user_cpus_ptr is set up by sched_setaffinity()
>> or by force_compatible_cpus_allowed_ptr(). user_cpus_ptr
>> set by sched_setaffinity() has priority and won't be
>> overwritten by force_compatible_cpus_allowed_ptr() or
>> relax_compatible_cpus_allowed_ptr().
> What why ?! The only possible case where
> restrict_cpus_allowed_ptr() will now need that weird new state is when
> the affinity has never been set before, in that case cpus_ptr should be
> possible_mask.

Since I don't have a full history for this particular patch series that 
add user_cpus_ptr, I am hesitant to change the current behavior for 
arm64 systems. However, given the statement that user_cpus_ptr is for 
tracking "requested affinity" which I assume is when user applications 
call sched_setaffinity(). It does make sense we may not really need this 
if sched_setaffinity() is never called.


> Please just make a single consistent rule and don't make weird corner
> cases like this.

I will take a closer look to try to simplify the rule here.

Cheers,
Longman

