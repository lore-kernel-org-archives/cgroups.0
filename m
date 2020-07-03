From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] mm/memcontrol: Fix OOPS inside
 mem_cgroup_get_nr_swap_pages()
Date: Fri, 3 Jul 2020 08:43:18 +0200
Message-ID: <20200703064318.GN18446@dhcp22.suse.cz>
References: <1593641660-13254-1-git-send-email-bhsharma@redhat.com>
 <1593641660-13254-2-git-send-email-bhsharma@redhat.com>
 <20200702060024.GA18446@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200702060024.GA18446-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

[Cc Andrew - the patch is http://lkml.kernel.org/r/1593641660-13254-2-git-send-email-bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]

On Thu 02-07-20 08:00:27, Michal Hocko wrote:
> On Thu 02-07-20 03:44:19, Bhupesh Sharma wrote:
> > Prabhakar reported an OOPS inside mem_cgroup_get_nr_swap_pages()
> > function in a corner case seen on some arm64 boards when kdump kernel
> > runs with "cgroup_disable=memory" passed to the kdump kernel via
> > bootargs.
> > 
> > The root-cause behind the same is that currently mem_cgroup_swap_init()
> > function is implemented as a subsys_initcall() call instead of a
> > core_initcall(), this means 'cgroup_memory_noswap' still
> > remains set to the default value (false) even when memcg is disabled via
> > "cgroup_disable=memory" boot parameter.
> > 
> > This may result in premature OOPS inside mem_cgroup_get_nr_swap_pages()
> > function in corner cases:
> > 
> >   [    0.265617] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000188
> >   [    0.274495] Mem abort info:
> >   [    0.277311]   ESR = 0x96000006
> >   [    0.280389]   EC = 0x25: DABT (current EL), IL = 32 bits
> >   [    0.285751]   SET = 0, FnV = 0
> >   [    0.288830]   EA = 0, S1PTW = 0
> >   [    0.291995] Data abort info:
> >   [    0.294897]   ISV = 0, ISS = 0x00000006
> >   [    0.298765]   CM = 0, WnR = 0
> >   [    0.301757] [0000000000000188] user address but active_mm is swapper
> >   [    0.308174] Internal error: Oops: 96000006 [#1] SMP
> >   [    0.313097] Modules linked in:
> >   <..snip..>
> >   [    0.331384] pstate: 00400009 (nzcv daif +PAN -UAO BTYPE=--)
> >   [    0.337014] pc : mem_cgroup_get_nr_swap_pages+0x9c/0xf4
> >   [    0.342289] lr : mem_cgroup_get_nr_swap_pages+0x68/0xf4
> >   [    0.347564] sp : fffffe0012b6f800
> >   [    0.350905] x29: fffffe0012b6f800 x28: fffffe00116b3000
> >   [    0.356268] x27: fffffe0012b6fb00 x26: 0000000000000020
> >   [    0.361631] x25: 0000000000000000 x24: fffffc00723ffe28
> >   [    0.366994] x23: fffffe0010d5b468 x22: fffffe00116bfa00
> >   [    0.372357] x21: fffffe0010aabda8 x20: 0000000000000000
> >   [    0.377720] x19: 0000000000000000 x18: 0000000000000010
> >   [    0.383082] x17: 0000000043e612f2 x16: 00000000a9863ed7
> >   [    0.388445] x15: ffffffffffffffff x14: 202c303d70617773
> >   [    0.393808] x13: 6f6e5f79726f6d65 x12: 6d5f70756f726763
> >   [    0.399170] x11: 2073656761705f70 x10: 6177735f726e5f74
> >   [    0.404533] x9 : fffffe00100e9580 x8 : fffffe0010628160
> >   [    0.409895] x7 : 00000000000000a8 x6 : fffffe00118f5e5e
> >   [    0.415258] x5 : 0000000000000001 x4 : 0000000000000000
> >   [    0.420621] x3 : 0000000000000000 x2 : 0000000000000000
> >   [    0.425983] x1 : 0000000000000000 x0 : fffffc0060079000
> >   [    0.431346] Call trace:
> >   [    0.433809]  mem_cgroup_get_nr_swap_pages+0x9c/0xf4
> >   [    0.438735]  shrink_lruvec+0x404/0x4f8
> >   [    0.442516]  shrink_node+0x1a8/0x688
> >   [    0.446121]  do_try_to_free_pages+0xe8/0x448
> >   [    0.450429]  try_to_free_pages+0x110/0x230
> >   [    0.454563]  __alloc_pages_slowpath.constprop.106+0x2b8/0xb48
> >   [    0.460366]  __alloc_pages_nodemask+0x2ac/0x2f8
> >   [    0.464938]  alloc_page_interleave+0x20/0x90
> >   [    0.469246]  alloc_pages_current+0xdc/0xf8
> >   [    0.473379]  atomic_pool_expand+0x60/0x210
> >   [    0.477514]  __dma_atomic_pool_init+0x50/0xa4
> >   [    0.481910]  dma_atomic_pool_init+0xac/0x158
> >   [    0.486220]  do_one_initcall+0x50/0x218
> >   [    0.490091]  kernel_init_freeable+0x22c/0x2d0
> >   [    0.494489]  kernel_init+0x18/0x110
> >   [    0.498007]  ret_from_fork+0x10/0x18
> >   [    0.501614] Code: aa1403e3 91106000 97f82a27 14000011 (f940c663)
> >   [    0.507770] ---[ end trace 9795948475817de4 ]---
> >   [    0.512429] Kernel panic - not syncing: Fatal exception
> >   [    0.517705] Rebooting in 10 seconds..
> > 
> > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> > Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> > Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> > Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> 
> Fixes: eccb52e78809 ("mm: memcontrol: prepare swap controller setup for integration")
> 
> > Reported-by: Prabhakar Kushwaha <pkushwaha-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>
> > Signed-off-by: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> This is subtle as hell, I have to say. I find the ordering in the init
> calls very unintuitive and extremely hard to follow. The above commit
> has introduced the problem but the code previously has worked mostly by
> a luck because our default was flipped.
> 
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 
> > ---
> >  mm/memcontrol.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 19622328e4b5..8323e4b7b390 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -7186,6 +7186,13 @@ static struct cftype memsw_files[] = {
> >  	{ },	/* terminate */
> >  };
> >  
> > +/*
> > + * If mem_cgroup_swap_init() is implemented as a subsys_initcall()
> > + * instead of a core_initcall(), this could mean cgroup_memory_noswap still
> > + * remains set to false even when memcg is disabled via "cgroup_disable=memory"
> > + * boot parameter. This may result in premature OOPS inside 
> > + * mem_cgroup_get_nr_swap_pages() function in corner cases.
> > + */
> >  static int __init mem_cgroup_swap_init(void)
> >  {
> >  	/* No memory control -> no swap control */
> > @@ -7200,6 +7207,6 @@ static int __init mem_cgroup_swap_init(void)
> >  
> >  	return 0;
> >  }
> > -subsys_initcall(mem_cgroup_swap_init);
> > +core_initcall(mem_cgroup_swap_init);
> >  
> >  #endif /* CONFIG_MEMCG_SWAP */
> > -- 
> > 2.7.4
> 
> -- 
> Michal Hocko
> SUSE Labs

-- 
Michal Hocko
SUSE Labs
