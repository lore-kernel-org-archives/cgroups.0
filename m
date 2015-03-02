From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Mon, 2 Mar 2015 10:09:33 +0100
Message-ID: <20150302090933.GH21418@twins.programming.kicks-ass.net>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
 <1424882288-2910-3-git-send-email-riel@redhat.com>
 <54EEFE15.3010005@huawei.com>
 <20150226121231.6fcba7e8@annuminas.surriel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150226121231.6fcba7e8-XDFsmL65zczMw9PXcw3sFBL4W9x8LtSr@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 26, 2015 at 12:12:31PM -0500, Rik van Riel wrote:
> Subject: cpusets,isolcpus: add file to show isolated cpus in cpuset
> 
> The previous patch makes it so the code skips over isolcpus when
> building scheduler load balancing domains. This makes it hard to
> see for a user which of the CPUs in a cpuset are participating in
> load balancing, and which ones are isolated cpus.
> 
> Add a cpuset.isolcpus file with info on which cpus in a cpuset are
> isolated CPUs.
> 
> This file is read-only for now. In the future we could extend things
> so isolcpus can be changed at run time, for the root (system wide)
> cpuset only.
> 
> Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

So let me start off by saying I hate isolcpus ;-)

Let me further state that I had hopes we could extend cpusets to
natively provide the functionality isolcpus has, and kill isolcpus.

The 'normal' way would be to create 2 cgroups with disjoint cpus,
disable sched_load_balance on root and one of the siblings, while moving
everything into the other group.

The 'problem' is that we cannot move everything that is affected by
isolcpus, workqueues have grown a horrible 'new' interface outside of
the regular task interfaces and things like kthreadd are non-movable for
mostly good reasons.

Furthermore it appears that software like system-disease and libvirt
hard assume they're lord and master of the cgroup hierarchy and do not
expect things like this.

So while I mostly hate all of this it might be the best we can do :-(
