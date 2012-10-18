From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 04/14] kmem accounting basic infrastructure
Date: Thu, 18 Oct 2012 12:37:17 -0700
Message-ID: <20121018193717.GA13370@google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com>
 <1350382611-20579-5-git-send-email-glommer@parallels.com>
 <alpine.DEB.2.00.1210171455010.20712@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lFpwK7+m2ysKQAMNqORMKuKUnmRitvpNGfav1Ija5K4=;
        b=lpcQvAe7RAcpOpG4fv+gtbABxUGUBSCli3LHL+Rr0jLlPMzIkBV1/CAkbHJ6ZxOWio
         9SoDdQJk//ToSPWpElmXXJYIBpruairNPO/kmvaJ7H0vv757ybBXUC4gMue3l5h7RZaq
         DF/n6mgN204B15fG3BRpT9iyxhBs8g4c9moVFv4Q3WCP2U4ZGyBv5GLiWY1j0HTssnRa
         3P4yDRkU8eKmjLr48ion26bY/+I1XyQ1bWuSa7of9rzzfeDL6ARerB1+y4toAH7+Q/0f
         y3eeybivjR1ds8Uyfu6/xD3MqAYbR0GpoUu+V6Zz4szVc4mlFvnB8xeK8NTz8R2Wfp5S
         JUyA==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1210171455010.20712-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, David.

On Wed, Oct 17, 2012 at 03:08:04PM -0700, David Rientjes wrote:
> > +static int memcg_update_kmem_limit(struct cgroup *cont, u64 val)
> > +{
> > +	int ret = -EINVAL;
> > +#ifdef CONFIG_MEMCG_KMEM
> > +	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> > +	/*
> > +	 * For simplicity, we won't allow this to be disabled.  It also can't
> > +	 * be changed if the cgroup has children already, or if tasks had
> > +	 * already joined.
> > +	 *
> > +	 * If tasks join before we set the limit, a person looking at
> > +	 * kmem.usage_in_bytes will have no way to determine when it took
> > +	 * place, which makes the value quite meaningless.
> > +	 *
> > +	 * After it first became limited, changes in the value of the limit are
> > +	 * of course permitted.
> > +	 *
> > +	 * Taking the cgroup_lock is really offensive, but it is so far the only
> > +	 * way to guarantee that no children will appear. There are plenty of
> > +	 * other offenders, and they should all go away. Fine grained locking
> > +	 * is probably the way to go here. When we are fully hierarchical, we
> > +	 * can also get rid of the use_hierarchy check.
> 
> Not sure it's so offensive, it's a pretty standard way of ensuring that 
> cont->children doesn't get manipulated in a race.

cgroup_lock is inherently one of the outermost locks as it protects
cgroup hierarchy and modifying cgroup hierarchy involves invoking
subsystem callbacks which may grab subsystem locks.  Grabbing it
directly from subsystems thus creates high likelihood of creating a
dependency loop and it's nasty to break.

And I'm unsure whether making cgroup locks finer grained would help as
cpuset grabs cgroup_lock to perform actual task migration which would
require the outermost cgroup locking anyway.  This one already has
showed up in a couple lockdep warnings involving static_key usages.

A couple days ago, I posted a patchset to remove cgroup_lock usage
from cgroup_freezer and at least cgroup_freezer seems like it was
aiming for the wrong behavior which led to the wrong locking behavior
requiring grabbing cgroup_lock.  I can't say whether others will be
that easy tho.

Anyways, so, cgroup_lock is in the process of being unexported and I'd
really like another usage isn't added but maybe that requires larger
changes to memcg and not something which can be achieved here.  Dunno.
Will think more about it.

Thanks.

-- 
tejun
