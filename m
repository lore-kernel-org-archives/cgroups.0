From: Joel Savitz <jsavitz@redhat.com>
Subject: [PATCH] Documentation: add missing angle bracket in cgroup-v2 doc Tejun Heo <tj@kernel.org>
Date: Fri, 22 Apr 2022 12:45:26 -0400
Message-ID: <20220422164526.3464306-1-jsavitz@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650645933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iRkZ/MlhVt4hFpcsFs4QSWVVxX1L4tCfV1bfk1REu+M=;
        b=Grlv4oUiST2rVnnkFtyNiLyWftAwKNbugMRs1AjFI6U/qzzol7xvieC2zT2Qqrhig/MTWy
        tDyRUm0uXyieQhklA9LaF+A+K3j28eL2G48yWg34EviWdwAXVZVw9XxRRX3wcDjgC0e0LA
        L9vFP5o/mW6AJrswx7tSZQ+vM5vf2j8=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: Joel Savitz <jsavitz@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, trivial@kernel.org

Trivial addition of missing closing angle backet.

Signed-off-by: Joel Savitz <jsavitz@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 69d7a6983f78..38aa01939e1e 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1881,7 +1881,7 @@ IO Latency Interface Files
   io.latency
 	This takes a similar format as the other controllers.
 
-		"MAJOR:MINOR target=<target time in microseconds"
+		"MAJOR:MINOR target=<target time in microseconds>"
 
   io.stat
 	If the controller is enabled you will see extra stats in io.stat in
-- 
2.27.0

