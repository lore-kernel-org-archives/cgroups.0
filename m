From: zzuedu2000@163.com
Subject: [PATCH v2] Fix code style same in one function
Date: Sat, 13 Jun 2020 08:53:06 +0800
Message-ID: <20200613005306.29988-1-zzuedu2000@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Kz/7X
        sIp5vi6UQF9WmOwilNhRidydQLpthW7IODNcgs=; b=ARwD0woT59rUntfmArYjg
        Zy7q5hAeeOd7TGZi9HMD0CI7ZoWn+7ai5MAb7A4uDoBLwct25tAZXe0UtswM4GEg
        Xi3wWybnIXg1/ZqMTK8seP3SFbGkaxvFGRC8AeyoA+ABx9TPcU4fSTwFytgYBZWI
        M8+8m+2BsIC3o8TNNl+CK0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, weifenghai <zzuedu2000@163.com>

From: weifenghai <zzuedu2000@163.com>

Combine two assignments for the variable “l” into one statement.

Signed-off-by: weifenghai <zzuedu2000@163.com>
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


