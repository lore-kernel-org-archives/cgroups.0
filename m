From: Shida Zhang <starzhangzsd@gmail.com>
Subject: [PATCH] cgroup: fix potential null pointer risk
Date: Tue, 17 May 2022 15:31:06 +0800
Message-ID: <20220517073106.1704628-1-zhangshida@kylinos.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1f0Z9m+vbuD/qdSf6InzF9TURBzbVV0rFya1IWbNtOo=;
        b=NpF/ctrLv7ZXdNrGCvD0hg21ovh+HtPwfrjn2Vn5+Kaz9xxkY2bSYYX+jvXLILwQmK
         GNLyzcfB9p5vtLQyy080RlDn8BI/wOniIJePP1KfvLiFgwFrQd2W2jb1Gjn+tfUWmqSg
         oBuNRiQ/JvyIjvF86rQ94VnSC37y9e+rwNNOkVJr86rgx1kQ6N+DBrz75BSMppUymB4a
         8vIJ3KqS7hfl2k07Q0i8lZWEIxmNWOfhMWwhtEa/aH0p0X8X5hnj6QH0zvS7wnEo439v
         7pQqte7CIDeDmOeRajJft70DLqgo/e06I4kSUJW1Ztg9IyrJ/WQKDI2KPfQxXVjnbHgL
         hPow==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: zhangshida@kylinos.cn, starzhangzsd@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

We previously assumed 'parent' could be null,
so null pointer judgment should be added.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 kernel/cgroup/cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index adb820e98f24..7f230b0ab644 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5701,7 +5701,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	}
 	spin_unlock_irq(&css_set_lock);
 
-	cgroup1_check_for_release(parent);
+	if (parent)
+		cgroup1_check_for_release(parent);
 
 	cgroup_bpf_offline(cgrp);
 
-- 
2.25.1

