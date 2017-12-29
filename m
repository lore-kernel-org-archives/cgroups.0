From: Matt Roper <matthew.d.roper@intel.com>
Subject: [PATCH 2/2] cgroup: Update documentation reference
Date: Fri, 29 Dec 2017 12:02:00 -0800
Message-ID: <20171229200200.18873-2-matthew.d.roper@intel.com>
References: <20171229200200.18873-1-matthew.d.roper@intel.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20171229200200.18873-1-matthew.d.roper@intel.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: Matt Roper <matthew.d.roper@intel.com>, Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org

The cgroup_subsys structure references a documentation file that has been
renamed after the v1/v2 split.  Since the v2 documentation doesn't
currently contain any information on kernel interfaces for controllers,
point the user to the v1 docs.

Cc: Tejun Heo <tj@kernel.org>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
---
 include/linux/cgroup-defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8b7fd8e..9f242b8 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -561,7 +561,7 @@ struct cftype {
 
 /*
  * Control Group subsystem type.
- * See Documentation/cgroups/cgroups.txt for details
+ * See Documentation/cgroup-v1/cgroups.txt for details
  */
 struct cgroup_subsys {
 	struct cgroup_subsys_state *(*css_alloc)(struct cgroup_subsys_state *parent_css);
-- 
2.9.5

