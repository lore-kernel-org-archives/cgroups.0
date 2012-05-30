From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 12/28] slab: pass memcg parameter to kmem_cache_create
Date: Wed, 30 May 2012 13:01:37 +0200
Message-ID: <20120530110134.GA25094@somewhere.redhat.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
 <1337951028-3427-13-git-send-email-glommer@parallels.com>
 <alpine.DEB.2.00.1205290922340.4666@router.home>
 <4FC4F04F.1070401@parallels.com>
 <alpine.DEB.2.00.1205291131590.6723@router.home>
 <4FC4FAF6.8060900@parallels.com>
 <alpine.DEB.2.00.1205291149280.8406@router.home>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fVACOVlyFYWVpk2c3WOuXvxhgZ8y+EKlwxY+EGuy5UM=;
        b=mYyAmf+lZRIXZikZDIB9dGovWd+a82x3g2ukOF4QdHCdQNcae18c1YShRaYzm4+/nT
         4gMTyQt3OD23+dI7ajyY1bDxhM1rKAgttz24PSVKMJdg5KdnoXpj/6qi+vYpq19YOUN8
         l/efsxejfGDZ7ICz7kCeulI5m9nXoQQOxmUCfRlZT+XKZ0TyJRJ174sSOVFcHV/96uUI
         rJ5wArSNlH0E/+f93YzQNliw6GQnqdZzZ01HAIno+Dg2SQj9pi/P0BathoP0OUrShuWB
         3W7M3CEt6Qa8z0AzV/jVAIDfMD9qpYaP6bnLF2/Q2h4YoBY4pqiFCfmhvlqIJamGCQpf
         4jxg==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205291149280.8406-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Tue, May 29, 2012 at 11:52:55AM -0500, Christoph Lameter wrote:
> On Tue, 29 May 2012, Glauber Costa wrote:
> 
> > > How do you detect that someone is touching it?
> >
> > kmem_alloc_cache will create mem_cgroup_get_kmem_cache.
> > (protected by static_branches, so won't happen if you don't have at least
> > non-root memcg using it)
> >
> > * Then it detects which memcg the calling process belongs to,
> > * if it is the root memcg, go back to the allocation as quickly as we
> >   can
> > * otherwise, in the creation process, you will notice that each cache
> >   has an index. memcg will store pointers to the copies and find them by
> >   the index.
> >
> > From this point on, all the code of the caches is reused (except for
> > accounting the page)
> 
> Well kmem_cache_alloc cache is the performance critical hotpath.
> 
> If you are already there and doing all of that then would it not be better
> to simply count the objects allocated and freed per cgroup? Directly
> increment and decrement counters in a cgroup? You do not really need to
> duplicate the kmem_cache structure and do not need to modify allocators if
> you are willing to take that kind of a performance hit. Put a wrapper
> around kmem_cache_alloc/free and count things.

I believe one of the issues is also that a task can migrate to another cgroup
anytime. But an object that has been charged to a cgroup must be later uncharged
to the same, unless you move the charge as you move the task. But then it means
you need to keep track of the allocations per task, and you also need to be able
to do that reverse mapping (object -> allocating task) because your object can
be allocated by task A but later freed by task B. Then when you do the uncharge
it must happen to the cgroup of A, not the one of B.

That all would be much more complicated and performance sensitive than what this
patchset does. Dealing with duplicate caches for accounting seem to me a good tradeoff
between allocation performance hot path and maintaining cgroups semantics.
