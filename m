From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: docker crashes rcuos in __blkg_release_rcu
Date: Wed, 11 Jun 2014 12:32:29 -0400
Message-ID: <20140611163229.GA12974@redhat.com>
References: <alpine.DEB.2.02.1406081816540.17948@jlaw-desktop.mno.stratus.com>
 <20140609174708.GA31499@redhat.com>
 <20140609182728.GB31499@redhat.com>
 <20140610143906.0d2f35d0@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140610143906.0d2f35d0-ceYW5R1vr2hcrvxNGtJwk767FWEIOpWeVpNB7YpNyf8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Lawrence <joe.lawrence-7+ureL1bLXNBDgjK7y7TUQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jun 10, 2014 at 02:39:06PM -0400, Joe Lawrence wrote:
> 
> Hi Vivek,
> 
> Thanks for taking a look.  For extra debugging, I wrote a quick set of
> kprobes that:
> 
>   1 - On blkg_alloc entry, save the request_queue's kobj address in a
>       list
>   2 - On kobject_put entry, dump the stack if the kobj is found in that
>       list
> 
> and this was the trace for the final kobject put for the
> request_queue before a crash:
> 
> JL: kobject_put kobj(queue) @ ffff88084d89c9e8, refcount=1
> ------------[ cut here ]------------
> WARNING: CPU: 27 PID: 11060 at /h/jlawrenc/kprobes/docker/probes_blk.c:166 kret_entry_kobject_put+0x47/0x50 [docker_debug]()
> [ ... snip modules ... ]
> CPU: 27 PID: 11060 Comm: docker Tainted: G        W  OE 3.15.0 #1
> Hardware name: Stratus ftServer 6400/G7LAZ, BIOS BIOS Version 6.3:57 12/25/2013
>  0000000000000000 0000000093cbdc81 ffff88104196fae8 ffffffff8162738d
>  0000000000000000 ffff88104196fb20 ffffffff8106d81d ffff88084d89c9e8
>  ffff881041912cd0 ffffffffa0181020 ffff88104196fbe0 ffffffffa01810c8
> Call Trace:
>  [<ffffffff8162738d>] dump_stack+0x45/0x56
>  [<ffffffff8106d81d>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff8106d94a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffffa017f107>] kret_entry_kobject_put+0x47/0x50 [docker_debug]
>  [<ffffffff816335ee>] pre_handler_kretprobe+0x9e/0x1c0
>  [<ffffffff81635a2f>] opt_pre_handler+0x4f/0x90
>  [<ffffffff81631dd7>] optimized_callback+0x97/0xb0
>  [<ffffffff812dde01>] ? kobject_put+0x1/0x60
>  [<ffffffff812b4561>] ? blk_cleanup_queue+0x101/0x1a0
>  [<ffffffffa011114b>] ? __dm_destroy+0x1db/0x260 [dm_mod]
>  [<ffffffffa0111f53>] ? dm_destroy+0x13/0x20 [dm_mod]
>  [<ffffffffa0117a2e>] ? dev_remove+0x11e/0x180 [dm_mod]
>  [<ffffffffa0117910>] ? dev_suspend+0x250/0x250 [dm_mod]
>  [<ffffffffa0118105>] ? ctl_ioctl+0x255/0x500 [dm_mod]
>  [<ffffffff8118483f>] ? do_wp_page+0x38f/0x750
>  [<ffffffffa01183c3>] ? dm_ctl_ioctl+0x13/0x20 [dm_mod]
>  [<ffffffff811e1c20>] ? do_vfs_ioctl+0x2e0/0x4a0
>  [<ffffffff81277d56>] ? file_has_perm+0xa6/0xb0
>  [<ffffffff811e1e61>] ? SyS_ioctl+0x81/0xa0
>  [<ffffffff816381e9>] ? system_call_fastpath+0x16/0x1b
> ---[ end trace b4b8112437afdac8 ]---
>  
> so I think when dm_destroy() is called, it leads to the request_queue
> in question going away.
> 
> > I am wondering if we need to take a reference on the queue
> > (blk_get_queue()) in blkg_alloc(), to make sure request queue is
> > still around when blkg is being freed.
> 
> I experimented with this and the crash does go away (and the docker
> invocation completes successfully).  I wasn't sure where the
> accompanying blk_put_queue() should go.  If I put it in blkg_free, the
> kref accounting doesn't seem to even out, ie they never fall to zero.

CC cgroups list.

Ok, I think I figured out why reference counting does not seem to even
out.

There are two ways to destroy blkg. Either device goes away and
blk_release_queue() will take care of removing blkg or cgroup is deleted
and that will take care of cleaning up blkg. I think only exception is
root blkg where one can not delete root cgroup so it is cleaned up only
when request queue goes away.

Now if blkg holds a reference to queue, then blk_release_queue() never
gets called. And root blkg can't be cleaned till queue goes away. So
this seems like chicken and egg situation.

Even for non-root blkg, blkg will not be cleaned till cgroup goes away.

Tejun, any thoughts on how to solve this issue. Delaying blkg release
in rcu context and then expecting queue to be still present is causing
this problem.

Thanks
Vivek
