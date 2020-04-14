From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Tue, 14 Apr 2020 14:20:15 +0200
Message-ID: <20200414122015.GR3456981@phenom.ffwll.local>
References: <20200226190152.16131-1-Kenny.Ho@amd.com>
 <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
 <20200324184633.GH162390@mtj.duckdns.org>
 <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA@mail.gmail.com>
 <20200413191136.GI60335@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ffwll.ch; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=AVWsXI3MqWUjHSFF7fJc9dwzNvhf7xe+RbgEyfrAzNQ=;
 b=C5ErIHkCVZ6bwX/7a4Q98OMFyyzYOVUtlEGm/S86pHsNjUxpLifmMl0gwrR9FVv/eg
 DBy+1TWPtHW1UjmLp8i/0VBZqa61Ni68+/dmh6VPBNHlS0sr9ckMI+AXPa6Orp5wBgNR
 iuLNwnQ+2b6+dhu+W1zMJqdXAMgvSKHGlrWzE=
Content-Disposition: inline
In-Reply-To: <20200413191136.GI60335-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
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
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

On Mon, Apr 13, 2020 at 03:11:36PM -0400, Tejun Heo wrote:
> Hello, Kenny.
> 
> On Tue, Mar 24, 2020 at 02:49:27PM -0400, Kenny Ho wrote:
> > Can you elaborate more on what are the missing pieces?
> 
> Sorry about the long delay, but I think we've been going in circles for quite
> a while now. Let's try to make it really simple as the first step. How about
> something like the following?
> 
> * gpu.weight (should it be gpu.compute.weight? idk) - A single number
>   per-device weight similar to io.weight, which distributes computation
>   resources in work-conserving way.
> 
> * gpu.memory.high - A single number per-device on-device memory limit.
> 
> The above two, if works well, should already be plenty useful. And my guess is
> that getting the above working well will be plenty challenging already even
> though it's already excluding work-conserving memory distribution. So, let's
> please do that as the first step and see what more would be needed from there.

This agrees with my understanding of the consensus here and what's
reasonable possible across different gpus. And in case this isn't clear:
This is very much me talking with my drm co-maintainer hat on, not with a
gpu vendor hat on (since that's implied somewhere further down the
discussion). My understanding from talking with a few other folks is that
the cpumask-style CU-weight thing is not something any other gpu can
reasonably support (and we have about 6+ of those in-tree), whereas some
work-preserving computation resource thing should be doable for anyone
with a scheduler. +/- more or less the same issues as io devices, there
might be quite bit latencies involved from going from one client to the
other because gpu pipelines are deed and pre-emption for gpus rather slow.
And ofc not all gpu "requests" use equal amounts of resources (different
engines and stuff just to begin with), same way not all io requests are
made equal. Plus since we do have a shared scheduler used by at least most
drivers, this shouldn't be too hard to get done somewhat consistently
across drivers

tldr; Acked by me.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
