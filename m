From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] memcg, oom: unmark under_oom after the oom killer is done
Date: Fri, 22 Sep 2023 07:05:28 +0000
Message-ID: <20230922070529.362202-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1695366342; x=1695971142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RyLfLRpZqTOqTStamV6qTVG95Q+PZuaFWt0g8stCLvk=;
        b=GyXK78Wfo/zOHzJBmK/cio1ZSi/CmeXiZWYClGzE/eEeoT02ZvR8iJ4AW28Ru31GoE
         p4/mYmvP1uWtq8DYw9eZjgjYRQmYtV2XBg8ZYGpV57snvTbg1y9BruWrZMKh/HkBfNke
         /GiOE9qudMMr6kH5H3HUr8WB4IKRAeC7OgKtJduXe49Wx1B6sSWiQqZNzUdK5ecLgszr
         fmemvMe3tH8sXXlmIGJRqjvcbVuneRJJdk87VWlLOZ4OB2nf9mkZRhfqX3G2z/NdSO0J
         rki3PeDUjQg0S79Q56Y+FRwqsrf9mABwrbCjZGL+lAJ2cMx0809BQa4ahgKU2fa3L1a2
         EDNQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

When application in userland receives oom notification from kernel
and reads the oom_control file, it's confusing that under_oom is 0
though the omm killer hasn't finished. The reason is that under_oom
is cleared before invoking mem_cgroup_out_of_memory(), so move the
action that unmark under_oom after completing oom handling. Therefore,
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

