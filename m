From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] mm/memcontrol.c: remove meaningless while loop in
 mem_cgroup_iter()
Date: Tue, 22 Apr 2014 12:34:21 +0200
Message-ID: <20140422103420.GI29311@dhcp22.suse.cz>
References: <1397861935-31595-1-git-send-email-nasa4836@gmail.com>
 <20140422094759.GC29311@dhcp22.suse.cz>
 <CAHz2CGWrk3kuR=BLt2vT-8gxJVtJcj6h17ase9=1CoWXwK6a3w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHz2CGWrk3kuR=BLt2vT-8gxJVtJcj6h17ase9=1CoWXwK6a3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue 22-04-14 18:17:09, Jianyu Zhan wrote:
> On Tue, Apr 22, 2014 at 5:47 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> > What about
> >   3. last_visited == last_node in the tree
> >
> > __mem_cgroup_iter_next returns NULL and the iterator would return
> > without visiting anything.
> 
> Hi,  Michal,
> 
> yep,  if 3 last_visited == last_node, then this means we have done a round-trip,
> thus __mem_cgroup_iter_next returns NULL, in turn mem_cgroup_iter() return NULL.

Sorry, I should have been more specific that I was talking about
mem_cgroup_reclaim_cookie path where the iteration for this particular
zone and priority ended at the last node without finishing the full
roundtrip last time. This new iteration (prev==NULL) wants to continue
and it should start a new roundtrip.

Makes sense?
-- 
Michal Hocko
SUSE Labs
