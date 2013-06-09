From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: do not account memory used for cache creation
Date: Sun, 9 Jun 2013 15:57:44 +0400
Message-ID: <20130609115742.GA5315@localhost.localdomain>
References: <1370355059-24968-1-git-send-email-glommer@openvz.org>
 <20130607092132.GE8117@dhcp22.suse.cz>
 <51B1B1E9.1020701@parallels.com>
 <20130607141204.GG8117@dhcp22.suse.cz>
 <51B1F1FD.7000002@gmail.com>
 <20130607155406.GL8117@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Hv/kEeiz0uPl6m/sSGaY+RKMmysXNkFeHYJZmnfj0Z8=;
        b=jLsBX+BFQvO1YNRoELeu4Xm2J3f12cGUaNq51Ue8YcyFQLFQJIbhrcAwiUMoeZr//E
         XJo34iiG7ML21qVayn2lms2APXtajuW6mVXUY/ouM/xSyUcmlJd9V1osHgg2FEJPkNnx
         CK3Ud6BInaFttgydDMuGtrY6fNqg2BKnkmSKLVUXHXR5zuEu28IbwO+LFXelHqCDKpUW
         E/a4/snRFtZNLaNaq5+ciyRnk9evKjZOezbPx6lAIbztZ4DLULG2UVdJPqjoRr5S0kYW
         qbFphyvY8LCkcea6Vhq2rY/V+x27l4E1jhX66lOFVyr5UmHpD8oIgevPxP+4ia8sIOwF
         RymQ==
Content-Disposition: inline
In-Reply-To: <20130607155406.GL8117-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On Fri, Jun 07, 2013 at 05:54:06PM +0200, Michal Hocko wrote:
> On Fri 07-06-13 18:45:17, Glauber Costa wrote:
> > On 06/07/2013 06:12 PM, Michal Hocko wrote:
> > >On Fri 07-06-13 14:11:53, Glauber Costa wrote:
> > >>On 06/07/2013 01:21 PM, Michal Hocko wrote:
> > >>>On Tue 04-06-13 18:10:59, Glauber Costa wrote:
> > >>>>The memory we used to hold the memcg arrays is currently accounted to
> > >>>>the current memcg.
> > >>>
> > >>>Maybe I have missed a train but I thought that only some caches are
> > >>>tracked and those have to be enabled explicitly by using __GFP_KMEMCG in
> > >>>gfp flags.
> > >>
> > >>No, all caches are tracked. This was set a long time ago, and only a
> > >>very few initial versions differed from this. This barely changed over
> > >>the lifetime of the memcg patchset.
> > >>
> > >>You probably got confused, due to the fact that only some *allocations*
> > >
> > >OK, I was really imprecise. Of course any type of cache might be tracked
> > >should the allocation (which takes gfp) say so. What I have missed is
> > >that not only stack allocations say so but also kmalloc itself enforces
> > >that rather than the actual caller of kmalloc. This is definitely new
> > >to me. And it is quite confusing that the flag is set only for large
> > >allocations (kmalloc_order) or am I just missing other parts where
> > >__GFP_KMEMCG is set unconditionally?
> > >
> > >I really have to go and dive into the code.
> > >
> > 
> > Here is where you are getting your confusion: we don't track caches,
> > we track *pages*.
> > 
> > Everytime you pass GFP_KMEMCG to a *page* allocation, it gets tracked.
> > Every memcg cache - IOW, a memcg copy of a slab cache, sets
> > GFP_KMEMCG for all its allocations.
> 
> yes that is clear to me.
> 
> > Now, the slub - and this is really an implementation detail -
> > doesn't have caches for high order kmalloc caches. Instead, it gets
> > pages directly from the page allocator. So we have to mark them
> > explicitly. (they are a cache, they are just not implemented as
> > such)
> 
> I am still confused. If kmalloc_large_node is called because the size of
> the object is larger than SLUB_MAX_SIZE then __GFP_KMEMCG is added
> automatically regardless what _caller_ of kmalloc said. What am I
> missing?
>  

You are not missing anything, I am.

It was not a problem since now because all allocations being bypassed
were pretty small - so I got blinded by this.

The logic I have explained to you is correct and will for 100 % of the
time for the SLAB. The SLUB allocator, however, will ignore our bypassing
request because it will never get to memcg_kmem_get_cache.

It doesn't hurt to have the bypass check at memcg_kmem_newpage_charge as
well, so I will add it - Thank you very much for noticing this.

The only situation in which it *could* hurt to have an extra check in there,
is if we decide to bypass the allocations somewhere inside the slab caches
themselves, in such a way that we would select a memcg cache at
memcg_kmem_get_cache, but then insert a non-memcg page in it because between
the cache selection and the allocation there was a bypass request.

As long as we keep the bypass requests memcg-internal, it should not be
a problem.

So in a summary: We will need two patches instead of one to tackle this.
I will send you shortly.
