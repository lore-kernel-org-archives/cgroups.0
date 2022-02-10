From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 4/4] memcg: synchronously enforce memory.high
Date: Thu, 10 Feb 2022 12:15:34 -0800
Message-ID: <YgVyZrDPxVgP6OLG@carbon.dhcp.thefacebook.com>
References: <20220210081437.1884008-1-shakeelb@google.com>
 <20220210081437.1884008-5-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=znVSLUxVJgvB7Xxsv0c1Vo8l4xO9MfnfaPHIio67DAg=;
 b=ds6TeeeoezIWUgbkNbsITAg/mPilH/wda+VvxpTG0pwFLcADOHHagzljQ+JVWiFZITp0
 fY5WaS16KkGAZoxk6HgUlywgrdlKsWO+cDXp74uTZBv97V6SpG/47DQvvVrRTbLZ6UNz
 oBYhqgBbWQKxhj18FdbtdYitH7Lz0/YwD0Q= 
Content-Disposition: inline
In-Reply-To: <20220210081437.1884008-5-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 10, 2022 at 12:14:37AM -0800, Shakeel Butt wrote:
> The high limit is used to throttle the workload without invoking the
> oom-killer. Recently we tried to use the high limit to right size our
> internal workloads. More specifically dynamically adjusting the limits
> of the workload without letting the workload get oom-killed. However due
> to the limitation of the implementation of high limit enforcement, we
> observed the mechanism fails for some real workloads.
> 
> The high limit is enforced on return-to-userspace i.e. the kernel let
> the usage goes over the limit and when the execution returns to
> userspace, the high reclaim is triggered and the process can get
> throttled as well. However this mechanism fails for workloads which do
> large allocations in a single kernel entry e.g. applications that
> mlock() a large chunk of memory in a single syscall. Such applications
> bypass the high limit and can trigger the oom-killer.
> 
> To make high limit enforcement more robust, this patch make the limit
> enforcement synchronous. However there are couple of open questions to
> enforce high limit synchronously. What should be the behavior of
> __GFP_NORETRY allocaion on hitting high limit? Similar question arise
> for allocations which do not allow blocking. This patch took the
> approach to keep the previous behavior i.e. let such allocations not
> throttle synchronously but rely on the return-to-userspace mechanism to
> throttle processes triggering such allocations.
> 
> This patch does not remove the return-to-userspace high limit
> enforcement due to the reason mentioned in the previous para. Also the
> allocations where the memory usage is below high limit but the swap
> usage is above swap's high limit, such allocators are throttled in the
> return-to-userspace.

Has this approach been extensively tested in the production?

Injecting sleeps at return-to-userspace moment is safe in terms of priority
inversions: a slowed down task will unlikely affect the rest of the system.

It way less predictable for a random allocation in the kernel mode, what if
the task is already holding a system-wide resource?

Someone might argue that it's not better than a system-wide memory shortage
and the same allocation might go into a direct reclaim anyway, but with
the way how memory.high is used it will happen way more often.

Thanks!
