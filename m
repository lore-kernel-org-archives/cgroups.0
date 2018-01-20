From: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH RFC 8/9] drm/i915: Allow default context priority to be set via
 cgroup parameter
Date: Sat, 20 Jan 2018 09:36:10 +0000
Message-ID: <151644097064.13504.16277692057900569412@mail.alporthouse.com>
References: <20180120015141.10118-1-matthew.d.roper@intel.com>
 <20180120015141.10118-9-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180120015141.10118-9-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Quoting Matt Roper (2018-01-20 01:51:40)
> GPU contexts are usually created with "normal" priority as a starting point and
> then may be adjusted from their either via explicit methods (context_set_param)
> or implicit methods (boosts/penalization due to runtime behavior).  Let's allow
> a system integrator to override this starting GPU priority for a group of
> processes by setting a parameter on the cgroup that these processes belong to.

You are still allowing a process to undo the cgroup by changing its
own priority. What you want I think is a priority-offset or somesuch.
-Chris
