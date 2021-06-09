From: Alexander Kuznetsov <wwfq-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: [PATCH] cgroup1: don't allow '\n' in renaming
Date: Wed,  9 Jun 2021 10:17:19 +0300
Message-ID: <1623223039-35764-1-git-send-email-wwfq@yandex-team.ru>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1623223049; bh=S7Jlb+iv+KHJKh1j38RnlbemQ1r5YpudVR63I/AHP4g=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=LcAPHm6KcvWyTPgYpN1ov4qiG2AxRpwbRbWE5UjFP42/uAcjKEOBwj8ppR5mWdf0m
         fAFEzaTFf1rqpYf11DLSax+ERn0rArOZf84jo/Rsddo29Mz0sdRPIwSabKsPDRE3UF
         2eYodyV4wOpDx0/ekFAdJQ9QuWSJ5W5TnE6TtPWM=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, dmtrmonakhov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

cgroup_mkdir() have restriction on newline usage in names:
$ mkdir $'/sys/fs/cgroup/cpu/test\ntest2'
mkdir: cannot create directory
'/sys/fs/cgroup/cpu/test\ntest2': Invalid argument

But in cgroup1_rename() such check is missed.
This allows us to make /proc/<pid>/cgroup unparsable:
$ mkdir /sys/fs/cgroup/cpu/test
$ mv /sys/fs/cgroup/cpu/test $'/sys/fs/cgroup/cpu/test\ntest2'
$ echo $$ > $'/sys/fs/cgroup/cpu/test\ntest2'
$ cat /proc/self/cgroup
11:pids:/
10:freezer:/
9:hugetlb:/
8:cpuset:/
7:blkio:/user.slice
6:memory:/user.slice
5:net_cls,net_prio:/
4:perf_event:/
3:devices:/user.slice
2:cpu,cpuacct:/test
test2
1:name=systemd:/
0::/

Signed-off-by: Alexander Kuznetsov <wwfq-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Reported-by: Andrey Krasichkov <buglloc-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Acked-by: Dmitry Yakunin <zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 391aa57..cf2a3e8 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -820,6 +820,10 @@ static int cgroup1_rename(struct kernfs_node *kn, struct kernfs_node *new_parent
 	struct cgroup *cgrp = kn->priv;
 	int ret;
 
+	/* do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable */
+	if (strchr(new_name_str, '\n'))
+		return -EINVAL;
+
 	if (kernfs_type(kn) != KERNFS_DIR)
 		return -ENOTDIR;
 	if (kn->parent != new_parent)
-- 
2.7.4

