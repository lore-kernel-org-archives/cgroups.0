From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] cpusets,isolcpus: exclude isolcpus from load
 balancing in cpusets
Date: Fri, 27 Feb 2015 10:32:31 +0100
Message-ID: <20150227093231.GG21418@twins.programming.kicks-ass.net>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
 <1424882288-2910-2-git-send-email-riel@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424882288-2910-2-git-send-email-riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 25, 2015 at 11:38:07AM -0500, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Ensure that cpus specified with the isolcpus= boot commandline
> option stay outside of the load balancing in the kernel scheduler.
> 
> Operations like load balancing can introduce unwanted latencies,
> which is exactly what the isolcpus= commandline is there to prevent.
> 
> Previously, simply creating a new cpuset, without even touching the
> cpuset.cpus field inside the new cpuset, would undo the effects of
> isolcpus=, by creating a scheduler domain spanning the whole system,
> and setting up load balancing inside that domain. The cpuset root
> cpuset.cpus file is read-only, so there was not even a way to undo
> that effect.
> 
> This does not impact the majority of cpusets users, since isolcpus=
> is a fairly specialized feature used for realtime purposes.
> 
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Tested-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Might I asked you to update Documentation/cgroups/cpusets.txt with this
knowledge? While it does mentions isolcpus it does not clarify the
interaction between it and cpusets.

Other than that,

Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
