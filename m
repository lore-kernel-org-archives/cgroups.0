From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/11] drm, cgroup: Introduce lgpu as DRM cgroup resource
Date: Fri, 14 Feb 2020 14:17:54 -0500
Message-ID: <20200214191754.GA218629@mtj.thefacebook.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com>
 <20200214155650.21203-10-Kenny.Ho@amd.com>
 <CAOFGe96N5gG+08rQCRC+diHKDAfxPFYEnVxDS8_udvjcBYgsPg@mail.gmail.com>
 <CAOWid-f62Uv=GZXX2V2BsQGM5A1JJG_qmyrOwd=KwZBx_sr-bg@mail.gmail.com>
 <20200214183401.GY2363188@phenom.ffwll.local>
 <CAOWid-caJHeXUnQv3MOi=9U+vdBLfewN+CrA-7jRrz0VXqatbQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2bDv0jVyoaqUAZCYtXw4PRnG3vvu6ogXS+PiWyXVnGQ=;
        b=ogbXgW9ewuGmJIGKdp7mK1xwjaEV448C9wRMZUb/UpM2qUxfj6kQmQ8YI/6OYFAoQ1
         luR+o1V+KBIaQyMsIVJNs0bEdQ9gHJQmqWJLN2W6XvGxC3T1Z35sfCCMib3C/wFp3sdc
         9Zxk6HrtSWgYljyCwbvwgny/YallHX+aY27ZMvcxno9Ox80WA0Un+eIfVBjDFqHiWKli
         2Jnls9HUxdWYnq57CdVGXws1lZjKaPqhnYv/yqvp3BD/NRNVpfaItfjgME/elE4BRKHx
         WHJWRHi9qIM7yRhB+1p808k+sKqB/KTo7wZR+FVlSs2JDxfOvrErluaL32I9aia9AN3j
         GxRA==
Content-Disposition: inline
In-Reply-To: <CAOWid-caJHeXUnQv3MOi=9U+vdBLfewN+CrA-7jRrz0VXqatbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jason Ekstrand <jason-fQELhIk9awXprZlt/sZkLg@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maling list - DRI developers <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, amd-gfx mailing list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, nirmoy.das-5C7GfCeVMHo@public.gmane.org, damon.mcdougall-5C7GfCeVMHo@public.gmane.org, juan.zuniga-anaya-5C7GfCeVMHo@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Kenny, Daniel.

(cc'ing Johannes)

On Fri, Feb 14, 2020 at 01:51:32PM -0500, Kenny Ho wrote:
> On Fri, Feb 14, 2020 at 1:34 PM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> >
> > I think guidance from Tejun in previos discussions was pretty clear that
> > he expects cgroups to be both a) standardized and c) sufficient clear
> > meaning that end-users have a clear understanding of what happens when
> > they change the resource allocation.
> >
> > I'm not sure lgpu here, at least as specified, passes either.
> 
> I disagree (at least on the characterization of the feedback
> provided.)  I believe this series satisfied the sprite of Tejun's
> guidance so far (the weight knob for lgpu, for example, was
> specifically implemented base on his input.)  But, I will let Tejun
> speak for himself after he considered the implementation in detail.

I have to agree with Daniel here. My apologies if I weren't clear
enough. Here's one interface I can think of:

 * compute weight: The same format as io.weight. Proportional control
   of gpu compute.

 * memory low: Please see how the system memory.low behaves. For gpus,
   it'll need per-device entries.

Note that for both, there one number to configure and conceptually
it's pretty clear to everybody what that number means, which is not to
say that it's clear to implement but it's much better to deal with
that on this side of the interface than the other.

cc'ing Johannes. Do you have anything on mind regarding how gpu memory
configuration should look like? e.g. should it go w/ weights rather
than absoulte units (I don't think so given that it'll most likely
need limits at some point too but still and there are benefits from
staying consistent with system memory).

Also, a rather trivial high level question. Is drm a good controller
name given that other controller names are like cpu, memory, io?

Thanks.

-- 
tejun
