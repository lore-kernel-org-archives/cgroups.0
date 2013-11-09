From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v3.13-rc1
Date: Sun, 10 Nov 2013 07:38:31 +0900
Message-ID: <20131109223831.GC24275@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=/LFRifueToiT3C7fiAKHV8A5OCct58gs11MAp1Y1AOM=;
        b=QoY8nXcc9HbkVoX4Mj55jkccvymhQtvtHfFiWFRtMsZ+3/X3eOk+EueaiTp7SZc6kN
         XKFPx7SB32x4T6iyYiNomkHe85oRcirDsWNCkVB+TZmBP2zctycC8u1UpL5ULdu3WdQf
         KgFCSK8g/lSlZTOmD46FvxISFwmvA7Cz8Ap17GEaFVSZWpuzbya3NZ9yGMQmAjzUyQ9Y
         PRXgBvHiBPO6OogmkAhCReEuQQGMExZ06D7P4YeheQ+i0renPiu8XHSQWHfzAC5rDj8Q
         XNokFWp6w8P7N+jEtThjtxvgqbmYaDhrWAI3Gmjk3W4w0m8xjCl77W6TlRLOFJe30ih4
         8zvQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, again.

Not too much activity this time around.  css_id is finally killed and
a minor update to device_cgroup; however, the pull request does lead
to a conflict in mm/memcontrol.c between the following two commits.

  b862783594847 ("memcg: stop using css id")
  bb4cc1a8b5eaf ("revert "memcg: get rid of soft-limit tree infrastructure"")

The former removes free_css_id() call from __mem_cgroup_free() and the
latter restores mem_cgroup_remove_from_trees() right above it leading
to context conflict.  The conflict looks like

  static void __mem_cgroup_free(struct mem_cgroup *memcg)
  {
	  int node;
	  size_t size = memcg_size();

  <<<<<<< HEAD
	  mem_cgroup_remove_from_trees(memcg);
	  free_css_id(&mem_cgroup_subsys, &memcg->css);

  =======
  >>>>>>> 73ba353471e0b692f398f3d63018b7f46ccf1d3e
	  for_each_node(node)
		  free_mem_cgroup_per_zone_info(memcg, node);

	  free_percpu(memcg->stat);

and can be resolved like the following.

  static void __mem_cgroup_free(struct mem_cgroup *memcg)
  {
	  int node;
	  size_t size = memcg_size();

	  mem_cgroup_remove_from_trees(memcg);

	  for_each_node(node)
		  free_mem_cgroup_per_zone_info(memcg, node);

	  free_percpu(memcg->stat);

The changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.13

for you to fetch changes up to 73ba353471e0b692f398f3d63018b7f46ccf1d3e:

  device_cgroup: remove can_attach (2013-10-24 06:56:56 -0400)

Just in case, the test merge is available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge-3.13

Thanks.

----------------------------------------------------------------
Li Zefan (5):
      memcg: convert to use cgroup_is_descendant()
      memcg: convert to use cgroup id
      memcg: fail to create cgroup if the cgroup id is too big
      memcg: stop using css id
      cgroup: kill css_id

Serge Hallyn (1):
      device_cgroup: remove can_attach

 include/linux/cgroup.h   |  37 -------
 kernel/cgroup.c          | 248 +----------------------------------------------
 mm/memcontrol.c          |  67 +++++++------
 security/device_cgroup.c |  11 ---
 4 files changed, 41 insertions(+), 322 deletions(-)

-- 
tejun
