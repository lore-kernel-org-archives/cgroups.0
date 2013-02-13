From: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: Add memory.pressure_level events
Date: Tue, 12 Feb 2013 23:19:22 -0800
Message-ID: <20130213071922.GB20543@lizard.gateway.2wire.net>
References: <20130211000220.GA28247@lizard.gateway.2wire.net>
 <5118C522.3070905@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5118C522.3070905-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Leonid Moiseichuk <leonid.moiseichuk-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

Hi Glauber,

On Mon, Feb 11, 2013 at 02:17:06PM +0400, Glauber Costa wrote:
[...]
> > +static struct vmpressure *vmpressure_parent(struct vmpressure *vmpr)
> > +{
> > +	struct cgroup *cg = vmpr_to_css(vmpr)->cgroup->parent;
> > +
> > +	if (!cg)
> > +		return NULL;
> > +	return cg_to_vmpr(cg);
> > +}
> 
> Unfortunately, "parent" in memcg have different meanings for information
> propagation purposes depending on the value of the flag "use_hierarchy".
> That is set for deprecation, but still...
> 
> I suggest you use the helper mem_cgroup_parent, that will already give
> you the right parent (either immediate parent or root) with all that
> taken into account.

Got it, will change.

[...]
> > +void __init enable_pressure_cgroup(void)
> > +{
> > +	WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys,
> > +				   vmpressure_cgroup_files));
> > +}
> 
> There is no functionality discovery going on here, and this is
> conditional on nothing. Isn't it better then to just add the register +
> read functions to memcontrol.c and add the files in the memcontrol cftype ?

I was trying to make the stuff similar to the existing CONFIG_MEMCG_SWAP
code, which does this kind of adding files to the cgroup. But I can surely
place files into memcontrol cftype as you suggest.

Thanks a lot for the comments!

Anton
