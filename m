From: suhua <suhua.tanke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: Fix comment in cpuset_hotplug_workfn
Date: Thu,  8 Jun 2023 16:54:39 +0800
Message-ID: <20230608085439.27501-1-suhua.tanke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686214498; x=1688806498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jz1qf2zlWvjIpJVPr8zbP9jXOvJw9H1KwfzL0mmuSd4=;
        b=EuMNUFCfE0m86T6owuPiuM3nPqKSsrppr0wIRvWzkBFqPSyYAwjgWJ61t4zN5rSJu0
         Ayeta9huLcJBWt0FElPaKqc5fDe+DbWXiyF99GiNyAdXME7CQe2Kmkl+BVekSF0Vxu7G
         oBHNbJoqx+5q+tpwJOfaYMWZyXMm3dQRCX2xX4D9OIzKM/Rs/T0klFg7Gk8IR0+QKyJT
         8qh8yNo4uL4Ej350MaH8gIp7cbyU12rhdfkT2rwiE5veSRw00Ta7pPwlINcE1PMp+Rjp
         m4SOAfrSesBUy5Y240gqXo9HO2Z5HP76qwj/RFXri19iewh5vTbHAfqLfzYXAQ7M5waU
         5jqA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, suhua.tanke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

"synchronize cpus_allowed to cpu_active_mask"
-> "synchronize cpu_active_mask to cpus_allowed"

Signed-off-by: suhua <suhua.tanke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b0aee733b92b..4810d29e2d63 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3739,7 +3739,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	if (!cpus_updated && top_cpuset.nr_subparts_cpus)
 		cpus_updated = true;
 
-	/* synchronize cpus_allowed to cpu_active_mask */
+	/* synchronize cpu_active_mask to cpus_allowed */
 	if (cpus_updated) {
 		spin_lock_irq(&callback_lock);
 		if (!on_dfl)
-- 
2.34.1

