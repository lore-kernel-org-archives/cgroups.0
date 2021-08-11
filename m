From: Waiman Long <longman@redhat.com>
Subject: [PATCH] cgroup/cpuset: Enable memory migration for cpuset v2
Date: Wed, 11 Aug 2021 12:30:35 -0400
Message-ID: <20210811163035.1977-1-longman@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628699457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=LxSuW5nHsETbJXIQDCaep1MG1Cjx73IJH53bJ9bhEiQ=;
        b=SiwxhHFj21aPWUsXlARo1rkxBsCCLPM/LapfiMOUQQkk8Chat2GQEUcjdJoBt9xSZ0D9xp
        N7r7qed7pq1NuTd2VcLXx81wGiTLOOZo7kkB/sIHJidTHN/2oFaR3KGzaTuj/9/b6sxb8h
        5LV/xKPMdIHbicmkBQc09HlgiLLtn3w=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Waiman Long <longman@redhat.com>

When a user changes cpuset.cpus, each task in a v2 cpuset will be moved
to one of the new cpus if it is not there already. For memory, however,
they won't be migrated to the new nodes when cpuset.mems changes. This is
an inconsistency in behavior.

In cpuset v1, there is a memory_migrate control file to enable such
behavior by setting the CS_MEMORY_MIGRATE flag. Make it the default
for cpuset v2 so that we have a consistent set of behavior for both
cpus and memory.

There is certainly a cost to make memory migration the default, but it
is a one time cost that shouldn't really matter as long as cpuset.mems
isn't changed frequenty.  Update the cgroup-v2.rst file to document the
new behavior and recommend against changing cpuset.mems frequently.

Since there won't be any concurrent access to the newly allocated cpuset
structure in cpuset_css_alloc(), we can use the cheaper non-atomic
__set_bit() instead of the more expensive atomic set_bit().

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 6 ++++++
 kernel/cgroup/cpuset.c                  | 6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 5c7377b5bd3e..47c832ad1322 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2056,6 +2056,12 @@ Cpuset Interface Files
 	The value of "cpuset.mems" stays constant until the next update
 	and won't be affected by any memory nodes hotplug events.
 
+	Setting a non-empty value to "cpuset.mems" causes memory of
+	tasks within the cgroup to be migrated to the designated nodes if
+	they are currently using memory outside of the designated nodes.
+	There is a cost for this migration.  So "cpuset.mems" shouldn't
+	be changed frequently.
+
   cpuset.mems.effective
 	A read-only multiple values file which exists on all
 	cpuset-enabled cgroups.
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index adb5190c4429..d151e1de93d4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2737,12 +2737,16 @@ cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+	__set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	nodes_clear(cs->mems_allowed);
 	nodes_clear(cs->effective_mems);
 	fmeter_init(&cs->fmeter);
 	cs->relax_domain_level = -1;
 
+	/* Set CS_MEMORY_MIGRATE for default hierarchy */
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys))
+		__set_bit(CS_MEMORY_MIGRATE, &cs->flags);
+
 	return &cs->css;
 }
 
-- 
2.18.1

