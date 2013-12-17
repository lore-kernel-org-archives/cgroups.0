From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Date: Tue, 17 Dec 2013 14:12:41 +0100
Message-ID: <20131217131241.GE28991@dhcp22.suse.cz>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
 <20131216163530.GH32509@htj.dyndns.org>
 <20131216171937.GG26797@dhcp22.suse.cz>
 <20131216172143.GJ32509@htj.dyndns.org>
 <alpine.LNX.2.00.1312161718001.2037@eggly.anvils>
 <52AFC163.5010507@huawei.com>
 <20131217122926.GC29989@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131217122926.GC29989-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 17-12-13 07:29:26, Tejun Heo wrote:
> Hello, Li.
> 
> On Tue, Dec 17, 2013 at 11:13:39AM +0800, Li Zefan wrote:
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index c36d906..769b5bb 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -868,6 +868,15 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
> >  		struct cgroup *cgrp = dentry->d_fsdata;
> >  
> >  		BUG_ON(!(cgroup_is_dead(cgrp)));
> > +
> > +		/*
> > +		 * We should remove the cgroup object from idr before its
> > +		 * grace period starts, so we won't be looking up a cgroup
> > +		 * while the cgroup is being freed.
> > +		 */
> 
> Let's remove this comment and instead comment that this is to be made
> per-css.  I mixed up the lifetime rules of the cgroup and css and
> thought css_from_id() should fail once css is confirmed to be offline,
> so the above comment.  It looks like we'll eventually have to move
> cgrp->id to css->id (just simple per-ss idr) as the two objects'
> lifetime rules will be completely separate.  Other than that, looks
> good to me.

Yeah, please remove it. It made me think that idr_remove cannot be
pulled to later and that's why I ruled out css based solution from the
beginning.
-- 
Michal Hocko
SUSE Labs
