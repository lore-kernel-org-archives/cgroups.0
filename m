From: Brian Welty <brian.welty@intel.com>
Subject: [RFC PATCH 0/9] cgroup support for GPU devices
Date: Tue, 26 Jan 2021 13:46:17 -0800
Message-ID: <20210126214626.16260-1-brian.welty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Brian Welty <brian.welty@intel.com>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Kenny Ho <Kenny.Ho@amd.com>, amd-gfx@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, intel-gfx@lists.freedesktop.org, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Eero Tamminen <eero.t.tamminen@intel.com>

We'd like to revisit the proposal of a GPU cgroup controller for managing
GPU devices but with just a basic set of controls.  This series is based on 
the prior patch series from Kenny Ho [1].  We take Kenny's base patches
which implement the basic framework for the controller, but we propose an
alternate set of control files.  Here we've taken a subset of the controls
proposed in earlier discussion on ML here [2]. 

This series proposes a set of device memory controls (gpu.memory.current,
gpu.memory.max, and gpu.memory.total) and accounting of GPU time usage
(gpu.sched.runtime).  GPU time sharing controls are left as future work.
These are implemented within the GPU controller along with integration/usage
of the device memory controls by the i915 device driver.

As an accelerator or GPU device is similar in many respects to a CPU with
(or without) attached system memory, the basic principle here is try to
copy the semantics of existing controls from other controllers when possible
and where these controls serve the same underlying purpose.
For example, the memory.max and memory.current controls are based on
same controls from MEMCG controller.

Following with the implementation used by the existing RDMA controller,
here we introduce a general purpose drm_cgroup_try_charge and uncharge
pair of exported functions. These functions are to be used for
charging and uncharging all current and future DRM resource controls.

Patches 1 - 4 are part original work and part refactoring of the prior
work from Kenny Ho from his series for GPU / DRM controller v2 [1].

Patches 5 - 7 introduce new controls to the GPU / DRM controller for device
memory accounting and GPU time tracking.

Patch 8 introduces DRM support for associating GEM objects with a cgroup.

Patch 9 implements i915 changes to use cgroups for device memory charging
and enforcing device memory allocation limit.

[1] https://lists.freedesktop.org/archives/dri-devel/2020-February/257052.html
[2] https://lists.freedesktop.org/archives/dri-devel/2019-November/242599.html

Brian Welty (6):
  drmcg: Add skeleton seq_show and write for drmcg files
  drmcg: Add support for device memory accounting via page counter
  drmcg: Add memory.total file
  drmcg: Add initial support for tracking gpu time usage
  drm/gem: Associate GEM objects with drm cgroup
  drm/i915: Use memory cgroup for enforcing device memory limit

Kenny Ho (3):
  cgroup: Introduce cgroup for drm subsystem
  drm, cgroup: Bind drm and cgroup subsystem
  drm, cgroup: Initialize drmcg properties

 Documentation/admin-guide/cgroup-v2.rst    |  58 ++-
 Documentation/cgroup-v1/drm.rst            |   1 +
 drivers/gpu/drm/drm_drv.c                  |  11 +
 drivers/gpu/drm/drm_gem.c                  |  89 ++++
 drivers/gpu/drm/i915/gem/i915_gem_mman.c   |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_region.c |  23 +-
 drivers/gpu/drm/i915/intel_memory_region.c |  13 +-
 drivers/gpu/drm/i915/intel_memory_region.h |   2 +-
 include/drm/drm_cgroup.h                   |  85 ++++
 include/drm/drm_device.h                   |   7 +
 include/drm/drm_gem.h                      |  17 +
 include/linux/cgroup_drm.h                 | 113 +++++
 include/linux/cgroup_subsys.h              |   4 +
 init/Kconfig                               |   5 +
 kernel/cgroup/Makefile                     |   1 +
 kernel/cgroup/drm.c                        | 533 +++++++++++++++++++++
 16 files changed, 954 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/cgroup-v1/drm.rst
 create mode 100644 include/drm/drm_cgroup.h
 create mode 100644 include/linux/cgroup_drm.h
 create mode 100644 kernel/cgroup/drm.c

-- 
2.20.1
