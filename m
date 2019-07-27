From: Miles Chen <miles.chen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: fix use after free in mem_cgroup_iter()
Date: Sat, 27 Jul 2019 14:00:10 +0800
Message-ID: <1564207210.19817.9.camel@mtkswgap22>
References: <20190726021247.16162-1-miles.chen@mediatek.com>
 <20190726124933.GN6142@dhcp22.suse.cz>
 <20190726125533.GO6142@dhcp22.suse.cz>
 <1564184878.19817.5.camel@mtkswgap22>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20170209; h=Sender:
	Content-Transfer-Encoding:Content-Type:Cc:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:MIME-Version:References:In-Reply-To:
	Date:To:From:Subject:Message-ID:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=7Ozz1W8XLn7vFdzexPFOYTalJYjDOwvPhSzQLMpOIHI=; b=AaXbenyjDimliT
	nZOe9uQMoxkeXBuw7ARuIV9yihfv4hvLlaKUDgNAAzxgakRdk98/UbBQjBeWJbs7xOFYFYuV46iqy
	g4CGsRAer7zDyjMfWqfkki1ZFgwYROjls4PbjFN+gEnSR/47/TJIRI+WGTpveM9shNEIUTRjSsCU+
	a6JVd3YDxwJPwKNSRLEuH1e0yFDAy5hLesWKV+QbeUutxnDy1Q/D+OmZMON/zS0wkPTsBeWsaQL7q
	68XgdkHSPjEh3YPJ700v5DDcc3oWcqXc2rgy67+shl7UF9nTwlkHnctP1JLJ0S9qvwy5T6dnkVzAI
	fGk4PssAJ9iTf03lGrfw==;
