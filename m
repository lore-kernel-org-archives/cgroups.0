From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Mon, 14 Apr 2014 15:32:14 -0400
Message-ID: <20140414193214.GC16835@htj.dyndns.org>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=C7qRpLyvGbrT2SSp7arLdUFXsakDx5FqhTr7FO1MeCI=;
        b=d2qHfKV5CweTUa6EvI1va3AikPDVE53/c2AhU4hnRJMWDtMIGBiuB3GvPH7YTt9qNL
         07GGZZvdPdPXNOI83L6uES4lQYyDl/lgTN0nzhRYbVjUzPpcKuFI40KPNkuhB409KITs
         Rj00RI4uCgCBtO0IGYsWpj22gVnpJs3GggflR84J1ZSEr72QtoBYxPCcuoZmO7OBU+7O
         E4nl0dVjQIEUFxmjuUomqpyUukeiu6AVsUnw/FkShZBXLOEUEZAFi2u8I9NmKbyonX/k
         xKAFflprcR8X9r26iBWLrtqDqfXiIvcfUSu0vxwdts7nE+LY4sdRoEDD89Xm0m+MTbce
         +Avg==
Content-Disposition: inline
In-Reply-To: <20140414180824.GB9552@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

Hello,

On Mon, Apr 14, 2014 at 02:08:24PM -0400, Vivek Goyal wrote:
> Can you please also update Documentation/block/cfq-iosched.txt and
> Documentation/cgroup/blkio-controller.txt to reflect these new
> changes.

Sure thing.

> So now we have tree modes?
> 
> - Orignal multi hierachy mode
> - Multi hierarchy with sane flag
> 	- Sane flag modifies behavior of throttling.
> - Unified hierarchy
> 	- Changes tunables.

No, we don't.  __DEVEL__sane_behavior is a tool to implement unified
hierarchy.  Once unified hierarchy lands, sane_behavior will be folded
into unified hierarchy.

> Looks like some of the changes are related to sane flag and others
> are related to unified hierarchy. Will it make sense to break it down
> int two patches.

So, they're one and the same.

> > * For cfq, weight[_device] behave inherently differently from the same
> >   knobs on !root cgroups as root cgroup is treated as parallel to
> >   immediate children.  Let's omit it for now.
> 
> So now root cgroup will not have any cfq, weight[_device] knobs but
> non root cgroups will have one? What's the harm in providing one for
> root too for the sake of uniformity. That's a differnt thing thet root
> does not have a competitor so value in that knob does not matter.

Please see at the end of the mail.

> > * cfq's time stats reports the total time slice consumed but its unit
> >   is in jiffies and it's not reported per-device like all other stats.
> >   Omit it for now.  If slice time is actually necessary, let's add it
> >   in the form consistent with other stats.
> 
> To me this knob is also for debugging purposes. CFQ divides disk time
> proportionally. And if one wants to see how disk time is being divided
> among cgroups, this knob helps. This is more to verify whether our
> algorithm is working fine or not and if disk time is being divided
> in proportion to weights or not.
> 
> But again, I am not particular about this knob. Sounds more like
> debugging stuff.

If it is a debug knob, let's please require it to be enabled
explicitly - ie. require a boot param which *clearly* indicates that
this is a debug option; otherwise, we end up leaking internal details
w/o actually intending or designing for it and userland is likely to
grow dependency on it.

> Google folks wanted all these knobs. And they said that they have lot
> of more knobs which they carry internally.

AFAIK, google folks forked cfq a couple years ago, I'm not sure how
much this will affect them.

> Personally I think io_queued might be a useful knob because it can
> show current backlog on a particular cgroup and some tool might want
> to dynamically monitor the queue lenghts of various cgroups and adjust
> weights dynamically.
> 
> So this one might be worth retaining.

Can we do that once we know for sure that this is actually necessary?
I'm quite skeptical that this sort of snapshot stats are actually
useful except for debugging.

> > * cfq adds a number of stats knobs if CONFIG_DEBUG_BLK_CGROUP.  If
> >   these are actually for debugging, they shouldn't show up by default
> >   (ie. should be gated by kernel param or something).  If userland
> >   already developed dependency on them, we need to take them out of
> >   CONFIG_DEBUG_BLK_CGROUP.  Skip them for now.  We can add back the
> >   relevant ones later.
> 
> I am fine with this. Again Google folks intorduced those. Not sure
> if they still use those. Less stats are better.

The same thing with above.  If these are really for debugging, let's
please hide them better.

> >   weight_device			-> cfq.weight_device
> >   weight			-> cfq.weight
> >   sectors_recursive		-> cfq.sectors
> >   io_service_bytes_recursive	-> cfq.bytes
> 
> throttling has correspnding knob as throttle.io_service_bytes. So either
> we can change the name of throttling knob to throttle.bytes or
> chnage keep this one as it is (cfq.io_service_bytes) for the sake of
> consistency.

Yeah, thought about keeping them consistent but would that really
matter?  Having internal consistency in cfq seems more important to
me.

> >   io_serviced_recursive		-> cfq.serviced
> 
> throttling layer uses throttle.io_serviced.

Ditto.

> Given the fact that throttling layer counts bios and CFQ counts requests
> may be we can keep throttle.bio_serviced  and cfq.rq_serviced as names.
> 
> Or may be just throttle.bios and cfq.requests respectively.

I'm not sure whether we want to rename throttle knobs.  Renaming cfq
knobs makes sense as they need to be renamed for cfq. prefix anyway
but throttle knobs are already mostly fine, so wouldn't it make sense
to leave them as they are?  It makes things a bit incosistent between
cfq and throttle but do we really care?

> > @@ -761,6 +761,7 @@ EXPORT_SYMBOL_GPL(blkg_conf_finish);
> >  struct cftype blkcg_files[] = {
> >  	{
> >  		.name = "reset_stats",
> > +		.flags = CFTYPE_INSANE,
> >  		.write_u64 = blkcg_reset_stats,
> 
> So this knob will not be user visible with unified hierarchy as well as with
> sane behavior?
> 
> So this looks like a cleanup independent of unified hiearchy.

Again, sane_behavior is subset of unified hierarchy and will be
absorbed into unified hierarchy.  No need to make the distinction.

> > +	/* files for default hierarchy, properly prefixed with cfq */
> > +	{
> > +		.name = "cfq.weight_device",
> > +		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_NOT_ON_ROOT,
> > +		.seq_show = cfqg_print_weight_device,
> > +		.write_string = cfqg_set_weight_device,
> > +	},
> > +	{
> > +		.name = "cfq.weight",
> > +		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_NOT_ON_ROOT,
> > +		.seq_show = cfq_print_weight,
> > +		.write_u64 = cfq_set_weight,
> > +	},
> > +
> 
> What't the harm in providing these knobs for root too?

Because I'm not sure about the benefits and it makes cfq behave
differently from other controllers.  root cgroup behavior probably has
to be special per controller so there's nothing fundamentally wrong
with that.  I just am not sure whether this actually adds something
significantly beneficial and it's kinda silly to commit to things when
not really necessary.  Adding things later is easy, removing is not,
so...

Thanks.

-- 
tejun
