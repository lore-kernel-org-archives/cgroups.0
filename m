From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Fri, 20 May 2016 13:49:38 -0400
Message-ID: <20160520174938.GF5632@htj.duckdns.org>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
 <573F23D0.2030500@suse.de>
 <20160520152244.GB5632@htj.duckdns.org>
 <1463758258.8091.3.camel@HansenPartnership.com>
 <20160520160352.GC5632@htj.duckdns.org>
 <1463760550.8091.13.camel@HansenPartnership.com>
 <20160520161759.GD5632@htj.duckdns.org>
 <1463761509.8091.19.camel@HansenPartnership.com>
 <20160520165326.GE5632@htj.duckdns.org>
 <1463765326.8091.42.camel@HansenPartnership.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SbSN7fHfJN15mEdCxDicOWKmqlO8T9YolpA4sp3X5aI=;
        b=tw7B+SK30NSwpT9Xj4DeXAmXs+zWUORvh+JElGnP6SziO6D3L2aR3En95GJfIKE2y6
         3yw6Hpz3CeRyuupD296EFWyzIJ2UVkAsEtc7v738HTbbmjqZ2lyS6GJdJpImJGwsFnvf
         FTnj9Wqyf1RGe+0uyyIrcABZEmuqcF/PrHrnqr6htFsQmKLQmvjLQspxs4Ivif0OG6ZX
         9XNHPeYOOLs7/idq12n0Dj1rzcXUTkpwyX1802LF++Z3rXCGcyj+woiL/g55H8880m6K
         buYNzP1H75PkD9kpGmOv1D9yC6Ues2f01DVN0f1oeYSM/I2oz0e43JdtaG5dZFS4Og9d
         JmsQ==
Content-Disposition: inline
In-Reply-To: <1463765326.8091.42.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

Hello, James.

On Fri, May 20, 2016 at 01:28:46PM -0400, James Bottomley wrote:
> Just so I'm clear: by delegation you mean create a subdirectory in the
> cgroup hierarchy with a non-root owner?  We may have a solution for the
> escape constraints problem: see below.

Yeah, there's delegation section in cgroup-v2.txt.

> > Unfortunately, cgroup hierarchy isn't designed to support this sort 
> > of automatic delegation.  Unpriv processes would be able to escape
> > constraints on v1 with some controllers and on v2 controllers have to
> > be explicitly enabled by root for delegated scope to have access to
> > them.
> 
> Not necessarily.  We also talked about pinning the cgroup tree so that
> once you enter the cgroup namespace, your current cgroup directory
> becomes your root, meaning you can't cd back into the ancestors and
> thus can't write their tasks file, meaning, I think, that it should be
> impossible to escape ancestor constraints.

I wish it were that clean.  Unfortunately, on v1, some controllers
(memory and blkio depending on settings, netcls and netprio always)
simply aren't properly hierarchical and if you have write perm to
subdirectory you can escape the constraints of your ancestors.
Whether you can cd back up or not doesn't matter at all, so we can't
allow delegation by default.

> > Why does an unpriv NS need to have cgroup delegated to it without
> > cooperation from cgroup manager?
> 
> There's actually many answers to this.  The one I'm insterested in is
> the ability for applications to make use of container features without
> having to ask permission from some orchestration engine.  The problem

What's "container features"?  Do you mean resource control by that?

> most people are looking at is how do I prevent the cgroup manager from
> running as root, because that's a security problem waiting to happen.

It's distributing system wide resources so the top of the tree will
always be owned by root and delegating subtrees is a fairly minimal
operation.  I don't see how that would necessarily lead to security
problems.

> >   If for resource control, I'm pretty sure we don't want to allow 
> > that without explicit cooperation from the enclosing scope.
> 
> The enclosing scope should be allowed to define the parameters (happens
> today with namespaces) but there shouldn't be an active "thing" which
> is the permission gateway.

It's not that I fundamentally disagree that that'd be nice to have
but, given the way cgroup is designed and implemented currently, I'm
not sure this is a feasible goal.

Thanks.

-- 
tejun
