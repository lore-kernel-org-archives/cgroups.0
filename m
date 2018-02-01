From: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH RFC v2 7/7] drm/i915: Add context priority & priority offset to
 debugfs
Date: Thu, 01 Feb 2018 20:24:00 +0000
Message-ID: <151751664033.28099.8069028482469265908@mail.alporthouse.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
 <20180201195315.4956-8-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201195315.4956-8-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Matt Roper (2018-02-01 19:53:15)
> Update i915_context_status to include priority information.
> 
> Signed-off-by: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/gpu/drm/i915/i915_debugfs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
> index 3849ded354e3..e9d8e20155b1 100644
> --- a/drivers/gpu/drm/i915/i915_debugfs.c
> +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> @@ -1915,6 +1915,9 @@ static int i915_context_status(struct seq_file *m, void *unused)
>                 seq_putc(m, ctx->remap_slice ? 'R' : 'r');
>                 seq_putc(m, '\n');
>  
> +               seq_printf(m, "Priority %d (prio offset = %d)\n",
> +                          ctx->priority, ctx->priority_offset);

s/prio offset/cgroup offset/ ?
"prio" itself I think is redundant given that we are providing further
details of "Priority"
-Chris
