From: "Christopherson, Sean J" <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/2] mm/memcontrol: fix reclaim bugs in mem_cgroup_iter
Date: Tue, 2 May 2017 14:20:45 +0000
Message-ID: <37306EFA9975BE469F115FDE982C075B9B704A9A@ORSMSX108.amr.corp.intel.com>
References: <1493416547-19212-1-git-send-email-sean.j.christopherson@intel.com>
 <20170502140357.GL14593@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170502140357.GL14593-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: 'Michal Hocko' <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Fri 28-04-17 14:55:45, Sean Christopherson wrote:
> > This patch set contains two bug fixes for mem_cgroup_iter().  The bugs
> > were found by code inspection and were confirmed via synthetic testing
> > that forcefully setup the failing conditions.
> 
> I assume that you added some artificial sleeps to make those races more
> probable, right? Or did you manage to hit those issue solely from the
> userspace? I will have a look at those patches. It has been some time
> since I've had it cached. It is pretty subtle code so I would like to
> understand the urgency before I dive into this further.
> -- 
> Michal Hocko
> SUSE Labs

The code to prove the bugs is completely artificial, it's basically a
unit test for mem_cgroup_iter() that uses a thread barrier to all but
guarantee two threads will call mem_cgroup_iter() simultaneously.  I
haven't even attempted to hit this via the actual userspace flow.
