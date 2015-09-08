From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] cgroup: fix seq_show_option merge with legacy_name
Date: Tue, 8 Sep 2015 11:30:43 -0700
Message-ID: <20150908183043.GA23974@www.outflux.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When seq_show_option (068acf2ee776) was merged, it did not correctly
collide with cgroup's addition of legacy_name (3e1d2eed39d8) changes. This
fixes the reported name.

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a8538e443784..2cf0f79f1fc9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1342,7 +1342,7 @@ static int cgroup_show_options(struct seq_file *seq,
 	if (root != &cgrp_dfl_root)
 		for_each_subsys(ss, ssid)
 			if (root->subsys_mask & (1 << ssid))
-				seq_show_option(seq, ss->name, NULL);
+				seq_show_option(seq, ss->legacy_name, NULL);
 	if (root->flags & CGRP_ROOT_NOPREFIX)
 		seq_puts(seq, ",noprefix");
 	if (root->flags & CGRP_ROOT_XATTR)
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
