From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [RFC PATCH 1/2] cpuset: Don't change the cpumask on attach if it is a subset.
Date: Wed,  2 Nov 2022 11:55:29 +0100
Message-ID: <20221102105530.1795429-2-bigeasy@linutronix.de>
References: <20221102105530.1795429-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667386538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MxLD+kWPx3lLvr+vk97jAcOCFNUbHoatvsStYxnpabQ=;
        b=gRdn8Kk+9daT6ZaXRsCbyPCBOrp67oJ0J5Jh49uic6NI2WT2n6UknoWUNGe50PfF3kX9WI
        /6nz6hJwbTPpFf70xBPndo/WoENfMzKSP8CORDHZKTfDaJONpy8AzWYODHwW7nGpTrx4p3
        l9F4/05EGozKhsx82GjCelNq4m2uDtbCIh1zWJ6iOD+Le8bm3pxYh3/BrTfTMo4vmfd4S4
        kwutEUL96HIk1mKBTN3+eWdJ/hfXV9ZFT9eWNIavny6epvI8L+TtK9JhOk7jfJbrSwdusf
        EEXZDU588VCy/qTKAdzoMWt+kUypeiuVecyGX/xknfJ57zG1iwwZl9pyUYxs1Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667386538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MxLD+kWPx3lLvr+vk97jAcOCFNUbHoatvsStYxnpabQ=;
        b=RHC/NzcwWbpQAmMu3pqEgJN9jPXPlgNOCoxNvDiAXuNNo6AL9pBUMLY9amL2ixmcIEHj8d
        FIoqtrYxUpu10FDw==
In-Reply-To: <20221102105530.1795429-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

If a task it attached to a cgroup then its CPU-mask will be set to the
mask of the cgroup. Upon enabling the cpuset controller it will be set
to all online CPUs. All running user tasks, that changed their CPU-mask,
will have their mask altered without knowing it. Tasks with unchanged
CPU-mask are set to all online CPUs and this change is a nop.

If the task is already using a subset of the allowed (new) CPUs, skip
changing the mask. This will preserve the CPU-mask as long as it
contains only allowed CPUs from the new CPU-mask.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b474289c15b82..8d5126684f9e6 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2527,7 +2527,8 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		 * can_attach beforehand should guarantee that this doesn't
 		 * fail.  TODO: have a better way to handle failure here
 		 */
-		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+		if (!cpumask_subset(&task->cpus_mask, cpus_attach))
+			WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
=20
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
 		cpuset_update_task_spread_flag(cs, task);
--=20
2.37.2

