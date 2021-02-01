From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Mon, 1 Feb 2021 15:49:25 +0100
Message-ID: <YBgU9Vu0BGV8kCxD@phenom.ffwll.local>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com>
 <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
 <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
 <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ffwll.ch; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=EGmzCB5chSwq9pe2qQDXhGstL/uSMglbti4AeZbvc9M=;
 b=T0u0mZ+Z3spqI5csq8199vdWw2F0HEI5De5S85KRWxCdxr+4jQR5HF/ESPI+khBobI
 0kID6zY387C7nAXsNhluEAdeknIbOqrsZ2D0JaogcRsYEATDQywghJ/9qSSQ5q5A55FI
 yWsOBfzIjs33oPqk4PuKrYwi8nfXeV5MoJxBo=
Content-Disposition: inline
In-Reply-To: <20201103232805.6uq4zg3gdvw2iiki-+o4/htvd0TCa6kscz5V53/3mLCh9rsb+VpNB7YpNyf8@public.gmane.org>
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
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, DRI Development <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>

Adding gpu folks.

On Tue, Nov 03, 2020 at 03:28:05PM -0800, Alexei Starovoitov wrote:
> On Tue, Nov 03, 2020 at 05:57:47PM -0500, Kenny Ho wrote:
> > On Tue, Nov 3, 2020 at 4:04 PM Alexei Starovoitov
> > <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > On Tue, Nov 03, 2020 at 02:19:22PM -0500, Kenny Ho wrote:
> > > > On Tue, Nov 3, 2020 at 12:43 AM Alexei Starovoitov
> > > > <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > > > On Mon, Nov 2, 2020 at 9:39 PM Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > Sounds like either bpf_lsm needs to be made aware of cgv2 (which would
> > > be a great thing to have regardless) or cgroup-bpf needs a drm/gpu specific hook.
> > > I think generic ioctl hook is too broad for this use case.
> > > I suspect drm/gpu internal state would be easier to access inside
> > > bpf program if the hook is next to gpu/drm. At ioctl level there is 'file'.
> > > It's probably too abstract for the things you want to do.
> > > Like how VRAM/shader/etc can be accessed through file?
> > > Probably possible through a bunch of lookups and dereferences, but
> > > if the hook is custom to GPU that info is likely readily available.
> > > Then such cgroup-bpf check would be suitable in execution paths where
> > > ioctl-based hook would be too slow.
> > Just to clarify, when you say drm specific hook, did you mean just a
> > unique attach_type or a unique prog_type+attach_type combination?  (I
> > am still a bit fuzzy on when a new prog type is needed vs a new attach
> > type.  I think prog type is associated with a unique type of context
> > that the bpf prog will get but I could be missing some nuances.)
> > 
> > When I was thinking of doing an ioctl wide hook, the file would be the
> > device file and the thinking was to have a helper function provided by
> > device drivers to further disambiguate.  For our (AMD's) driver, we
> > have a bunch of ioctls for set/get/create/destroy
> > (https://elixir.bootlin.com/linux/latest/source/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c#L1763)
> > so the bpf prog can make the decision after the disambiguation.  For
> > example, we have an ioctl called "kfd_ioctl_set_cu_mask."  You can
> 
> Thanks for the pointer.
> That's one monster ioctl. So much copy_from_user.
> BPF prog would need to be sleepable to able to examine the args in such depth.
> After quick glance at the code I would put a new hook into
> kfd_ioctl() right before
> retcode = func(filep, process, kdata);
> At this point kdata is already copied from user space 
> and usize, that is cmd specific, is known.
> So bpf prog wouldn't need to copy that data again.
> That will save one copy.
> To drill into details of kfd_ioctl_set_cu_mask() the prog would
> need to be sleepable to do second copy_from_user of cu_mask.
> At least it's not that big.
> Yes, the attachment point will be amd driver specific,
> but the program doesn't need to be.
> It can be generic tracing prog that is agumented to use BTF.
> Something like writeable tracepoint with BTF support would do.
> So on the bpf side there will be minimal amount of changes.
> And in the driver you'll add one or few writeable tracepoints
> and the result of the tracepoint will gate
> retcode = func(filep, process, kdata);
> call in kfd_ioctl().
> The writeable tracepoint would need to be cgroup-bpf based.
> So that's the only tricky part. BPF infra doesn't have
> cgroup+tracepoint scheme. It's probably going to be useful
> in other cases like this. See trace_nbd_send_request.


Yeah I think this proposal doesn't work:

- inspecting ioctl arguments that need copying outside of the
  driver/subsystem doing that copying is fundamentally racy

- there's been a pile of cgroups proposal to manage gpus at the drm
  subsystem level, some by Kenny, and frankly this at least looks a bit
  like a quick hack to sidestep the consensus process for that.

So once we push this into drivers it's not going to be a bpf hook anymore
I think.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
