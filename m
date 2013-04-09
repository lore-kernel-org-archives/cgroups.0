From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/8] cgroup: implement cgroup_is_ancestor()
Date: Tue, 9 Apr 2013 08:42:49 +0200
Message-ID: <20130409064239.GA29860@dhcp22.suse.cz>
References: <51627DA9.7020507@huawei.com>
 <51627DBB.5050005@huawei.com>
 <20130408144750.GK17178@dhcp22.suse.cz>
 <20130408180335.GA22512@dhcp22.suse.cz>
 <20130408213646.GB17159@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130408213646.GB17159-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 08-04-13 14:36:46, Tejun Heo wrote:
> On Mon, Apr 08, 2013 at 08:03:44PM +0200, Michal Hocko wrote:
> > __mem_cgroup_same_or_subtree relies on css_is_ancestor if hierarchy is
> > enabled for ages. This, however, is not correct because use_hierarchy
> > doesn't need to be true all the way up the cgroup hierarchy. Consider
> > the following example:
> > root (use_hierarchy=0)
> >  \
> >   A (use_hierarchy=0)
> >    \
> >     B (use_hierarchy=1)
> >      \
> >       C (use_hierarchy=1)
> > 
> > __mem_cgroup_same_or_subtree(A, C) would return true even though C is
> > not from the same hierarchy subtree. The bug shouldn't be critical but
> > at least dump_tasks might print unrelated tasks (via
> > task_in_mem_cgroup).
> 
> Huh?  Isn't that avoided by the !root_memcg->use_hierarchy test?

Yes, it is. My selective blindness strikes again :/ I was convinced that
it was memcg we tested use_hierarchy for...
Sorry about all the churn.

> > @@ -1470,9 +1470,12 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
> >  {
> >  	if (root_memcg == memcg)
> >  		return true;
> > -	if (!root_memcg->use_hierarchy || !memcg)
>             ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > +	if (!memcg)
> >  		return false;
> > -	return css_is_ancestor(&memcg->css, &root_memcg->css);
> > +	while ((memcg = parent_mem_cgroup(memcg)))
> > +		if (memcg == root_memcg)
> > +			return true;
> > +	return false;
> >  }
> >  
-- 
Michal Hocko
SUSE Labs
