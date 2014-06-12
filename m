From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] cgroup: fix broken css_has_online_children()
Date: Thu, 12 Jun 2014 14:31:31 +0800
Message-ID: <53994943.60703@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

After running:

  # mount -t cgroup cpu xxx /cgroup && mkdir /cgroup/sub && \
    rmdir /cgroup/sub && umount /cgroup

I found the cgroup root still existed:

  # cat /proc/cgroups
  #subsys_name    hierarchy       num_cgroups     enabled
  cpuset  0       1       1
  cpu     1       1       1
  ...

It turned out css_has_online_children() is broken.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 05b8ca4..1c65f24 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3327,7 +3327,7 @@ bool css_has_online_children(struct cgroup_subsys_state *css)
 
 	rcu_read_lock();
 	css_for_each_child(child, css) {
-		if (css->flags & CSS_ONLINE) {
+		if (child->flags & CSS_ONLINE) {
 			ret = true;
 			break;
 		}
-- 
1.8.0.2
