From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] cgroup: export cgrp_dfl_root
Date: Sun,  2 Aug 2015 16:23:41 -0400
Message-ID: <1438547024-23497-2-git-send-email-tj@kernel.org>
References: <1438547024-23497-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/2cfPRubWtP6LcmNdZAC+VwmD5Cr1kYJ175jOV/6qkg=;
        b=tof0OFkkV3FEhAr+/vasF3LTBOb/m1Sywunx2PBalebhnb3s7Dgvg12hVSgV41zo2L
         NrGy+7rBLzenk0OT9Ac4wF3z97hxL7c9a+LRySjlmFyW9cbPcDku05lRNFe8rfAGGicR
         qGjY7MYILlYWwOOBvBwR8hv+s+ibN+HRGpqCZcIA/vj+6BS2+iI5qN564jywfL/ZgK6G
         exDyVO+Bnv2bXJlNFPcLFvcFR1DneMPzgSYvaNv/sDgKPr7r8L9vv9z1x4vtV35vUQRC
         Et+np3x1KUU92JnQL3Citvd46//dJahb+b03wSLPn/TxtEYMePQSXiabUiHd2szWsNiY
         Gc3Q==
In-Reply-To: <1438547024-23497-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, hannes@cmpxchg.org, lizefan@huawei.com
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, avanzini.arianna@gmail.com, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

While cgroup subsystems can't be modules, blkcg supports dynamically
loadable policies which interact with cgroup core.  Export
cgrp_dfl_root so that cgroup_on_dfl() can be used in those modules.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1276569..9c8eb17 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -145,6 +145,7 @@ static const char *cgroup_subsys_name[] = {
  * part of that cgroup.
  */
 struct cgroup_root cgrp_dfl_root;
+EXPORT_SYMBOL_GPL(cgrp_dfl_root);
 
 /*
  * The default hierarchy always exists but is hidden until mounted for the
-- 
2.4.3
