From: David Rientjes <rientjes@google.com>
Subject: [patch -mm] mm, memcg: separate oom_group from selection criteria
Date: Thu, 15 Mar 2018 13:34:49 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803151334260.52771@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803131720470.247949@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=7A4lT1g+X09TcaAIP27OxdozxKCo4JGHOEHBXiOqeaY=;
        b=GuSulhz6hyF83CK7raNpulbN/24sJh+dJuU4i0rr9ORwXXEgQx6+vi+KUSGm92TB5X
         GUcI/AZQW8CzduDn/Tmp9jOzMc4KeBdGit4hccAnl9m45Fkpp0iJ58YKxYsgT1+NH1T0
         D9b12/8AQzG5qLsT2F5uU7AVZX9+F1EcdHIINR+IYh/43X09yy09oCvwVUaaYnqxy8iT
         /rJ7eW1K6qEZ8YRcj4PP7dt+YR7WEYyGljXtkn0fXHiMPIzJQTddOSsuel1rf2qtk7Iw
         Laia9aTeUtjxzhlfv1s7b7cAf9vFbUuiJjx/l0eN5NRtmgDK4O+mucVLzZL8SZu9VbRT
         4mmA==
In-Reply-To: <alpine.DEB.2.20.1803131720470.247949@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

With the current implementation of the cgroup-aware oom killer,
memory.oom_group defines two behaviors:

 - consider the footprint of the "group" consisting of the mem cgroup
   itself and all descendants for comparison with other cgroups, and

 - when selected as the victim mem cgroup, kill all processes attached to
   it and its descendants that are eligible to be killed.

Now that the memory.oom_policy of "tree" considers the memory footprint of
the mem cgroup and all its descendants, separate the memory.oom_group
setting from the selection criteria.

Now, memory.oom_group only controls whether all processes attached to the
victim mem cgroup and its descendants are oom killed (when set to "1") or
the single largest memory consuming process attached to the victim mem
cgroup and its descendants is killed.

This is generally regarded as a property of the workload attached to the
subtree: it depends on whether the workload can continue running and be
useful if a single process is oom killed or whether it's better to kill
all attached processes.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Based on top of oom policy patch series at
 https://marc.info/?t=152090280800001 and follow-up patch at
 https://marc.info/?l=linux-kernel&m=152098687824112

 Documentation/cgroup-v2.txt | 21 ++++-----------------
 mm/memcontrol.c             |  8 ++++----
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1045,25 +1045,12 @@ PAGE_SIZE multiple when read back.
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "0".
 
-	If set, OOM killer will consider the memory cgroup as an
-	indivisible memory consumers and compare it with other memory
-	consumers by it's memory footprint.
-	If such memory cgroup is selected as an OOM victim, all
-	processes belonging to it or it's descendants will be killed.
+	If such memory cgroup is selected as an OOM victim, all processes
+	attached to it and its descendants that are eligible for oom kill
+	(their /proc/pid/oom_score_adj is not oom disabled) will be killed.
 
 	This applies to system-wide OOM conditions and reaching
 	the hard memory limit of the cgroup and their ancestor.
-	If OOM condition happens in a descendant cgroup with it's own
-	memory limit, the memory cgroup can't be considered
-	as an OOM victim, and OOM killer will not kill all belonging
-	tasks.
-
-	Also, OOM killer respects the /proc/pid/oom_score_adj value -1000,
-	and will never kill the unkillable task, even if memory.oom_group
-	is set.
-
-	If cgroup-aware OOM killer is not enabled, ENOTSUPP error
-	is returned on attempt to access the file.
 
   memory.oom_policy
 
@@ -1325,7 +1312,7 @@ When selecting a cgroup as a victim, the OOM killer will kill the process
 with the largest memory footprint.  A user can control this behavior by
 enabling the per-cgroup memory.oom_group option.  If set, it causes the
 OOM killer to kill all processes attached to the cgroup, except processes
-with /proc/pid/oom_score_adj set to -1000 (oom disabled).
+with /proc/pid/oom_score_adj set to OOM_SCORE_ADJ_MIN.
 
 The root cgroup is treated as a leaf memory cgroup as well, so it is
 compared with other leaf memory cgroups.
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2732,11 +2732,11 @@ static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
 			continue;
 
 		/*
-		 * We don't consider non-leaf non-oom_group memory cgroups
-		 * without the oom policy of "tree" as OOM victims.
+		 * We don't consider non-leaf memory cgroups without the oom
+		 * policy of "tree" as OOM victims.
 		 */
-		if (memcg_has_children(iter) && !mem_cgroup_oom_group(iter) &&
-		    iter->oom_policy != MEMCG_OOM_POLICY_TREE)
+		if (iter->oom_policy != MEMCG_OOM_POLICY_TREE &&
+				memcg_has_children(iter))
 			continue;
 
 		/*
