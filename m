From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH -next] cpuset: fix non static symbol warning
Date: Fri, 16 Sep 2016 13:02:37 +0000
Message-ID: <1474030957-6589-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Eh+L4cFrX+luPMfw2v5A/N760v95u1ab+eu+V7egnPA=;
        b=epmAmgVXDqzlawZWGqarO4Vm00oNfurItxZYPhc6l3PCwvjQkNJody3DxC1OIo3hCW
         xdVcm+L5T8dLL5CSFtZomPRKOz7q/NQ5M6QyGS9BPbzlWtz/4wZWIGtE0FLAOSVDpeOU
         AlLd2vzoMYl3ilIUF+PmwS+Z5xS9vDsO1faqxBOPjy9rBuubY8ekHu5S2KLRVwqAtz2M
         I+RDSX5C5t2i9Jf3ifCM/GGbFcxpcrPe3psh6zAtfS78RKSukZztniTsLfOTtW1nVoSn
         zciWyJdWYpox7XQWSX/9b4CPkX50wDPl6CK8XJwIgmhXEzcDHZGpGzMZ+aDOD7x34GwY
         7moQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Fixes the following sparse warning:

kernel/cpuset.c:2088:6: warning:
 symbol 'cpuset_fork' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 8141c6b..7fa608d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2085,7 +2085,7 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
  * which could have been changed by cpuset just after it inherits the
  * state from the parent and before it sits on the cgroup's task list.
  */
-void cpuset_fork(struct task_struct *task)
+static void cpuset_fork(struct task_struct *task)
 {
 	if (task_css_is_root(task, cpuset_cgrp_id))
 		return;
