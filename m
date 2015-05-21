From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
 leader is moved
Date: Thu, 21 May 2015 13:22:17 -0400
Message-ID: <20150521172217.GB12800@cmpxchg.org>
References: <1431978595-12176-1-git-send-email-tj@kernel.org>
 <1431978595-12176-4-git-send-email-tj@kernel.org>
 <20150519121321.GB6203@dhcp22.suse.cz>
 <20150519212754.GO24861@htj.duckdns.org>
 <20150520131044.GA28678@dhcp22.suse.cz>
 <20150520132158.GB28678@dhcp22.suse.cz>
 <20150520175302.GA7287@redhat.com>
 <20150520202221.GD14256@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520202221.GD14256-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, May 20, 2015 at 10:22:21PM +0200, Michal Hocko wrote:
> On Wed 20-05-15 19:53:02, Oleg Nesterov wrote:
> > On 05/20, Michal Hocko wrote:
> > >
> > > So I assume the leader simply waits for its threads to finish and it
> > > stays in the sibling list. __unhash_process seems like it does the final
> > > cleanup and unlinks the leader from the lists. Which means that
> > > mm_update_next_owner never sees !group_leader. Is that correct Oleg?
> > 
> > Yes, yes, the group leader can't go away until the whole thread-group dies.
> 
> OK, then we should have a guarantee that mm->owner is always thread
> group leader, right?
> 
> > But can't we kill mm->owner somehow?
> 
> I would be happy about that. But it is not that simple.
> 
> > I mean, turn it into something else,
> > ideally into "struct mem_cgroup *" although I doubt this is possible.
> 
> Sounds like a good idea but... it duplicates the cgroup tracking into
> two places and that asks for troubles. On the other hand we are doing
> that already because mm->owner might be in a different cgroup than the
> current. However, this is an inherent problem because CLONE_VM doesn't
> imply CLONE_THREAD. So in the end it doesn't look much worse IMO.
> We will loose the "this task is in charge" aspect and that would
> be a user space visible change but I am not sure how much it is a
> problem. Maybe somebody is (ab)using this to workaround the restriction
> that all threads are in the same cgroup.

If mm->owner is currently always the threadgroup leader, it should be
fairly straight forward to maintain mm->memcg on all events that move
any threadgroup leader between cgroups, without having mm->owner, no?

It would have a lot of benefits for sure.  The code would be simpler,
but it would also reduce some of the cost that Mel is observing inside
__mem_cgroup_count_vm_event(), by reducing one level of indirection.
