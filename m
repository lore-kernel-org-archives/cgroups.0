From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Tue, 14 Apr 2020 16:04:42 +0200
Message-ID: <CAKMK7uGWxE-gDa25mi4EtLqPKZZfacm0VhTem=StHAQABRAkUQ@mail.gmail.com>
References: <20200226190152.16131-1-Kenny.Ho@amd.com>
 <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
 <20200324184633.GH162390@mtj.duckdns.org>
 <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA@mail.gmail.com>
 <20200413191136.GI60335@mtj.duckdns.org>
 <20200414122015.GR3456981@phenom.ffwll.local>
 <CAOWid-f-XWyg0o3znH28xYndZ0OMzWfv3OOuWw08iJDKjrqFGA@mail.gmail.com>
 <CAKMK7uEs5QvUrxKcTFksO30D+x=XJnV+_TA-ebawcihtLqDG0Q@mail.gmail.com>
 <CAOWid-fwEOk+4CvUAumo=byWpq4vVUoCiwW1N6F-0aEd6G7d4A@mail.gmail.com>
 <CAKMK7uHwX9NbGb1ptnP=CAwxDayfM_z9kvFMMb=YiH+ynjNqKQ@mail.gmail.com>
 <CAOWid-dJckd8kV57MKNA_W83SN4OHnOGPURL7oOm-SqoYRLX=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ffwll.ch; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=nG6rwLK05kgRqo36TW1Ru/yJmMM+eopNPi+TYtRWoUQ=;
 b=IQHGr79VPAVZ3AG9pbatKRCu/JuwE6BOlClabNesPOjPXZjQeyFW8WwYPnENdBrMx2
 7ymDHmJEmAtFjJuV/PMrgxlRpH3vNtzPJ5DGJfaW4JEOktgCM93Tro6CdQyQf4d92qJj
 oVgOPrPzFKownLyYIsJ/73SQsxBgEGf5yE3VE=
In-Reply-To: <CAOWid-dJckd8kV57MKNA_W83SN4OHnOGPURL7oOm-SqoYRLX=w@mail.gmail.com>
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
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, lkaplan-WVYJKLFxKCc@public.gmane.org, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse,
 Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

On Tue, Apr 14, 2020 at 3:50 PM Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Hi Daniel,
>
> I appreciate many of your review so far and I much prefer keeping
> things technical but that is very difficult to do when I get Intel
> developers calling my implementation "most AMD-specific solution
> possible" and objecting to an implementation because their hardware
> cannot support it.  Can you help me with a more charitable
> interpretation of what has been happening?

This is upstream. It's your job to show that this can be done,
reasonable, on other devices. This doesn't need to be an intel device,
you can pretty much pick any other driver stack and show that
sufficiently many of them can support what you want to do. But as long
as all I can see is something that only works on AMD, it's not useful
as an upstreamable resource management thing.

This has _nothing_ to do with Intel (I think over the past 25 years or
so intel has implemented all 4 versions of gpu splitting that I
listed, but not entirely sure).

So again pls less tribal fighting, more collaboration. If you can't do
that, let's pick nouveau/nvidia as arbitrary neutral ground.

> Perhaps the following questions can help keep the discussion technical:
> 1)  Is it possible to implement non-work-conserving distribution of
> GPU without spatial sharing?  (If yes, I'd love to hear a suggestion,
> if not...question 2.)
> 2)  If spatial sharing is required to support GPU HPC use cases, what
> would you implement if you have the hardware support today?

