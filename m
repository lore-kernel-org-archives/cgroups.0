From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-5.6] iocost: Fix iocost_monitor.py due to helper
 type mismatch
Date: Fri, 17 Jan 2020 11:58:42 -0800
Message-ID: <20200117195842.GL2677547@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=sPdxpH8MyQUiW9CeltxFRckECiJJQpVH4BhIsZDdF38=;
        b=mByunD+oO3XP1Dvhlmwzm3IO5l5bbxtR7KUnDCY2fpWJT/NmUuwRdNyextOSNzsTbh
         p1gZ8nAYOytmy0hv1bgACpmjM4b3notpx/+JJTVlex00JnhTF7bGcNsjcI/THfBE3Qyo
         R4rAF4E7PF6FZQMtIJ8e8X575u4L5RanoVjGr8A+00GRsQpGRq2o9krqCew2n/JGLYeO
         20sgCShe0s/t7ZZUPjr96nhEyqh0hdnY/kK0QJKAQOo5qftObgn04Tn1AlWqtR34mnJ/
         6kM0MiKYxqsyaC8byA0bW/WnqYXKH9thF+JXmJSwOK4jmHgKVglXwUZpsMXZvfnjFqYl
         I4Kg==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>, kernel-team@fb.com

From 9ea37e24d4a95dd934a0600d65caa25e409705bb Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 17 Jan 2020 11:54:35 -0800

iocost_monitor.py broke with recent versions of drgn due to helper
being stricter about types.  Fix it so that it uses the correct type.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Omar Sandoval <osandov@fb.com>
---
Applied to cgroup/for-5.6.

 tools/cgroup/iocost_monitor.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/cgroup/iocost_monitor.py b/tools/cgroup/iocost_monitor.py
index f79b23582a1d..7427a5ee761b 100644
--- a/tools/cgroup/iocost_monitor.py
+++ b/tools/cgroup/iocost_monitor.py
@@ -72,7 +72,7 @@ autop_names = {
         name = BlkgIterator.blkcg_name(blkcg)
         path = parent_path + '/' + name if parent_path else name
         blkg = drgn.Object(prog, 'struct blkcg_gq',
-                           address=radix_tree_lookup(blkcg.blkg_tree, q_id))
+                           address=radix_tree_lookup(blkcg.blkg_tree.address_of_(), q_id))
         if not blkg.address_:
             return
 
@@ -228,7 +228,7 @@ q_id = None
 root_iocg = None
 ioc = None
 
-for i, ptr in radix_tree_for_each(blkcg_root.blkg_tree):
+for i, ptr in radix_tree_for_each(blkcg_root.blkg_tree.address_of_()):
     blkg = drgn.Object(prog, 'struct blkcg_gq', address=ptr)
     try:
         if devname == blkg.q.kobj.parent.name.string_().decode('utf-8'):
-- 
2.17.1

