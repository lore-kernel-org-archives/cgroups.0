From: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kmemleaks reports a lot of cases around memcg_create_kmem_cache
Date: Wed, 5 Jul 2017 21:06:37 -0700
Message-ID: <20170706040636.GA18363@gmail.com>
References: <CANaxB-x=xgLq116VReo4Og+jFsAB+ehx3xThnXoCx8pR3YXPSA@mail.gmail.com>
 <20170702185017.ew5cn4altyw7nomi@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n9m02YoN71+PNyfUcquBV0HHfiqNyVBnxbzC7cMMDH4=;
        b=F+r2r2m21Wp4CCwOkyquEfmxjAmPobIap1OVuqF8z3poj6mGBUVCKzqQpx6vhCveWV
         dIvDOdUuII4uXty3sJlmQ862729cbLys+qczdow8YmUOdCN+AH5YcWRLHh+NIR06obVw
         ocMQj/1q2gwnrgm0rN33oqBkaOmWXq2v8cadB64s4sH35t1tTF/iR3TCc89TsN/2lb6C
         eeZz974O/mENxCJ0ZYBQGSCvMx3L7ztGXb8nJCgKWrrgsDUoi3UsWTXFBsADVxeWqrB8
         ru+6lOvNq3iwQcFygC0PRxWJpj70RVJqoWrI6XMGTOyp0YROgEuUFoALRO0SkanTJa/k
         ysYQ==