The thing we can currently do in upstream (from how I'm understanding
hw) is assign entire PCI devices to containers, so essentially only
the entire /dev/dri/* cdev. That works, and it works across all
drivers we have in upstream right now.

Anything more fine-grained I don't think is currently possible,
because everyone has a different idea of how to split up gpus. It
would be nice to have it, but in upstream, cross-vendor, I'm just not
seeing it happen right now.
-Daniel

>
> Regards,
> Kenny
>
> On Tue, Apr 14, 2020 at 9:26 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> >
> > On Tue, Apr 14, 2020 at 3:14 PM Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > Ok.  I was hoping you can clarify the contradiction between the
> > > existance of the spec below and your "not something any other gpu can
> > > reasonably support" statement.  I mean, OneAPI is Intel's spec and
> > > doesn't that at least make SubDevice support "reasonable" for one more
> > > vendor?
> > >
> > > Partisanship aside, as a drm co-maintainer, do you really not see the
> > > need for non-work-conserving way of distributing GPU as a resource?
> > > You recognized the latencies involved (although that's really just
> > > part of the story... time sharing is never going to be good enough
> > > even if your switching cost is zero.)  As a drm co-maintainer, are you
> > > suggesting GPU has no place in the HPC use case?
> >
> >  So I did chat with people and my understanding for how this subdevice
> > stuff works is roughly, from least to most fine grained support:
> > - Not possible at all, hw doesn't have any such support
> > - The hw is actually not a single gpu, but a bunch of chips behind a
> > magic bridge/interconnect, and there's a scheduler load-balancing
> > stuff and you can't actually run on all "cores" in parallel with one
> > compute/3d job. So subdevices just give you some of these cores, but
> > from client api pov they're exactly as powerful as the full device. So
> > this kinda works like assigning an entire NUMA node, including all the
> > cpu cores and memory bandwidth and everything.
> > - Hw has multiple "engines" which share resources (like compute cores
> > or whatever) behind the scenes. There's no control over how this
> > sharing works really, and whether you have guarantees about minimal
> > execution resources or not. This kinda works like hyperthreading.
> > - Then finally we have the CU mask thing amdgpu has. Which works like
> > what you're proposing, works on amd.
> >
> > So this isn't something that I think we should standardize in a
> > resource management framework like cgroups. Because it's a complete
> > mess. Note that _all_ the above things (including the "no subdevices"
> > one) are valid implementations of "subdevices" in the various specs.
> >
> > Now on your question on "why was this added to various standards?"
> > because opencl has that too (and the rocm thing, and everything else
> > it seems). What I heard is that a few people pushed really hard, and
> > no one objected hard enough (because not having subdevices is a
> > standards compliant implementation), so that's why it happened. Just
> > because it's in various standards doesn't mean that a) it's actually
> > standardized in a useful fashion and b) something we should just
> > blindly adopt.
> >
> > Also like where exactly did you understand that I'm against gpus in
> > HPC uses cases. Approaching this in a slightly less tribal way would
> > really, really help to get something landed (which I'd like to see
> > happen, personally). Always spinning this as an Intel vs AMD thing
> > like you do here with every reply really doesn't help moving this in.
> >
> > So yeah stricter isolation is something customers want, it's just not
> > something we can really give out right now at a level below the
> > device.
> > -Daniel
> >
> > >
> > > Regards,
> > > Kenny
> > >
> > > On Tue, Apr 14, 2020 at 8:52 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> > > >
> > > > On Tue, Apr 14, 2020 at 2:47 PM Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > > > On Tue, Apr 14, 2020 at 8:20 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> > > > > > My understanding from talking with a few other folks is that
> > > > > > the cpumask-style CU-weight thing is not something any other gpu can
> > > > > > reasonably support (and we have about 6+ of those in-tree)
> > > > >
> > > > > How does Intel plan to support the SubDevice API as described in your
> > > > > own spec here:
> > > > > https://spec.oneapi.com/versions/0.7/oneL0/core/INTRO.html#subdevice-support
> > > >
> > > > I can't talk about whether future products might or might not support
> > > > stuff and in what form exactly they might support stuff or not support
> > > > stuff. Or why exactly that's even in the spec there or not.
> > > >
> > > > Geez
> > > > -Daniel
> > > > --
> > > > Daniel Vetter
> > > > Software Engineer, Intel Corporation
> > > > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> >
> >
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > +41 (0) 79 365 57 48 - http://blog.ffwll.ch



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
