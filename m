From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH] cpuset: remove unused task_has_mempolicy()
Date: Mon, 18 Feb 2019 15:28:11 +0900
Message-ID: <1550471291-4327-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com x1I6SF1Z003818
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1550471296;
        bh=GQ7y1jv3TPMmSnBg82zb/DrP9e/mLTCQYVUXjI9OyZ4=;
        h=From:To:Cc:Subject:Date:From;
        b=KkA3AKPZ51exYb2sT/Xer+WNznFqHg5jSHzJaOkrzi89Me3a+WapQkd+0VVxGWMt+
         D315WrZ1URvw8GckMPFT/LVqSOtTEbjl2WxpUWYYccQJ2CFgPhy66HzBa/ElDa50WA
         4trva+OK9SxyQhykCu7cZeWylxqkYkF6nh4lbP4/tw3fy55Ohr9Y9IOdqBA1PJWilT
         Iq11cpMPGyY0K8pKCK+RkBHqNKMiawtr+V9sLTWKj1v6Qu5gxbokMjtUFZ8k3T44NM
         5BVO3DVnhjMXE241ukLo7JclWtX90L+iIz/z2MXhP6j6iP/+8acZ+Kua/9X0Im/aWO
         0jGEtrIS3U9iQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org

This is a remnant of commit 5f155f27cb7f ("mm, cpuset: always use
seqlock when changing task's nodemask").

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 kernel/cgroup/cpuset.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 479743d..72afd55 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -203,19 +203,6 @@ static inline struct cpuset *parent_cs(struct cpuset *cs)
 	return css_cs(cs->css.parent);
 }
 
-#ifdef CONFIG_NUMA
-static inline bool task_has_mempolicy(struct task_struct *task)
-{
-	return task->mempolicy;
-}
-#else
-static inline bool task_has_mempolicy(struct task_struct *task)
-{
-	return false;
-}
-#endif
-
-
 /* bits in struct cpuset flags field */
 typedef enum {
 	CS_ONLINE,
-- 
2.7.4

