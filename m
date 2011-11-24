From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC][PATCH 3/3] replace mem_cgroup_disabled
Date: Thu, 24 Nov 2011 09:20:09 +0900
Message-ID: <20111124092009.c8245576.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
	<20111123173421.39c99643.kamezawa.hiroyu@jp.fujitsu.com>
	<4ECCCE43.9090904@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ECCCE43.9090904-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org" <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, 23 Nov 2011 08:43:15 -0200
Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

> On 11/23/2011 06:34 AM, KAMEZAWA Hiroyuki wrote:
> > I'll rebase this onto mmotm this is based on mainline git tree.
> > ==
> >  From 2da35fd8eab3a8c2ca80d7aa5dfd4276a23ebf57 Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > Date: Wed, 23 Nov 2011 16:42:59 +0900
> > Subject: [PATCH 3/3] replace mem_cgroup_disabled().
> >
> > cgroup provires cgroup_xxxx_disabled() functions for checking
> > subsys is diabled by boot option or not. Make use of it instead
> > of using private function.
> >
> > Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > ---
> >   include/linux/memcontrol.h |   12 ------------
> >   kernel/cgroup.c            |    4 ++--
> >   mm/memcontrol.c            |   32 ++++++++++++++++----------------
> >   mm/page_cgroup.c           |    4 ++--
> >   4 files changed, 20 insertions(+), 32 deletions(-)
> >
> 
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 28d4430..e5c33f5 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -4778,7 +4778,7 @@ static void cgroup_release_agent(struct work_struct *work)
> >   }
> >   #ifdef CONFIG_JUMP_LABEL
> >   #define SUBSYS(_x)\
> > -	struct jump_label_key cgroup_ ## _x ## _disable_key;
> > +	struct jump_label_key cgroup_ ## _x ## _disabled_key;
> >   #include<linux/cgroup_subsys.h>
> >   #undef SUBSYS
> 
> I have the impression this is just churn. Can you call it disabled_key
> from the beginning ?
> 

Ouch, I made a mistake at commiting and fix to previous commit sneaked
into here. Thank you for review, I'll do fix.


> > @@ -4786,7 +4786,7 @@ static void cgroup_subsys_disable(void)
> >   {
> >   #define SUBSYS(_x)\
> >   	if ( _x ## _subsys.disabled)\
> > -		jump_label_inc(&cgroup_ ## _x ## _disable_key);
> > +		jump_label_inc(&cgroup_ ## _x ## _disabled_key);
> >   #include<linux/cgroup_subsys.h>
> >   #undef SUBSYS
> >   }
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6aff93c..594af98 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -916,7 +916,7 @@ void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru)
> >   	struct page_cgroup *pc;
> >   	struct mem_cgroup_per_zone *mz;
> >
> > -	if (mem_cgroup_disabled())
> > +	if (cgroup_mem_cgroup_disabled())
> >   		return;
> >   	pc = lookup_page_cgroup(page);
> >   	/* can happen while we handle swapcache. */
> > @@ -952,7 +952,7 @@ void mem_cgroup_rotate_reclaimable_page(struct page *page)
> >   	struct page_cgroup *pc;
> >   	enum lru_list lru = page_lru(page);
> >
> > -	if (mem_cgroup_disabled())
> > +	if (cgroup_mem_cgroup_disabled())
> >   		return;
> >
> >   	pc = lookup_page_cgroup(page);
> 
> In many cases, this will be just a useless function call. Wouldn't it be 
> better if in the disabled case we would not even call those functions? 
> It may help some fast paths.
> 
Hm ? diassembled code is like this.

Dump of assembler code for function mem_cgroup_rotate_reclaimable_page:
   0xffffffff8116c460 <+0>:     push   %rbp
   0xffffffff8116c461 <+1>:     mov    %rsp,%rbp
   0xffffffff8116c464 <+4>:     sub    $0x10,%rsp
   0xffffffff8116c468 <+8>:     mov    %rbx,(%rsp)
   0xffffffff8116c46c <+12>:    mov    %r12,0x8(%rsp)
   0xffffffff8116c471 <+17>:    callq  0xffffffff815c59c0
   0xffffffff8116c476 <+22>:    mov    (%rdi),%rax
   0xffffffff8116c479 <+25>:    mov    $0x4,%ebx
   0xffffffff8116c47e <+30>:    mov    %rdi,%r12
   0xffffffff8116c481 <+33>:    test   $0x100000,%eax
   0xffffffff8116c486 <+38>:    jne    0xffffffff8116c4a6 <mem_cgroup_rotate_reclaimable_page+70>
   0xffffffff8116c488 <+40>:    mov    (%rdi),%rax
   0xffffffff8116c48b <+43>:    and    $0x80000,%eax
   0xffffffff8116c490 <+48>:    cmp    $0x1,%rax
   0xffffffff8116c494 <+52>:    mov    (%rdi),%rax
   0xffffffff8116c497 <+55>:    sbb    %ebx,%ebx
   0xffffffff8116c499 <+57>:    and    $0x2,%ebx
   0xffffffff8116c49c <+60>:    and    $0x40,%eax
   0xffffffff8116c49f <+63>:    cmp    $0x1,%rax
   0xffffffff8116c4a3 <+67>:    sbb    $0xffffffffffffffff,%ebx
   0xffffffff8116c4a6 <+70>:    jmpq   0xffffffff8116c4ab <mem_cgroup_rotate_reclaimable_page+75>
   0xffffffff8116c4ab <+75>:    mov    %r12,%rdi
   0xffffffff8116c4ae <+78>:    callq  0xffffffff81173740 <lookup_page_cgroup>

0xffffffff8116c4a6  is the jump label I used.

jump labels in static inline functions seems to work as expected.
and no function calls. This seems good.

Thanks,
-Kame

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
