From: Odin Ugedal <odin@uged.al>
Subject: [RFC] docs/admin-guide/cgroup-v2: Add hugetlb rsvd files
Date: Fri, 16 Apr 2021 16:11:46 +0200
Message-ID: <20210416141146.542786-1-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qvg0+ynFQWDqQCIO8KNqZL3+z/lrvuKdEEgfI7FsQlo=;
        b=ELyLsiUaExhjw8YySJFA347NWUPn9j1onQtEB8PIFFgCd0rSH4RHWYCfpnKhEl3/w8
         r2tqpsvCLvbZ5ufl2YzrkABtOqLiXfpc0s8WWpP3j3liXDtL+8fKYh5E9BtuYP9NUBBX
         F2RVbdj+Qd8QICZ7cK0S2WsPyy+wtkXbj1aPNXuRK2WCHEYbL77Bn4+S2Y1AJKqvIjF2
         zfQDxWkt6S7yWSrOahYG/p9o44w/TMzabmP+cykZtFiKvJ1q2vp/jai2lvCYV6KhH8Cc
         KVKs/iOKDIlgT+3z6ih24LIhHDsL0lZHPBf+YFFqElurjSyFM4D6fHiUcnCmVZS5dKlR
         e/VA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: corbet@lwn.net
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Odin Ugedal <odin@uged.al>

Add missing docs about reservation accounting for hugetlb in cgroup v2.

Signed-off-by: Odin Ugedal <odin@uged.al>
---
RFC: This is linking from cgroup-v1 docs, and that is probably not
optimal. The information about the difference between reservation
accounting and page fault accounting is pretty hard to make short.

I think we have four ways to do it, but I don't know what is
most optimal:

- Link from cgroup-v2 to cgroup-v1 (this patch)
- Have a separate description for both v1 and v2
- Move description from cgroup-v1 to cgroup-v2, and link from v1 to
  v2.
- Move info from cgroup-v1 to admin-guide/mm/hugetlbpage or
  vm/hugetlbfs_reserv, and link from cgroup to them.

admin-guide/cgroup-v1/hugetlb need some formatting anyhow also, will fix
that in the same patchset as this. Together with describing
<hugepagesize> in cgroup-v2.

 Documentation/admin-guide/cgroup-v2.rst | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 64c62b979f2f..0a29cd46b1ab 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2143,12 +2143,31 @@ RDMA Interface Files
 HugeTLB
 -------
 
-The HugeTLB controller allows to limit the HugeTLB usage per control group and
-enforces the controller limit during page fault.
+The "HugeTLB" controller regulates usage of huge pages. The controller
+supports two forms of accounting: page fault accounting and reservation
+accounting. See
+:ref:`Documentation/admin-guide/cgroup-v1/hugetlb.rst <cgroup-v1-hugetlb>`
+for more details.
+
 
 HugeTLB Interface Files
 ~~~~~~~~~~~~~~~~~~~~~~~
 
+  hugetlb.<hugepagesize>.rsvd.current
+	Show current reservations and no-reserve faults for "hugepagesize"
+	hugetlb.  It exists for all the cgroup except root.
+
+  hugetlb.<hugepagesize>.rsvd.max
+	Set/show the hard limit of reservations and no-reserve faults for
+	"hugepagesize" hugetlb. The default value is "max".
+	It exists for all the cgroup except root.
+
+  hugetlb.<hugepagesize>.rsvd.events
+	A read-only flat-keyed file which exists on non-root cgroups.
+
+	  max
+		The number of allocation failure due to HugeTLB reservation limit
+
   hugetlb.<hugepagesize>.current
 	Show current usage for "hugepagesize" hugetlb.  It exists for all
 	the cgroup except root.
-- 
2.31.1

