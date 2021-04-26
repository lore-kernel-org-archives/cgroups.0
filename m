From: Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH 3/3] docs/admin-guide/cgroup-v2: add cpuset.mems.migration
Date: Mon, 26 Apr 2021 14:59:46 +0800
Message-ID: <20210426065946.40491-4-wuyun.abel@bytedance.com>
References: <20210426065946.40491-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SfF/Z0ScslK5LaLkBhpaNHR++tEupceqm51lspaZqiM=;
        b=0i9nIWEJj9GpgmwDenmDPUoRWsFexvOFaT+BUwCnkkTJB+KggV7EM95SvP/FIHknUT
         OJdeK9AduA5wcmvM8cbrNSN3YxfhLD0Ib9/gHGWwTDLfElVl2TVHo59+PlUjZXwWbKXn
         g34ffK1upYiGkve9TcgSCFheOQoFet00lvgYTSy76AS3IfROqU5uXI8ICbiFPg9jDG4g
         2p9kPKgAc/HLRmNmSrHHyvu8BznKlDrqvvh0eyyB15I2bdRy0CmVsufO9jHXl3LVnQam
         RFh/sPCgsHU7lLUh91NE99fh0cdns99W4GJ+YvzguW4sWEQgMGtMyfqGqoIx0mE7zwqU
         Uo0g==
In-Reply-To: <20210426065946.40491-1-wuyun.abel@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org, lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, corbet@lwn.net
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Abel Wu <wuyun.abel@bytedance.com>

Add docs for new interface cpuset.mems.migration, most of which
are stolen from cpuset(7) manpages.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 36 +++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index b1e81aa8598a..abf6589a390d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2079,6 +2079,42 @@ Cpuset Interface Files
 	Changing the partition state of an invalid partition root to
 	"member" is always allowed even if child cpusets are present.
 
+  cpuset.mems.migration
+	A read-write single value file which exists on non-root
+	cpuset-enabled cgroups.
+
+	Only the following migration modes are defined.
+
+	  ========	==========================================
+	  "none"	migration disabled [default]
+	  "sync"	move pages to cpuset nodes synchronously
+	  "lazy"	move pages to cpuset nodes on second touch
+	  ========	==========================================
+
+	By default, "none" mode is enabled. In this mode, once a page
+	is allocated (given a physical page of main memory) then that
+	page stays on whatever node it was allocated, so long as it
+	remains allocated, even if the cpusets memory placement policy
+	'cpuset.mems' subsequently changes.
+
+	If "sync" mode is enabled in a cpuset, when the 'cpuset.mems'
+	setting is changed, any memory page in use by any process in
+	the cpuset that is on a memory node that is no longer allowed
+	will be migrated to a memory node that is allowed synchronously.
+	The relative placement of a migrated page within the cpuset is
+	preserved during these migration operations if possible.
+
+	The "lazy" mode is almost the same as "sync" mode, except that
+	it doesn't move the pages right away. Instead it sets these
+	pages to protnone, and numa faults triggered by second touching
+	these pages will handle the movement.
+
+	Furthermore, if a process is moved into a cpuset with migration
+	enabled ("sync" or "lazy" enabled), any memory pages it uses
+	that on memory nodes allowed in its previous cpuset, but which
+	are not allowed in its new cpuset, will be migrated to a memory
+	node allowed in the new cpuset.
+
 
 Device controller
 -----------------
-- 
2.31.1

