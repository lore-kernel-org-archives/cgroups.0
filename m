From: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Subject: Re: [Intel-gfx] [PATCH RFC v2 4/7] drm: Add helper to obtain cgroup of
 drm_file's owning process
Date: Thu, 01 Feb 2018 20:10:12 +0000
Message-ID: <151751581276.28099.14713646900027669861@mail.alporthouse.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
 <20180201195315.4956-5-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201195315.4956-5-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Matt Roper (2018-02-01 19:53:12)
> +/**
> + * drm_file_get_cgroup - obtain cgroup for drm_file's owning process
> + * @file_priv: DRM file
> + *
> + * Obtains the cgroup from a specific hierarchy that the drm_file's owning
> + * process belongs to.  The cgroup may be used to set driver-specific
> + * policy (priority, vram usage, etc.).
> + */
> +static inline struct cgroup *
> +drm_file_get_cgroup(struct drm_file *file_priv)
> +{
> +       return cgroup_for_driver_process(file_priv->pid);

Just a word of warning file_priv->pid isn't a true indicator of the
attached process's pid. E.g. DRI3 passes the struct drm_file over a UNIX
socket, so pid is Xorg but the actual process is the GL client.

Not sure if we can detect the transfer over the socket, but one
suggestion has been to update file->pid based on who creates a context.
-Chris
