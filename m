From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus
 affinity was explicitly set
Date: Thu, 28 Jul 2022 15:21:26 -0400
Message-ID: <606ed69e-8ad0-45d5-9de7-48739df7f48d@redhat.com>
References: <20220728005815.1715522-1-longman@redhat.com>
 <YuLF+xXaCzwWi2BR@slm.duckdns.org>
 <1ae1cc6c-dca9-4958-6b22-24a5777c5e8d@redhat.com>
 <YuLdX7BYGvo57LNU@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659036093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zpAAXgdBuqbloSbXAkh13drsVm6WLwNgqwukGGREVlE=;
        b=VGZPINUCWBbksqHCbK7r10+hZ4369nQ/+ZCUeLnC7jGOxYu6wxTbsjhBHzqjJua9IaZGCV
        nPm+NaSpY/lrU9ccPSQMa2T3todnVb/BajY05VXTBXHXk2ZaElNPZ9OIoKbCqy5O33b86E
        mXuUm+HfNVjvVlC7cS1tMLNtaF3sEUo=
Content-Language: en-US
In-Reply-To: <YuLdX7BYGvo57LNU-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/28/22 15:02, Tejun Heo wrote:
> Hello,
>
> On Thu, Jul 28, 2022 at 02:57:28PM -0400, Waiman Long wrote:
>> There can be a counter argument that if a user found out that there is not
>> enough cpus in a cpuset to meet its performance target, one can always
>> increase the number of cpus in the cpuset. Generalizing this behavior to all
>> the tasks irrespective if they have explicitly set cpus affinity before will
>> disallow this use case.
> This is nasty.

That is a nasty example, I know. There may be users depending on the 
existing behavior even if they don't know it. So I am a bit hesitant to 
change the default behavior like that. On the other hand, tasks that 
have explicitly set its cpu affinity certainly don't want to have 
unexpected change to that.

> The real solution here is separating out what user requested
> and the mask that cpuset (or cpu hotplug) needs to apply on top. ie.
> remember what the user requested in a separate cpumask and compute the
> intersection into p->cpus_maks whenever something changes and apply
> fallbacks on that final mask. Multiple parties updating the same variable is
> never gonna lead to anything consistent and we're patching up for whatever
> the immediate use case seems to need at the moment. That said, I'm not
> necessarily against patching it up but if you're interested in delving into
> it deeper, that'd be great.

I believe the current code is already restricting what cpu affinity that 
a user can request by limiting to those allowed by the current cpuset. 
Hotplug is another issue that may need to be addressed. I will update my 
patch to make it handle hotplug in a more graceful way.

Thanks,
Longman

