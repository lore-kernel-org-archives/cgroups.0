From: williamsukatube-9Onoh4P/yGk@public.gmane.org
Subject: [PATCH -next] cgroup: simplify code in cgroup_apply_control
Date: Sat, 17 Sep 2022 16:40:39 +0800
Message-ID: <20220917084039.3177-1-williamsukatube@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=vO2ff
        7f+cjYtcbeBGzWru6y8NNAZmlNdhrWX/ZBZ7DE=; b=Rlv2gthXQP/yutEvEmIMG
        JRGcgkdPhTXIbKSo1WPWccwfkFON3yL4tA006dk8D8N1qRnhJ6QJ+TxqD2v88fcm
        g6/YomqSDOzDQ6V9yPG96srFUpnmmZmbNwEY5YljUrCFOKMyZPndqUN5z4CQryF0
        CX5H+LnWMlcXjzxbI26AeI=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: William Dean <williamsukatube-9Onoh4P/yGk@public.gmane.org>

From: William Dean <williamsukatube-9Onoh4P/yGk@public.gmane.org>

It could directly return 'cgroup_update_dfl_csses' to simplify code.

Signed-off-by: William Dean <williamsukatube-9Onoh4P/yGk@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e4bb5d57f4d1..1958f8bd93d6 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3292,11 +3292,7 @@ static int cgroup_apply_control(struct cgroup *cgrp)
 	 * making the following cgroup_update_dfl_csses() properly update
 	 * css associations of all tasks in the subtree.
 	 */
-	ret = cgroup_update_dfl_csses(cgrp);
-	if (ret)
-		return ret;
-
-	return 0;
+	return cgroup_update_dfl_csses(cgrp);
 }

 /**
