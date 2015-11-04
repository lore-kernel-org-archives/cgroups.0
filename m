From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [cgroup:test-merge-for-4.4 1/1] mm/vmscan.c:178:6: error:
 implicit declaration of function 'cgroup_on_dfl'
Date: Wed, 4 Nov 2015 09:56:30 +0100
Message-ID: <20151104085630.GD29607@dhcp22.suse.cz>
References: <201511040637.nB1K9bmQ%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201511040637.nB1K9bmQ%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

[CCing Johannes as well]

On Wed 04-11-15 06:26:39, Wu Fengguang wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge-for-4.4
> head:   1c93277f15d351a4c7244cdcc50c8f80cbd9e84e
> commit: 1c93277f15d351a4c7244cdcc50c8f80cbd9e84e [1/1] Merge branch 'for-4.4' into test-merge-for-4.4
> config: i386-randconfig-s1-201544 (attached as .config)
> reproduce:
>         git checkout 1c93277f15d351a4c7244cdcc50c8f80cbd9e84e
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    mm/vmscan.c: In function 'sane_reclaim':
> >> mm/vmscan.c:178:6: error: implicit declaration of function 'cgroup_on_dfl' [-Werror=implicit-function-declaration]
>      if (cgroup_on_dfl(memcg->css.cgroup))
>          ^
>    cc1: some warnings being treated as errors

Ohh, this seems because CONFIG_CGROUP_WRITEBACK depends on BLK_CGROUP
and MEMCG and none of it depends on CGROUP. Dang. The patch is below
I haven't checked other controllers yet.

> vim +/cgroup_on_dfl +178 mm/vmscan.c
> 
> 97c9341f Tejun Heo        2015-05-22  172  {
> 97c9341f Tejun Heo        2015-05-22  173  	struct mem_cgroup *memcg = sc->target_mem_cgroup;
> 97c9341f Tejun Heo        2015-05-22  174  
> 97c9341f Tejun Heo        2015-05-22  175  	if (!memcg)
> 97c9341f Tejun Heo        2015-05-22  176  		return true;
> 97c9341f Tejun Heo        2015-05-22  177  #ifdef CONFIG_CGROUP_WRITEBACK
> d5028f9f Vladimir Davydov 2015-09-22 @178  	if (cgroup_on_dfl(memcg->css.cgroup))
> 97c9341f Tejun Heo        2015-05-22  179  		return true;
> 97c9341f Tejun Heo        2015-05-22  180  #endif
> 97c9341f Tejun Heo        2015-05-22  181  	return false;
---
From 509ebecf457b852b3d83af04be258833a434db16 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Date: Wed, 4 Nov 2015 09:45:20 +0100
Subject: [PATCH] make CONFIG_MEMCG and CONFIG_BLK_CGROUP depend on CGROUPS

Neither CONFIG_MEMCG nor CONFIG_BLK_CGROUP depend on CGROUPS which
doesn't really make much sense because none of them are usable without
all the infrastructure. This even leads to compilation problems as
reported by 0-day compile test:

   mm/vmscan.c: In function 'sane_reclaim':
>> mm/vmscan.c:178:6: error: implicit declaration of function 'cgroup_on_dfl' [-Werror=implicit-function-declaration]
     if (cgroup_on_dfl(memcg->css.cgroup))
         ^
   cc1: some warnings being treated as errors

Reported-by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
---
 init/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index 287674421294..47fea987b82d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1014,6 +1014,7 @@ config PAGE_COUNTER
 
 config MEMCG
 	bool "Memory Resource Controller for Control Groups"
+	depends on CGROUPS
 	select PAGE_COUNTER
 	select EVENTFD
 	help
@@ -1128,6 +1129,7 @@ endif #CGROUP_SCHED
 
 config BLK_CGROUP
 	bool "Block IO controller"
+	depends on CGROUPS
 	depends on BLOCK
 	default n
 	---help---
-- 
2.6.1



-- 
Michal Hocko
SUSE Labs
