From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] cpuset: drop spurious retval assignment in
 proc_cpuset_show()
Date: Tue, 15 Jan 2013 08:41:19 -0800
Message-ID: <20130115164119.GD2668@htj.dyndns.org>
References: <50F4F2F1.8070107@huawei.com>
 <50F4F314.4040103@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=lh+A3KhfAkwd9yFCKpNZArY9gqdjWoWEI7kb2ESuWdY=;
        b=GloyQ01Ub2d4QGvwdJDgnkA2FYxTXgRf2w97Aq8oVqfZnxMqECg+6Q6BPMNfdtlseg
         a1cskZjCJ5Xw6k33B4I1488tk09eCztTfYiaLdzfCDipVcFRrasstP7HQhPUuJTiZeln
         TOHX0avShWr72ak1vnH/fZKMG++LTNLKCOcvv0cw+JkKmZKDmJ9SxOJHVIB+plYmLLxn
         Fl5Ea0WHKxikz//3TFtUcpCqrVAf2BfwoACplstAiIhouEtN2sXDZPsTrB3PxBtgzcLa
         EyF4hFPJtIPlJ6Is4ltGyjeDJz3c7npG0J22klayBp+D3t5fkGu9KyaK6LIHAMqUIyU1
         M/Nw==
Content-Disposition: inline
In-Reply-To: <50F4F314.4040103-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From d127027baf98dce3ca31bec18c2c0e048ceda7c4 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Tue, 15 Jan 2013 14:11:32 +0800

proc_cpuset_show() has a spurious -EINVAL assignment which does
nothing.  Remove it.

This patch doesn't make any functional difference.

tj: Rewrote patch description.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Ditto.  Thanks!

 kernel/cpuset.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1a675e4..16be7c9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2677,7 +2677,6 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 	if (!tsk)
 		goto out_free;
 
-	retval = -EINVAL;
 	rcu_read_lock();
 	css = task_subsys_state(tsk, cpuset_subsys_id);
 	retval = cgroup_path(css->cgroup, buf, PAGE_SIZE);
-- 
1.8.0.2
