From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.6-rc5 cgroups blkio throttle + md regression
Date: Thu, 20 Sep 2012 15:17:16 -0400
Message-ID: <20120920191716.GI4681@redhat.com>
References: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com>
 <CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com>
 <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com>
 <20120919194231.GF31860@redhat.com>
 <20120920183153.GI28934@google.com>
 <20120920184219.GH4681@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120920184219.GH4681-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 20, 2012 at 02:42:19PM -0400, Vivek Goyal wrote:
> On Thu, Sep 20, 2012 at 11:31:53AM -0700, Tejun Heo wrote:
> > Hello,
> > 
> > On Wed, Sep 19, 2012 at 03:42:31PM -0400, Vivek Goyal wrote:
> > > On Thu, Sep 20, 2012 at 04:20:42AM +1000, Joseph Glanville wrote:
> > > > Hi,
> > > > 
> > > > I booted the machine under bare metal to continue bisecting.
> > > > Thankfully this allowed me to locate the commit that causes the
> > > > problem.
> > > > 
> > > 
> > > I tested it and I am also noticing the hang. I can see this hang on
> > > dm devices also.
> > > 
> > > I suspect this issue is related to bio based drivers. We exit the
> > > bypass mode in blk_init_allocated_queue() and that will be called
> > > only for request based drivers. So for bio based drivers may be 
> > > we never exit the bypass mode and this issue is somehow side
> > > affect of that.
> > 
> > Can you please trigger sysrq-t and post the result?
> 
> Sorry, I had taken the sysrq-t output yesterday itself. Got distracted
> in other things and could never look through the code. Here it is.
> 
> [  418.685015] bash            D ffff880037aa4e88  4720  2898   2847
> 0x00000080
> [  418.685015]  ffff88007c777cd8 0000000000000082 ffff880037aa4b00
> ffff88007c777fd8
> [  418.685015]  ffff88007c777fd8 ffff88007c777fd8 ffffffff81c13440
> ffff880037aa4b00
> [  418.685015]  ffff88007c777ce8 ffffffff81e05e40 ffff88007c777d18
> 000000010001d5e4
> [  418.685015] Call Trace:
> [  418.685015]  [<ffffffff817a2fa9>] schedule+0x29/0x70
> [  418.685015]  [<ffffffff817a1570>] schedule_timeout+0x130/0x250
> [  418.685015]  [<ffffffff8140bbcb>] ? kobj_lookup+0x10b/0x160
> [  418.685015]  [<ffffffff8104a9b0>] ? usleep_range+0x50/0x50
> [  418.685015]  [<ffffffff817a16ae>] schedule_timeout_uninterruptible+0x1e/0x20
> [  418.685015]  [<ffffffff8104c310>] msleep+0x20/0x30
> [  418.685015]  [<ffffffff812ccaa8>] blkg_conf_prep+0x118/0x140
> [  418.685015]  [<ffffffff812cd400>] ? tg_set_conf_uint+0x20/0x20
> [  418.685015]  [<ffffffff812cd33a>] tg_set_conf.isra.20+0x2a/0xd0
> [  418.685015]  [<ffffffff810021ff>] ? do_signal+0x3f/0x610
> [  418.685015]  [<ffffffff812cd417>] tg_set_conf_u64+0x17/0x20
> [  418.685015]  [<ffffffff8109de6f>] cgroup_file_write+0x1bf/0x2c0
> [  418.685015]  [<ffffffff812864bc>] ? security_file_permission+0x2c/0xb0
> [  418.685015]  [<ffffffff811325cc>] vfs_write+0xac/0x180
> [  418.685015]  [<ffffffff811328fa>] sys_write+0x4a/0x90
> [  418.685015]  [<ffffffff817ab8d2>] system_call_fastpath+0x16/0x1b

I suspect we are looping in retry code because bio based queues never come
out of bypass mode.

                /*
                 * If queue was bypassing, we should retry.  Do so after a
                 * short msleep().  It isn't strictly necessary but queue
                 * can be bypassing for some time and it's always nice to
                 * avoid busy looping.
                 */
                if (ret == -EBUSY) {
                        msleep(10);
                        ret = restart_syscall();
                }


Thanks
Vivek
