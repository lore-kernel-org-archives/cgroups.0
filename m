From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 10:42:11 -0700
Message-ID: <CAJuCfpEFV7ZB4pvnf6n0bVpTCDWCVQup9PtrHuAayrf3GrQskg@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan> <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <ZFIVtB8JyKk0ddA5@moria.home.lan> <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683135744; x=1685727744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CyWASKhXrRNVBOOq8h+mxQvWE1hyBqHS7EnIBAfoYzo=;
        b=lILby+6OTcd6uGew9Gqa7pI7NZDERobvBEoUxW0HhFyA1BRI3IbjTEpaxJY5cI5dqK
         DA1zSIWnr7NZMDeUF05eCVuGGh2CT9vrOAzryneu8JduHDYkP6FYutQNmyLESxSwuuGA
         QuyLAcoDwkidYgw1urIbr/7WmePlI+jjpkr/y8SQuG47YOMKyQjyUqQZLY1V6cSIQnsN
         gF8ibE844UGbtwqhvwKyiswwRZ5DNj7ChXG/ByW2u3EBE9OETY+04pa10/S8xbX8Bwfw
         LuAtgmQvuglHVzqT12ntCD4oe90ZORyd/+eYUAlMEp51urNfjxmt4VM8J4BfTDsPwJJU
         u65A==
In-Reply-To: <ZFKNZZwC8EUbOLMv-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Wed, May 3, 2023 at 9:35=E2=80=AFAM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello, Kent.
>
> On Wed, May 03, 2023 at 04:05:08AM -0400, Kent Overstreet wrote:
> > No, we're still waiting on the tracing people to _demonstrate_, not
> > claim, that this is at all possible in a comparable way with tracing.
>
> So, we (meta) happen to do stuff like this all the time in the fleet to h=
unt
> down tricky persistent problems like memory leaks, ref leaks, what-have-y=
ou.
> In recent kernels, with kprobe and BPF, our ability to debug these sorts =
of
> problems has improved a great deal. Below, I'm attaching a bcc script I u=
sed
> to hunt down, IIRC, a double vfree. It's not exactly for a leak but leaks
> can follow the same pattern.

Thanks for sharing, Tejun!

>
> There are of course some pros and cons to this approach:
>
> Pros:
>
> * The framework doesn't really have any runtime overhead, so we can have =
it
>   deployed in the entire fleet and debug wherever problem is.

Do you mean it has no runtime overhead when disabled?
If so, do you know what's the overhead when enabled? I want to
understand if that's truly a viable solution to track all allocations
(including slab) all the time.
Thanks,
Suren.

>
> * It's fully flexible and programmable which enables non-trivial filterin=
g
>   and summarizing to be done inside kernel w/ BPF as necessary, which is
>   pretty handy for tracking high frequency events.
>
> * BPF is pretty performant. Dedicated built-in kernel code can do better =
of
>   course but BPF's jit compiled code & its data structures are fast enoug=
h.
>   I don't remember any time this was a problem.
>
> Cons:
>
> * BPF has some learning curve. Also the fact that what it provides is a w=
ide
>   open field rather than something scoped out for a specific problem can
>   make it seem a bit daunting at the beginning.
>
> * Because tracking starts when the script starts running, it doesn't know
>   anything which has happened upto that point, so you gotta pay attention=
 to
