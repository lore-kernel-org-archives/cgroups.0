From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/8] cgroup: move cgroup files under kernel/cgroup/
Date: Tue, 20 Dec 2016 16:08:21 -0500
Message-ID: <20161220210827.11176-3-tj@kernel.org>
References: <20161220210827.11176-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WWjWTo5RS/LJKt/QijC0smWndLDx+mSK+ZH8rE/H1Sk=;
        b=bB2l9bfgpnZQmDD/X82fFtjznCOvpGLWjdIXqYwPwmkAEiV8YSSHctAtpO1yxpVrLZ
         O/rmvvNUIxOLZfUjhzEJBj3bsdB0B536pyc+wSu246r5dnzMcVLwITuxcRDUP6PFYxIO
         uq/c6Zbksp5HR10EJS7CYlSQ5+gqSs7sX9HorO6dCuXUMPUD2uXZ38jJbpjKmy9NNYdl
         gZVMXhkecNTV/11WjOGVATRgQOlGib4a7TJYpZXesw6hk3vjYCGNPEPTP8yHsdPhiCcC
         k+gCCQqeDPJhSm7lSO/sF4A2Mr1KsbHuOQTqQYIT3Psfub26tA5g7psJWi+kwxaucUiN
         oeJg==
In-Reply-To: <20161220210827.11176-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

They're growing to be too many and planned to get split further.  Move
them under their own directory.

 kernel/cgroup.c		-> kernel/cgroup/cgroup.c
 kernel/cgroup_freezer.c	-> kernel/cgroup/freezer.c
 kernel/cgroup_pids.c		-> kernel/cgroup/pids.c
 kernel/cpuset.c		-> kernel/cgroup/cpuset.c

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/Makefile                               | 5 +----
 kernel/cgroup/Makefile                        | 5 +++++
 kernel/{ => cgroup}/cgroup.c                  | 0
 kernel/{ => cgroup}/cpuset.c                  | 0
 kernel/{cgroup_freezer.c => cgroup/freezer.c} | 0
 kernel/{cgroup_pids.c => cgroup/pids.c}       | 0
 6 files changed, 6 insertions(+), 4 deletions(-)
 create mode 100644 kernel/cgroup/Makefile
 rename kernel/{ => cgroup}/cgroup.c (100%)
 rename kernel/{ => cgroup}/cpuset.c (100%)
 rename kernel/{cgroup_freezer.c => cgroup/freezer.c} (100%)
 rename kernel/{cgroup_pids.c => cgroup/pids.c} (100%)

diff --git a/kernel/Makefile b/kernel/Makefile
index 12c679f..b302b47 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -64,10 +64,7 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
-obj-$(CONFIG_CGROUPS) += cgroup.o
-obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
-obj-$(CONFIG_CGROUP_PIDS) += cgroup_pids.o
-obj-$(CONFIG_CPUSETS) += cpuset.o
+obj-$(CONFIG_CGROUPS) += cgroup/
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
new file mode 100644
index 0000000..4d561a5
--- /dev/null
+++ b/kernel/cgroup/Makefile
@@ -0,0 +1,5 @@
+obj-y := cgroup.o
+
+obj-$(CONFIG_CGROUP_FREEZER) += freezer.o
+obj-$(CONFIG_CGROUP_PIDS) += pids.o
+obj-$(CONFIG_CPUSETS) += cpuset.o
diff --git a/kernel/cgroup.c b/kernel/cgroup/cgroup.c
similarity index 100%
rename from kernel/cgroup.c
rename to kernel/cgroup/cgroup.c
diff --git a/kernel/cpuset.c b/kernel/cgroup/cpuset.c
similarity index 100%
rename from kernel/cpuset.c
rename to kernel/cgroup/cpuset.c
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup/freezer.c
similarity index 100%
rename from kernel/cgroup_freezer.c
rename to kernel/cgroup/freezer.c
diff --git a/kernel/cgroup_pids.c b/kernel/cgroup/pids.c
similarity index 100%
rename from kernel/cgroup_pids.c
rename to kernel/cgroup/pids.c
-- 
2.9.3
