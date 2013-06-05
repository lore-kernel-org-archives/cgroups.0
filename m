From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Wed, 5 Jun 2013 10:50:21 -0400
Message-ID: <20130605145021.GR15576@cmpxchg.org>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
 <1370306679-13129-4-git-send-email-tj@kernel.org>
 <20130604131843.GF31242@dhcp22.suse.cz>
 <20130604205025.GG14916@htj.dyndns.org>
 <20130604212808.GB13231@dhcp22.suse.cz>
 <20130604215535.GM14916@htj.dyndns.org>
 <20130605073023.GB15997@dhcp22.suse.cz>
 <20130605082023.GG7303@mtj.dyndns.org>
 <20130605143949.GQ15576@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130605143949.GQ15576-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Jun 05, 2013 at 10:39:49AM -0400, Johannes Weiner wrote:
> On Wed, Jun 05, 2013 at 01:20:23AM -0700, Tejun Heo wrote:
> > Hello, Michal.
> > 
> > On Wed, Jun 05, 2013 at 09:30:23AM +0200, Michal Hocko wrote:
> > > > We aren't talking about something gigantic or can
> > > 
> > > mem_cgroup is 888B now (depending on configuration). So I wouldn't call
> > > it negligible.
> > 
> > Do you think that the number can actually grow harmful?  Would you be
> > kind enough to share some calculations with me?
> 
> 5k cgroups * say 10 priority levels * 1k struct mem_cgroup may pin 51M
> of dead struct mem_cgroup, plus whatever else the css pins.

Bleh, ... * nr_node_ids * MAX_NR_ZONES.  So it is a couple hundred MB
in that case.
