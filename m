From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Tue, 3 Nov 2020 17:57:47 -0500
Message-ID: <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com> <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com> <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p1h/LKIjKhwCaZN5JW6lQr8X/bwNTpcCZCyLALzsZSg=;
        b=tr5vPjWUjAouhWvPxTC7MBVgGO79ny7u55kLEr8RCRj6bxH1t3gSkiC71IMTkzC2Uq
         tewnvHi/iikOF9VEI0TnR6StnqdbjbcTMYc6+bRCLaFZGXkz4lp/gubVHAELLmPwekr7
         BapanDlC20YtC+zgNpcKEiddgqI3Ntl0Ls3ZK5Syh2j22luIaJbsj1n0Uqzu0HPkpUPt
         O0Pb9O+WEsZTY/rpInmKULg+gW42UB3akBmakChPrjkaO2R6R4dUk4LKibSeEkN7M48u
         9pptgIOUotK2/wmU0/izcuCDPjwnCTvHUgEX3lwdm/fQMdUMM4mb3ZNR+cZV0CP1Bxnr
         wD6A==
In-Reply-To: <20201103210418.q7hddyl7rvdplike-+o4/htvd0TCa6kscz5V53/3mLCh9rsb+VpNB7YpNyf8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

On Tue, Nov 3, 2020 at 4:04 PM Alexei Starovoitov
<alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Tue, Nov 03, 2020 at 02:19:22PM -0500, Kenny Ho wrote:
> > On Tue, Nov 3, 2020 at 12:43 AM Alexei Starovoitov
> > <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > On Mon, Nov 2, 2020 at 9:39 PM Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Sounds like either bpf_lsm needs to be made aware of cgv2 (which would
> be a great thing to have regardless) or cgroup-bpf needs a drm/gpu specific hook.
> I think generic ioctl hook is too broad for this use case.
> I suspect drm/gpu internal state would be easier to access inside
> bpf program if the hook is next to gpu/drm. At ioctl level there is 'file'.
> It's probably too abstract for the things you want to do.
> Like how VRAM/shader/etc can be accessed through file?
> Probably possible through a bunch of lookups and dereferences, but
> if the hook is custom to GPU that info is likely readily available.
> Then such cgroup-bpf check would be suitable in execution paths where
> ioctl-based hook would be too slow.
Just to clarify, when you say drm specific hook, did you mean just a
unique attach_type or a unique prog_type+attach_type combination?  (I
am still a bit fuzzy on when a new prog type is needed vs a new attach
type.  I think prog type is associated with a unique type of context
that the bpf prog will get but I could be missing some nuances.)

When I was thinking of doing an ioctl wide hook, the file would be the
device file and the thinking was to have a helper function provided by
device drivers to further disambiguate.  For our (AMD's) driver, we
have a bunch of ioctls for set/get/create/destroy
(https://elixir.bootlin.com/linux/latest/source/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c#L1763)
so the bpf prog can make the decision after the disambiguation.  For
example, we have an ioctl called "kfd_ioctl_set_cu_mask."  You can
think of cu_mask like cpumask but for the cores/compute-unit inside a
GPU.  The ioctl hook will get the file, the bpf prog will call a
helper function from the amdgpu driver to return some data structure
specific to the driver and then the bpf prog can make a decision on
gating the ioctl or not.  From what you are saying, sounds like this
kind of back and forth lookup and dereferencing should be avoided for
performance considerations?

Having a DRM specific hook is certainly an alternative.  I just wasn't
sure which level of trade off on abstraction/generic is acceptable.  I
am guessing a new BPF_PROG_TYPE_CGROUP_AMDGPU is probably too
specific?  But sounds like BPF_PROG_TYPE_CGROUP_DRM may be ok?

Regards,
Kenny
