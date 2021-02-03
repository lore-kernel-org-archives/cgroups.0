From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Wed, 3 Feb 2021 12:09:32 +0100
Message-ID: <YBqEbHyIjUjgk+es@phenom.ffwll.local>
References: <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
 <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
 <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
 <YBgU9Vu0BGV8kCxD@phenom.ffwll.local>
 <CAOWid-eXMqcNpjFxbcuUDU7Y-CCYJRNT_9mzqFYm1jeCPdADGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ffwll.ch; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=10v1VhHSAkUfosKyz8E/GXqf1Nzg9103R9baLtggV6c=;
 b=AwADaWJ4LwJCoyZjbksaAIXa2APpKqAzdcH9SXnJSG7fszSPLuUH+3Bwq8LRRDPDdi
 NoWIXSFbFk7LIjysbkr0z+9qT5D6IV+LPHIDP1dNAXkIXUoE8fy0uJRszcDfXUx0bqw7
 A7GDs34BM4mVn+70Za7HOYwh3WFfPNv53flts=
Content-Disposition: inline
In-Reply-To: <CAOWid-eXMqcNpjFxbcuUDU7Y-CCYJRNT_9mzqFYm1jeCPdADGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, DRI Development <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>

On Mon, Feb 01, 2021 at 11:51:07AM -0500, Kenny Ho wrote:
> [Resent in plain text.]
> 
> On Mon, Feb 1, 2021 at 9:49 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> > - there's been a pile of cgroups proposal to manage gpus at the drm
> >   subsystem level, some by Kenny, and frankly this at least looks a bit
> >   like a quick hack to sidestep the consensus process for that.
> No Daniel, this is quick *draft* to get a conversation going.  Bpf was
> actually a path suggested by Tejun back in 2018 so I think you are
> mischaracterizing this quite a bit.
> 
> "2018-11-20 Kenny Ho:
> To put the questions in more concrete terms, let say a user wants to
>  expose certain part of a gpu to a particular cgroup similar to the
>  way selective cpu cores are exposed to a cgroup via cpuset, how
>  should we go about enabling such functionality?
> 
> 2018-11-20 Tejun Heo:
> Do what the intel driver or bpf is doing?  It's not difficult to hook
> into cgroup for identification purposes."

Yeah, but if you go full amd specific for this, you might as well have a
specific BPF hook which is called in amdgpu/kfd and returns you the CU
mask for a given cgroups (and figures that out however it pleases).

Not a generic framework which lets you build pretty much any possible
cgroups controller for anything else using BPF. Trying to filter anything
at the generic ioctl just doesn't feel like a great idea that's long term
maintainable. E.g. what happens if there's new uapi for command
submission/context creation and now your bpf filter isn't catching all
access anymore? If it's an explicit hook that explicitly computes the CU
mask, then we can add more checks as needed. With ioctl that's impossible.

Plus I'm also not sure whether that's really a good idea still, since if
cloud companies have to built their own bespoke container stuff for every
gpu vendor, that's quite a bad platform we're building. And "I'd like to
make sure my gpu is used fairly among multiple tenents" really isn't a
use-case that's specific to amd.

If this would be something very hw specific like cache assignment and
quality of service stuff or things like that, then vendor specific imo
makes sense. But for CU masks essentially we're cutting the compute
resources up in some way, and I kinda expect everyone with a gpu who cares
about isolating workloads with cgroups wants to do that.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
