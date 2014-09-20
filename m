From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix missing unlock in cgroup_release_agent()
Date: Sat, 20 Sep 2014 14:35:43 +0800
Message-ID: <541D203F.4020902@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

The patch 971ff4935538: "cgroup: use a per-cgroup work for release
agent" from Sep 18, 2014, leads to the following static checker
warning:

	kernel/cgroup.c:5310 cgroup_release_agent()
	warn: 'mutex:&cgroup_mutex' is sometimes locked here and sometimes unlocked.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7f23551..33f15b3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5290,7 +5290,10 @@ static void cgroup_release_agent(struct work_struct *work)
 
 	mutex_unlock(&cgroup_mutex);
 	call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+	goto out_free;
 out:
+	mutex_unlock(&cgroup_mutex);
+out_free:
 	kfree(agentbuf);
 	kfree(pathbuf);
 }
-- 
1.8.0.2
