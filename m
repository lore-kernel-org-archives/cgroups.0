From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: [PATCH 08/10] doc/admin-guide/cgroup-v2: use tables
Date: Tue, 19 Jan 2021 16:18:22 -0800
Message-ID: <20210120001824.385168-9-kolyshkin@gmail.com>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=045PvP5AZFJnLagMgpduNxgCsOQAzU/2eOj/YLdBA4A=;
        b=gqrB0eAJfwpSU25eN7Jtg6+8cofftYbci8tlN7GIxkNIgv7rj4AvBL0j7a/XCcl3GO
         Uq0DU/ugxh+YaceXN20O9rqGPcixxwyGpTevGEnXTs6o1OQBc12A5KAvnEXVHDKZnYqC
         2wM80/HKZ5B6OcOp+7HpodTJNAJ3g9G7G6Z9SbomHRzWg++X4GWmO8sps++rkUH7bbQU
         6rRja8dqCgTWcsLie68NOcxgthqGPELhFwCMvA3sgu5auhckN36wl19yB3ijtOR0ToYY
         ha1QWQhbnPP+XObvf81YeXH7K/dw87nFMcC/0DRE6xDVIv5Yl7mNZxKCiM6TcjTYm+pF
         hhVA==
In-Reply-To: <20210120001824.385168-1-kolyshkin@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: corbet@lwn.net
Cc: linux-doc@vger.kernel.org, cgroups@vger.kernel.org, Kir Kolyshkin <kolyshkin@gmail.com>

These two places are rendered like a table in the source (rst) code,
but they are seen as plain text by formatters, and thus are joined
together into a single line, e.g.:

> “root” - a partition root “member” - a non-root member of a partition

This is definitely not what was intended.

To fix, use table formatting, like in other places.

Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index c1b6ffc286cf..6f59f13f28d0 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2003,10 +2003,12 @@ Cpuset Interface Files
 	cpuset-enabled cgroups.  This flag is owned by the parent cgroup
 	and is not delegatable.
 
-        It accepts only the following input values when written to.
+	It accepts only the following input values when written to.
 
-        "root"   - a partition root
-        "member" - a non-root member of a partition
+	  ========	================================
+	  "root"	a partition root
+	  "member"	a non-root member of a partition
+	  ========	================================
 
 	When set to be a partition root, the current cgroup is the
 	root of a new partition or scheduling domain that comprises
@@ -2047,9 +2049,11 @@ Cpuset Interface Files
 	root to change.  On read, the "cpuset.sched.partition" file
 	can show the following values.
 
-	"member"       Non-root member of a partition
-	"root"         Partition root
-	"root invalid" Invalid partition root
+	  ==============	==============================
+	  "member"		Non-root member of a partition
+	  "root"		Partition root
+	  "root invalid"	Invalid partition root
+	  ==============	==============================
 
 	It is a partition root if the first 2 partition root conditions
 	above are true and at least one CPU from "cpuset.cpus" is
-- 
2.29.2

