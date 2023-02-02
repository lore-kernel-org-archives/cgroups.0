From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Thu, 2 Feb 2023 20:42:03 +0100
Message-ID: <Y9wSC1Wxlm8CKKlN@hirez.programming.kicks-ass.net>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
 <Y9t1sP/6nFht7RSN@hirez.programming.kicks-ass.net>
 <d630ca53-71f0-c735-fbc3-e826479aa86b@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eKs4vAUwEv0arCZAQ6y5NgakMpLZsicc4cD1nO/mnYw=; b=I2dAg18TWwn0J9HsHUU4oS/mwI
        ZIg0D78vzxqetQTkb+D+GnPnsU+n84veLlmahHdfkrLFyYyvAtBNwpAmIP2jSuGeZuJZlxs8yyvCI
        wzU+QRCsATbApLYTsE9fOUHlWPbYtiGA3vQl4tYW4tVqLLq9nN1Lqqr4ugR3TRTP1xUs7bk1VIUad
        o3fe+JORg8EF9KEtmOdw4YOx10+VeCTbdsJVmTnM/tFlFpHXdWnhaNaWTKIOcKuIAZvlicxrcejVn
        qMUMNBzbZt/GbcUmKToJBycax+vU24XD41FR+VRzgEXO3XX/13Tlu7d4IpuIjsTkRyx5YwtLL4TQF
        S5ItgR+w==;
Content-Disposition: inline
In-Reply-To: <d630ca53-71f0-c735-fbc3-e826479aa86b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 02, 2023 at 11:06:51AM -0500, Waiman Long wrote:

> After taking a close look at the patch, my understanding of what it is doing
> is as follows:
> 
> v2: cpus_allowed will not be affected by hotplug. So the new
> cpuset_cpus_allowed() will return effective_cpus + offline cpus that should
> have been part of effective_cpus if online before masking it with allowable
> cpus and then go up the cpuset hierarchy if necessary.
> 
> v1: cpus_allowed is equivalent to v2 effective_cpus. It starts at the
> current cpuset and move up the hierarchy if necessary to find a cpuset that
> have at least one allowable cpu.
> 
> First of all, it does not take into account of the v2 partition feature that
> may cause it to produce incorrect result if partition is enabled somewhere.

How so? For a partition the cpus_allowed mask should be the parition
CPUs. The only magical bit about partitions is that any one CPU cannot
belong to two partitions and load-balancing is split.

> Secondly, I don't see any benefit other than having some additional offline
> cpu available in a task's cpumask which the scheduler will ignore anyway.

Those CPUs can come online again -- you're *again* dismissing the true
bug :/

If you filter out the offline CPUs at sched_setaffinity() time, you
forever lose those CPUs, the task will never again move to those CPUs,
even if they do come online after.

It is really simple to reproduce this:

 - boot machine
 - offline all CPUs except one
 - taskset -p ffffffff $$
 - online all CPUs

and observe your shell (and all its decendants) being stuck to the one
CPU. Do the same thing on a CPUSET=n build and note the difference (you
retain the full mask).

> v2 is able to recover a previously offlined cpu. So we don't gain any
> net benefit other than the going up the cpuset hierarchy part.

Only for !root tasks. Not even v2 will re-set the affinity of root tasks
afaict.

> For v1, I agree we should go up the cpuset hierarchy to find a usable
> cpuset. Instead of introducing such a complexity in cpuset_cpus_allowed(),
> my current preference is to do the hierarchy climbing part in an enhanced
> cpuset_cpus_allowed_fallback() after an initial failure of
> cpuset_cpus_allowed(). That will be easier to understand than having such
> complexity and overhead in cpuset_cpus_allowed() alone.
> 
> I will work on a patchset to do that as a counter offer.

We will need a small and simple patch for /urgent, or I will need to
revert all your patches -- your call.

I also don't tihnk you fully appreciate the ramifications of
task_cpu_possible_mask(), cpuset currently gets that quite wrong.

