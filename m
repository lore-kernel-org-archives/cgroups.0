From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Tue,  8 Sep 2015 02:08:16 +0530
Message-ID: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=zbyf0LgYlGTYMdnoTGROYE7hfpVOTfg97jUFUdK52P0=;
        b=tjDDYbPMMPHskgHr8roEVnSrGfJjSQ298IQLVL+w60pAr/W60eJaiEu1JK3wqHx+zV
         M91u4UGuH7FzsklTxwJDES0/jGb5ATdpsVTBCSoneoP4TKLBcqG7pT+/fv7eS4TNu6X2
         bcHKSBBl841G1y8qcvX+mO1tw1B7pK5feP1vImZzUb/4sBE23qYBJZj7IrueOtqCnzDp
         AleZ2OpueiA/FyAAbS8JrL25IoUVQ/wvwZ4aCH8QQ0VofHv47oRhaLg/3ONIBVQ572xt
         i/fVFqlhBl7jIcG741XJh4onwGMSbgoH53tYXGP834TTbTew2f9I8IfERN83SbuNom9k
         iiyg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Currently user space applications can easily take away all the rdma
device specific resources such as AH, CQ, QP, MR etc. Due to which other
applications in other cgroup or kernel space ULPs may not even get chance
to allocate any rdma resources.

This patch-set allows limiting rdma resources to set of processes.
It extend device cgroup controller for limiting rdma device limits.

With this patch, user verbs module queries rdma device cgroup controller
to query process's limit to consume such resource. It uncharge resource 
counter after resource is being freed.

It extends the task structure to hold the statistic information about process's 
rdma resource usage so that when process migrates from one to other controller,
right amount of resources can be migrated from one to other cgroup.

Future patches will support RDMA flows resource and will be enhanced further
to enforce limit of other resources and capabilities.

Parav Pandit (7):
  devcg: Added user option to rdma resource tracking.
  devcg: Added rdma resource tracking module.
  devcg: Added infrastructure for rdma device cgroup.
  devcg: Added rdma resource tracker object per task
  devcg: device cgroup's extension for RDMA resource.
  devcg: Added support to use RDMA device cgroup.
  devcg: Added Documentation of RDMA device cgroup.

 Documentation/cgroups/devices.txt     |  32 ++-
 drivers/infiniband/core/uverbs_cmd.c  | 139 +++++++++--
 drivers/infiniband/core/uverbs_main.c |  39 +++-
 include/linux/device_cgroup.h         |  53 +++++
 include/linux/device_rdma_cgroup.h    |  83 +++++++
 include/linux/sched.h                 |  12 +-
 init/Kconfig                          |  12 +
 security/Makefile                     |   1 +
 security/device_cgroup.c              | 119 +++++++---
 security/device_rdma_cgroup.c         | 422 ++++++++++++++++++++++++++++++++++
 10 files changed, 850 insertions(+), 62 deletions(-)
 create mode 100644 include/linux/device_rdma_cgroup.h
 create mode 100644 security/device_rdma_cgroup.c

-- 
1.8.3.1
