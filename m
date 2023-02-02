From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/2] cgroup/cpuset: Skip task update if hotplug doesn't affect current cpuset
Date: Thu,  2 Feb 2023 09:31:59 -0500
Message-ID: <20230202143200.128753-2-longman@redhat.com>
References: <20230202143200.128753-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675348347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rONQLTKynqTykPVaxa5ORG7HhLk0Eh/0pOKFH75qGhM=;
        b=UFIcsgUMGNsaKEcJerP+5jgFo+/viC/4fVw2T7linEmxQmBblBx/+TGmngqMZ9CLIHi1hi
        sW0Z9XVIhxiLYwJvUIg5Rs2OmPC2HraG0XMKTcR3otjtFZwpl62HGtRsSTiVcbX1ldt7hP
        pSY3HNLW9GnxBZV8W41Ti+1ytvR/Quk=
In-Reply-To: <20230202143200.128753-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

If a hotplug event doesn't affect the current cpuset, there is no point
to call hotplug_update_tasks() or hotplug_update_tasks_legacy(). So
just skip it.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 205dc9edcaa9..cbf749fc05d9 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3506,6 +3506,8 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 update_tasks:
 	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
 	mems_updated = !nodes_equal(new_mems, cs->effective_mems);
+	if (!cpus_updated && !mems_updated)
+		goto unlock;	/* Hotplug doesn't affect this cpuset */
 
 	if (mems_updated)
 		check_insane_mems_config(&new_mems);
@@ -3517,6 +3519,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 		hotplug_update_tasks_legacy(cs, &new_cpus, &new_mems,
 					    cpus_updated, mems_updated);
 
+unlock:
 	percpu_up_write(&cpuset_rwsem);
 }
 
-- 
2.31.1

