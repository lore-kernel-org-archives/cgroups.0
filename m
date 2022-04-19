From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH] cgroup/cpuset: fix a memory binding failure for cgroup v2
Date: Tue, 19 Apr 2022 10:09:58 +0800
Message-ID: <20220419020958.40419-1-feng.tang@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650334202; x=1681870202;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nH/XrxtiTaYfm0g+ofM2ITpPrGvqHIGnxGucWn4QUeE=;
  b=kI0VVkCRSajLSMxg3jLmKadZpF3GbPhDv+0vLS6s9f0+13EdOnLF+DX6
   bIoxMJjNM5wblWvW3Moi4arbUWEEM/YGwDAHDX8Y2HaSj04w3mZwuEV+B
   D5nJdUuD9sij/5ly1SHJW4cPRoLB/5gnqy6LnTWk5TOwrCH8gQUbueiC9
   7BDfxVPgV+Z3QqIyrNR8jYRh564/rxYFOozFQgXDEJhW+Mc/4aCgUceu4
   N43b/HHPstWKiraVqsCujRptyo0KXkJ+RmesA6d7yjHnsOsVB/lS8D/9k
   hoZqD40L+EMY4GFQlxcoGGkmTEmkx4ZE4qFIozZEso2YHBNosgLTtyoz5
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

We got report that setting cpuset.mems failed when the nodemask
contains a newly onlined memory node (not enumerated during boot)
for cgroup v2, while the binding succeeded for cgroup v1.

The root cause is, for cgroup v2, when a new memory node is onlined,
top_cpuset's 'mem_allowed' is not updated with the new nodemask of
memory nodes, and the following setting memory nodemask will fail,
if the nodemask contains a new node.

Fix it by updating top_cpuset.mems_allowed right after the
new memory node is onlined, just like v1.

Signed-off-by: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Very likely I missed some details here, but it looks strange that
the top_cpuset.mem_allowed is not updatd even after we onlined
several memory nodes after boot.

 kernel/cgroup/cpuset.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9390bfd9f1cd..b97caaf16374 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3314,8 +3314,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	/* synchronize mems_allowed to N_MEMORY */
 	if (mems_updated) {
 		spin_lock_irq(&callback_lock);
-		if (!on_dfl)
-			top_cpuset.mems_allowed = new_mems;
+		top_cpuset.mems_allowed = new_mems;
 		top_cpuset.effective_mems = new_mems;
 		spin_unlock_irq(&callback_lock);
 		update_tasks_nodemask(&top_cpuset);
-- 
2.27.0

