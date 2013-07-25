From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 0/8] memcg, cgroup: kill css_id
Date: Thu, 25 Jul 2013 09:41:46 +0200
Message-ID: <20130725074146.GC12818@dhcp22.suse.cz>
References: <51EFA554.6080801@huawei.com>
 <20130724143214.GL2540@dhcp22.suse.cz>
 <51F07863.2070705@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51F07863.2070705-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu 25-07-13 08:59:15, Li Zefan wrote:
> On 2013/7/24 22:32, Michal Hocko wrote:
> > On Wed 24-07-13 17:58:44, Li Zefan wrote:
> >> This patchset converts memcg to use cgroup->id, and then we can remove
> >> cgroup css_id.
> >>
> >> As we've removed memcg's own refcnt, converting memcg to use cgroup->id
> >> is very straight-forward.
> >>
> >> The patchset is based on Tejun's cgroup tree.
> > 
> > Does it depend on any particular patches? I am asking because I would
> > need to cherry pick those and apply them into my -mm git tree before
> > these.
> > 
> 
> Nope, but you should see a few but small conflicts if you apply them to
> your git tree.
 
Ohh, then there is no problem at all and Tejun, doesn't have to prepare
any special branch.

Thanks!
-- 
Michal Hocko
SUSE Labs
