From: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 0/4]  Add support for DRM cgroup memory accounting.
Date: Wed,  3 May 2023 10:34:56 +0200
Message-ID: <20230503083500.645848-1-maarten.lankhorst@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Type: text/plain; charset="us-ascii"
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-xe-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

RFC as I'm looking for comments.

For long running compute, it can be beneficial to partition the GPU memory
between cgroups, so each cgroup can use its maximum amount of memory without
interfering with other scheduled jobs. Done properly, this can alleviate the
need for eviction, which might result in a job being terminated if the GPU
doesn't support mid-thread preemption or recoverable page faults.

This is done by adding a bunch of knobs to cgroup:
drm.capacity: Shows maximum capacity of each resource region.
drm.max: Display or limit max amount of memory.
drm.current: Current amount of memory in use.

TTM has not been made cgroup aware yet, so instead of evicting from
the current cgroup to stay within the cgroup limits, it simply returns
the error -ENOSPC to userspace.

I've used Tvrtko's cgroup controller series as a base, but it implemented
scheduling weight, not memory accounting, so I only ended up keeping the
base patch.

Xe is not upstream yet, so the driver specific patch will only apply on
https://gitlab.freedesktop.org/drm/xe/kernel

Maarten Lankhorst (3):
  drm/cgroup: Add memory accounting to DRM cgroup
  drm/ttm: Handle -EAGAIN in ttm_resource_alloc as -ENOSPC.
  drm/xe: Add support for the drm cgroup

Tvrtko Ursulin (1):
  cgroup: Add the DRM cgroup controller

 Documentation/admin-guide/cgroup-v2.rst    |  46 ++
 Documentation/gpu/drm-compute.rst          |  54 ++
 drivers/gpu/drm/ttm/ttm_bo.c               |   4 +-
 drivers/gpu/drm/xe/xe_device.c             |   4 +
 drivers/gpu/drm/xe/xe_device_types.h       |   4 +
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c       |  21 +-
 drivers/gpu/drm/xe/xe_ttm_vram_mgr_types.h |   5 +
 include/linux/cgroup_drm.h                 |  90 ++++
 include/linux/cgroup_subsys.h              |   4 +
 init/Kconfig                               |   7 +
 kernel/cgroup/Makefile                     |   1 +
 kernel/cgroup/drm.c                        | 557 +++++++++++++++++++++
 12 files changed, 794 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/gpu/drm-compute.rst
 create mode 100644 include/linux/cgroup_drm.h
 create mode 100644 kernel/cgroup/drm.c

-- 
2.34.1

