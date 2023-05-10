From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Add support for DRM cgroup memory accounting.
Date: Wed, 10 May 2023 08:46:00 -1000
Message-ID: <ZFvmaGNo0buQEUi1@slm.duckdns.org>
References: <20230503083500.645848-1-maarten.lankhorst@linux.intel.com>
 <ZFVeI2DKQXddKDNl@slm.duckdns.org>
 <4d6fbce3-a676-f648-7a09-6f6dcc4bdb46@linux.intel.com>
Mime-Version: 1.0
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1683744362; x=1686336362;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
 :reply-to; bh=5fuvzbzfAPaWz0F0qnb+ng0M3t+DRDPEy+SEvx5Zlpw=;
 b=WaX/lA3Y5RC6vqi8Gstz4xLqZDGmFXeG7a3rgiWsDu5hUwAToAZzkqoYMo1FT7KjnA
 ARUu3pTtOMc7WAoU2YOH9cnEDLX7dlPp5Fk+vl639nloA3cqkDUb96asyf9ZQw15ihXz
 nIf9q2YeVZUyrcSMtyeAkgoRbV+oLyls91sRKUg2xusZZZ3Ihxuq/x0/E/g2898K6qQY
 NY2fYU0eav3eoftoQ/+ak267O1ldNVnrMhtexIpFA1GoP5llXOIGlF9JxtpQi2ToH3Sb
 zXx6m0I8PgYy7bI06tjMymfporVo62Z/NoPWgDzh1wszI52lSrupgJLtKhGceUulCGBv
 Mj0g==
Content-Disposition: inline
In-Reply-To: <4d6fbce3-a676-f648-7a09-6f6dcc4bdb46-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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
Content-Transfer-Encoding: 7bit
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, intel-xe-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org

Hello,

On Wed, May 10, 2023 at 04:59:01PM +0200, Maarten Lankhorst wrote:
> The misc controller is not granular enough. A single computer may have any number of
> graphics cards, some of them with multiple regions of vram inside a single card.

Extending the misc controller to support dynamic keys shouldn't be that
difficult.

...
> In the next version, I will move all the code for handling the resource limit to
> TTM's eviction layer, because otherwise it cannot handle the resource limit correctly.
> 
> The effect of moving the code to TTM, is that it will make the code even more generic
> for drivers that have vram and use TTM. When using TTM, you only have to describe your
> VRAM, update some fields in the TTM manager and (un)register your device with the
> cgroup handler on (un)load. It's quite trivial to add vram accounting to amdgpu and
> nouveau. [2]
> 
> If you want to add a knob for scheduling weight for a process, it makes sense to
> also add resource usage as a knob, otherwise the effect of that knob is very
> limited. So even for Tvrtko's original proposed usecase, it would make sense.

It does make sense but unlike Tvrtko's scheduling weights what's being
proposed doesn't seem to encapsulate GPU memory resource in a generic enough
manner at least to my untrained eyes. ie. w/ drm.weight, I don't need any
specific knoweldge of how a specific GPU operates to say "this guy should
get 2x processing power over that guy". This more or less holds for other
major resources including CPU, memory and IO. What you're proposing seems a
lot more tied to hardware details and users would have to know a lot more
about how memory is configured on that particular GPU.

Now, if this is inherent to how all, or at least most, GPUs operate, sure,
but otherwise let's start small in terms of interface and not take up space
which should be for something universal. If this turns out to be the way,
expanding to take up the generic interface space isn't difficult.

I don't know GPU space so please educate me where I'm wrong.

Thanks.

-- 
tejun
