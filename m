From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/19] mm: memcontrol: switch to native NR_FILE_PAGES and
 NR_SHMEM counters
Date: Wed, 10 Jun 2020 18:42:22 +0200
Message-ID: <20200610164222.GE20204@dhcp22.suse.cz>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
 <20200508183105.225460-10-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200508183105.225460-10-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri 08-05-20 14:30:56, Johannes Weiner wrote:
> Memcg maintains private MEMCG_CACHE and NR_SHMEM counters. This
> divergence from the generic VM accounting means unnecessary code
> overhead, and creates a dependency for memcg that page->mapping is set
> up at the time of charging, so that page types can be told apart.
> 
> Convert the generic accounting sites to mod_lruvec_page_state and
> friends to maintain the per-cgroup vmstat counters of NR_FILE_PAGES
> and NR_SHMEM. The page is already locked in these places, so
> page->mem_cgroup is stable; we only need minimal tweaks of two
> mem_cgroup_migrate() calls to ensure it's set up in time.
> 
> Then replace MEMCG_CACHE with NR_FILE_PAGES and delete the private
> NR_SHMEM accounting sites.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

While looking at the code I've noticed that add_to_swap_cache resp.
__delete_from_swap_cache are accounting only to global counters.
Is there any reason for that? Not something that this patch is
responsible for of course but I am just wondering.
-- 
Michal Hocko
SUSE Labs
