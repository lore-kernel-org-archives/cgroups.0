From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
Date: Tue, 26 Jun 2012 21:01:32 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206262100320.24245@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-7-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206260210200.16020@chino.kir.corp.google.com> <4FE97E31.3010201@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=p9h0jnq1iACkNJDEca8vQLCJ/y79L401kh/BIJGLFX4=;
        b=O9PcFy9PaQzjA7k6xZkgfP2Bs+Fov0phKBLIBpjkoE3GM7dhltKFYw1KQB5mITz6nk
         PXOmzt6HGs233+G7RATFV/GwqsGFg4F+Go1eWv9/bcCjkrRtFN2+Y0eJLvorijDzvCnw
         p0Ig90LJbZqET36RgMrgdtcY4/LHP9wputIo+7jvMiQwpcMEgzBEfXgo7Nyw3oRL3AaR
         KYknIAlmV8DCeXbACuZWawBrEAPbp+B3D6mkMtWWnGsBrvjvLk+AjeEMhKxeZeDgTkVw
         LuGGTJTuhUDw0ei6prmqVsz2oyednNnYMfkv0Tp8xHZvoN7TzneTKdU0Or7sGQABJQtZ
         lnxA==
In-Reply-To: <4FE97E31.3010201@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>

On Tue, 26 Jun 2012, Glauber Costa wrote:

> > > @@ -416,6 +423,43 @@ static inline void sock_update_memcg(struct sock *sk)
> > >   static inline void sock_release_memcg(struct sock *sk)
> > >   {
> > >   }
> > > +
> > > +#define mem_cgroup_kmem_on 0
> > > +#define __mem_cgroup_new_kmem_page(a, b, c) false
> > > +#define __mem_cgroup_free_kmem_page(a,b )
> > > +#define __mem_cgroup_commit_kmem_page(a, b, c)
> > > +#define is_kmem_tracked_alloc (false)
> > >   #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
> > > +
> > > +static __always_inline
> > > +bool mem_cgroup_new_kmem_page(gfp_t gfp, void *handle, int order)
> > > +{
> > > +	if (!mem_cgroup_kmem_on)
> > > +		return true;
> > > +	if (!is_kmem_tracked_alloc)
> > > +		return true;
> > > +	if (!current->mm)
> > > +		return true;
> > > +	if (in_interrupt())
> > > +		return true;
> > 
> > You can't test for current->mm in irq context, so you need to check for
> > in_interrupt() first.
> >
> Right, thanks.
> 
> > Also, what prevents __mem_cgroup_new_kmem_page()
> > from being called for a kthread that has called use_mm() before
> > unuse_mm()?
> 
> Nothing, but I also don't see how to prevent that.

You can test for current->flags & PF_KTHREAD following the check for 
in_interrupt() and return true, it's what you were trying to do with the 
check for !current->mm.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
