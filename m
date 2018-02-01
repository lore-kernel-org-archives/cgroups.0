From: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH RFC v2 5/7] drm/i915: cgroup integration
Date: Thu, 01 Feb 2018 20:11:39 +0000
Message-ID: <151751589976.28099.4209324863651884229@mail.alporthouse.com>
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
> diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
> index dfd95889f4b7..1c6b53ee76cd 100644
> --- a/drivers/gpu/drm/i915/Kconfig
> +++ b/drivers/gpu/drm/i915/Kconfig
> @@ -23,6 +23,7 @@ config DRM_I915
>         select SYNC_FILE
>         select IOSF_MBI
>         select CRC32
> +       select CGROUP_DRIVER if CGROUPS

Hmm, I was expecting a DRM_CGROUP around here?

Was it too small to be worth building conditionally?
-Chris
