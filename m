From: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 0/9] DRM management via cgroups
Date: Fri, 19 Jan 2018 17:51:32 -0800
Message-ID: <20180120015141.10118-1-matthew.d.roper@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

cgroups are core kernel mechanism that allows a system integrator /
system administrator to collect OS processes into a hierarchy of groups
according to their intended role in the overall system; resource
management and policy configuration can then be applied to each cgroup
independently.

The DRM subsystem manages several concepts that would be a good match
for cgroup-level configuration.  This series adds infrastructure to
allow DRM drivers to track 'parameters' associated with individual
cgroups.  These parameters can be used to manage things like GPU
priority, discrete/stolen memory limits, etc.; drivers will be able to
query the parameters set for a process' cgroup and then apply
appropriate driver-level policy.

The series is organized as follows:
 * Patches 1-4 export some additional interfaces from the cgroup core
   kernel implementation to make them accessible to modules and drivers.
 * Patch 5 introduces a new DRM ioctl that allows userspace to set
   parameter values for specific cgroups.
 * Patch 6 introduces a DRM helper library to simplify the management
   of allocation/storage/fetching of per-cgroup driver-specific data.
 * Patch 7 adds a helper function to obtain the v2 cgroup of the process
   associated with a drm_file.
 * Patch 8 implements support for GPU priority as a cgroup parameter in
   the i915 driver.
 * Patch 9 adds context priority to i915's debugfs output to make it
   easier to verify that context priorities are being initialized as
   expected.

Anticipated questions / concerns
--------------------------------

Q:  What's the userspace consumer of this?

A:  I'll send a follow-up to the dri-devel / intel-gfx mailing lists
    with a small patch that adds a simple command line tool to the
    libdrm tests directory.  Although it looks more like a simple test
    program than a real consumer, I think it's about the only userspace
    we'll ever want/need.  Keep in mind that the real "consumers" here
    aren't the graphics applications themselves, but rather the system
    startup process (e.g., a sysv-init script or systemd service).  The
    startup scripts can shuffle the various services/programs into
    appropriate cgroups and then make some calls like:

       drm_set_cgrp_param /dev/dri/card0 /cgroup2/safety_critical/ 1 900
       drm_set_cgrp_param /dev/dri/card0 /cgroup2/high_priority/ 1 100
       drm_set_cgrp_param /dev/dri/card0 /cgroup2/best_effort/ 1 -200

    to define the priority policy for each cgroup.  Aside from initial
    startup scripts, none of the actual graphics clients are expected to
    touch this interface.


Q:  The initial use case here is for setting i915 GPU priority according
    to cgroup.  How/why does this differ from existing priority
    mechanisms (e.g., setting I915_CONTEXT_PARAM_PRIORITY via the
    I915_GEM_CONTEXT_SETPARAM ioctl on individual GPU contexts)?

A:  Existing mechanisms like the i915 context priority parameter will
    ultimately be called by the software that priority is being assigned
    for (e.g., a 3D application might use EGL_IMG_context_priority to
    self-classify as high priority or low priority).  However the
    priority of an application usually isn't a characteristic of an
    application itself, but rather a decision that an admin/integrator
    makes from a system-level perspective.  cgroups provide a standard,
    convenient mechanism for a system integrator to apply the specific
    policy he needs to build a cohesive system.

    Note that the cgroups support for i915 priority  here just assigns the
    initial/default priority for GPU contexts and doesn't block runtime
    adjustment of the priority via other mechanisms.


Q:  Do we really anticipate other DRM concepts (beyond GPU priority)
    being a reasonable match for cgroups-style management/control?

A:  I think there's a lot of potential to use cgroups to manage limits
    on various types of "graphics memory" in the future.  That could
    either be things like stolen memory on i915 (granted, we don't allow
    direct allocations of this from userspace today, but it's been
    talked about in the past) or discrete video RAM on systems that have
    that.


Q:  Why is this implemented via DRM ioctl rather than as a cgroup
    controller which would expose settings via kernfs nodes?

A:  The kernel has a concept of 'cgroup controllers' for exposing
    settings via virtual filesystem nodes.  My initial thought was to
    expose this kind of functionality as a driver-level cgroup
    controller so that, for example, virtual files like "i915.priority"
    would appear in each cgroup folder and be readable/writable
    directly.  However as of commit ("3ed80a6 ("cgroup: drop module
    support")), it's now required that controllers be built directly
    into the kernel; they can no longer be provided by modules.  There
    was some discussion about this direction at the time here:
      https://www.spinics.net/lists/cgroups/msg10077.html
    and we discussed it recently again on the cgroups mailing list here:  
      https://www.spinics.net/lists/cgroups/msg18672.html
    
    The way I see it, usage of cgroups can pretty much be broken down
    into two categories:  (a) distribution/management of a limited
    resource across a hierarchy of processes, and (b) general
    policy/configuration setting for groups of processes.  The cgroup
    controller concept is really designed for category (a) above, and a
    lot of work is done to take the cgroup hierarchy itself into
    account, not just the details of the final leaf node.  In contrast,
    my initial use of cgroups for DRM drivers (i915 GPU priority) falls
    into the second category --- we're managing the GPU priority that
    the scheduler makes use of rather than share of GPU time.  The
    solution I've taken here (driver/subsystem call that takes a cgroup
    as a parameter and manages data locally) is closer in design to some
    other areas of the kernel (like the BPF_PROG_ATTACH command accepted
    by the bpf() system call).

    It's possible that if/when we do start looking to cgroups for
    graphics-specific memory management we will want to consider using a
    true cgroup controller for that type of management (since it will
    fit more into category (a) above as a true resource controller).
    That will probably be some serious work to resurrect module-based
    controller support in the cgroup subsystem, so I'll leave that until
    we have a definite use case that needs it.  For simpler policy (like
    GPU priority), the approach here is probably a better direction
    forward.  Of course this is an initial RFC, so feedback welcome!
    

