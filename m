From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 6/6] cpuset: Add cpuset.isolation_mask file
Date: Wed, 14 Jul 2021 18:52:43 +0200
Message-ID: <YO8WWxWBmNuI0iUW@hirez.programming.kicks-ass.net>
References: <20210714135420.69624-1-frederic@kernel.org>
 <20210714135420.69624-7-frederic@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Q0twLm1z1R0272a0gO8MDKn0VGtCaKOLX5zeaoDfy7Y=; b=fyvXzPlxhF3nWWnznUlnq4Dikm
        hX2wJaaNocJtshQ0ww0fN1B4flWR1WAf9fv6REtMnCM11+TFwu72WK17oDrcLSDc9pOww0UZFQvGq
        nk5K1LrOAyuAEF880y7lGv2O5lk6CYX5cz+rNEM4jAooUOPr0uzxpRDDd6VqmrTpu9OvzsM/Y0NpJ
        vpK9G3MPxB49hQERwFqvHF2RBPArImxE4GZooADG7gXFSiBMWUIxP5xPDGYW8YLQyG9shv3Gfex64
        9L7P98EIfUwgbPdWp075MRNcR5MBJFoGs28h/co7WlWPYfzKj3mMTFhyn1QWxCuwG5uZy9PqS/fpP
        Qq3IMuyQ==;
Content-Disposition: inline
In-Reply-To: <20210714135420.69624-7-frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 14, 2021 at 03:54:20PM +0200, Frederic Weisbecker wrote:
> Add a new cpuset.isolation_mask file in order to be able to modify the
> housekeeping cpumask for each individual isolation feature on runtime.
> In the future this will include nohz_full, unbound timers,
> unbound workqueues, unbound kthreads, managed irqs, etc...
> 
> Start with supporting domain exclusion and CPUs passed through
> "isolcpus=".
> 
> The cpuset.isolation_mask defaults to 0. Setting it to 1 will exclude
> the given cpuset from the domains (they will be attached to NULL domain).
> As long as a CPU is part of any cpuset with cpuset.isolation_mask set to
> 1, it will remain isolated even if it overlaps with another cpuset that
> has cpuset.isolation_mask  set to 0. The same applies to parent and
> subdirectories.
> 
> If a cpuset is a subset of "isolcpus=", it automatically maps it and
> cpuset.isolation_mask will be set to 1. This subset is then cleared from
> the initial "isolcpus=" mask. The user is then free to override
> cpuset.isolation_mask to 0 in order to revert the effect of "isolcpus=".
> 
> Here is an example of use where the CPU 7 has been isolated on boot and
> get re-attached to domains later from cpuset:
> 
> 	$ cat /proc/cmdline
> 		isolcpus=7
> 	$ cd /sys/fs/cgroup/cpuset
> 	$ mkdir cpu7
> 	$ cd cpu7
> 	$ cat cpuset.cpus
> 		0-7
> 	$ cat cpuset.isolation_mask
> 		0
> 	$ ls /sys/kernel/debug/domains/cpu7	# empty because isolcpus=7
> 	$ echo 7 > cpuset.cpus
> 	$ cat cpuset.isolation_mask	# isolcpus subset automatically mapped
> 		1
> 	$ echo 0 > cpuset.isolation_mask
> 	$ ls /sys/kernel/debug/domains/cpu7/
> 		domain0  domain1
> 

cpusets already has means to create paritions; why are you creating
something else?
