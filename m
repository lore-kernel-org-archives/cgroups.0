From: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: Fix typo in comment
Date: Sun, 20 Nov 2022 15:51:34 +0000
Message-ID: <20221120155134.57193-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DttQDPYJqDe2lRvTfIAZ96JFKMlEltVMw+oadVUR8gw=;
        b=jvTBchvEr1cpkAFx1KWphFje2d/lHBFdAMl2ic9Wwv3/qYiIPMqd8hNFjdxVP9FbzN
         dF2yWOgzqFAeYontau/3ftgNeLXDbjC5nUwoAqUNt/Kac3hPXAXK8fgWGKaf9j7wnLLa
         VjkRM8LZ/W+fFIBF4H0FTBGsQJs1pzPxuy1pLPYse4wEMFqMBYyl5w9TImS7Uky0NF7j
         06iJOR7JYYmFAlA4TrEvplumSaDxcCuav2hg/OguaHJ7rXa0o7jes+q2qhfGqf4sTprt
         U9zx7uUHFKJ+eaDrV5maUiLIjC+jYvmzrJLpoEepYKHcf/GqKZBszq6VIipscvPNorrG
         k/RA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

Replace iff with if.

Signed-off-by: haifeng.xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f2743a476190..93c5e50b1392 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -814,7 +814,7 @@ static bool css_set_populated(struct css_set *cset)
  * One of the css_sets associated with @cgrp is either getting its first
  * task or losing the last.  Update @cgrp->nr_populated_* accordingly.  The
  * count is propagated towards root so that a given cgroup's
- * nr_populated_children is zero iff none of its descendants contain any
+ * nr_populated_children is zero if none of its descendants contain any
  * tasks.
  *
  * @cgrp's interface file "cgroup.populated" is zero if both
-- 
2.25.1

