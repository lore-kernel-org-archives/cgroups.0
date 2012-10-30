From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: memcg/cgroup: do not fail fail on pre_destroy callbacks
Date: Wed, 31 Oct 2012 00:37:36 +0100
Message-ID: <20121030233356.GA19496@dhcp22.suse.cz>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
 <20121029232602.GF4066@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121029232602.GF4066-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Mon 29-10-12 16:26:02, Tejun Heo wrote:
> Hello, Michal.
> 
> > Tejun is planning to build on top of that and make some more cleanups
> > in the cgroup core (namely get rid of of the whole retry code in
> > cgroup_rmdir).
> 
> I applied 1-3 to the following branch which is based on top of v3.6.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git cgroup-destroy-updates

Ok, Andrew droped all the patches from his tree and I set up this
branch for automerging to -mm git tree.

> I'll follow up with updates to the destroy path which will replace #4.
> #5 and #6 should be stackable on top.

Could you take care of them and apply those two on top of the first one
which guarantees that css_tryget fails and no new task can appear in the
group (aka #4 without follow up cleanups)? So that Andrew doesn't have
to care about them later.

Thanks!
-- 
Michal Hocko
SUSE Labs
