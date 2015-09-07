From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/7] devcg: Added Documentation of RDMA device cgroup.
Date: Tue,  8 Sep 2015 02:08:23 +0530
Message-ID: <1441658303-18081-8-git-send-email-pandit.parav@gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZBf8l9p7bArbklVtUPeGR9kKPc2msV2kjKieDdb/n1o=;
        b=EIP6VFs4S2HCKybgR3TPoJ1PENbsdoxJ76gcAs0zrheeSPK3SX/lwmFySzg3nG2TTl
         lZg9mPVVphEUNIqqrRzfD0lGoHY5PanOkiEYN0qAC9Y57Xqqmbpg5h0TiZu7TPT+fU+y
         WkgfK4M64O3OIYBzrGqlScESm704OBbMa4LwVE0HHPBBU8csbSQIskjFQ3G1Wyt59hTZ
         RS6EBfjWWszAE5r1WFbWv9ztExX27d1eafzM2JRrtvqqHy5DTRhto09NEEj+5flpcVNR
         9SXwgo5rcU1c53Ooj/4lFA3JBqoxoXAgoezD1MiqdY3TnamUMaKQCPnoiOTjbeKmgGb8
         AEpA==
In-Reply-To: <1441658303-18081-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Modified device cgroup documentation to reflect its dual purpose
without creating new cgroup subsystem for rdma.

Added documentation to describe functionality and usage of device cgroup
extension for RDMA.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/cgroups/devices.txt | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/cgroups/devices.txt b/Documentation/cgroups/devices.txt
index 3c1095c..eca5b70 100644
--- a/Documentation/cgroups/devices.txt
+++ b/Documentation/cgroups/devices.txt
@@ -1,9 +1,12 @@
-Device Whitelist Controller
+Device Controller
 
 1. Description:
 
-Implement a cgroup to track and enforce open and mknod restrictions
-on device files.  A device cgroup associates a device access
+Device controller implements a cgroup for two purposes.
+
+1.1 Device white list controller
+It implement a cgroup to track and enforce open and mknod
+restrictions on device files.  A device cgroup associates a device access
 whitelist with each cgroup.  A whitelist entry has 4 fields.
 'type' is a (all), c (char), or b (block).  'all' means it applies
 to all types and all major and minor numbers.  Major and minor are
@@ -15,8 +18,15 @@ cgroup gets a copy of the parent.  Administrators can then remove
 devices from the whitelist or add new entries.  A child cgroup can
 never receive a device access which is denied by its parent.
 
+1.2 RDMA device resource controller
+It implements a cgroup to limit various RDMA device resources for
+a controller. Such resource includes RDMA PD, CQ, AH, MR, SRQ, QP, FLOW.
+It limits RDMA resources access to tasks of the cgroup across multiple
+RDMA devices.
+
 2. User Interface
 
+2.1 Device white list controller
 An entry is added using devices.allow, and removed using
 devices.deny.  For instance
 
@@ -33,6 +43,22 @@ will remove the default 'a *:* rwm' entry. Doing
 
 will add the 'a *:* rwm' entry to the whitelist.
 
+2.2 RDMA device controller
+
+RDMA resources are limited using devices.rdma.resource.max.<resource_name>.
+Doing
+	echo 200 > /sys/fs/cgroup/1/rdma.resource.max_qp
+will limit maximum number of QP across all the process of cgroup to 200.
+
+More examples:
+	echo 200 > /sys/fs/cgroup/1/rdma.resource.max_flow
+	echo 10  > /sys/fs/cgroup/1/rdma.resource.max_pd
+	echo 15  > /sys/fs/cgroup/1/rdma.resource.max_srq
+	echo 1   > /sys/fs/cgroup/1/rdma.resource.max_uctx
+
+RDMA resource current usage can be tracked using devices.rdma.resource.usage
+	cat /sys/fs/cgroup/1/devices.rdma.resource.usage
+
 3. Security
 
 Any task can move itself between cgroups.  This clearly won't
-- 
1.8.3.1
