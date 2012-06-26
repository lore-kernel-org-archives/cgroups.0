From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 22:59:24 +0200
Message-ID: <20120626205924.GH27816@cmpxchg.org>
References: <1340725634-9017-1-git-send-email-glommer@parallels.com>
 <1340725634-9017-3-git-send-email-glommer@parallels.com>
 <20120626180451.GP3869@google.com>
 <20120626185542.GE27816@cmpxchg.org>
 <20120626191450.GT3869@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120626191450.GT3869-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Jun 26, 2012 at 12:14:50PM -0700, Tejun Heo wrote:
> Hello, Johannes.
> 
> On Tue, Jun 26, 2012 at 08:55:42PM +0200, Johannes Weiner wrote:
> > > 2. Mark flat hierarchy deprecated and produce a warning message if
> > >    memcg is mounted w/o hierarchy option for a year or two.
> > 
> > I think most of us assume that the common case is either not nesting
> > directories or still working with hierarchy support actually enabled.
> 
> How do we know that?  At least from what I see from blkcg usage,
> people do crazy stuff when given crazy interface and we've been
> providing completely crazy interface for years.  We cannot switch that
> implicitly - the changed default behavior is drastically different and
> even could be difficult to chase down.  Transitions towards good
> behavior are good but they have to be explicit.

I can't really argue against this because this can't be anything but a
handwaving contest.  We simply have no data.

Backward compatibility is a really good idea but I think it depends on
the situation:

  I don't expect such a configuration to happen by accident because
  this behaviour is against fundamental expectations users have toward
  a filesystem, which is the hierarchical nature of nested entities.

  I also don't expect it to happen intentionnaly, simply because there
  is nothing to gain from a more complicated nested setup.

  And because there is nothing to gain, it is in addition really
  trivial to fix the insane setups by simply undoing the nesting,
  there is no downside for them.

The only point where I agree with you is that it may indeed be
non-obvious to detect in case you were relying on the filesystem
hierarchy not being reflected in the controller hierarchy.  But even
that depends on the usecase, whether it's a subtle performance
regression or a total failure to execute a previously supported
workload, which would be pretty damn obvious.

> > I would hate if people had to jump through hoops to get the only
> > behaviour we want to end up supporting and to not get yelled at, it
> > sends all the wrong signals.
> 
> It is inconvenient but that's the price that we have to pay for having
> been stupid.  Kernel flipping behavior implicitly is far worse than
> any such inconvenience.

That's a matter of taste.  It's not inconvenient for us, but for every
normal person trying to use the feature in a sane way, just to support
hypothetical crazy people when there is a really trivial solution for
the crazy people's problem.

> These default behavior flips are something is better handled by
> distros / admins than kernel itself.  They can orchestrate the
> userland infrastructure and handle and communicate these flips far
> better than kernel alone can do.  We can't send out mails to flat
> hierarchy users after all.  That's the reason why I'm suggesting mount
> option which can't be flipped (sans remount but that's going away too)
> once the system is configured by the distro or admin.
> 
> The kernel should nudge mainline users towards new behavior while
> providing distros / admins a way to move to the new behavior.  The
> kernel itself can't flip it like that.

I thought it was the kernel's job to provide sensible defaults and the
distro's job to ease transitions...

> > > 3. After the existing users had enough chance to move away from flat
> > >    hierarchy, rip out flat hierarchy code and error if hierarchy
> > >    option is not specified.
> > 
> > This description sounds much more sane than what we are actually
> > trying to ban, which is not a flat structure, but treating groups with
> > nested directories as equal siblings.
> 
> Ah... yeah, flat hierarchy probably is the wrong way to describe it.
> I don't know.  Superficial hierarchy?

Not sure there really is an appropriate two-word name for this
artifact.  How about, pardon my German,
Cgroupfilesystemcontrollerhierarchysemanticsdiscrepancy?
