From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/4] mm: memcontrol: reign in the CONFIG space madness
Date: Tue, 22 Dec 2015 18:38:23 -0500
Message-ID: <20151222233823.GA28111@cmpxchg.org>
References: <1449863653-6546-1-git-send-email-hannes@cmpxchg.org>
 <1449863653-6546-2-git-send-email-hannes@cmpxchg.org>
 <20151212163332.GC28521@esperanza>
 <20151212172057.GA7997@cmpxchg.org>
 <20151222151138.0c35816e53b0f0ad940568bb@linux-foundation.org>
 <20151222151527.b4fd06da45d5c86d193c773d@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151222151527.b4fd06da45d5c86d193c773d-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Dec 22, 2015 at 03:15:27PM -0800, Andrew Morton wrote:
> On Tue, 22 Dec 2015 15:11:38 -0800 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> 
> > What I have is
> 
> And after a bit of reject resolution in
> mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch we
> have
> 
> 
> static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
> {
> 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> 
> 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
> 		static_branch_dec(&memcg_sockets_enabled_key);
> 
> 	vmpressure_cleanup(&memcg->vmpressure);
> 	cancel_work_sync(&memcg->high_work);
> 	mem_cgroup_remove_from_trees(memcg);
> 	memcg_free_kmem(memcg);
> 
> 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_active)
> 		static_branch_dec(&memcg_sockets_enabled_key);
> 
> 	mem_cgroup_free(memcg);
> }
> 
> code looks a bit strange.  Can we move the static_branch_dec's together
> and run cgroup_subsys_on_dfl just once?

Thanks for fixing it up. I think we can at least put the branches next
to each other. Here is what I have in my local tree:

static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
{
	struct mem_cgroup *memcg = mem_cgroup_from_css(css);

	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
		static_branch_dec(&memcg_sockets_enabled_key);

	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_active)
		static_branch_dec(&memcg_sockets_enabled_key);

	vmpressure_cleanup(&memcg->vmpressure);
	cancel_work_sync(&memcg->high_work);
	mem_cgroup_remove_from_trees(memcg);
	memcg_free_kmem(memcg);
	mem_cgroup_free(memcg);
}

However, I don't think turning it into this would be an improvement:

	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
		if (!cgroup_memory_nosocket)
			static_branch_dec(&memcg_sockets_enabled_key);
	} else if (memcg->tcpmem_active) {
		static_branch_dec(&memcg_sockets_enabled_key);
	}

Plus, I'm a little worried that conflating cgroup and cgroup2 blocks
will get us into trouble. Yeah, that code looks a little unusual, but
I can't help but think it's easier to follow the code flow for one
particular mode when the jump labels are always explicit. Then the
brain can easily pattern-match and ignore blocks of the other mode.
It doesn't work the same when we hide keywords in implicit else ifs.
