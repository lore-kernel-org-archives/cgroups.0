From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
	leader is moved
Date: Wed, 20 May 2015 19:53:02 +0200
Message-ID: <20150520175302.GA7287@redhat.com>
References: <1431978595-12176-1-git-send-email-tj@kernel.org> <1431978595-12176-4-git-send-email-tj@kernel.org> <20150519121321.GB6203@dhcp22.suse.cz> <20150519212754.GO24861@htj.duckdns.org> <20150520131044.GA28678@dhcp22.suse.cz> <20150520132158.GB28678@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520132158.GB28678-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 05/20, Michal Hocko wrote:
>
> So I assume the leader simply waits for its threads to finish and it
> stays in the sibling list. __unhash_process seems like it does the final
> cleanup and unlinks the leader from the lists. Which means that
> mm_update_next_owner never sees !group_leader. Is that correct Oleg?

Yes, yes, the group leader can't go away until the whole thread-group dies.

But can't we kill mm->owner somehow? I mean, turn it into something else,
ideally into "struct mem_cgroup *" although I doubt this is possible.

It would be nice to kill mm_update_next_owner()/etc, this looks really
ugly. We only need it for mem_cgroup_from_task(), and it would be much
more clean to have mem_cgroup_from_mm(struct mm_struct *mm), imho.

Oleg.
