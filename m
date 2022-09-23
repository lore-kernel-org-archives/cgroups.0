From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix cgroup_get_from_id
Date: Fri, 23 Sep 2022 19:51:19 +0800
Message-ID: <20220923115119.2035603-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663933892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LSqlKmINboHpHtUNR10HWYgYVkgSi8ssnna63UQWneM=;
        b=UgQeyVN5SmEqxFp4n0VDwvpLYVIQACHaflA2gCt/vnbqcoo7uCzOlnlZt+y97+yIhVEqqj
        4MpT9iIFJq/mwtYUFxjIEgKiHwO8v7RbR9YviygaBZ1xmg+LdPON70jfiO+ox4vIupjm93
        Kt8SZbM1ESLCnZieA6k8yQd/cdiq/xQ=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marco Patalano <mpatalan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Muneendra <muneendra.kumar-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

cgroup has to be one kernfs dir, otherwise kernel panic is caused,
especially cgroup id is provide from userspace.

Reported-by: Marco Patalano <mpatalan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Fixes: 6b658c4863c1 ("scsi: cgroup: Add cgroup_get_from_id()")
Cc: Muneendra <muneendra.kumar-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e4bb5d57f4d1..5f2090d051ac 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6049,6 +6049,9 @@ struct cgroup *cgroup_get_from_id(u64 id)
 	if (!kn)
 		goto out;
 
+	if (kernfs_type(kn) != KERNFS_DIR)
+		goto put;
+
 	rcu_read_lock();
 
 	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
@@ -6056,7 +6059,7 @@ struct cgroup *cgroup_get_from_id(u64 id)
 		cgrp = NULL;
 
 	rcu_read_unlock();
-
+put:
 	kernfs_put(kn);
 out:
 	return cgrp;
-- 
2.31.1

