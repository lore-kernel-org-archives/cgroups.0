From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] cgroup/cpuset: Make cpuset_attach_task() skip subpartitions CPUs for top_cpuset
Date: Fri, 31 Mar 2023 10:50:44 -0400
Message-ID: <20230331145045.2251683-3-longman@redhat.com>
References: <20230331145045.2251683-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680274283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+9i7sLun1jgv9svlyB9jcs4mFG0+IKoU4iPpMJ0u9ZQ=;
        b=LvrIXz6WGo4R2W2uI9IDoagN0uhNYZ+lsQGhOM1ptyhgMmSYRSzD/Qwq23rkkRRd27wkUn
        FgK3h8NE1D97TuTJ6TR6KdXJ/sJNHTHUnm5mSJbgEl/S1/Zm1oy+G16G4kXf5GaaE6KCAQ
        QSn11VCRyL9daNrOeW7ZR5jsSeVdQlg=
In-Reply-To: <20230331145045.2251683-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It is found that attaching a task to the top_cpuset does not currently
ignore CPUs allocated to subpartitions in cpuset_attach_task(). So the
code is changed to fix that.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f6d5614982d7..2367de611c42 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2530,7 +2530,8 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 	if (cs != &top_cpuset)
 		guarantee_online_cpus(task, cpus_attach);
 	else
-		cpumask_copy(cpus_attach, task_cpu_possible_mask(task));
+		cpumask_andnot(cpus_attach, task_cpu_possible_mask(task),
+			       cs->subparts_cpus);
 	/*
 	 * can_attach beforehand should guarantee that this doesn't
 	 * fail.  TODO: have a better way to handle failure here
-- 
2.31.1

