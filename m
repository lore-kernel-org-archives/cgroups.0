From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Tue, 15 Apr 2014 09:53:59 -0400
Message-ID: <20140415135359.GA13033@redhat.com>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140414193214.GC16835-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 14, 2014 at 03:32:14PM -0400, Tejun Heo wrote:

[..]
> > So now we have tree modes?
> > 
> > - Orignal multi hierachy mode
> > - Multi hierarchy with sane flag
> > 	- Sane flag modifies behavior of throttling.
> > - Unified hierarchy
> > 	- Changes tunables.
> 
> No, we don't.  __DEVEL__sane_behavior is a tool to implement unified
> hierarchy.  Once unified hierarchy lands, sane_behavior will be folded
> into unified hierarchy.

Ok, got it. So unified hierarchy will co-exist with other hierarchies
in the system.

I somehow had the impression that either one will have unified hierarchy
or will be multiple hierarchies. But one can't have both.

But looks like that you are targetting that one can have multiple
hierarchies. One of those will be unified hierarchy with new contstraints.
Other hierarchies can be old type hierarchies. Do I understand it right?

> 
> > Looks like some of the changes are related to sane flag and others
> > are related to unified hierarchy. Will it make sense to break it down
> > int two patches.
> 
> So, they're one and the same.
> 
> > > * For cfq, weight[_device] behave inherently differently from the same
> > >   knobs on !root cgroups as root cgroup is treated as parallel to
> > >   immediate children.  Let's omit it for now.
> > 
> > So now root cgroup will not have any cfq, weight[_device] knobs but
> > non root cgroups will have one? What's the harm in providing one for
> > root too for the sake of uniformity. That's a differnt thing thet root
> > does not have a competitor so value in that knob does not matter.
> 
> Please see at the end of the mail.
> 
> > > * cfq's time stats reports the total time slice consumed but its unit
> > >   is in jiffies and it's not reported per-device like all other stats.
> > >   Omit it for now.  If slice time is actually necessary, let's add it
> > >   in the form consistent with other stats.
> > 
> > To me this knob is also for debugging purposes. CFQ divides disk time
> > proportionally. And if one wants to see how disk time is being divided
> > among cgroups, this knob helps. This is more to verify whether our
> > algorithm is working fine or not and if disk time is being divided
> > in proportion to weights or not.
> > 
> > But again, I am not particular about this knob. Sounds more like
> > debugging stuff.
> 
> If it is a debug knob, let's please require it to be enabled
> explicitly - ie. require a boot param which *clearly* indicates that
> this is a debug option; otherwise, we end up leaking internal details
> w/o actually intending or designing for it and userland is likely to
> grow dependency on it.

So you want all the debug knobs to be enabled by  DEBUG_BLK_CGROUP option as
well as using a kernel command line? But I thought that in general
people are not supposed to set CONFIG_DEBUG_BLK_CGROUP=y. It brings in
unnecessary overhead. Those who are doing development and trying to debug
things only those can enable above config option.

But anyway, I am fine with hiding these files behind a command line
parameter too.

> 
> > Google folks wanted all these knobs. And they said that they have lot
> > of more knobs which they carry internally.
> 
> AFAIK, google folks forked cfq a couple years ago, I'm not sure how
> much this will affect them.
> 
> > Personally I think io_queued might be a useful knob because it can
> > show current backlog on a particular cgroup and some tool might want
> > to dynamically monitor the queue lenghts of various cgroups and adjust
> > weights dynamically.
> > 
> > So this one might be worth retaining.
> 
> Can we do that once we know for sure that this is actually necessary?
> I'm quite skeptical that this sort of snapshot stats are actually
> useful except for debugging.

Ok, that's fine. We can introduce it once somebody really needs it.

> 
> > > * cfq adds a number of stats knobs if CONFIG_DEBUG_BLK_CGROUP.  If
> > >   these are actually for debugging, they shouldn't show up by default
> > >   (ie. should be gated by kernel param or something).  If userland
> > >   already developed dependency on them, we need to take them out of
> > >   CONFIG_DEBUG_BLK_CGROUP.  Skip them for now.  We can add back the
> > >   relevant ones later.
> > 
> > I am fine with this. Again Google folks intorduced those. Not sure
> > if they still use those. Less stats are better.
> 
> The same thing with above.  If these are really for debugging, let's
> please hide them better.
> 
> > >   weight_device			-> cfq.weight_device
> > >   weight			-> cfq.weight
> > >   sectors_recursive		-> cfq.sectors
> > >   io_service_bytes_recursive	-> cfq.bytes
> > 
> > throttling has correspnding knob as throttle.io_service_bytes. So either
> > we can change the name of throttling knob to throttle.bytes or
> > chnage keep this one as it is (cfq.io_service_bytes) for the sake of
> > consistency.
> 
> Yeah, thought about keeping them consistent but would that really
> matter?  Having internal consistency in cfq seems more important to
> me.

I think from a user's perspective it really matters. If I see two knobs
in a cgroup, say throttle.io_service_bytes and cfq.io_service_bytes, it
is much more intuitive.

So I feel that we should aim for having consistent names in CFQ and
throttling. If one understands one knob at one layer, it is intuitive
to figure out what same knob means at other layer.

And, thankfully, we have only two stats at throttling layer.

blkio.throttle.io_serviced
blkio.throttle.io_service_bytes

Though names are little longer, but they look fine to me. They are
intuitive. So I can't see a strong reason to change those names
at CFQ layer.

blkio.cfq.io_serviced
blkio.cfq.io_service_bytes

> 
> > >   io_serviced_recursive		-> cfq.serviced
> > 
> > throttling layer uses throttle.io_serviced.
> 
> Ditto.
> 
> > Given the fact that throttling layer counts bios and CFQ counts requests
> > may be we can keep throttle.bio_serviced  and cfq.rq_serviced as names.
> > 
> > Or may be just throttle.bios and cfq.requests respectively.
> 
> I'm not sure whether we want to rename throttle knobs.  Renaming cfq
> knobs makes sense as they need to be renamed for cfq. prefix anyway
> but throttle knobs are already mostly fine, so wouldn't it make sense
> to leave them as they are?  It makes things a bit incosistent between
> cfq and throttle but do we really care?

Instead of renaming throttling knob, I will prefer to keep new CFQ knob
names consistent with throttling names.

Thanks
Vivek
