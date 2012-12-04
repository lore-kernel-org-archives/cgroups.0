From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] Disable swap cgroup allocation at system boot
 stage
Date: Tue, 4 Dec 2012 14:18:27 +0100
Message-ID: <20121204131827.GD1343@dhcp22.suse.cz>
References: <50BDB5E0.7030906@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50BDB5E0.7030906-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Tue 04-12-12 16:35:44, Jeff Liu wrote:
> Hello,

Hi,

> 
> Currently, we allocate pages for swap cgroup when the system is booting up.

That is not precise. We do that during _swapon_ time which usually
happen during boot but still...

> Which means that a particular size of pre-allocated memory(depending
> on the total size of the enabled swap files/partitions) would be
> wasted if there is no child memcg being alive.
>
> This patch set is intended to defer the memory allocation for swap
> cgroup until the first children of memcg was created. Actually, it was
> totally inspired by Glabuer's previous proposed patch set, which can
> be found at: "memcg: do not call page_cgroup_init at system_boot".
> http://lwn.net/Articles/517562/
>
> These patches works to me with some sanity check up.  There must
> have some issues I am not aware of for now, at least, performing
> swapon/swapoff when there have child memcg alives can run into some
> potential race conditions that would end up go into bad_page() path...

The locking is kind of awkward because there are indirect locking
dependencies which are not described anywhere.

> but I'd like to post it early to seek any directions if possible, so
> that I can continue to improve it.

Besides small things I have commented on already there is one bigger
issue. You are assuming that the swap tracking is applicable only
if there is at least one cgroup but the root. This is usually true
because we cannot set up any limit for the root cgroup. But this
doesn't consider that we do _tracking_ even though there is no limit
for the root cgroup. This is important as soon as a task is moved
to other group (with immigrate_on_move enabled). Your series would
cause that the swapped out pages wouldn't be migrated (have a look at
swap_cgroup_cmpxchg). Maybe this is can be tricked out somehow (e.g.
return a root cgroup id if the swap_cgroup is 0).

The patches should be also cleaned up a bit and changelogs enhanced to
be more descriptive. I would suggest the following split up
	- swap_cgroup_swapon should only setup ctrl->length and move the
	  rest to swap_cgroup_prepare
	- introduce memsw_accounting_users (have it 1 by default now)
	  and call swap_cgroup_prepare only if it is > 1. Same applies
	  to lookup_swap_cgroup
	- hackaround charge moving from the root cgroup
	- make memsw_accounting_users 0 by default and increment it on
	  a first non-root cgroup creation + call swap_cgroup_swapon.
	- (optionally) deallocate swap accounting structures on the last
	  non-root cgroup removal - I am not sure this is really
	  necessary but if it is then it should be done only after all
	  references to the memcg are gone rather than from
	  mem_cgroup_destroy

Thanks!
-- 
Michal Hocko
SUSE Labs
