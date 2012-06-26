From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: first step towards hierarchical controller
Date: Wed, 27 Jun 2012 00:08:09 +0200
Message-ID: <20120626220809.GA4653@tiehlicka.suse.cz>
References: <1340725634-9017-1-git-send-email-glommer@parallels.com>
 <1340725634-9017-3-git-send-email-glommer@parallels.com>
 <20120626180451.GP3869@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120626180451.GP3869-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue 26-06-12 11:04:51, Tejun Heo wrote:
> On Tue, Jun 26, 2012 at 07:47:14PM +0400, Glauber Costa wrote:
[...]
> > @@ -5221,6 +5225,7 @@ mem_cgroup_create(struct cgroup *cont)
> >  			INIT_WORK(&stock->work, drain_local_stock);
> >  		}
> >  		hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
> > +		memcg->use_hierarchy = true;
> >  	} else {
> >  		parent = mem_cgroup_from_cont(cont->parent);
> >  		memcg->use_hierarchy = parent->use_hierarchy;
> 
> So, ummm, I don't think we can do this.  We CAN NOT silently flip the
> default behavior like this.  Hell, no.  What we can do is something
> like the following.
> 
> 1. Make .use_hierarchy a global property and convert .use_hierarchy
>    file to reject writes to the setting which is different from the
>    global one. 

Yes, that's how I understood your global knob suggestion and I liked it
in the beginning but then I realized that this would just mean "tweak it
to work and don't report anything because that's easy to find in forums"
for most users, which is not good because we would end up stuck in this
half (not)hierarchical state for ever which is not a desirable state -
at least from my POV.

According to my experience, people usually create deeper subtrees
just because they want to have memcg hierarchy together with other
controller(s) and the other controller requires a different topology
but then they do not care about memory.* attributes in parents.
Those cases are not affected by this change because parents are
unlimited by default.
Deeper subtrees without hierarchy and independent limits are usually
mis-configurations, and we would like to hear about those to help to fix
them, or they are unfixable usecases which we want to know about as well
(because then we have a blocker for the unified cgroup hierarchy, don't
we).

>    Rip out partial hierarchy related code (how little
>    they may be).

I double checked this and it's really a surprisingly small amount of
code (I expected much more, to be honest).
The only interesting parts are mem_cgroup_swappiness_write and
mem_cgroup_oom_control_write which don't allow the value setting if
the parent is hierarchical (the values are consistent throughout the
hierarchy). This will need to be changed and it is definitely required
before this change can be introduced (sorry I should have noticed
that sooner). 
Anyway, both changes should be OK to ignore parent's use_hierarchy
because both the reclaim and oom happens on the root of the subtree
which hit the limit (and the global vm_swapiness resp. global OOM will
be used if we get up to root).
So what is the result in the end? We will reduce few annoying
use_hierarchy checks in the end but I guess that the more important
part is a reasonable semantic. Does it really make sense to build non
hierarchical subtrees? How does it work along with other controllers
which are hierarchical?
The original implementation enabled that, all right, but we know that
many things were over-designed in this area (and in cgroups in general)
and we should rather fix them.

>   Note that the default should still be flat hierarchy.
> 
> 2. Mark flat hierarchy deprecated and produce a warning message if
>    memcg is mounted w/o hierarchy option for a year or two.

I would agree with you on this with many kernel configurables but
this one doesn't fall in. There is a trivial fallback (set root to
use_hierarchy=0) so the mount option seems like an overkill - yet
another API to keep for some time...

So in short, I do think we should go the sanity path and end up
with hierarchical trees and sooner we start the better.

> 3. After the existing users had enough chance to move away from flat
>    hierarchy, rip out flat hierarchy code and error if hierarchy
>    option is not specified.
> 
> Later on, we may decide to get rid of the hierarchy mount option but I
> don't think that matters all that much.
> 
> Thanks.
> 
> -- 
> tejun

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
