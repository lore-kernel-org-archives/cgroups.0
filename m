From: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Intel-gfx] [IGT PATCH RFC] tools: Introduce intel_cgroup tool
Date: Thu, 1 Feb 2018 15:14:38 -0800
Message-ID: <20180201231437.GJ31510@mdroper-desk.amr.corp.intel.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
 <20180201195615.5124-1-matthew.d.roper@intel.com>
 <151751685381.28099.5351495854502256843@mail.alporthouse.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <151751685381.28099.5351495854502256843-M6iVdVfohj6unts5RBS2dVaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Cc: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

+cgroups list since this discussion goes back to the general design

On Thu, Feb 01, 2018 at 08:27:33PM +0000, Chris Wilson wrote:
> Quoting Matt Roper (2018-02-01 19:56:15)
> > intel_cgroup is used to modify i915 cgroup parameters.  At the moment only a
> > single parameter is supported (GPU priority offset).  In the future the driver
> > may support additional parameters as well (e.g., limits on memory usage).
> > 
> > Signed-off-by: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
<snip>
> > +#define I915_CGROUP_PARAM_PRIORITY_OFFSET       0x1
> 
> Hmm. Could we not avoid drm_ioctl + well known param names and use a
> more generic tool to set cgroup attributes? Just feels wrong that a
> such a generic interface boils down to a driver specific ioctl.
> -Chris

There are a few different design choices here, so feedback like this is
definitely what I'm looking for with this series.  A few goals we should
keep in mind as we consider options:

 * I'd like to keep the attributes we set tied to a driver/device in
   some manner.  E.g., if we have a machine with multiple GPU's, we
   should be able to set card0 priority independently of card1 priority
   A DRM or driver ioctl makes this easy, but it certainly isn't the
   only approach.

 * Some of the attributes we want to manage don't fall under the design
   goals of formal cgroup controllers.  I.e., they don't care about the
   hierarchy layout of cgroups at all; they only care about the details
   of the process' final leaf node.  GPU priority as implemented in this
   series is an example of that.

 * Other attributes we'll eventually want to control (such as graphics
   memory usage), probably _will_ want to take the hierarchy design into
   account, the same way real cgroup controllers like the mem controller
   do.

 * The drivers that want to make use of this functionality may be built
   as modules rather than compiled directly into the kernel.  This is
   important because the cgroups subsystem removed the ability to have
   cgroup controllers in modules a few years ago.  While it might be
   possible to resurrect module-based cgroup controller support, my
   impression is that the cgroups community would prefer a separate
   non-controller mechanism for doing what we want to do.  E.g., see
   https://www.spinics.net/lists/cgroups/msg18674.html for some brief
   discussion on this topic.

I think the nicest interface for setting cgroup attributes would be to
find a way to add our own kernfs entries to the cgroup filesystem, the
same way real cgroup controllers do.  Then we could do something like
"echo 123 > /cgroup2/apps/highprio/i915.card0.priority" and not need to
call any ioctl's at all.  Without creating an actual cgroup controller,
I think this might be challenging, but I'm investigating it on the side
right now to see if it's a viable option.

There are other options that might be suitable as well, but I haven't
throught through them in details:

 * Hang the ioctl() off the cgroup filesystem entry rather than the DRM
   device node.  Not sure if this gains us anything given that we still
   want to track data on a per-device basis.

 * Add a cgroup filesystem entry that just handles write() events of the
   form "drivername:key:value" to trigger driver callbacks.  This might
   be a decent compromise.  E.g., we could issue a command like:
      echo "i915.card0:prio_base:123" > /cgroup2/foo/cgroup.driver_attr
   and the kernfs handler for that file would looks for a cgroup_driver
   registered under the name "i915.card0" to figure out what driver
   callback to call for the key/value data.

The second bullet above is growing on me as I think more about it, so I
might try implementing that approach in the third version of my series
if nobody has other suggestions or feedback.


Matt

-- 
Matt Roper
Graphics Software Engineer
IoTG Platform Enabling & Development
Intel Corporation
(916) 356-2795
