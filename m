From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] devcg: Store local settings for each device cgroup
Date: Thu, 15 Aug 2013 17:09:37 -0400
Message-ID: <20130815210937.GB10977@mtj.dyndns.org>
References: <1376580854-30929-1-git-send-email-aris@redhat.com>
 <20130815195941.GA10977@mtj.dyndns.org>
 <20130815204804.GO7878@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=M88qZGrpyA5GbTcjJ7pMsguYC99fHja9sPuON4kvbQE=;
        b=UG5f6NMNUJ4LbCSxwXKxarTIV+XPH14BZ8hPZx9AS3JtWjeGuR13TWTzPzSoocJgZ8
         OGtKqYOBPhxmCTgd5YYaBUZxcoQaBphb+gSnlmjVP6oKBOOcGL8iE9aSiu62ccJqLzYI
         TjdpTfGKcva5DVTfuauvA8ENworIPsIx7aMB+QynKVF/OadYdYjG/LVHxcXxZ733SQFv
         XWvFDATmNbA5aOrUUpUsqS1E18N4SPQ37YgAAIUMR124suRLjbzS6cjDqYpy24jCI3n5
         nLz/xSeCJ+7gsZfAuIxXbDMDgWvQzEfZcogffsXZmAiGW5skk2QdS58DxlOM6yCCxaJg
         +SyQ==
Content-Disposition: inline
In-Reply-To: <20130815204804.GO7878-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>

Hello,

On Thu, Aug 15, 2013 at 04:48:04PM -0400, Aristeu Rozanski wrote:
> > * The configurations are finicky and complex.  There are many ways to
> >   configure it and some may fail depending on some conditions.  I
> >   really wish it were a lot simpler, at least when sane_behavior.
> 
> The ways it can fail is based on parent's permission. Yes, it's complex,
> but part of it was based on decisions taken to make the code simpler.
> For example: one thing left out from the last patchset was propagating
> access to new devices: let's say you add an exception to a behavior deny
> cgroup, it'd not be propagated down.
> 
> I'd prefer just top down changes. Parent allows X? cgroup allows X
> unless local rule says otherwise.

I think the configuration rules are too complex.  Without being privy
to the implementation itself, the restrictions seem mostly arbitrary.
The thing with this sort of greedy restrictions is that it might seem
okay for a while after enough tweaking (the current state) but it gets
weird as soon as the circumstance changes a bit and all the tweakings
quickly become extra baggages to carry around.

e.g. if a cgroup will be allowed to be moved to another position in
the hierarchy, the cgroup shouldn't change its configuration across
such migration, right?  If so, we'd be allowing creating a cgroup
outside the hierarchy with any configuration moving it under another
while disallowing creating it under there and creating the same
configuration, which would be an outright buggy behavior.

> > * Using separate propagation paths for allows and denys feels a bit
> >   weird.  Can't config just update local config and always propagate
> >   the change downwards?
> 
> That was a design decision back then. It might be doable to keep the
> same way it is by simply not adding extra access to devices in cgroups
> when propagating an exception like that. But that will only make both
> paths call the same function, not really any different.

The thing is I really don't like specific config change triggering
different actions.  It really should be "this chagned, recalculate all
rules in this sub-hierarchy" rather than "this may affect XXX and YYY
but not ZZZ so let's trigger this subpart".  The latter is way more
tricky to fragile and difficult to follow and verify.  In addition, to
support migration, it should be ready for any set of config changes in
a go anyway.

> > When sane_behavior, can't we have something like the following?
> > 
> > * Setting local config is not affected by what ancestors or
> >   descendants are doing.  It just sets local config and triggers
> >   propagation and never fails (except for things like alloc failure).
> 
> That could be done but would certanly break the interface. Perhaps a
> good time to introduce a newer interface that can mirror the
> behavior/exception model to userspace?

That's what cgroup_sane_behavior() is for.  It's essentially the next
revision of cgroup interface.

> > * Config defaults to allow-all unconfigured and there are only two
> >   modes - allow-all or allow-only-listed with an easy way to flip
> >   between the two and clear the list, which lists either specific
> >   maj:min or maj.
> 
> That would get rid of the 'allow all but with some exceptions' model
> which is useful in cases such when you just don't want scsi devices to be
> written, but pretty much everything else is ok. Wonder how many people
> would miss it?

The reason why I want to get rid of disallow w/ exceptions is that
it's difficult to stack properly and ends up with this hodgepodge of
restrictions which can serve a set of contorted requirements at the
cost of overall consitent design which can be evolved and maintained
in the long term.  If the majority of use cases are whitelisting, I
think it'd be a better idea to just stick with whitelisting.

Thanks.

-- 
tejun
