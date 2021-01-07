From: Jiang Biao <benbjiang@gmail.com>
Subject: [PATCH] Documentation: Fix typos found in cgroup-v2.rst
Date: Thu,  7 Jan 2021 22:11:18 +0800
Message-ID: <20210107141118.9530-1-benbjiang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G+/yW7D6tgLkfN73HRcn97T4dV2Qj+zmTeZIf737PxQ=;
        b=Qgbt7mCZ/t2lHcdTBmIgFYZN4t4oWy0AeqUjnjy23hkhVF+p9+Gat10t3UuhooBE5z
         h73ZrSzcfENRWBuNBlC7OjGJOVC/5EoHwlT4efFOqV3UgGokjW3iJ7UnE4XjBZ70c+A0
         yRyhNpfEKSyxLBE+3FfcCMq50v1v7xlWifXb1iuchM40Glv70zSixRf6fRT2i3xpw8y6
         0wlXYCXfFUEuSWargxi9VqLhPKp8164+CIVWaPzRcZSjUlhnI3nI+ClgJPL/tB3fu2dF
         EH6oGATMR84Yg7iXW9xR1kudfkcAivYbOm5/hOdfHHcxxoYrhx3xVafQdS3HVF54tC9p
         6jnA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan@huawei.com, corbet@lwn.net, hannes@cmpxchg.org
Cc: linux-doc@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>

From: Jiang Biao <benbjiang@tencent.com>

Fix typos found in Documentation/admin-guide/cgroup-v2.rst.

Signed-off-by: Jiang Biao <benbjiang@tencent.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 63521cd36ce5..e0f6ff7cfa93 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1558,7 +1558,7 @@ IO Interface Files
 	  8:0 rbytes=90430464 wbytes=299008000 rios=8950 wios=1252 dbytes=50331648 dios=3021
 
   io.cost.qos
-	A read-write nested-keyed file with exists only on the root
+	A read-write nested-keyed file which exists only on the root
 	cgroup.
 
 	This file configures the Quality of Service of the IO cost
@@ -1613,7 +1613,7 @@ IO Interface Files
 	automatic mode can be restored by setting "ctrl" to "auto".
 
   io.cost.model
-	A read-write nested-keyed file with exists only on the root
+	A read-write nested-keyed file which exists only on the root
 	cgroup.
 
 	This file configures the cost model of the IO cost model based
-- 
2.21.0

