From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 14:19:07 -0700
Message-ID: <20120626211907.GX3869@google.com>
References: <1340725634-9017-1-git-send-email-glommer@parallels.com>
 <1340725634-9017-3-git-send-email-glommer@parallels.com>
 <20120626180451.GP3869@google.com>
 <20120626185542.GE27816@cmpxchg.org>
 <20120626191450.GT3869@google.com>
 <20120626205924.GH27816@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=G80BtrOOIyYZsWftHxKT+EGnulGYRtG006wjdbnmg10=;
        b=GNnWOAtzNbknwT0s1mZjA66ke45W8JBWK74pWG9B2Fwmzf52AOKWnLEPG98TxEmuiV
         f7o0PP8oyJ8h6ibIhpnnNGZdcmzOQg4QyTCk5iwKZf+lcPwYWbMfquE71shn03NZqLwB
         D+ivqXyxgc+VAhGr7Y+FxDl5k83OdPdGv5QliMMBQGSBWKKiWfimS2iMGUxzSCX0eoYZ
         YdHp9HoQjkp94IeLYNn6KOAz/sizab2k/QS2EkB/SrNhe9K5dXRLMs24P7yvS93Hsrzl
         hb/f9wWmyuA0yrFOkjOgh3mjqHrPYaQU6F4Z7Tssi9KutNDujBM7OPL+QI+BvPDyVeTC
         8BRQ==
Content-Disposition: inline
In-Reply-To: <20120626205924.GH27816-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Johannes.

On Tue, Jun 26, 2012 at 10:59:24PM +0200, Johannes Weiner wrote:
> > How do we know that?  At least from what I see from blkcg usage,
> > people do crazy stuff when given crazy interface and we've been
> > providing completely crazy interface for years.  We cannot switch t=
hat
> > implicitly - the changed default behavior is drastically different =
and
> > even could be difficult to chase down.  Transitions towards good
> > behavior are good but they have to be explicit.
>=20
> I can't really argue against this because this can't be anything but =
a
> handwaving contest.  We simply have no data.

The problem is that we can't know for sure until we make it explode
and, once we make it explode, well, it has exploded.

> Backward compatibility is a really good idea but I think it depends o=
n
> the situation:
>=20
>   I don't expect such a configuration to happen by accident because
>   this behaviour is against fundamental expectations users have towar=
d
>   a filesystem, which is the hierarchical nature of nested entities.
>=20
>   I also don't expect it to happen intentionnaly, simply because ther=
e
>   is nothing to gain from a more complicated nested setup.

I agree it's a feature which no sane person should be using but if you
look at the cgroup interface as whole, sadly, sanity is fairly scarce.
Nothing prevents one from mounting cpu and mem on the same hierarchy
expecting hierarchical control for cpus while using flat enforcement
on mem.  That was the default behavior after all.

>   And because there is nothing to gain, it is in addition really
>   trivial to fix the insane setups by simply undoing the nesting,
>   there is no downside for them.

I have to disagree with that.  Deployment sometimes can be very
painful.  In some cases, even flipping single parameter in sysfs
depending on kernel version takes considerable effort.  The behavior
has been the contract that we offered userland for quite some time
now.  We shouldn't be changing that underneath them without any clear
way for them to notice it.

> The only point where I agree with you is that it may indeed be
> non-obvious to detect in case you were relying on the filesystem
> hierarchy not being reflected in the controller hierarchy.  But even
> that depends on the usecase, whether it's a subtle performance
> regression or a total failure to execute a previously supported
> workload, which would be pretty damn obvious.

And imagine that happening in serveral thousand machine cluster with
fairly complicated cgroup setup and kernel update rolling out for
subset of machine types.  I would be screaming bloody murder.

> > > I would hate if people had to jump through hoops to get the only
> > > behaviour we want to end up supporting and to not get yelled at, =
it
> > > sends all the wrong signals.
> >=20
> > It is inconvenient but that's the price that we have to pay for hav=
ing
> > been stupid.  Kernel flipping behavior implicitly is far worse than
> > any such inconvenience.
>=20
> That's a matter of taste.  It's not inconvenient for us, but for ever=
y
> normal person trying to use the feature in a sane way, just to suppor=
t
> hypothetical crazy people when there is a really trivial solution for
> the crazy people's problem.

To me, this doesn't seem to be a matter of taste.  This is crossing
the line.  Note that the said inconvenience is likely to be felt only
by distros or admins and what should be done to remedy the situation
will be obvious.  I agree it isn't ideal but such is life, I suppose.

> > The kernel should nudge mainline users towards new behavior while
> > providing distros / admins a way to move to the new behavior.  The
> > kernel itself can't flip it like that.
>=20
> I thought it was the kernel's job to provide sensible defaults and th=
e
> distro's job to ease transitions...

Yeah, sure, and we failed horribly at providing sensible default here.
The right thing to do now is to gradually move towards the better
default.

> > Ah... yeah, flat hierarchy probably is the wrong way to describe it=
=2E
> > I don't know.  Superficial hierarchy?
>=20
> Not sure there really is an appropriate two-word name for this
> artifact.  How about, pardon my German,
> Cgroupfilesystemcontrollerhierarchysemanticsdiscrepancy?

I'd like more Schei=DFe in there please.

Thanks.

--=20
tejun
