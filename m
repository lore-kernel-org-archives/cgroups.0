From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Fri, 7 May 2021 10:59:38 +0200
Message-ID: <YJUBer3wWKSAeXe7@phenom.ffwll.local>
References: <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
 <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
 <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
 <YBgU9Vu0BGV8kCxD@phenom.ffwll.local>
 <CAOWid-eXMqcNpjFxbcuUDU7Y-CCYJRNT_9mzqFYm1jeCPdADGQ@mail.gmail.com>
 <YBqEbHyIjUjgk+es@phenom.ffwll.local>
 <CAOWid-c4Nk717xUah19B=z=2DtztbtU=_4=fQdfhqpfNJYN2gw@mail.gmail.com>
 <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
 <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/nh1bbQT5CiK8IqERbTeRh4gKwm6+O6Vg+VARq82rio=;
        b=ddP9vw2/xz6l5rgNknMnioGUpBwslhkhK/Vqn+Kl45rxtCUI1B37VPu4ncHEAzfh5G
         lraIDVUeYC1DCwyViD6+lq/nLpHJ7NVA4UnG4dIh03OPLcXFQHOCKIsy6MTCyG7IvMTN
         ggSkExoADblSOWRHwZ8hPSr4yuGq19xGJhDe8=
Content-Disposition: inline
In-Reply-To: <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, DRI Development <dri-devel@l>

On Thu, May 06, 2021 at 10:06:32PM -0400, Kenny Ho wrote:
> Sorry for the late reply (I have been working on other stuff.)
> 
> On Fri, Feb 5, 2021 at 8:49 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> >
> > So I agree that on one side CU mask can be used for low-level quality
> > of service guarantees (like the CLOS cache stuff on intel cpus as an
> > example), and that's going to be rather hw specific no matter what.
> >
> > But my understanding of AMD's plans here is that CU mask is the only
> > thing you'll have to partition gpu usage in a multi-tenant environment
> > - whether that's cloud or also whether that's containing apps to make
> > sure the compositor can still draw the desktop (except for fullscreen
> > ofc) doesn't really matter I think.
> This is not correct.  Even in the original cgroup proposal, it
> supports both mask and count as a way to define unit(s) of sub-device.
> For AMD, we already have SRIOV that supports GPU partitioning in a
> time-sliced-of-a-whole-GPU fashion.

Hm I missed that. I feel like time-sliced-of-a-whole gpu is the easier gpu
cgroups controler to get started, since it's much closer to other cgroups
that control bandwidth of some kind. Whether it's i/o bandwidth or compute
bandwidht is kinda a wash.

CU mask feels a lot more like an isolation/guaranteed forward progress
kind of thing, and I suspect that's always going to be a lot more gpu hw
specific than anything we can reasonably put into a general cgroups
controller.

Also for the time slice cgroups thing, can you pls give me pointers to
these old patches that had it, and how it's done? I very obviously missed
that part.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
