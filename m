From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Mon, 13 Apr 2020 16:17:14 -0400
Message-ID: <CAOWid-dM=38faGOF9=-Pq=sxssaL+gm2umctyGVQWVx2etShyQ@mail.gmail.com>
References: <20200226190152.16131-1-Kenny.Ho@amd.com>
 <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
 <20200324184633.GH162390@mtj.duckdns.org>
 <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA@mail.gmail.com>
 <20200413191136.GI60335@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=dD5YUEDwlW8icDI+F/y9bZzsHxv/M2KUcD6dDQ+9NEo=;
 b=aNP6WsOcy9oz2oIOPIazkJvo8godHmXtmr1TwE8JPmYx+cwAVWXPfV6tSX5Lgfey/B
 3dXc7YsM8r6adTCmRF/bA55Ip/VGpC/QouxCgsQDUpe81/U9Fg7B4wijrK6SEei3kqkC
 ckFdpb5ffuQhmtYRxoPwQSvKez4TVEY/lFeJKCGRQKZmdMr2cji+OnaFGXEd0FDSvNJn
 ah9styOQohwsf/lT2taKcFugIxEvavHdQFOqN5eEXFGvhCRerpBZtJMXtQ8WAqk+o+8W
 kfwKC0+fOvq4LnzI7HYDNDHI9Ae9Lj/D123X3Ussr43iDtHsF6WcqZhku2VK0AvP2KfL
 8raQ==
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
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, lkaplan-WVYJKLFxKCc@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse,
 Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

(replying again in plain-text)

Hi Tejun,

Thanks for taking the time to reply.

Perhaps we can even narrow things down to just
gpu.weight/gpu.compute.weight as a start?  In this aspect, is the key
objection to the current implementation of gpu.compute.weight the
work-conserving bit?  This work-conserving requirement is probably
what I have missed for the last two years (and hence going in circle.)

If this is the case, can you clarify/confirm the followings?

1) Is resource scheduling goal of cgroup purely for the purpose of
throughput?  (at the expense of other scheduling goals such as
latency.)
2) If 1) is true, under what circumstances will the "Allocations"
resource distribution model (as defined in the cgroup-v2) be
acceptable?
3) If 1) is true, are things like cpuset from cgroup v1 no longer
acceptable going forward?

To be clear, while some have framed this (time sharing vs spatial
sharing) as a partisan issue, it is in fact a technical one.  I have
implemented the gpu cgroup support this way because we have a class of
users that value low latency/low jitter/predictability/synchronicity.
For example, they would like 4 tasks to share a GPU and they would
like the tasks to start and finish at the same time.

What is the rationale behind picking the Weight model over Allocations
as the first acceptable implementation?  Can't we have both
work-conserving and non-work-conserving ways of distributing GPU
resources?  If we can, why not allow non-work-conserving
implementation first, especially when we have users asking for such
functionality?

Regards,
Kenny

On Mon, Apr 13, 2020 at 3:11 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
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
>
> Thanks.
>
> --
> tejun
