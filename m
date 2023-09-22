From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] memcg, oom: do not wake up memcg_oom_waitq if waitqueue is empty
Date: Fri, 22 Sep 2023 07:05:29 +0000
Message-ID: <20230922070529.362202-2-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1695366346; x=1695971146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XVblwGEZgzzMamuC2lPhj14gVXLYTQn0EwcGLXw/zVI=;
        b=Yi3IgC1J4m1C1Iaz12L0Qr/sEJYpVFT7xpKLE/VYVUXL7BIzQ4AAfW8GK8ivNTU++L
         fISQcvxWPyVVy2J7XsL8bFQu/gHRdVNyt1hmKSn+3OBGzUMOoe4+zUoVtKuz2IS/8tmb
         JFA+RMSRsDqSNxR3BcZdVzqLeu8iUhmr2kOzUsOIiUZc6wwwsu3oM2VEqx4FiR6w/L/Z
         nInXOAoZztjSv1UmyyMHiqf0t4U4hMuUjPk51jbTsLM3yw534hqv2OEiZy2myh5YvIcv
         p/J8P/gELrybiQmttcV04RxQ+Ns1LRcwlbsBWoSUG+fJ2I2czj+DDyUFJufmqB5Jkhr8
         E3pQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

Only when memcg oom killer is disabled, the task which triggers memecg
oom handling will sleep on a waitqueue. Except this case, the waitqueue
is empty though under_oom is true. There is no need to step into wake
up path when resolve the oom situation. So add a check that whether the
waitqueue is empty.

Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0b6ed63504ca..2bb98ff5be3d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1918,7 +1918,7 @@ static void memcg_oom_recover(struct mem_cgroup *memcg)
 	 * achieved by invoking mem_cgroup_mark_under_oom() before
 	 * triggering notification.
 	 */
-	if (memcg && memcg->under_oom)
+	if (memcg && memcg->under_oom && !list_empty(&memcg_oom_waitq.head))
 		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
 
-- 
2.25.1

