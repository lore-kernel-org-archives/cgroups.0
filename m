From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Tue, 14 Apr 2020 09:14:27 -0400
Message-ID: <CAOWid-fwEOk+4CvUAumo=byWpq4vVUoCiwW1N6F-0aEd6G7d4A@mail.gmail.com>
References: <20200226190152.16131-1-Kenny.Ho@amd.com>
 <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
 <20200324184633.GH162390@mtj.duckdns.org>
 <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA@mail.gmail.com>
 <20200413191136.GI60335@mtj.duckdns.org>
 <20200414122015.GR3456981@phenom.ffwll.local>
 <CAOWid-f-XWyg0o3znH28xYndZ0OMzWfv3OOuWw08iJDKjrqFGA@mail.gmail.com>
 <CAKMK7uEs5QvUrxKcTFksO30D+x=XJnV+_TA-ebawcihtLqDG0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Ll4eqAKYtjTVgiWa+EM/tj8opR8soYnFbaqkSa8MX0w=;
 b=isQPS0YRieB7ch7fx9vRbFH6vVJ4/QFAfFtOxs7dl7WJwGeHCeTQS+qrGd9s7WRif5
 JqpVOBi2Cqe2E6ez62qE4/a7Sji/QthpWmK44OsPX7WYNXpcdiI2oOhmjb+4yRlXO5QK
 l23pyo3SDKhsQmdSNfmOZFuVUtenQdOdPK50FCKUU5z8N82ZFzdmWe+gVIcmuCw0h3Zn
 ArG3qdgBx2OhGRZcmg9uBy/DC+NSzJXr4coBZOznjpbpcYXf5kvVjA5L6qfe93w03on6
 O8wsBlWmpEmcZMWVG7vUxga9csu/DS5M8ieHTQ+WFXB78toa2EvqDVzMqTE5flLxLus+
 dqaw==
In-Reply-To: <CAKMK7uEs5QvUrxKcTFksO30D+x=XJnV+_TA-ebawcihtLqDG0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, lkaplan-WVYJKLFxKCc@public.gmane.org, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse,
 Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

Ok.  I was hoping you can clarify the contradiction between the
existance of the spec below and your "not something any other gpu can
reasonably support" statement.  I mean, OneAPI is Intel's spec and
doesn't that at least make SubDevice support "reasonable" for one more
vendor?

Partisanship aside, as a drm co-maintainer, do you really not see the
need for non-work-conserving way of distributing GPU as a resource?
You recognized the latencies involved (although that's really just
part of the story... time sharing is never going to be good enough
even if your switching cost is zero.)  As a drm co-maintainer, are you
suggesting GPU has no place in the HPC use case?

Regards,
Kenny

On Tue, Apr 14, 2020 at 8:52 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
>
> On Tue, Apr 14, 2020 at 2:47 PM Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Tue, Apr 14, 2020 at 8:20 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> > > My understanding from talking with a few other folks is that
> > > the cpumask-style CU-weight thing is not something any other gpu can
> > > reasonably support (and we have about 6+ of those in-tree)
> >
> > How does Intel plan to support the SubDevice API as described in your
> > own spec here:
> > https://spec.oneapi.com/versions/0.7/oneL0/core/INTRO.html#subdevice-support
>
> I can't talk about whether future products might or might not support
> stuff and in what form exactly they might support stuff or not support
> stuff. Or why exactly that's even in the spec there or not.
>
> Geez
> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
