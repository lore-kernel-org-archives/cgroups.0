From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v2 08/17] cgroup: Move debug cgroup to its own file
Date: Fri, 19 May 2017 15:33:14 -0400
Message-ID: <8d942ee6-ebf4-5ba5-5484-60762808f544@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-9-git-send-email-longman@redhat.com>
 <20170517213603.GE942@htj.duckdns.org>
 <ee36d4f8-9e9d-a5c7-2174-56c21aaf75af@redhat.com>
 <20170519192146.GA9741@wtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 69C0C81245
In-Reply-To: <20170519192146.GA9741-U58pm7aPsJ1N0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org

On 05/19/2017 03:21 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Thu, May 18, 2017 at 11:52:18AM -0400, Waiman Long wrote:
>> The controller name is "debug" and so it is obvious what this controller
>> is for. However, the config prompt "Example controller" is indeed vague
> Yeah but it also shows up as an integral part of stable interface
> rather than e.g. /sys/kernel/debug.  This isn't of any interest to
> people who aren't developing cgroup core code.  There is no reason to
> risk growing dependencies on it.

The debug controller is used to show information relevant to the cgroup
its css'es are attached to. So it will be very hard to use if we
relocate to /sys/kernel/debug, for example. Currently, nothing in the
debug controller other than debug_cgrp_subsys are exported. I don't see
any risk of having dependency on that controller from other parts of the
kernel.

>> in meaning. So we can make the prompt more descriptive here. As for the
>> boot param, are you saying something like "cgroup_debug" has to be
>> specified in the command line even if CGROUP_DEBUG config is there for
>> the debug controller to be enabled? I am fine with that if you think it
>> is necessary.
> Yeah, I think that'd be a good idea.  cgroup_debug should do.  While
> at it, can you also please make CGROUP_DEBUG depend on DEBUG_KERNEL?
>
> Thanks.
>
Sure. I will do that.

Cheers,
Longman

