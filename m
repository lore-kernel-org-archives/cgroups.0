From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Fri, 7 May 2021 18:54:13 +0200
Message-ID: <YJVwtS9XJlogZRqv@phenom.ffwll.local>
References: <CAOWid-c4Nk717xUah19B=z=2DtztbtU=_4=fQdfhqpfNJYN2gw@mail.gmail.com>
 <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
 <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com>
 <YJUBer3wWKSAeXe7@phenom.ffwll.local>
 <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
 <YJVnO+TCRW83S6w4@phenom.ffwll.local>
 <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
 <YJVqL4c6SJc8wdkK@phenom.ffwll.local>
 <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
 <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6IcOWYBUOtQoCBL1qPtrhl4ZlflWgXWFQU8YGjyhs7c=;
        b=NIKVq0m6gJjzBck2EAI1PVdmkAbsbaI4znOrznNtz8uXgXDzeBmuBeul21mUa8bFt4
         uNJHE9B3ehF8bZeerXMHwqS6G21foVpmb3IQZtqRXhfYl9UnFQAikv/lXCxl6wTvLKd7
         OmEDxdM0J1Vrfb4t9X/N6LOKM7wokQPZavKlk=
Content-Disposition: inline
In-Reply-To: <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Deucher <alexdeucher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, DRI Development <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, May 07, 2021 at 12:50:07PM -0400, Alex Deucher wrote:
> On Fri, May 7, 2021 at 12:31 PM Alex Deucher <alexdeucher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Fri, May 7, 2021 at 12:26 PM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> > >
> > > On Fri, May 07, 2021 at 12:19:13PM -0400, Alex Deucher wrote:
> > > > On Fri, May 7, 2021 at 12:13 PM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> > > > >
> > > > > On Fri, May 07, 2021 at 11:33:46AM -0400, Kenny Ho wrote:
> > > > > > On Fri, May 7, 2021 at 4:59 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> > > > > > >
> > > > > > > Hm I missed that. I feel like time-sliced-of-a-whole gpu is the easier gpu
> > > > > > > cgroups controler to get started, since it's much closer to other cgroups
> > > > > > > that control bandwidth of some kind. Whether it's i/o bandwidth or compute
> > > > > > > bandwidht is kinda a wash.
> > > > > > sriov/time-sliced-of-a-whole gpu does not really need a cgroup
> > > > > > interface since each slice appears as a stand alone device.  This is
> > > > > > already in production (not using cgroup) with users.  The cgroup
> > > > > > proposal has always been parallel to that in many sense: 1) spatial
> > > > > > partitioning as an independent but equally valid use case as time
> > > > > > sharing, 2) sub-device resource control as opposed to full device
> > > > > > control motivated by the workload characterization paper.  It was
> > > > > > never about time vs space in terms of use cases but having new API for
> > > > > > users to be able to do spatial subdevice partitioning.
> > > > > >
> > > > > > > CU mask feels a lot more like an isolation/guaranteed forward progress
> > > > > > > kind of thing, and I suspect that's always going to be a lot more gpu hw
> > > > > > > specific than anything we can reasonably put into a general cgroups
> > > > > > > controller.
> > > > > > The first half is correct but I disagree with the conclusion.  The
> > > > > > analogy I would use is multi-core CPU.  The capability of individual
> > > > > > CPU cores, core count and core arrangement may be hw specific but
> > > > > > there are general interfaces to support selection of these cores.  CU
> > > > > > mask may be hw specific but spatial partitioning as an idea is not.
> > > > > > Most gpu vendors have the concept of sub-device compute units (EU, SE,
> > > > > > etc.); OpenCL has the concept of subdevice in the language.  I don't
> > > > > > see any obstacle for vendors to implement spatial partitioning just
> > > > > > like many CPU vendors support the idea of multi-core.
> > > > > >
> > > > > > > Also for the time slice cgroups thing, can you pls give me pointers to
> > > > > > > these old patches that had it, and how it's done? I very obviously missed
> > > > > > > that part.
> > > > > > I think you misunderstood what I wrote earlier.  The original proposal
> > > > > > was about spatial partitioning of subdevice resources not time sharing
> > > > > > using cgroup (since time sharing is already supported elsewhere.)
> > > > >
> > > > > Well SRIOV time-sharing is for virtualization. cgroups is for
> > > > > containerization, which is just virtualization but with less overhead and
> > > > > more security bugs.
> > > > >
> > > > > More or less.
> > > > >
> > > > > So either I get things still wrong, or we'll get time-sharing for
> > > > > virtualization, and partitioning of CU for containerization. That doesn't
> > > > > make that much sense to me.
> > > >
> > > > You could still potentially do SR-IOV for containerization.  You'd
> > > > just pass one of the PCI VFs (virtual functions) to the container and
> > > > you'd automatically get the time slice.  I don't see why cgroups would
> > > > be a factor there.
> > >
> > > Standard interface to manage that time-slicing. I guess for SRIOV it's all
> > > vendor sauce (intel as guilty as anyone else from what I can see), but for
> > > cgroups that feels like it's falling a bit short of what we should aim
> > > for.
> > >
> > > But dunno, maybe I'm just dreaming too much :-)
> >
> > I don't disagree, I'm just not sure how it would apply to SR-IOV.
> > Once you've created the virtual functions, you've already created the
> > partitioning (regardless of whether it's spatial or temporal) so where
> > would cgroups come into play?
> 
> For some background, the SR-IOV virtual functions show up like actual
> PCI endpoints on the bus, so SR-IOV is sort of like cgroups
> implemented in hardware.  When you enable SR-IOV, the endpoints that
> are created are the partitions.

Yeah I think we're massively agreeing right now :-)

SRIOV is kinda by design vendor specific. You set up the VF endpoint, it
shows up, it's all hw+fw magic. Nothing for cgroups to manage here at all.

All I meant is that for the container/cgroups world starting out with
time-sharing feels like the best fit, least because your SRIOV designers
also seem to think that's the best first cut for cloud-y computing.
Whether it's virtualized or containerized is a distinction that's getting
ever more blurry, with virtualization become a lot more dynamic and
container runtimes als possibly using hw virtualization underneath.
-Daniel

> 
> Alex
> 
> >
> > Alex
> >
> > > -Daniel
> > >
> > > > Alex
> > > >
> > > > >
> > > > > Since time-sharing is the first thing that's done for virtualization I
> > > > > think it's probably also the most reasonable to start with for containers.
> > > > > -Daniel
> > > > > --
> > > > > Daniel Vetter
> > > > > Software Engineer, Intel Corporation
> > > > > http://blog.ffwll.ch
> > > > > _______________________________________________
> > > > > amd-gfx mailing list
> > > > > amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
> > > > > https://lists.freedesktop.org/mailman/listinfo/amd-gfx
> > >
> > > --
> > > Daniel Vetter
> > > Software Engineer, Intel Corporation
> > > http://blog.ffwll.ch

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
