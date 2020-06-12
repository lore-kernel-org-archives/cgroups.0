From: zzuedu2000-9Onoh4P/yGk@public.gmane.org
Subject: [PATCH] Fix code style same in one function
Date: Fri, 12 Jun 2020 21:54:59 +0800
Message-ID: <20200612135459.28537-1-zzuedu2000@163.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=L2UPa91bTaGr2nGxt5
        46epMlCxYbdwpTFHQ6idsU4S4=; b=DUtxQ+F39DdxT4/o5nwzw+dQRvWV6hXvsh
        cT+dsbwpbNQIrxYtZhf+JsJu7IGssukccNGHHleJPkYGyQmcDBM2Ki6cKLuwhgmj
        3BnWVewvWWhTvxJCDgX4EC9NL3hZe9qdxJRUAIio2uII9TsLxK1Yv4hVpxl291HM
        4Ye2IkZNA=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, weifenghai <zzuedu2000-9Onoh4P/yGk@public.gmane.org>

From: weifenghai <zzuedu2000-9Onoh4P/yGk@public.gmane.org>

One line similar code before in this function

Signed-off-by: weifenghai <zzuedu2000-9Onoh4P/yGk@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1ea181a58465..c3e6db6e44d8 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4352,8 +4352,7 @@ static struct css_set *css_task_iter_next_css_set(struct css_task_iter *it)
 	}
 
 	/* find the next cset */
-	l = it->cset_pos;
-	l = l->next;
+	l = it->cset_pos->next;
 	if (l == it->cset_head) {
 		it->cset_pos = NULL;
 		return NULL;
-- 
2.17.1


