From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Fri, 7 May 2021 11:33:46 -0400
Message-ID: <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
References: <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
 <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
 <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
 <YBgU9Vu0BGV8kCxD@phenom.ffwll.local> <CAOWid-eXMqcNpjFxbcuUDU7Y-CCYJRNT_9mzqFYm1jeCPdADGQ@mail.gmail.com>
 <YBqEbHyIjUjgk+es@phenom.ffwll.local> <CAOWid-c4Nk717xUah19B=z=2DtztbtU=_4=fQdfhqpfNJYN2gw@mail.gmail.com>
 <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
 <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com> <YJUBer3wWKSAeXe7@phenom.ffwll.local>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XItf2h9hovNafxela2Mfpgx6zd0s5dzNeA3YTSrq32g=;
        b=Jx5khNbbvbtn/U6yoK/8cw0ezIGuOk20VXL3g5Xc+1PO4u0/c7u9JdhS4Sh0A/238X
         qJDK3CmCrhsUw3kxgGmtVLKOVBpamJ+mgC++QhBm/huNDdpJjfnji8KQgSRdH6dR/6qw
         gnnCzv+ZkzfWEd8q02n4o5Q1u7vF1VZJ4e7OS4bTosSeDlXkdzxCU2dg/3t0bFiexOvm
         +Fns9n/UTIMVSeDR8FrwK2UMk0Co9GksoDN716frVRknDfq407ihSlg/RkoHgqcpmhWB
         9MxoWewWjLjGhCFj5Iy5vQfpMUzUk5ghM0z3CRFvwHCE5bR6RTjPI1mbzhQOqVqQKwNY
         QLzw==
In-Reply-To: <YJUBer3wWKSAeXe7-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Cc: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, DRI Development <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Brian

On Fri, May 7, 2021 at 4:59 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
>
> Hm I missed that. I feel like time-sliced-of-a-whole gpu is the easier gpu
> cgroups controler to get started, since it's much closer to other cgroups
> that control bandwidth of some kind. Whether it's i/o bandwidth or compute
> bandwidht is kinda a wash.
sriov/time-sliced-of-a-whole gpu does not really need a cgroup
interface since each slice appears as a stand alone device.  This is
already in production (not using cgroup) with users.  The cgroup
proposal has always been parallel to that in many sense: 1) spatial
partitioning as an independent but equally valid use case as time
sharing, 2) sub-device resource control as opposed to full device
control motivated by the workload characterization paper.  It was
never about time vs space in terms of use cases but having new API for
users to be able to do spatial subdevice partitioning.

> CU mask feels a lot more like an isolation/guaranteed forward progress
> kind of thing, and I suspect that's always going to be a lot more gpu hw
> specific than anything we can reasonably put into a general cgroups
> controller.
The first half is correct but I disagree with the conclusion.  The
analogy I would use is multi-core CPU.  The capability of individual
CPU cores, core count and core arrangement may be hw specific but
there are general interfaces to support selection of these cores.  CU
mask may be hw specific but spatial partitioning as an idea is not.
Most gpu vendors have the concept of sub-device compute units (EU, SE,
etc.); OpenCL has the concept of subdevice in the language.  I don't
see any obstacle for vendors to implement spatial partitioning just
like many CPU vendors support the idea of multi-core.

> Also for the time slice cgroups thing, can you pls give me pointers to
> these old patches that had it, and how it's done? I very obviously missed
> that part.
I think you misunderstood what I wrote earlier.  The original proposal
was about spatial partitioning of subdevice resources not time sharing
using cgroup (since time sharing is already supported elsewhere.)

Kenny
