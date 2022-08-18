From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/3] sched: Use user_cpus_ptr for saving user provided
 cpumask in sched_setaffinity()
Date: Thu, 18 Aug 2022 07:37:51 -0700
Message-ID: <58f4533b-6d0e-dc5f-2b8c-986212598125@redhat.com>
References: <20220816192734.67115-1-longman@redhat.com>
 <20220816192734.67115-2-longman@redhat.com>
 <YvymwlTkdsVDtmRB@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660833478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=55iMMmbwkaAqw4I8aj14bQmLqWfqTrm37aZFBETpBEc=;
        b=AXd06DJeCPoJ9Hwe1ARARheouGZU2j2KpSU3nHI2dajStUEwPoNf1ENqXQxPBA05Pko7ye
        GiACcwVfz/LjyRFe9JuTw5lKnp/e8hUGLMVZZboaF4e29tK0B1chAnmjCoWk1BXXd3H/B5
        NaqNAHScpANeeKO3PMR+9jRcrPejDk0=
Content-Language: en-US
In-Reply-To: <YvymwlTkdsVDtmRB-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 8/17/22 04:28, Peter Zijlstra wrote:
> On Tue, Aug 16, 2022 at 03:27:32PM -0400, Waiman Long wrote:
>
>> This will be some changes in behavior for arm64 systems with asymmetric
>> CPUs in some corner cases. For instance, if sched_setaffinity()
>> has never been called and there is a cpuset change before
>> relax_compatible_cpus_allowed_ptr() is called, its subsequent call will
>> follow what the cpuset allows but not what the previous cpu affinity
>> setting allows.
> That's arguably a correctness fix, no? That is, the save/restore should
> not have been allowed to revert to an earlier cpuset state.

Yes, it is a correctness fix in a sense. I just want to highlight that 
there will be some slight changes in behavior in some corner cases for 
the arm64 arch.

Cheers,
Longman

