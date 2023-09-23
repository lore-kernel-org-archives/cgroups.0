From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RESEND] memcg, oom: unmark under_oom after the oom killer is done
Date: Sat, 23 Sep 2023 08:17:39 +0000
Message-ID: <20230923081739.398912-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1695457147; x=1696061947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=53y+MSASX7iIoRiw0N0MaPINtyDxfHQ2/xhc/ZQOZdc=;
        b=BAGk2HHKrLK2UGICWdY8buG7pDqs5uR9HbtIFuj4ToKGt9FTCzsPi4r3WdpoyH3EPE
         xbpIBLRg3df4Ah9DMtpiRHE5kPyT/4jzpl+hwyum31gNAWGC9aU1LNDMOPFsHpd/ez2f
         0Cqf1x+3+m3VJykXt/ed30ZmVzJD+ta8+CTSSaaFwx+O1qpBwmcJEc2jDErvGq9VN6XT
         HQ5+ppYZGAI5M9SrPnjdhEinMC3S19d5bbrD/eF2e4ZAV35tgAXA9WUa4kZ6mnIB/19o
         SQXDn6PI7qxJPNXXhuloHwV7J2CmlH2zPdzv6m2VQOOmqJRYTetQOc5WuuACkzXx9EA5
         M9QA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

When application in userland receives oom notification from kernel
and reads the oom_control file, it's confusing that under_oom is 0
though the omm killer hasn't finished. The reason is that under_oom
is cleared before invoking mem_cgroup_out_of_memory(), so move the
action that unmark under_oom after completing oom handler. Therefore
the value of under_oom won't mislead users.

Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8ca4bdcb03c..0b6ed63504ca 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1970,8 +1970,8 @@ static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
 
-	mem_cgroup_unmark_under_oom(memcg);
 	ret = mem_cgroup_out_of_memory(memcg, mask, order);
+	mem_cgroup_unmark_under_oom(memcg);
 
 	if (locked)
 		mem_cgroup_oom_unlock(memcg);
-- 
2.25.1

