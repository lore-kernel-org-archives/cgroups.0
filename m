From: Wei Yongjun <weiyj_lk-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH -next] cgroup: remove duplicated include from cgroup.c
Date: Tue, 19 Jul 2016 12:02:39 +0000
Message-ID: <1468929759-9088-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=A8iZI
	N0oX/yi3Pat0ztm0/NGBMlE2qyLA6/0aLqO2nw=; b=Ac8WMGdxPeq1bW1KMt/lr
	Wr7XLA9aRwEWZ6z59X4ZZCtWud6Mid9c6EtvGqAgu4hpxN8wG8OIV/WvRlKWdkwv
	y2dBFM6Akfvw5FJ8wLHQAGmo6QaCHuPxBTp9T6ZFMYOLLKwzxVq6bcjYrWkYR3/k
	rdAv+8uWHlPEDIpK1DGBxc=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 kernel/cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f37c69a..d1c51b7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -61,7 +61,6 @@
 #include <linux/cpuset.h>
 #include <linux/proc_ns.h>
 #include <linux/nsproxy.h>
-#include <linux/proc_ns.h>
 #include <linux/file.h>
 #include <net/sock.h>
 



