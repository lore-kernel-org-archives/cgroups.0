From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
Date: Wed, 15 Aug 2012 15:02:28 +0200
Message-ID: <20120815130228.GH23985@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-5-git-send-email-glommer@parallels.com>
 <20120814162144.GC6905@dhcp22.suse.cz>
 <502B6D03.1080804@parallels.com>
 <20120815123931.GF23985@dhcp22.suse.cz>
 <502B9BD4.4070003@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <502B9BD4.4070003-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Wed 15-08-12 16:53:40, Glauber Costa wrote:
[...]
> >>> This doesn't check for the hierachy so kmem_accounted might not be in 
> >>> sync with it's parents. mem_cgroup_create (below) needs to copy
> >>> kmem_accounted down from the parent and the above needs to check if this
> >>> is a similar dance like mem_cgroup_oom_control_write.
> >>>
> >>
> >> I don't see why we have to.
> >>
> >> I believe in a A/B/C hierarchy, C should be perfectly able to set a
> >> different limit than its parents. Note that this is not a boolean.
> > 
> > Ohh, I wasn't clear enough. I am not against setting the _limit_ I just
> > meant that the kmem_accounted should be consistent within the hierarchy.
> > 
> 
> If a parent of yours is accounted, you get accounted as well. This is
> not the state in this patch, but gets added later. Isn't this enough ?

But if the parent is not accounted, you can set the children to be
accounted, right? Or maybe this is changed later in the series? I didn't
get to the end yet.
-- 
Michal Hocko
SUSE Labs
