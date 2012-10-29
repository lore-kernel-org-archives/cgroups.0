From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 3/6] memcg: Simplify mem_cgroup_force_empty_list error
 handling
Date: Mon, 29 Oct 2012 17:58:45 +0400
Message-ID: <508E8B95.406@parallels.com>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz> <1351251453-6140-4-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351251453-6140-4-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


> 
> Changes since v1
> - use kerndoc
> - be more specific about mem_cgroup_move_parent possible failures
> 
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

> + * move charges to its parent or the root cgroup if the group has no
> + * parent (aka use_hierarchy==0).
> + * Although this might fail (get_page_unless_zero, isolate_lru_page or
> + * mem_cgroup_move_account fails) the failure is always temporary and
> + * it signals a race with a page removal/uncharge or migration. In the
> + * first case the page is on the way out and it will vanish from the LRU
> + * on the next attempt and the call should be retried later.
> + * Isolation from the LRU fails only if page has been isolated from
> + * the LRU since we looked at it and that usually means either global
> + * reclaim or migration going on. The page will either get back to the
> + * LRU or vanish.

I just wonder for how long can it go in the worst case?
