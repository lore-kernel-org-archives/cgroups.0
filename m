From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/4] cgroup: Child cgroup creation not allowed on invalid domain
Date: Fri, 21 Jul 2017 16:34:50 -0400
Message-ID: <1500669293-21792-2-git-send-email-longman@redhat.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com F33A680478
In-Reply-To: <1500669293-21792-1-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

When thread mode is used, it is possible that some cgroups may be
in an invalid state. Currently users may not be aware that they are
invalid until they try to migrate tasks over. This patch disallows
child cgroup creation on invalid domain. This adds one more failure
point in reminding users that they are dealing with invalid domains.
It also minimizes the number of invalid domains outstanding as much
as possible.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e9a377d..5fc8133 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4664,6 +4664,14 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
 	if (!parent)
 		return -ENODEV;
 
+	/*
+	 * New cgroup creation isn't allowed on an invalid domain parent.
+	 */
+	if (!cgroup_is_threaded(parent) && !cgroup_is_valid_domain(parent)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	cgrp = cgroup_create(parent);
 	if (IS_ERR(cgrp)) {
 		ret = PTR_ERR(cgrp);
-- 
1.8.3.1
