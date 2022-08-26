From: cgel.zte@gmail.com
Subject: [PATCH linux-next] admin-guide: cgroup: fix a typo in description
Date: Fri, 26 Aug 2022 02:05:54 +0000
Message-ID: <20220826020552.239407-1-lu.fengchang@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=RHgqZb2XQveY9G/sJMRmpzdx+tOdeQ4iM+KusnEyRoY=;
        b=Pb3YzDPspbBnUW3qH117ZXq0J6MB5B7vyjogOalJat+W8jYnbkqOQmZKmQXSrSMupU
         8+kgv305Qpxb6/tniUToXHZSlc/AET1thtBvLtPRxkEdAPkY0ykBUrdhR8QMTBlTs6H9
         igIxdfupYdjQbH5yv8D+3AfaH79ZrSyF64Ux5Hxv1BjssyNRhsU+V7IB1/+zjpDA8r0b
         oDnB5/Nq6ymuDeZXNi1ar0XiVSpLiT1L6JPS8DTd11KP17pofDLEpzGWZfWsCL6yssAq
         GOI6sABvOCFYY4wPvVzQ0vZrwtC3nD7Z+QZ/95DPX7FpVRROdAqroybtH0oBTdcUW0el
         8FUg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, lufengchang <lu.fengchang@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>

From: lufengchang <lu.fengchang@zte.com.cn>

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: lufengchang <lu.fengchang@zte.com.cn>
---
 Documentation/admin-guide/cgroup-v1/cgroups.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/cgroups.rst b/Documentation/admin-guide/cgroup-v1/cgroups.rst
index b0688011ed06..fa747466e304 100644
--- a/Documentation/admin-guide/cgroup-v1/cgroups.rst
+++ b/Documentation/admin-guide/cgroup-v1/cgroups.rst
@@ -573,7 +573,7 @@ cgroup_for_each_descendant_pre() for details.
 ``void css_offline(struct cgroup *cgrp);``
 (cgroup_mutex held by caller)
 
-This is the counterpart of css_online() and called iff css_online()
+This is the counterpart of css_online() and called if css_online()
 has succeeded on @cgrp. This signifies the beginning of the end of
 @cgrp. @cgrp is being removed and the subsystem should start dropping
 all references it's holding on @cgrp. When all references are dropped,
-- 
2.25.1

