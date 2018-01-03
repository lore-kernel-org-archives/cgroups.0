From: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] Documentation/cgroup-v1: fix outdated programming
 details
Date: Tue, 2 Jan 2018 16:12:02 -0800
Message-ID: <20180103001202.GX5820@mdroper-desk.amr.corp.intel.com>
References: <20171229200200.18873-1-matthew.d.roper@intel.com>
 <20171229203449.GS5820@mdroper-desk.amr.corp.intel.com>
 <20180102150502.GC3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180102150502.GC3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 02, 2018 at 07:05:02AM -0800, Tejun Heo wrote:
> Hello, Matt.
> 
> On Fri, Dec 29, 2017 at 12:34:49PM -0800, Matt Roper wrote:
> > If a system is already using a cgroups-v2 hierarchy to manage other
> > system resources via the standard controllers, I think it would be ideal
> > if we could leverage that existing process organization to supply i915
> > with desired driver-specific policy and resource assignments.  Since
> > cgroup controllers don't seem to support this at the moment, is there an
> > alternate mechanism I should be looking at instead?  Or is this a type
> > of use case that we may want to evolve cgroups to support in a different
> > manner?
> 
> cgroup membership of a task and the hierarchical relationships of
> cgroups can be determined trivially.  Unless the resource in question
> needs to and can strictly follow the resource rules for cgroup
> controllers, which can become really involving and invasive, the
> better and easier approach is using cgroup membership as an extra
> information from the subsystem, which is how the network and bpf
> handle cgroup membership too.

Hi Tejun.

To make sure I'm understanding correctly --- you're suggesting that
instead of using a cgroup controller to add values (priority, vram,
etc.) as directly-accessible file nodes under a cgroup's kernfs
directory that I instead add new driver-specific ioctls (e.g.,
DRM_IOCTL_SET_CGROUP_PRIORITY) to programmatically update a driver
internal cgroup=>priority mapping table?  I think that roughly matches
what I see the bpf code doing with BPF_PROG_ATTACH in the bpf syscall.

I was originally hoping for some way that a driver could add entries to
the cgroup directory since that's easy to configure with something as
simple as a sysv-init script (and matches how other system policy values
will be updated).  But I guess we can write a simple userland tool to go
with our driver that can be called from such a script.

I guess the other alternative would be to try to mirror the cgroup
hierarchy in a driver-specific sysfs or debugfs tree where we'd add our
own value files, but that's probably more hassle than it's worth.

Thanks for your help.


Matt

> 
> Thanks.
> 
> -- 
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matt Roper
Graphics Software Engineer
IoTG Platform Enabling & Development
Intel Corporation
(916) 356-2795
