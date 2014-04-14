From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: do not use rule acceptance function to
 validate access
Date: Mon, 14 Apr 2014 14:16:12 -0400
Message-ID: <20140414181611.GU29214@redhat.com>
References: <20140414144736.GS29214@redhat.com>
 <20140414180323.GC15249@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140414180323.GC15249-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hi Tejun,

On Mon, Apr 14, 2014 at 02:03:23PM -0400, Tejun Heo wrote:
> On Mon, Apr 14, 2014 at 10:47:54AM -0400, Aristeu Rozanski wrote:
> > may_access() is currently used to validate both new exceptions from children
> > groups and to check if an access is allowed. This not only makes it hard to
> > understand and maintain, but it's also incorrect.
> > 
> > It currently allows one to:
> > 
> > 	# mkdir new_group
> > 	# cd new_group
> > 	# echo $$ >tasks
> > 	# echo "c 1:3 w" >devices.deny
> > 	# echo >/dev/null
> > 	# echo $?
> > 	0
> 
> It'd be nice to explain how this is broken and why the code paths
> can't be shared.

ok

> > This patch implements the device file access check separately and fixes
> > the issue.
> > 
> > This is broken since c39a2a3018f8065cb5ea38b0314c1bbedb2cfa0d
> 
> Please use 12-digits-of-SHA1 ("Subject of the patch") format.

ok

> > After review, this should be considered for stable series.
> > 
> > Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Can you please cc stable on the next posting?

ok

> > -	rc = may_access(dev_cgroup, &ex, dev_cgroup->behavior);
> > +	behavior = dev_cgroup->behavior;
> > +	list_for_each_entry_rcu(ex, &dev_cgroup->exceptions, list) {
> > +		if (type == DEV_BLOCK && !(ex->type & DEV_BLOCK))
> > +			continue;
> > +		if (type == DEV_CHAR && !(ex->type & DEV_CHAR))
> > +			continue;
> > +		if (ex->major != ~0 && major != ex->major)
> > +			continue;
> > +		if (ex->minor != ~0 && minor != ex->minor)
> > +			continue;
> > +		if (access & (~ex->access))
> > +			continue;
> > +		match = true;
> > +		break;
> 
> Can't we at least factor out the above part and share it between the
> two functions?

ok

> Currently, there's a lot of duplication in rather
> delicate code and it's not clear where they differ and why.

Are you referring to the duplication in this patch or other areas too?

-- 
Aristeu
