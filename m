From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/7] cgroup: use release_agent_path_lock in cgroup_release_agent_show()
Date: Fri,  9 May 2014 15:32:54 -0400
Message-ID: <1399663975-315-7-git-send-email-tj@kernel.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cMLhzjQhorQhe3KbKIE7a/E5rL70y82OxDAFgvfHd+s=;
        b=nfGmjyOqMtj/hVgJxAKQJtSZ09cJ659Txz/VgbpDuHxrl5wHt/aLbXjaTrIspQhqUY
         yYKzlTjHo5E/ntV/e1TODEi4hw3IntyuWZxUys3+bKI9f9udwKjAe6zXzLiHuE8pMy5e
         5PPBfojAu+pVYVDRK/K+i016g6IrnSbQPf5uSJ51BmRqajtPlQ9I2ghxQpgkiO6jSGlK
         gs2N0xF6cv4KTOPbkeA0H7VZKfBnn0t1C0gTdJGtQ7Jwp8p3D+n1NKXl3UONCAwh2Xbr
         9abTrqWv4YGixoMygBJClMPOmoidida0xOhF7ZLy3yax5mm5/3T4G3wAIZmo+MJOlk+q
         F2pQ==
In-Reply-To: <1399663975-315-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

release_path is now protected by release_agent_path_lock to allow
accessing it without grabbing cgroup_mutex; however,
cgroup_release_agent_show() was still grabbing cgroup_mutex.  Let's
convert it to release_agent_path_lock so that we don't have to worry
about this one for the planned locking updates.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ff92bac..7b55ca5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2373,11 +2373,10 @@ static int cgroup_release_agent_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	if (!cgroup_lock_live_group(cgrp))
-		return -ENODEV;
+	spin_lock(&release_agent_path_lock);
 	seq_puts(seq, cgrp->root->release_agent_path);
+	spin_unlock(&release_agent_path_lock);
 	seq_putc(seq, '\n');
-	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
 
-- 
1.9.0
