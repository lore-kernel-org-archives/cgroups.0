From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Tue, 3 Nov 2020 13:04:18 -0800
Message-ID: <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com>
 <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wrUBzqixMNGges3Fm8LEqTkGr+7Sx/OVd1FP+l0kdS0=;
 b=tqKpwE9c1XvzM26lsALNljg7czgItn9B2SFh1tA3jWE/ITdxfbUKdt+lGHvc4AqZJG
 DZ38w2G0ZCOMhepTm9Eowqe4LBfWPO8ILx0Ol+dgIFIwxdAiNzD1wA/i8yt6fsVNOptw
 SaiYvqBnxP3BX8+Vb8wu9Rwugz6FWLSJfUcENjTtu4V78jIYi59xfrDLTeLYUuG5oxAl
 NTgLN9RaB/G1pfPbVdSsuGof6GiB/WaIyBDaEjrF7Ha1Z98pSiyS5oXgB6h/IXv9HV1w
 sOAJhdJr5OPTpCg0tsq/C68T5BgQKFWAUoPDQTzUaXS7gzIxvEKvR4YiROniyFWZyWC3
 0Sag==
Content-Disposition: inline
In-Reply-To: <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>

On Tue, Nov 03, 2020 at 02:19:22PM -0500, Kenny Ho wrote:
> On Tue, Nov 3, 2020 at 12:43 AM Alexei Starovoitov
> <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Mon, Nov 2, 2020 at 9:39 PM Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > pls don't top post.
> My apology.
> 
> > > Cgroup awareness is desired because the intent
> > > is to use this for resource management as well (potentially along with
> > > other cgroup controlled resources.)  I will dig into bpf_lsm and learn
> > > more about it.
> >
> > Also consider that bpf_lsm hooks have a way to get cgroup-id without
> > being explicitly scoped. So the bpf program can be made cgroup aware.
> > It's just not as convenient as attaching a prog to cgroup+hook at once.
> > For prototyping the existing bpf_lsm facility should be enough.
> > So please try to follow this route and please share more details about
> > the use case.
> 
> Ok.  I will take a look and see if that is sufficient.  My
> understanding of bpf-cgroup is that it not only makes attaching prog
> to cgroup easier but it also facilitates hierarchical calling of
> attached progs which might be useful if users wants to manage gpu
> resources with bpf cgroup along with other cgroup resources (like
> cpu/mem/io, etc.)

Right. Hierarchical cgroup-bpf logic cannot be replicated inside
the program. If you're relying on cgv2 hierarchy to containerize
applications then what I suggested earlier won't work indeed.

> About the use case.  The high level motivation here is to provide the
> ability to subdivide/share a GPU via cgroups/containers in a way that
> is similar to other resources like CPU and memory.  Users have been
> requesting this type of functionality because GPU compute can get
> expensive and they want to maximize the utilization to get the most
> bang for their bucks.  A traditional way to do this is via
> SRIOV/virtualization but that often means time sharing the GPU as a
> whole unit.  That is useful for some applications but not others due
> to the flushing and added latency.  We also have a study that
> identified various GPU compute application types.  These types can
> benefit from more asymmetrical/granular sharing of the GPU (for
> example some applications are compute bound while others can be memory
> bound that can benefit from having more VRAM.)
> 
> I have been trying to add a cgroup subsystem for the drm subsystem for
> this purpose but I ran into two challenges.  First, the composition of
> a GPU and how some of the subcomponents (like VRAM or shader
> engines/compute units) can be shared are very much vendor specific so
> we are unable to arrive at a common interface across all vendors.
> Because of this and the variety of places a GPU can go into
> (smartphone, PC, server, HPC), there is also no agreement on how
> exactly a GPU should be shared.  The best way forward appears to
> simply provide hooks for users to define how and what they want to
> share via a bpf program.

Thank you for sharing the details. It certainly helps.

> From what I can tell so far (I am still learning), there are multiple
> pieces that need to fall in place for bpf-cgroup to work for this use
> case.  First there is resource limit enforcement, which is the
> motivation for this RFC (I will look into bpf_lsm as the path
> forward.)  I have also been thinking about instrumenting the drm
> subsystem with a new BPF program type and have various attach types
> across the drm subsystem but I am not sure if this is allowed (this
> one is more for resource usage monitoring.)  Another thing I have been
> considering is to have the gpu driver provide bpf helper functions for
> bpf programs to modify drm driver internals.  That was the reason I
> asked about the potential of BTF support for kernel modules a couple
> of months ago (and Andrii Nakryiko mentioned that it is being worked
> on.)

Sounds like either bpf_lsm needs to be made aware of cgv2 (which would
be a great thing to have regardless) or cgroup-bpf needs a drm/gpu specific hook.
I think generic ioctl hook is too broad for this use case.
I suspect drm/gpu internal state would be easier to access inside
bpf program if the hook is next to gpu/drm. At ioctl level there is 'file'.
It's probably too abstract for the things you want to do.
Like how VRAM/shader/etc can be accessed through file?
Probably possible through a bunch of lookups and dereferences, but
if the hook is custom to GPU that info is likely readily available.
Then such cgroup-bpf check would be suitable in execution paths where
ioctl-based hook would be too slow.
