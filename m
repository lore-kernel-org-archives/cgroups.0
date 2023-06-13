From: LeiZhou-97 <lei.zhou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup/misc: Expose misc.current on cgroup v2 root
Date: Tue, 13 Jun 2023 18:59:29 +0800
Message-ID: <20230613105929.269318-1-lei.zhou@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686654012; x=1718190012;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+ZwgnbFFD4kVifWi7M+EUMUQ3jIqdujOFhEyYhD1S1c=;
  b=JTBAaG0sOv1Rby/6HF+IuXtyI7O/r3jO6PWtFjAzUfgCPnOb/ig9O4HQ
   2otyuLjRVO/WnotEshFmJnJIpwOdmh/uPOUjrrFuM3QKDsAqAUkrx0jZV
   /Iiv+116SrixI792ecN5psBfkg5gY3GIBwOZMf4DnamGqmAqBgBJ1YBFF
   4LVMxXrCEYAiiJTEkf2QyejGmWB1ca9+Nbgzj5nggmFyoxnmu8xtGG+wU
   5hRn2gBmyPgPPZSZNgz/x+nHMWCKTlpeY77L9qLHwIzFc3lI2nTQzLMNh
   hrYU78CXIw8Ptdks6PGh4f2C85vVcfSRwGUgvB+wHlFLo2hLNDYMafu1P
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lei.zhou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Hello,

This patch is to expose misc.current on cgroup v2 root for tracking
how much of the resource has been consumed in total on the system.

Most of the cloud infrastucture use cgroup to fetch the host
information for scheduling purpose.

Currently, the misc controller can be used by Intel TDX HKIDs and
AMD SEV ASIDs, which are both used for creating encrypted VMs.
Intel TDX and AMD SEV are mostly be used by the cloud providers
for providing confidential VMs.

In actual use of a server, these confidential VMs may be launched
in different ways. For the cloud solution, there are kubvirt and
coco (tracked by kubepods.slice); on host, they can be booted
directly through qemu by end user (tracked by user.slice), etc.

In this complex environment, when wanting to know how many resource
is used in total it has to iterate through all existing slices to
get the value of each misc.current and add them up to calculate
the total number of consumed keys.

So exposing misc.current to root cgroup tends to give much easier
when calculates how much resource has been used in total, which
helps to schedule and count resources for the cloud infrastucture.

Signed-off-by: LeiZhou-97 <lei.zhou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 2 +-
 kernel/cgroup/misc.c                    | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index f67c0829350b..d9f3768a10db 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2439,7 +2439,7 @@ Miscellaneous controller provides 3 interface files. If two misc resources (res_
 	  res_b 10
 
   misc.current
-        A read-only flat-keyed file shown in the non-root cgroups.  It shows
+        A read-only flat-keyed file shown in the all cgroups.  It shows
         the current usage of the resources in the cgroup and its children.::
 
 	  $ cat misc.current
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index fe3e8a0eb7ed..ae2f4dd47508 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -357,7 +357,6 @@ static struct cftype misc_cg_files[] = {
 	{
 		.name = "current",
 		.seq_show = misc_cg_current_show,
-		.flags = CFTYPE_NOT_ON_ROOT,
 	},
 	{
 		.name = "capacity",
-- 
2.40.1

