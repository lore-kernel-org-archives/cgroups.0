From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 06:35:49 -1000
Message-ID: <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <ZFIVtB8JyKk0ddA5@moria.home.lan>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683131752; x=1685723752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W/389qplif+CNkXxtQ/HgIFDi4dycC02/rtil8xXRXc=;
        b=Z4Cs5R4/s1pDP2FSeVmU9xT76qMP3wouwY1Ps65fLeCYqjQMaYVvejB0JItUP+T4RT
         nWx4lT9WzEfq5aY3guO9R76KVrFDtaYaUEQ25Elo5NPmaZMniCMb9/o9TulI0KS66Wcc
         YYCLdO6ngyzuKE+06qHF3wji8nd2xQW3m1k3e5rdxhRItiF1X5TFu+t0PF7PfWXTDJOq
         vmBjGIGV1qcWBiu9R9ccyJNV/Zfw+WN6u7iyvNY1trl87oBHYSdkRTgtdNd6mx7MobO6
         19aTGTAzKUXos+LOcg5oYQLOH1Cb1ebcesa6IZ5JP32gGVOeFxZhN7B5M0PhCbOvncdK
         9/Vg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ZFIVtB8JyKk0ddA5-jC9Py7bek1znysI04z7BkA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello, Kent.

On Wed, May 03, 2023 at 04:05:08AM -0400, Kent Overstreet wrote:
> No, we're still waiting on the tracing people to _demonstrate_, not
> claim, that this is at all possible in a comparable way with tracing. 

So, we (meta) happen to do stuff like this all the time in the fleet to hunt
down tricky persistent problems like memory leaks, ref leaks, what-have-you.
In recent kernels, with kprobe and BPF, our ability to debug these sorts of
problems has improved a great deal. Below, I'm attaching a bcc script I used
to hunt down, IIRC, a double vfree. It's not exactly for a leak but leaks
can follow the same pattern.

There are of course some pros and cons to this approach:

Pros:

* The framework doesn't really have any runtime overhead, so we can have it
  deployed in the entire fleet and debug wherever problem is.

* It's fully flexible and programmable which enables non-trivial filtering
  and summarizing to be done inside kernel w/ BPF as necessary, which is
  pretty handy for tracking high frequency events.

* BPF is pretty performant. Dedicated built-in kernel code can do better of
  course but BPF's jit compiled code & its data structures are fast enough.
  I don't remember any time this was a problem.

Cons:

* BPF has some learning curve. Also the fact that what it provides is a wide
  open field rather than something scoped out for a specific problem can
  make it seem a bit daunting at the beginning.

* Because tracking starts when the script starts running, it doesn't know
  anything which has happened upto that point, so you gotta pay attention to
  handling e.g. handling frees which don't match allocs. It's kinda annoying
  but not a huge problem usually. There are ways to build in BPF progs into
  the kernel and load it early but I haven't experiemnted with it yet
  personally.

I'm not necessarily against adding dedicated memory debugging mechanism but
do wonder whether the extra benefits would be enough to justify the code and
maintenance overhead.

Oh, a bit of delta but for anyone who's more interested in debugging
problems like this, while I tend to go for bcc
(https://github.com/iovisor/bcc) for this sort of problems. Others prefer to
write against libbpf directly or use bpftrace
(https://github.com/iovisor/bpftrace).

Thanks.

#!/usr/bin/env bcc-py

import bcc
import time
import datetime
import argparse
import os
import sys
import errno

description = """
Record vmalloc/vfrees and trigger on unmatched vfree
"""

bpf_source = """
#include <uapi/linux/ptrace.h>
#include <linux/vmalloc.h>

struct vmalloc_rec {
	unsigned long		ptr;
	int			last_alloc_stkid;
	int			last_free_stkid;
	int			this_stkid;
	bool			allocated;
};

BPF_STACK_TRACE(stacks, 8192);
BPF_HASH(vmallocs, unsigned long, struct vmalloc_rec, 131072);
BPF_ARRAY(dup_free, struct vmalloc_rec, 1);

int kpret_vmalloc_node_range(struct pt_regs *ctx)
{
        unsigned long ptr = PT_REGS_RC(ctx);
	uint32_t zkey = 0;
	struct vmalloc_rec rec_init = { };
	struct vmalloc_rec *rec;
	int stkid;

	if (!ptr)
		return 0;

	stkid = stacks.get_stackid(ctx, 0);

        rec_init.ptr = ptr;
        rec_init.last_alloc_stkid = -1;
        rec_init.last_free_stkid = -1;
        rec_init.this_stkid = -1;

	rec = vmallocs.lookup_or_init(&ptr, &rec_init);
	rec->allocated = true;
	rec->last_alloc_stkid = stkid;
	return 0;
}

int kp_vfree(struct pt_regs *ctx, const void *addr)
{
	unsigned long ptr = (unsigned long)addr;
	uint32_t zkey = 0;
	struct vmalloc_rec rec_init = { };
	struct vmalloc_rec *rec;
	int stkid;

	stkid = stacks.get_stackid(ctx, 0);

        rec_init.ptr = ptr;
        rec_init.last_alloc_stkid = -1;
        rec_init.last_free_stkid = -1;
        rec_init.this_stkid = -1;

	rec = vmallocs.lookup_or_init(&ptr, &rec_init);
	if (!rec->allocated && rec->last_alloc_stkid >= 0) {
		rec->this_stkid = stkid;
		dup_free.update(&zkey, rec);
	}

	rec->allocated = false;
	rec->last_free_stkid = stkid;
        return 0;
}
"""

bpf = bcc.BPF(text=bpf_source)
bpf.attach_kretprobe(event="__vmalloc_node_range", fn_name="kpret_vmalloc_node_range");
bpf.attach_kprobe(event="vfree", fn_name="kp_vfree");
bpf.attach_kprobe(event="vfree_atomic", fn_name="kp_vfree");

stacks = bpf["stacks"]
vmallocs = bpf["vmallocs"]
dup_free = bpf["dup_free"]
last_dup_free_ptr = dup_free[0].ptr

def print_stack(stkid):
    for addr in stacks.walk(stkid):
        sym = bpf.ksym(addr)
        print('  {}'.format(sym))

def print_dup(dup):
    print('allocated={} ptr={}'.format(dup.allocated, hex(dup.ptr)))
    if (dup.last_alloc_stkid >= 0):
        print('last_alloc_stack: ')
        print_stack(dup.last_alloc_stkid)
    if (dup.last_free_stkid >= 0):
        print('last_free_stack: ')
        print_stack(dup.last_free_stkid)
    if (dup.this_stkid >= 0):
        print('this_stack: ')
        print_stack(dup.this_stkid)

while True:
    time.sleep(1)
    
    if dup_free[0].ptr != last_dup_free_ptr:
        print('\nDUP_FREE:')
        print_dup(dup_free[0])
        last_dup_free_ptr = dup_free[0].ptr
