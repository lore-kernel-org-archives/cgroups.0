From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 3/3] cgroup/cpuset: Keep user set cpus affinity
Date: Tue, 16 Aug 2022 20:13:25 -0400
Message-ID: <eed3b91b-5297-c27a-acab-87e4afb4148c@redhat.com>
References: <20220816192734.67115-1-longman@redhat.com>
 <20220816192734.67115-4-longman@redhat.com>
 <Yvv66EWygCwHUCqy@slm.duckdns.org>
 <c10e4f69-9951-6c38-6e28-fafcaec00d89@redhat.com>
 <YvwX24GXadKQNp6V@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660695214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n9qL/h6uXIAb6VYdRPx1bWna3ld2RQQy7Q8vkiGHtWQ=;
        b=YF4vFqcfxWEEd5k189P4s8bOWgjNDSP43I7RHjVOaCeg2l7RkduHsbLg8a2xraciDDqNwP
        yqPSgf3oPa618PcWQ6zhtG4u+BDosfaf4nh2KHBiQ5YPiUyUfBXNaFzsafhYulDo0GuKTL
        TRt1VCIjyb8BlOAXocwv729rMAK34K8=
Content-Language: en-US
In-Reply-To: <YvwX24GXadKQNp6V-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


On 8/16/22 18:19, Tejun Heo wrote:
> Hello,
>
> On Tue, Aug 16, 2022 at 06:11:03PM -0400, Waiman Long wrote:
>> It is hard to synchronize different subsystems atomically without running
>> into locking issue. Let me think about what can be done in this case.
> I have a hard time seeing why this would be particularly difficult. cpuset
> just needs to make the latest cpumask available to sched core in an easily
> accessible form and whenever that changes, trigger a set_cpus_allowed call.
> There's no need to entangle operations across the whole subsystems. All
> that's needed to be communicated is the current cpumask.
>
>> Is using a sequence number to check for race with retry good enough?
> It seems unnecessarily fragile and complicated to me. If we're gonna change
> it, let's change it right.

Thanks for the suggestion. I think I get what you want. I am going to 
migrate the cpuset_set_cpus_allowed_ptr() logic into 
set_cpus_allowed_ptr() itself. IOW, if user_cpus_ptr is defined, it will 
be an additional mask to be applied on top. It does affect all callers 
of set_cpus_allowed_ptr() though. I am going to drop this cpuset 
specific patch.

BTW, I will be on PTO starting tomorrow until next Tuesday. So I will be 
slow in responding to emails.

Cheers,
Longman

Cheers,
Longman