>   handling e.g. handling frees which don't match allocs. It's kinda annoy=
ing
>   but not a huge problem usually. There are ways to build in BPF progs in=
to
>   the kernel and load it early but I haven't experiemnted with it yet
>   personally.
>
> I'm not necessarily against adding dedicated memory debugging mechanism b=
ut
> do wonder whether the extra benefits would be enough to justify the code =
and
> maintenance overhead.
>
> Oh, a bit of delta but for anyone who's more interested in debugging
> problems like this, while I tend to go for bcc
> (https://github.com/iovisor/bcc) for this sort of problems. Others prefer=
 to
> write against libbpf directly or use bpftrace
> (https://github.com/iovisor/bpftrace).
>
> Thanks.
>
> #!/usr/bin/env bcc-py
>
> import bcc
> import time
> import datetime
> import argparse
> import os
> import sys
> import errno
>
> description =3D """
> Record vmalloc/vfrees and trigger on unmatched vfree
> """
>
> bpf_source =3D """
> #include <uapi/linux/ptrace.h>
> #include <linux/vmalloc.h>
>
> struct vmalloc_rec {
>         unsigned long           ptr;
>         int                     last_alloc_stkid;
>         int                     last_free_stkid;
>         int                     this_stkid;
>         bool                    allocated;
> };
>
> BPF_STACK_TRACE(stacks, 8192);
> BPF_HASH(vmallocs, unsigned long, struct vmalloc_rec, 131072);
> BPF_ARRAY(dup_free, struct vmalloc_rec, 1);
>
> int kpret_vmalloc_node_range(struct pt_regs *ctx)
> {
>         unsigned long ptr =3D PT_REGS_RC(ctx);
>         uint32_t zkey =3D 0;
>         struct vmalloc_rec rec_init =3D { };
>         struct vmalloc_rec *rec;
>         int stkid;
>
>         if (!ptr)
>                 return 0;
>
>         stkid =3D stacks.get_stackid(ctx, 0);
>
>         rec_init.ptr =3D ptr;
>         rec_init.last_alloc_stkid =3D -1;
>         rec_init.last_free_stkid =3D -1;
>         rec_init.this_stkid =3D -1;
>
>         rec =3D vmallocs.lookup_or_init(&ptr, &rec_init);
>         rec->allocated =3D true;
>         rec->last_alloc_stkid =3D stkid;
>         return 0;
> }
>
> int kp_vfree(struct pt_regs *ctx, const void *addr)
> {
>         unsigned long ptr =3D (unsigned long)addr;
>         uint32_t zkey =3D 0;
>         struct vmalloc_rec rec_init =3D { };
>         struct vmalloc_rec *rec;
>         int stkid;
>
>         stkid =3D stacks.get_stackid(ctx, 0);
>
>         rec_init.ptr =3D ptr;
>         rec_init.last_alloc_stkid =3D -1;
>         rec_init.last_free_stkid =3D -1;
>         rec_init.this_stkid =3D -1;
>
>         rec =3D vmallocs.lookup_or_init(&ptr, &rec_init);
>         if (!rec->allocated && rec->last_alloc_stkid >=3D 0) {
>                 rec->this_stkid =3D stkid;
>                 dup_free.update(&zkey, rec);
>         }
>
>         rec->allocated =3D false;
>         rec->last_free_stkid =3D stkid;
>         return 0;
> }
> """
>
> bpf =3D bcc.BPF(text=3Dbpf_source)
> bpf.attach_kretprobe(event=3D"__vmalloc_node_range", fn_name=3D"kpret_vma=
lloc_node_range");
> bpf.attach_kprobe(event=3D"vfree", fn_name=3D"kp_vfree");
> bpf.attach_kprobe(event=3D"vfree_atomic", fn_name=3D"kp_vfree");
>
> stacks =3D bpf["stacks"]
> vmallocs =3D bpf["vmallocs"]
> dup_free =3D bpf["dup_free"]
> last_dup_free_ptr =3D dup_free[0].ptr
>
> def print_stack(stkid):
>     for addr in stacks.walk(stkid):
>         sym =3D bpf.ksym(addr)
>         print('  {}'.format(sym))
>
> def print_dup(dup):
>     print('allocated=3D{} ptr=3D{}'.format(dup.allocated, hex(dup.ptr)))
>     if (dup.last_alloc_stkid >=3D 0):
>         print('last_alloc_stack: ')
>         print_stack(dup.last_alloc_stkid)
>     if (dup.last_free_stkid >=3D 0):
>         print('last_free_stack: ')
>         print_stack(dup.last_free_stkid)
>     if (dup.this_stkid >=3D 0):
>         print('this_stack: ')
>         print_stack(dup.this_stkid)
>
> while True:
>     time.sleep(1)
>
>     if dup_free[0].ptr !=3D last_dup_free_ptr:
>         print('\nDUP_FREE:')
>         print_dup(dup_free[0])
>         last_dup_free_ptr =3D dup_free[0].ptr
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kernel-team+unsubscribe-z5hGa2qSFaTowKkBSvOlow@public.gmane.org
>
