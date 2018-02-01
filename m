From: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH RFC v2 5/7] drm/i915: cgroup integration
Date: Thu, 01 Feb 2018 20:12:43 +0000
Message-ID: <151751596359.28099.14218841777633069315@mail.alporthouse.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
 <20180201195315.4956-6-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201195315.4956-6-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Matt Roper (2018-02-01 19:53:13)
> Register i915 as a consumer of the cgroup_driver framework and add an ioctl to
> allow userspace to set i915-specific parameters associated with cgroups.
> 
> Signed-off-by: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/gpu/drm/i915/Kconfig       |   1 +
>  drivers/gpu/drm/i915/Makefile      |   1 +
>  drivers/gpu/drm/i915/i915_cgroup.c | 134 +++++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/i915/i915_drv.c    |   7 ++
>  drivers/gpu/drm/i915/i915_drv.h    |  24 +++++++
>  include/uapi/drm/i915_drm.h        |  12 ++++
>  6 files changed, 179 insertions(+)
>  create mode 100644 drivers/gpu/drm/i915/i915_cgroup.c
> 
> diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
> index dfd95889f4b7..1c6b53ee76cd 100644
> --- a/drivers/gpu/drm/i915/Kconfig
> +++ b/drivers/gpu/drm/i915/Kconfig
> @@ -23,6 +23,7 @@ config DRM_I915
>         select SYNC_FILE
>         select IOSF_MBI
>         select CRC32
> +       select CGROUP_DRIVER if CGROUPS
>         help
>           Choose this option if you have a system that has "Intel Graphics
>           Media Accelerator" or "HD Graphics" integrated graphics,
> diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
> index 3bddd8a06806..5f4a21f1a9df 100644
> --- a/drivers/gpu/drm/i915/Makefile
> +++ b/drivers/gpu/drm/i915/Makefile
> @@ -47,6 +47,7 @@ i915-y := i915_drv.o \
>  i915-$(CONFIG_COMPAT)   += i915_ioc32.o
>  i915-$(CONFIG_DEBUG_FS) += i915_debugfs.o intel_pipe_crc.o
>  i915-$(CONFIG_PERF_EVENTS) += i915_pmu.o
> +i915-$(CONFIG_CGROUPS) += i915_cgroup.o

CONFIG_CGROUP_DRIVER since that's strictly what the code depends on?
-Chris