In-Reply-To: <1564184878.19817.5.camel@mtkswgap22>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>, 
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>, 
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 2019-07-27 at 07:47 +0800, Miles Chen wrote:
> On Fri, 2019-07-26 at 14:55 +0200, Michal Hocko wrote:
> > On Fri 26-07-19 14:49:33, Michal Hocko wrote:
> > > On Fri 26-07-19 10:12:47, Miles Chen wrote:
> > > > This patch is sent to report an use after free in mem_cgroup_iter()
> > > > after merging commit: be2657752e9e "mm: memcg: fix use after free in
> > > > mem_cgroup_iter()".
> > > > 
> > > > I work with android kernel tree (4.9 & 4.14), and the commit:
> > > > be2657752e9e "mm: memcg: fix use after free in mem_cgroup_iter()" has
> > > > been merged to the trees. However, I can still observe use after free
> > > > issues addressed in the commit be2657752e9e.
> > > > (on low-end devices, a few times this month)
> > > > 
> > > > backtrace:
> > > > 	css_tryget <- crash here
> > > > 	mem_cgroup_iter
> > > > 	shrink_node
> > > > 	shrink_zones
> > > > 	do_try_to_free_pages
> > > > 	try_to_free_pages
> > > > 	__perform_reclaim
> > > > 	__alloc_pages_direct_reclaim
> > > > 	__alloc_pages_slowpath
> > > > 	__alloc_pages_nodemask
> > > > 
> > > > To debug, I poisoned mem_cgroup before freeing it:
> > > > 
> > > > static void __mem_cgroup_free(struct mem_cgroup *memcg)
> > > > 	for_each_node(node)
> > > > 	free_mem_cgroup_per_node_info(memcg, node);
> > > > 	free_percpu(memcg->stat);
> > > > +       /* poison memcg before freeing it */
> > > > +       memset(memcg, 0x78, sizeof(struct mem_cgroup));
> > > > 	kfree(memcg);
> > > > }
> > > > 
> > > > The coredump shows the position=0xdbbc2a00 is freed.
> > > > 
> > > > (gdb) p/x ((struct mem_cgroup_per_node *)0xe5009e00)->iter[8]
> > > > $13 = {position = 0xdbbc2a00, generation = 0x2efd}
> > > > 
> > > > 0xdbbc2a00:     0xdbbc2e00      0x00000000      0xdbbc2800      0x00000100
> > > > 0xdbbc2a10:     0x00000200      0x78787878      0x00026218      0x00000000
> > > > 0xdbbc2a20:     0xdcad6000      0x00000001      0x78787800      0x00000000
> > > > 0xdbbc2a30:     0x78780000      0x00000000      0x0068fb84      0x78787878
> > > > 0xdbbc2a40:     0x78787878      0x78787878      0x78787878      0xe3fa5cc0
> > > > 0xdbbc2a50:     0x78787878      0x78787878      0x00000000      0x00000000
> > > > 0xdbbc2a60:     0x00000000      0x00000000      0x00000000      0x00000000
> > > > 0xdbbc2a70:     0x00000000      0x00000000      0x00000000      0x00000000
> > > > 0xdbbc2a80:     0x00000000      0x00000000      0x00000000      0x00000000
> > > > 0xdbbc2a90:     0x00000001      0x00000000      0x00000000      0x00100000
> > > > 0xdbbc2aa0:     0x00000001      0xdbbc2ac8      0x00000000      0x00000000
> > > > 0xdbbc2ab0:     0x00000000      0x00000000      0x00000000      0x00000000
> > > > 0xdbbc2ac0:     0x00000000      0x00000000      0xe5b02618      0x00001000
> > > > 0xdbbc2ad0:     0x00000000      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2ae0:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2af0:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2b00:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2b10:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2b20:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2b30:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2b40:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2b50:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2b60:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2b70:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2b80:     0x78787878      0x78787878      0x00000000      0x78787878
> > > > 0xdbbc2b90:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 0xdbbc2ba0:     0x78787878      0x78787878      0x78787878      0x78787878
> > > > 
> > > > In the reclaim path, try_to_free_pages() does not setup
> > > > sc.target_mem_cgroup and sc is passed to do_try_to_free_pages(), ...,
> > > > shrink_node().
> > > > 
> > > > In mem_cgroup_iter(), root is set to root_mem_cgroup because
> > > > sc->target_mem_cgroup is NULL.
> > > > It is possible to assign a memcg to root_mem_cgroup.nodeinfo.iter in
> > > > mem_cgroup_iter().
> > > > 
> > > > 	try_to_free_pages
> > > > 		struct scan_control sc = {...}, target_mem_cgroup is 0x0;
> > > > 	do_try_to_free_pages
> > > > 	shrink_zones
> > > > 	shrink_node
> > > > 		 mem_cgroup *root = sc->target_mem_cgroup;
> > > > 		 memcg = mem_cgroup_iter(root, NULL, &reclaim);
> > > > 	mem_cgroup_iter()
> > > > 		if (!root)
> > > > 			root = root_mem_cgroup;
> > > > 		...
> > > > 
> > > > 		css = css_next_descendant_pre(css, &root->css);
> > > > 		memcg = mem_cgroup_from_css(css);
> > > > 		cmpxchg(&iter->position, pos, memcg);
> > > > 
> > > > My device uses memcg non-hierarchical mode.
> > > > When we release a memcg: invalidate_reclaim_iterators() reaches only
> > > > dead_memcg and its parents. If non-hierarchical mode is used,
> > > > invalidate_reclaim_iterators() never reaches root_mem_cgroup.
> > > > 
> > > > static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
> > > > {
> > > > 	struct mem_cgroup *memcg = dead_memcg;
> > > > 
> > > > 	for (; memcg; memcg = parent_mem_cgroup(memcg)
> > > > 	...
> > > > }
> > > > 
> > > > So the use after free scenario looks like:
> > > > 
> > > > CPU1						CPU2
> > > > 
> > > > try_to_free_pages
> > > > do_try_to_free_pages
> > > > shrink_zones
> > > > shrink_node
> > > > mem_cgroup_iter()
> > > >     if (!root)
> > > >     	root = root_mem_cgroup;
> > > >     ...
> > > >     css = css_next_descendant_pre(css, &root->css);
> > > >     memcg = mem_cgroup_from_css(css);
> > > >     cmpxchg(&iter->position, pos, memcg);
> > > > 
> > > > 					invalidate_reclaim_iterators(memcg);
> > > > 					...
> > > > 					__mem_cgroup_free()
> > > > 						kfree(memcg);
> > > > 
> > > > try_to_free_pages
> > > > do_try_to_free_pages
> > > > shrink_zones
> > > > shrink_node
> > > > mem_cgroup_iter()
> > > >     if (!root)
> > > >     	root = root_mem_cgroup;
> > > >     ...
> > > >     mz = mem_cgroup_nodeinfo(root, reclaim->pgdat->node_id);
> > > >     iter = &mz->iter[reclaim->priority];
> > > >     pos = READ_ONCE(iter->position);
> > > >     css_tryget(&pos->css) <- use after free
> > > 
> > > Thanks for the write up. This is really useful.
> > > 
> > > > To avoid this, we should also invalidate root_mem_cgroup.nodeinfo.iter in
> > > > invalidate_reclaim_iterators().
> > > 
> > > I am sorry, I didn't get to comment an earlier version but I am
> > > wondering whether it makes more sense to do and explicit invalidation.
> > > 
> 
> I think we should keep the original v2 version, the reason is the 
> !use_hierarchy does not imply we can reach root_mem_cgroup:

Sorry I want to correct myself:

(dead_memcg->use_hierarchy == true) does not guarantee that we can
reach root_mem_cgroup by parent_mem_cgroup(dead_memcg)

> cd /sys/fs/cgroup/memory/0
> mkdir 1
> cd /sys/fs/cgroup/memory/0/1
> echo 1 > memory.use_hierarchy // only 1 and its children has
> use_hierarchy set
> mkdir 2
> 
> rmdir 2 // parent_mem_cgroup(2) goes up to 1
> 
> > > [...]
> > > > +static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
> > > > +{
> > > > +	struct mem_cgroup *memcg = dead_memcg;
> > > > +	int invalidate_root = 0;
> > > > +
> > > > +	for (; memcg; memcg = parent_mem_cgroup(memcg))
> > > > +		__invalidate_reclaim_iterators(memcg, dead_memcg);
> > > 
> > > 	/* here goes your comment */
> > > 	if (!dead_memcg->use_hierarchy)
> > > 		__invalidate_reclaim_iterators(root_mem_cgroup,	dead_memcg);
> > > > +
> > > > +}
> > > 
> > > Other than that the patch looks good to me.
> > > 
> > > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > 
> > Btw. I believe we want to push this to stable trees as well. I think it
> > goes all the way down to 5ac8fb31ad2e ("mm: memcontrol: convert reclaim
> > iterator to simple css refcounting"). Unless I am missing something a
> > Fixes: tag would be really helpful.
> 
> No problem. I'll add the fix tag to patch v3.
> Fixes: 5ac8fb31ad2e ("mm: memcontrol: convert reclaim iterator to simple
> css refcounting")
> 
> 
> Miles
> 
> 
