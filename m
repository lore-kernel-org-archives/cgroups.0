From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/4]  Add support for DRM cgroup memory accounting.
Date: Fri, 5 May 2023 09:50:59 -1000
Message-ID: <ZFVeI2DKQXddKDNl@slm.duckdns.org>
References: <20230503083500.645848-1-maarten.lankhorst@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683316261; x=1685908261;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9VTfSz0yyeWdPF85h+AGQ/vGWi6fRSpfJvLR0EPjDWQ=;
        b=YzCXidzcvcJPIoxaBZ+1nS64ayb4z2Nf/LW7iWyUN9Mns5/BbiJOUSxxUH/670nETy
         MIs5soNpscb526ENU8VjKh6AdiDPRH98QzW13/BUp9S+rDbjVHfd3KCVMKP9SEX3qgfA
         K1ywoVkU2tKVOeJIyZdnfV9SFvQ+jCeepatv589ecD3xCxWZvUiuoMFaAVK0Vw+XLPIa
         VpXQlYmhF33TSjEjtEeLUKbnUMQd2SJy9bedok132XO7Har+gUApfjkynV5S5dUx+MDg
         ftBonzsxuMC4noRNfzT1bUaXe150dGe63LYuU5IwhhM4dL63Q7uC6ix1Fn5ZgosyQkuN
         bSEA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230503083500.645848-1-maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-xe-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello,

On Wed, May 03, 2023 at 10:34:56AM +0200, Maarten Lankhorst wrote:
> RFC as I'm looking for comments.
> 
> For long running compute, it can be beneficial to partition the GPU memory
> between cgroups, so each cgroup can use its maximum amount of memory without
> interfering with other scheduled jobs. Done properly, this can alleviate the
> need for eviction, which might result in a job being terminated if the GPU
> doesn't support mid-thread preemption or recoverable page faults.
> 
> This is done by adding a bunch of knobs to cgroup:
> drm.capacity: Shows maximum capacity of each resource region.
> drm.max: Display or limit max amount of memory.
> drm.current: Current amount of memory in use.
> 
> TTM has not been made cgroup aware yet, so instead of evicting from
> the current cgroup to stay within the cgroup limits, it simply returns
> the error -ENOSPC to userspace.
> 
> I've used Tvrtko's cgroup controller series as a base, but it implemented
> scheduling weight, not memory accounting, so I only ended up keeping the
> base patch.
> 
> Xe is not upstream yet, so the driver specific patch will only apply on
> https://gitlab.freedesktop.org/drm/xe/kernel

Some high-level feedbacks.

* There have been multiple attempts at this but the track record is kinda
  poor. People don't seem to agree what should constitute DRM memory and how
  they should be accounted / controlled.

* I like Tvrtko's scheduling patchset because it exposes a generic interface
  which makes sense regardless of hardware details and then each driver can
  implement the configured control in whatever way they can. However, even
  for that, there doesn't seem much buy-in from other drivers.

* This proposal seems narrowly scoped trying to solve a specific problem
  which may not translate to different hardware configurations. Please let
  me know if I got that wrong, but if that's the case, I think a better and
  easier approach might be just being a part of the misc controller. That
  doesn't require much extra code and should be able to provide everything
  necessary for statically limiting specific resources.

Thanks.

-- 
tejun
