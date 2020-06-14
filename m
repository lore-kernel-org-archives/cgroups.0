From: zzuedu2000-9Onoh4P/yGk@public.gmane.org
Subject: [PATCH] cgroup: Refactor two assignments in css_task_iter_next_css_set()
Date: Sun, 14 Jun 2020 10:28:33 +0800
Message-ID: <20200614022833.2641-1-zzuedu2000@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=R2b6w
        Jp/Gu3jW9BF0+d6Dg/51CAAqjCiWDo1SliDiWA=; b=NRrOvDxTUB4AvIdiCo2Vw
        WLW6zJBowDWDOya8eb6S6BLRqku4qH6P5hOc/IZ4POav5Z6eyUzpppDC5BOFs+bS
        f7uRI0jtsvwe6ML8rAFmPxUy7ZQOALv7irQFO6FQj929RoN351ai1NZqItdKqzYM
        6p3P56+zW5pCTeMZ/yxguU=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Markus.Elfring-S0/GAf8tV78@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, buddy.zhang-Dw/NWeUnuQfQT0dZR+AlfA@public.gmane.org, Wei Fenghai <zzuedu2000-9Onoh4P/yGk@public.gmane.org>

From: Wei Fenghai <zzuedu2000-9Onoh4P/yGk@public.gmane.org>

Combine two assignments for the variable ‘l’ into one statement.

Signed-off-by: Wei Fenghai <zzuedu2000-9Onoh4P/yGk@public.gmane.org>
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