Q:  Why does the DRM cgroup support here restrict itself to the
    cgroup-v2 hierarchy?  Why not allow DRM parameters to be set on
    all the cgroup-v1 hierarchies my distro has?

A:  cgroups has two ABI's (a multi-hierarchy cgroup-v1 and a single
    hierarchy cgroup-v2).  Both can co-exist and be used simultaneously
    on a system, but cgroups-v1 is really for backward compatility, and
    cgroups-v2 is supposed to be the way of the future.  I restricted
    the support here to v2 mostly so that we wouldn't be building on a
    legacy framework, but also because the multi-hierarchy nature of v1
    cgroups adds some extra complexity.  When creating a new GPU
    context, how would you decide which hierarchy to try to lookup
    priority in?  What if a process had different priority values set on
    its cgroups in different hierarchies?  It's easiest to just avoid
    the confusion by sticking with the single v2 hierarchy.


Q:  The patches here add support for "i915 priority."  Should we
    simplify this to a more general "GPU priority" that isn't
    driver-specific or device-specific?

A:  I opted for a device-specific approach here for a few reasons.
    First, it doesn't seem unreasonable to have a multi-GPU system where
    groups have different priorities for each GPU they can submit
    workloads to.  Second, we already have multiple scheduler
    implementations in the DRM tree (e.g., the shared "DRM scheduler"
    contributed by AMD and the Intel i915 scheduler).  These schedulers
    have different priority ranges and expectations so it might be
    confusing to try to map any general purpose "GPU priority" range
    into the specifc range used by an individual scheduler, especially
    when driver-specific interfaces would then have the ability to alter
    the priority further via driver-specific interfaces.


Q:  Given the justification above, is "i915 priority" too high-level?
    Should we allow priority to be set independently for different
    engines within a single GPU (e.g., render prio != blit prio != video
    prio)?

A:  Maybe?  I'm open to feedback on this one.  If we decide to stick
    with a single i915 priority for now, we can always add per-engine
    priority parameters in the future and update the code so that the
    existing parameter (I915_CGRP_DEF_CONTEXT_PRIORITY) simply sets the
    priority for all engines to the same value at once.


Q:  What is the access control on this ioctl?  Who/what is allowed to
    set cgroup parameters?

A:  I've tied the access to this ioctl to filesystem permissions on the
    cgroup kernfs directory.  If a process has write access on the
    directory (meaning it can make other types of cgroup modifications),
    then it can update cgroup parameters via the ioctl.  I think this is
    the most sensible way to handle access permission, but alternate
    suggestions are welcome.


TODO
----
 - Add some i-g-t tests to exercise the ioctl interface, especially
   interaction with various cgroup operations (e.g., set parameter for a
   cgroup, then rmdir the cgroup directory)

 - Documentation:  the new code here has a lot of kerneldoc embedded in
   it, but none of that is actually integrated into the rst files in the
   Documentation/gpu directory yet.



Matt Roper (9):
  kernfs: Export kernfs_get_inode
  cgroup: Add notifier call chain for cgroup destruction
  cgroup: Export cgroup_on_dfl() to drivers
  cgroup: Export task_cgroup_from_root() and cgroup_mutex for drivers
  drm: Introduce DRM_IOCTL_CGROUP_SETPARAM
  drm: Add cgroup helper library
  drm: Add helper to obtain cgroup of drm_file's owning process
  drm/i915: Allow default context priority to be set via cgroup
    parameter
  drm/i915: Add context priority to debugfs

 drivers/gpu/drm/Makefile                |   2 +
 drivers/gpu/drm/drm_cgroup.c            | 120 ++++++++++++++++
 drivers/gpu/drm/drm_cgroup_helper.c     | 244 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_ioctl.c             |   5 +
 drivers/gpu/drm/i915/Makefile           |   1 +
 drivers/gpu/drm/i915/i915_cgroups.c     | 162 +++++++++++++++++++++
 drivers/gpu/drm/i915/i915_debugfs.c     |   2 +
 drivers/gpu/drm/i915/i915_drv.c         |   4 +
 drivers/gpu/drm/i915/i915_drv.h         |  32 +++++
 drivers/gpu/drm/i915/i915_gem_context.c |   2 +-
 fs/kernfs/inode.c                       |   1 +
 include/drm/drm_cgroup.h                |  38 +++++
 include/drm/drm_cgroup_helper.h         | 153 ++++++++++++++++++++
 include/drm/drm_device.h                |  13 ++
 include/drm/drm_file.h                  |  28 ++++
 include/linux/cgroup.h                  |  10 +-
 include/uapi/drm/drm.h                  |  10 ++
 include/uapi/drm/i915_drm.h             |   9 ++
 kernel/cgroup/cgroup-internal.h         |   4 -
 kernel/cgroup/cgroup.c                  |  27 +++-
 20 files changed, 858 insertions(+), 9 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_cgroup.c
 create mode 100644 drivers/gpu/drm/drm_cgroup_helper.c
 create mode 100644 drivers/gpu/drm/i915/i915_cgroups.c
 create mode 100644 include/drm/drm_cgroup.h
 create mode 100644 include/drm/drm_cgroup_helper.h

-- 
2.14.3
