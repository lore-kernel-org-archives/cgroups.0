From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcontrol: fix a data race in scan count
Date: Fri, 07 Feb 2020 14:30:34 -0500
Message-ID: <1581103834.7365.22.camel@lca.pw>
References: <1581096119-13593-1-git-send-email-cai@lca.pw>
         <CANpmjNMk5zw+nbLa4Ko7zUdWOY8pFR6EuQ6WbRECmX=8o8PLUw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UZ0miLyLVEkfKHeEyE0u4OVk16FS3JucgNtnKmSivzw=;
        b=a2ght5jDtaODJqTahY9YF9dET2z5wQ9d8zyuDNRJFlx+w25JwWWveGiuzoOi8eX7Sq
         0u+pc0jfAQ/M4MpRfAHn2ZRyrhj4SNYZzBZ5sC33jWhlUsVjm7wjfQb3ZTKOS0gKT+Vn
         oZFYu+9ScaZvOlTkucdePP7dVqc7Ga90r647D2VD6icMNvYK8xeBqmzgEk1vKy2arM8k
         XvQFALHfxaUJLkw1T2I9ixxJDecnaWYEVuOAsRDC/AcGdcWc9Cp9YtiWJ3Pseyfj4BXw
         0uEhBbc1myFWX0E+xkHXapKLMPsHfiZvxKIjSBZYfdiYg3NEfH9fZYqFugj2eNpVCU34
         ooBA==
In-Reply-To: <CANpmjNMk5zw+nbLa4Ko7zUdWOY8pFR6EuQ6WbRECmX=8o8PLUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, 2020-02-07 at 19:19 +0100, Marco Elver wrote:
> On Fri, 7 Feb 2020 at 18:22, Qian Cai <cai-J5quhbR+WMc@public.gmane.org> wrote:
> > 
> > struct mem_cgroup_per_node mz.lru_zone_size[zone_idx][lru] could be
> > accessed concurrently as noticed by KCSAN,
> > 
> >  BUG: KCSAN: data-race in lruvec_lru_size / mem_cgroup_update_lru_size
> > 
> >  write to 0xffff9c804ca285f8 of 8 bytes by task 50951 on cpu 12:
> >   mem_cgroup_update_lru_size+0x11c/0x1d0
> >   mem_cgroup_update_lru_size at mm/memcontrol.c:1266
> >   isolate_lru_pages+0x6a9/0xf30
> >   shrink_active_list+0x123/0xcc0
> >   shrink_lruvec+0x8fd/0x1380
> >   shrink_node+0x317/0xd80
> >   do_try_to_free_pages+0x1f7/0xa10
> >   try_to_free_pages+0x26c/0x5e0
> >   __alloc_pages_slowpath+0x458/0x1290
> >   __alloc_pages_nodemask+0x3bb/0x450
> >   alloc_pages_vma+0x8a/0x2c0
> >   do_anonymous_page+0x170/0x700
> >   __handle_mm_fault+0xc9f/0xd00
> >   handle_mm_fault+0xfc/0x2f0
> >   do_page_fault+0x263/0x6f9
> >   page_fault+0x34/0x40
> > 
> >  read to 0xffff9c804ca285f8 of 8 bytes by task 50964 on cpu 95:
> >   lruvec_lru_size+0xbb/0x270
> >   mem_cgroup_get_zone_lru_size at include/linux/memcontrol.h:536
> >   (inlined by) lruvec_lru_size at mm/vmscan.c:326
> >   shrink_lruvec+0x1d0/0x1380
> >   shrink_node+0x317/0xd80
> >   do_try_to_free_pages+0x1f7/0xa10
> >   try_to_free_pages+0x26c/0x5e0
> >   __alloc_pages_slowpath+0x458/0x1290
> >   __alloc_pages_nodemask+0x3bb/0x450
> >   alloc_pages_current+0xa6/0x120
> >   alloc_slab_page+0x3b1/0x540
> >   allocate_slab+0x70/0x660
> >   new_slab+0x46/0x70
> >   ___slab_alloc+0x4ad/0x7d0
> >   __slab_alloc+0x43/0x70
> >   kmem_cache_alloc+0x2c3/0x420
> >   getname_flags+0x4c/0x230
> >   getname+0x22/0x30
> >   do_sys_openat2+0x205/0x3b0
> >   do_sys_open+0x9a/0xf0
> >   __x64_sys_openat+0x62/0x80
> >   do_syscall_64+0x91/0xb47
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> >  Reported by Kernel Concurrency Sanitizer on:
> >  CPU: 95 PID: 50964 Comm: cc1 Tainted: G        W  O L    5.5.0-next-20200204+ #6
> >  Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019
> > 
> > The write is under lru_lock, but the read is done as lockless. The scan
> > count is used to determine how aggressively the anon and file LRU lists
> > should be scanned. Load tearing could generate an inefficient heuristic,
> > so fix it by adding READ_ONCE() for the read and WRITE_ONCE() for the
> > writes.
> > 
> > Signed-off-by: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
> > ---
> > 
> > v2: also have WRITE_ONCE() in the writer which is necessary.
> 
> Again, note that KCSAN will *not* complain if you omitted the
> WRITE_ONCE and only had the READ_ONCE, as long as the write aligned
> and up to word-size. Because we still don't have a nice way to deal
> with read-modify-writes, like 'var +=', '++', I don't know if we want
> to do the WRITE_ONCE right now.
> 
> I think the kernel might need a primitive that avoids the readability
> issues of writing 'WRITE_ONCE(var, var + val)'. I don't have strong
> opinions on this, so it's up to maintainers.

Those are good points. Andrew, feel free to pick the v1 instead which seems like
a reasonable trade off.

> 
> Thanks,
> -- Marco
> 
> >  include/linux/memcontrol.h | 2 +-
> >  mm/memcontrol.c            | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index a7a0a1a5c8d5..e8734dabbc61 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -533,7 +533,7 @@ unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
> >         struct mem_cgroup_per_node *mz;
> > 
> >         mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> > -       return mz->lru_zone_size[zone_idx][lru];
> > +       return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
> >  }
> > 
> >  void mem_cgroup_handle_over_high(void);
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6f6dc8712e39..daf375cc312c 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1263,7 +1263,7 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
> >         lru_size = &mz->lru_zone_size[zid][lru];
> > 
> >         if (nr_pages < 0)
> > -               *lru_size += nr_pages;
> > +               WRITE_ONCE(*lru_size, *lru_size + nr_pages);
> > 
> >         size = *lru_size;
> >         if (WARN_ONCE(size < 0,
> > @@ -1274,7 +1274,7 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
> >         }
> > 
> >         if (nr_pages > 0)
> > -               *lru_size += nr_pages;
> > +               WRITE_ONCE(*lru_size, *lru_size + nr_pages);
> >  }
> > 
> >  /**
> > --
> > 1.8.3.1
> > 
