From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/4] mm: memcontrol: reign in the CONFIG space madness
Date: Tue, 22 Dec 2015 15:11:38 -0800
Message-ID: <20151222151138.0c35816e53b0f0ad940568bb@linux-foundation.org>
References: <1449863653-6546-1-git-send-email-hannes@cmpxchg.org>
	<1449863653-6546-2-git-send-email-hannes@cmpxchg.org>
	<20151212163332.GC28521@esperanza>
	<20151212172057.GA7997@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151212172057.GA7997-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sat, 12 Dec 2015 12:20:57 -0500 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> On Sat, Dec 12, 2015 at 07:33:32PM +0300, Vladimir Davydov wrote:
> > On Fri, Dec 11, 2015 at 02:54:11PM -0500, Johannes Weiner wrote:
> > > What CONFIG_INET and CONFIG_LEGACY_KMEM guard inside the memory
> > > controller code is insignificant, having these conditionals is not
> > > worth the complication and fragility that comes with them.
> > > 
> > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > 
> > Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> > 
> > > @@ -4374,17 +4342,11 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
> > >  {
> > >  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> > >  
> > > -#ifdef CONFIG_INET
> > >  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
> > >  		static_branch_dec(&memcg_sockets_enabled_key);
> > > -#endif
> > > -
> > > -	memcg_free_kmem(memcg);
> > 
> > I wonder where the second call to memcg_free_kmem comes from. Luckily,
> > it couldn't result in a breakage. And now it's removed.
> 
> Lol, I had to double check my trees to see what's going on as I don't
> remember this being part of the patch. But it looks like the double
> free came from the "net: drop tcp_memcontrol.c" patch and I must have
> removed it again during conflict resolution when rebasing this patch
> on top of yours. I must have thought git's auto-merge added it.
> 
> However, this causes an underflow of the kmem static branch, so we
> will have to fix this directly in "net: drop tcp_memcontrol.c".
> 
> Andrew, could you please pick this up? However, it's important to also
> then remove the hunk above from THIS patch, the one that deletes the
> excessive memcg_free_kmem(). We need exactly one memcg_free_kmem() in
> mem_cgroup_css_free(). :-)

So you want to retain
mm-memcontrol-reign-in-the-config-space-madness.patch's removal of the
ifdef CONFIG_INET?


What I have is

Against net-drop-tcp_memcontrolc.patch:

--- a/mm/memcontrol.c~net-drop-tcp_memcontrolc-fix
+++ a/mm/memcontrol.c
@@ -4421,8 +4421,6 @@ static void mem_cgroup_css_free(struct c
 		static_branch_dec(&memcg_sockets_enabled_key);
 #endif
 
-	memcg_free_kmem(memcg);
-
 	__mem_cgroup_free(memcg);
 }
 

and against mm-memcontrol-reign-in-the-config-space-madness.patch:

--- a/mm/memcontrol.c~mm-memcontrol-reign-in-the-config-space-madness-fix
+++ a/mm/memcontrol.c
@@ -4380,6 +4380,8 @@ static void mem_cgroup_css_free(struct c
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
+	memcg_free_kmem(memcg);
+
 	if (memcg->tcp_mem.active)
 		static_branch_dec(&memcg_sockets_enabled_key);
 

Producing

static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
{
	struct mem_cgroup *memcg = mem_cgroup_from_css(css);

	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
		static_branch_dec(&memcg_sockets_enabled_key);

	memcg_free_kmem(memcg);

	if (memcg->tcp_mem.active)
		static_branch_dec(&memcg_sockets_enabled_key);

	__mem_cgroup_free(memcg);
}

And I did s/reign/rein/;)
