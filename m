From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: memcontrol: Let mem_cgroup_move_account() have
 effect only if MMU enabled
Date: Wed, 4 Mar 2015 10:59:04 +0100
Message-ID: <20150304095904.GA14748@dhcp22.suse.cz>
References: <54F4E739.6040805@qq.com>
 <20150303134524.GE2409@dhcp22.suse.cz>
 <54F61300.1070409@sohu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <54F61300.1070409@sohu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Gang <dsg_gchen_5257@sohu.com>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chen Gang <762976180@qq.com>, Balbir Singh <bsingharora@gmail.com>

[CCing Balbir]

On Wed 04-03-15 04:01:04, Chen Gang wrote:
> On 3/3/15 21:45, Michal Hocko wrote:
> > On Tue 03-03-15 06:42:01, Chen Gang wrote:
> >> When !MMU, it will report warning. The related warning with allmodconfig
> >> under c6x:
> > 
> > Does it even make any sense to enable CONFIG_MEMCG when !CONFIG_MMU?
> > Is anybody using this configuration and is it actually usable? My
> > knowledge about CONFIG_MMU is close to zero so I might be missing
> > something but I do not see a point into fixing compile warnings when
> > the whole subsystem is not usable in the first place.
> > 
> 
> For me, only according to the current code, the original author assumes
> CONFIG_MEMCG can still have effect when !CONFIG_MMU: "or, he/she needn't
> use CONFIG_MMU switch macro in memcontrol.c".

Well this was before my time. 024914477e15 (memcg: move charges of
anonymous swap) added them because of lack of page tables (as per
documentation). This is a good reason but a bigger question is whether
we want to add small little changes to make compiler happy or face the
reality and realize that MEMCG without MMU is so restricted (I am even
not sure whether it is usable at all) and reflect that in the
dependency. Balbir had actually mentioned this in early submissions:
https://lkml.org/lkml/2008/3/16/59. I haven't seen anybody objecting to
this so I guess it went in without a good reason. So instead I suggest
the following change instead.
---
From 396a311891b29189bf306d5dedd1608a2a06bda4 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 4 Mar 2015 10:48:47 +0100
Subject: [PATCH] memcg: make CONFIG_MEMCG depend on CONFIG_MMU

CONFIG_MEMCG might be currently enabled also for !MMU architectures
which was probably an omission because Balbir had this on the TODO
list section (https://lkml.org/lkml/2008/3/16/59)
"
Only when CONFIG_MMU is enabled, is the virtual address space control
enabled. Should we do this for nommu cases as well? My suspicion is
that we don't have to.
"
I do not see any traces for !MMU requests after then. The code compiles
with !MMU but I haven't heard about anybody using it in the real life
so it is not clear to me whether it works and it is usable at all
considering how !MMU configuration is restricted.

Let's make CONFIG_MEMCG depend on CONFIG_MMU to make our support
explicit and also to get rid of few ifdefs in the code base.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/cgroups/memory.txt |  2 --
 init/Kconfig                     |  1 +
 mm/memcontrol.c                  | 24 ------------------------
 3 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index a22df3ad35ff..9111540657d6 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -667,8 +667,6 @@ NOTE2: It is recommended to set the soft limit always below the hard limit,
 
 Users can move charges associated with a task along with task migration, that
 is, uncharge task's pages from the old cgroup and charge them to the new cgroup.
-This feature is not supported in !CONFIG_MMU environments because of lack of
-page tables.
 
 8.1 Interface
 
diff --git a/init/Kconfig b/init/Kconfig
index 9afb971497f4..b16f77fbd050 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -979,6 +979,7 @@ config MEMCG
 	bool "Memory Resource Controller for Control Groups"
 	select PAGE_COUNTER
 	select EVENTFD
+	depends on MMU
 	help
 	  Provides a memory resource controller that manages both anonymous
 	  memory and page cache. (See Documentation/cgroups/memory.txt)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0c86945bcc9a..1c4bb9c6227e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3467,7 +3467,6 @@ static u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
 	return mem_cgroup_from_css(css)->move_charge_at_immigrate;
 }
 
-#ifdef CONFIG_MMU
 static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 					struct cftype *cft, u64 val)
 {
@@ -3485,13 +3484,6 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 	memcg->move_charge_at_immigrate = val;
 	return 0;
 }
-#else
-static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
-					struct cftype *cft, u64 val)
-{
-	return -ENOSYS;
-}
-#endif
 
 #ifdef CONFIG_NUMA
 static int memcg_numa_stat_show(struct seq_file *m, void *v)
@@ -4676,7 +4668,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 }
 
-#ifdef CONFIG_MMU
 /* Handlers for move charge at task migration. */
 static int mem_cgroup_do_precharge(unsigned long count)
 {
@@ -5209,21 +5200,6 @@ static void mem_cgroup_move_task(struct cgroup_subsys_state *css,
 	if (mc.to)
 		mem_cgroup_clear_mc();
 }
-#else	/* !CONFIG_MMU */
-static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
-				 struct cgroup_taskset *tset)
-{
-	return 0;
-}
-static void mem_cgroup_cancel_attach(struct cgroup_subsys_state *css,
-				     struct cgroup_taskset *tset)
-{
-}
-static void mem_cgroup_move_task(struct cgroup_subsys_state *css,
-				 struct cgroup_taskset *tset)
-{
-}
-#endif
 
 /*
  * Cgroup retains root cgroups across [un]mount cycles making it necessary
-- 
2.1.4

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
