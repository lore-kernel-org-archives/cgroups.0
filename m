From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v4 00/10] DRM scheduling cgroup controller
Date: Fri, 24 Mar 2023 15:43:02 -1000
Message-ID: <ZB5RpmSm9qrpGIMS@slm.duckdns.org>
References: <20230314141904.1210824-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679708584;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4G7GTEkLJyxigscpgaXHx8wuFhpcA7W1uQv4GS0Q4mY=;
        b=FoqxvAznsCIPXUN2bat6fZfzRKWvB8hC7d1uXLR7mVPwwg15e2Wqn4qYAFs4yfyxZt
         uQ4FGAvuaVZaat5ySstLpCG8lARHkK0BiHAzSLQPyB4fWrsxfO19z5zSSBCdHg78qpk7
         VImKYhp9iAwcnpZZbKOxD+SDqXTU8vj2q55k/jL/z6ZCF+PJ6PdSIgMoEIS/L2K5jKJ1
         MdmkS1EAgAqOcMHNgO2tMwHARoSzuWa+UY/kKebbf4b4/FaOO9kJbfisICdL/XubcyI+
         1nJ1lGqoaR6Ifwsn8/YXOnVKWRPi/PJNFJWx+Ai7U53p4TjzVpxqV8pUExZQ2yFK8GNq
         ZPWw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230314141904.1210824-1-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello, Tvrtko.

On Tue, Mar 14, 2023 at 02:18:54PM +0000, Tvrtko Ursulin wrote:
> DRM scheduling soft limits
> ~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Because of the heterogenous hardware and driver DRM capabilities, soft limits
> are implemented as a loose co-operative (bi-directional) interface between the
> controller and DRM core.
> 
> The controller configures the GPU time allowed per group and periodically scans
> the belonging tasks to detect the over budget condition, at which point it
> invokes a callback notifying the DRM core of the condition.
> 
> DRM core provides an API to query per process GPU utilization and 2nd API to
> receive notification from the cgroup controller when the group enters or exits
> the over budget condition.
> 
> Individual DRM drivers which implement the interface are expected to act on this
> in the best-effort manner only. There are no guarantees that the soft limits
> will be respected.
> 
> DRM scheduling soft limits interface files
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In general, I'm in favor of your approach but can you please stop using the
term "soft limit". That's a term with a specific historical meaning in
cgroup, so it gets really confusing when you use the term for hierarchical
weighted control. If you need a term to refer to how the weighted control is
implemented by throttling cgroups at target rates, please just come up with
a different term "usage threshold based control", "usage throttling based
control" or whichever you may like.

>   drm.weight
> 	Standard cgroup weight based control [1, 10000] used to configure the
> 	relative distributing of GPU time between the sibling groups.
> 
> This builds upon the per client GPU utilisation work which landed recently for a
> few drivers. My thinking is that in principle, an intersect of drivers which
> support both that and some sort of scheduling control, like  priorities, could
> also in theory support this controller.
> 
> Another really interesting angle for this controller is that it mimics the same
> control menthod used by the CPU scheduler. That is the proportional/weight based
> GPU time budgeting. Which makes it easy to configure and does not need a new
> mental model.

FWIW, the hierarchical weighted distribution is also implemented by IO
control.

> However, as the introduction mentions, GPUs are much more heterogenous and
> therefore the controller uses very "soft" wording as to what it promises. The
> general statement is that it can define budgets, notify clients when they are
> over them, and let individual drivers implement best effort handling of those
> conditions.

Maybe "best effort" is more suited than "soft"?

...
> Roughly simultaneously we run the following two benchmarks in each session
> respectively:
> 
> 1)
> ./GpuTest /test=pixmark_julia_fp32 /width=1920 /height=1080 /fullscreen /no_scorebox /benchmark /benchmark_duration_ms=60000
> 
> 2)
> vblank_mode=0 bin/testfw_app --gl_api=desktop_core --width=1920 --height=1080 --fullscreen 1 --gfx=glfw -t gl_manhattan
> 
> (The only reason for vsync off here is because I struggled to find an easily
> runnable and demanding enough benchmark, or to run on a screen large enough to
> make even a simpler ones demanding.)
> 
> With this test we get 252fps from GpuTest and 96fps from GfxBenchmark.
> 
> Premise here is that one of these GPU intensive benchmarks is intended to be ran
> by the user with lower priority. Imagine kicking off some background compute
> processing and continuing to use the UI for other tasks. Hence the user will now
> re-run the test by first lowering the weight control of the first session (DRM
> cgroup):
> 
> 1)
> echo 50 | sudo tee /sys/fs/cgroup/`cut -d':' -f3 /proc/self/cgroup`/drm.weight
> ./GpuTest /test=pixmark_julia_fp32 /width=1920 /height=1080 /fullscreen /no_scorebox /benchmark /benchmark_duration_ms=60000
> 
> 2)
> vblank_mode=0 bin/testfw_app --gl_api=desktop_core --width=1920 --height=1080 --fullscreen 1 --gfx=glfw -t gl_manhattan
> 
> In this case we will see that GpuTest has recorded 208fps (~18% down) and
> GfxBenchmark 114fps (18% up), demonstrating that even a very simple approach of
> wiring up i915 to the DRM cgroup controller can enable external GPU scheduling
> control.

It's really nice to see it working pretty intuitively.

>  * For now (RFC) I haven't implemented the 2nd suggestion from Tejun of having
>    a shadow tree which would only contain groups with DRM clients. (Purpose
>    being less nodes to traverse in the scanning loop.)
> 
>  * Is the global state passing from can_attach to attach really okay? (I need
>    source and destination css.)

Right now, it is and there are other places that depend on it. Obviously,
it's not great and we probably want to add explicit context passed around
instead in the future, but for now, it should be okay.

While not fully polished, from cgroup POV, the series looks pretty good and
I'd be happy to see it merged.

Thanks.

-- 
tejun