Content-Disposition: inline
In-Reply-To: <20170702185017.ew5cn4altyw7nomi@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Sun, Jul 02, 2017 at 09:50:17PM +0300, Vladimir Davydov wrote:
> On Thu, Jun 29, 2017 at 11:04:01AM -0700, Andrei Vagin wrote:
> > Hello,
> > 
> > We run CRIU tests on the linus' tree and found that kmemleak reports
> > unreferenced objects which are allocated from memcg_create_kmem_cache:
> > 
> > unreferenced object 0xffff9f79442cd980 (size 112):
> >   comm "kworker/1:4", pid 15416, jiffies 4307432421 (age 28687.562s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
> >     ff ff ff ff ff ff ff ff b8 39 1b 97 ff ff ff ff  .........9......
> >   backtrace:
> >     [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
> >     [<ffffffff95276198>] kmem_cache_alloc_node+0x168/0x2a0
> >     [<ffffffff95279f28>] __kmem_cache_create+0x2b8/0x5c0
> >     [<ffffffff9522ff57>] create_cache+0xb7/0x1e0
> >     [<ffffffff952305f8>] memcg_create_kmem_cache+0x118/0x160
> >     [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
> >     [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
> >     [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
> >     [<ffffffff950d5169>] kthread+0x109/0x140
> >     [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
> >     [<ffffffffffffffff>] 0xffffffffffffffff
> > unreferenced object 0xffff9f798a79f540 (size 32):
> >   comm "kworker/1:4", pid 15416, jiffies 4307432429 (age 28687.554s)
> >   hex dump (first 32 bytes):
> >     6b 6d 61 6c 6c 6f 63 2d 31 36 28 31 35 39 39 3a  kmalloc-16(1599:
> >     6e 65 77 72 6f 6f 74 29 00 23 6b c0 ff ff ff ff  newroot).#k.....
> >   backtrace:
> >     [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
> >     [<ffffffff9527a378>] __kmalloc_track_caller+0x148/0x2c0
> >     [<ffffffff95499466>] kvasprintf+0x66/0xd0
> >     [<ffffffff954995a9>] kasprintf+0x49/0x70
> >     [<ffffffff952305c6>] memcg_create_kmem_cache+0xe6/0x160
> >     [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
> >     [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
> >     [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
> >     [<ffffffff950d5169>] kthread+0x109/0x140
> >     [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
> >     [<ffffffffffffffff>] 0xffffffffffffffff
> > unreferenced object 0xffff9f79b6136840 (size 416):
> >   comm "kworker/1:4", pid 15416, jiffies 4307432429 (age 28687.573s)
> >   hex dump (first 32 bytes):
> >     40 fb 80 c2 3e 33 00 00 00 00 00 40 00 00 00 00  @...>3.....@....
> >     00 00 00 00 00 00 00 00 10 00 00 00 10 00 00 00  ................
> >   backtrace:
> >     [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
> >     [<ffffffff95275bc8>] kmem_cache_alloc+0x128/0x280
> >     [<ffffffff9522fedb>] create_cache+0x3b/0x1e0
> >     [<ffffffff952305f8>] memcg_create_kmem_cache+0x118/0x160
> >     [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
> >     [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
> >     [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
> >     [<ffffffff950d5169>] kthread+0x109/0x140
> >     [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
> >     [<ffffffffffffffff>] 0xffffffffffffffff
> > unreferenced object 0xffff9f798cac8000 (size 1024):
> >   comm "kworker/1:4", pid 15416, jiffies 4307432429 (age 28687.573s)
> >   hex dump (first 32 bytes):
> >     10 00 00 00 70 09 00 00 20 09 00 00 00 09 00 00  ....p... .......
> >     80 02 00 00 b0 03 00 00 30 06 00 00 50 02 00 00  ........0...P...
> >   backtrace:
> >     [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
> >     [<ffffffff952766b8>] __kmalloc+0x158/0x2c0
> >     [<ffffffff95230a5f>] cache_random_seq_create+0x6f/0x130
> >     [<ffffffff952714da>] init_cache_random_seq+0x3a/0x90
> >     [<ffffffff95279d70>] __kmem_cache_create+0x100/0x5c0
> >     [<ffffffff9522ff57>] create_cache+0xb7/0x1e0
> >     [<ffffffff952305f8>] memcg_create_kmem_cache+0x118/0x160
> >     [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
> >     [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
> >     [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
> >     [<ffffffff950d5169>] kthread+0x109/0x140
> >     [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
> >     [<ffffffffffffffff>] 0xffffffffffffffff
> > unreferenced object 0xffff9f79442cd800 (size 112):
> > 
> > [root@zdtm linux]# git describe HEAD
> > v4.12-rc7-26-gb216759
> > 
> > [root@zdtm linux]# uname -a
> > Linux zdtm.openvz.org 4.12.0-rc7+ #9 SMP Thu Jun 29 08:28:18 CEST 2017
> > x86_64 x86_64 x86_64 GNU/Linux
> 
> Could you check if the patch below fixes the issue?

It works. Thanks!

> --
> From: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Subject: [PATCH] slub: fix per memcg cache leak on css offline
> 
> To avoid a possible deadlock, sysfs_slab_remove() schedules an
> asynchronous work to delete sysfs entries corresponding to the kmem
> cache. To ensure the cache isn't freed before the work function is
> called, it takes a reference to the cache kobject. The reference is
> supposed to be released by the work function. However, the work function
> (sysfs_slab_remove_workfn()) does nothing in case the cache sysfs entry
> has already been deleted, leaking the kobject and the corresponding
> cache. This may happen on a per memcg cache destruction, because sysfs
> entries of a per memcg cache are deleted on memcg offline if the cache
> is empty (see __kmemcg_cache_deactivate()).
> 
> The kmemleak report looks like this:
> 
>   unreferenced object 0xffff9f798a79f540 (size 32):
>     comm "kworker/1:4", pid 15416, jiffies 4307432429 (age 28687.554s)
>     hex dump (first 32 bytes):
>       6b 6d 61 6c 6c 6f 63 2d 31 36 28 31 35 39 39 3a  kmalloc-16(1599:
>       6e 65 77 72 6f 6f 74 29 00 23 6b c0 ff ff ff ff  newroot).#k.....
>     backtrace:
>       [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
>       [<ffffffff9527a378>] __kmalloc_track_caller+0x148/0x2c0
>       [<ffffffff95499466>] kvasprintf+0x66/0xd0
>       [<ffffffff954995a9>] kasprintf+0x49/0x70
>       [<ffffffff952305c6>] memcg_create_kmem_cache+0xe6/0x160
>       [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
>       [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
>       [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
>       [<ffffffff950d5169>] kthread+0x109/0x140
>       [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
>       [<ffffffffffffffff>] 0xffffffffffffffff
>   unreferenced object 0xffff9f79b6136840 (size 416):
>     comm "kworker/1:4", pid 15416, jiffies 4307432429 (age 28687.573s)
>     hex dump (first 32 bytes):
>       40 fb 80 c2 3e 33 00 00 00 00 00 40 00 00 00 00  @...>3.....@....
>       00 00 00 00 00 00 00 00 10 00 00 00 10 00 00 00  ................
>     backtrace:
>       [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
>       [<ffffffff95275bc8>] kmem_cache_alloc+0x128/0x280
>       [<ffffffff9522fedb>] create_cache+0x3b/0x1e0
>       [<ffffffff952305f8>] memcg_create_kmem_cache+0x118/0x160
>       [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
>       [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
>       [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
>       [<ffffffff950d5169>] kthread+0x109/0x140
>       [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
>       [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Fix the leak by adding the missing call to kobject_put() to
> sysfs_slab_remove_workfn().
> 
> Reported-by: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Fixes: 3b7b314053d02 ("slub: make sysfs file removal asynchronous")
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 8addc535bcdc..a0f3c56611c6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5637,13 +5637,14 @@ static void sysfs_slab_remove_workfn(struct work_struct *work)
>  		 * A cache is never shut down before deactivation is
>  		 * complete, so no need to worry about synchronization.
>  		 */
> -		return;
> +		goto out;
>  
>  #ifdef CONFIG_MEMCG
>  	kset_unregister(s->memcg_kset);
>  #endif
>  	kobject_uevent(&s->kobj, KOBJ_REMOVE);
>  	kobject_del(&s->kobj);
> +out:
>  	kobject_put(&s->kobj);
>  }
>  
