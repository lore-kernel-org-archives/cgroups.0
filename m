From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/6] cpuset: Allow to modify isolcpus through cpuset
Date: Mon, 19 Jul 2021 15:57:28 +0200
Message-ID: <20210719135728.GD116346@lothringen>
References: <20210714135420.69624-1-frederic@kernel.org>
 <8ea7a78f-948e-75e8-1c4f-59b349c858f6@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626703050;
        bh=+gVq/NFsqZiiPUEMlRTEwLOqGw7ioAT+zNXkcTJwXSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oDyz5R+TBMFxLUUYo1IoQTxZpDh1twoMsHUmfL0NQkHCmV9hhtBs/kvJ0JI7WZIaa
         mddj4GV4kxWWR/KJi+/bK8N4FPB9OD0RMAFdfFnTfIYY+47oZ9zCli0GHBv3rm5gRy
         aRyUECiBI9Vhem5Lfq5o09JOb7d7DkR7ON+ceouOITetcG7rM2405gaH/+vX3Be953
         5Bm3FcH0mX1Ek1rGpB+qXz3ZCwCHcdZlqyr472clqvGzJKs/+iwQhi3pLIb/9xLqKW
         0B4C+rb2rxI+Cyx85ZUR3NwT5A37yIMHuNkGO1kmelIzRBkNARj2916Fkou0EjXd/O
         tu1JH1vqPyxKg==
Content-Disposition: inline
In-Reply-To: <8ea7a78f-948e-75e8-1c4f-59b349c858f6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 16, 2021 at 02:02:50PM -0400, Waiman Long wrote:
> On 7/14/21 9:54 AM, Frederic Weisbecker wrote:
> > The fact that "isolcpus=" behaviour can't be modified at runtime is an
> > eternal source of discussion and debate opposing a useful feature against
> > a terrible interface.
> > 
> > I've long since tried to figure out a proper way to control this at
> > runtime using cpusets, which isn't easy as a boot time single cpumask
> > is difficult to map to a hierarchy of cpusets that can even overlap.
> 
> I have a cpuset patch that allow disabling of load balancing in a cgroup-v2
> setting:
> 
> https://lore.kernel.org/lkml/20210621184924.27493-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
> 
> The idea of cpuset partition is that there will be no overlap of cpus in
> different partitions. So there will be no confusion whether a cpu is
> load-balanced or not.

Oh ok I missed that, time for me to check your patchset.

Thanks!

> 
> > 
> > The idea here is to map the boot-set isolation behaviour to any cpuset
> > directory whose cpumask is a subset of "isolcpus=". I let you browse
> > for details on the last patch.
> > 
> > Note this is still WIP and half-baked, but I figured it's important to
> > validate the interface early.
> 
> Using different cpumasks for different isolated properties is the easy part.
> The hard part is to make different subsystems to change their behavior as
> the isolation masks change dynamically at run time. Currently, they check
> the housekeeping cpumask only at boot time or when certain events happen.
> 
> Cheers,
> Longman
> 
> 
