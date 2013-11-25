From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.12] cgroup: make cgroup_event specific
 to memcg
Date: Mon, 25 Nov 2013 11:33:12 +0100
Message-ID: <20131125103312.GA11849@dhcp22.suse.cz>
References: <1376582550-12548-1-git-send-email-tj@kernel.org>
 <20131110044811.GA25112@mtj.dyndns.org>
 <20131111141010.GB14497@dhcp22.suse.cz>
 <20131122233947.GH8981@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131122233947.GH8981-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 22-11-13 18:39:47, Tejun Heo wrote:
> Hello,
> 
> On Mon, Nov 11, 2013 at 03:10:10PM +0100, Michal Hocko wrote:
> > On Sun 10-11-13 13:48:11, Tejun Heo wrote:
> > > Hey, guys.
> > > 
> > > I'll route this series through the cgroup tree with the acks added
> > > once v3.13-rc1 drops.
> > 
> > Do you have it a local branch which I can merge into mm git tree?
> 
> Applied to cgroup/memcg_event which is based on top of v3.12 and then
> pulled into cgroup/for-3.14.  Both branches are stable.  Please feel
> free to use any.

Cool! Thanks Tejun.
 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git memcg_event
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.14
> 
> Thanks.
> 
> -- 
> tejun

-- 
Michal Hocko
SUSE Labs
