From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cgroup/cpuset: Enable memory migration for cpuset v2
Date: Wed, 11 Aug 2021 15:57:07 -0400
Message-ID: <20210811195707.30851-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628711880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=WxdcaYuyKYoi6tYy6rnNj7AJtwXW/DVftZFjymOGA2c=;
        b=c5lcvTKVGt+/wwgvMdYJ0ARA5hOF/ipJ7dKb/78lq1BiqvfHMbSQ5LUvXOHGzytGqMlEYu
        pK1DeMFmdVdFfC6ago9W3ypyOFRCiDc+SsEXgihnf4wk5Az9IqjbGeJNWdtOq3S5b7spzR
        Lwm5e/5O+sD82A6/1i0TCLUUlWCxi8U=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

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

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 11 +++++++++++
 kernel/cgroup/cpuset.c                  |  6 +++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 5c7377b5bd3e..babbe04c8d37 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2056,6 +2056,17 @@ Cpuset Interface Files
 	The value of "cpuset.mems" stays constant until the next update
 	and won't be affected by any memory nodes hotplug events.
 
+	Setting a non-empty value to "cpuset.mems" causes memory of
+	tasks within the cgroup to be migrated to the designated nodes if
+	they are currently using memory outside of the designated nodes.
+
+	There is a cost for this memory migration.  The migration
+	may not be complete and some memory pages may be left behind.
+	So it is recommended that "cpuset.mems" should be set properly
+	before spawning new tasks into the cpuset.  Even if there is
+	a need to change "cpuset.mems" with active tasks, it shouldn't
+	be done frequently.
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

