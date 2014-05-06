From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] cgroup: use release_agent_path_lock in cgroup_release_agent_show()
Date: Tue,  6 May 2014 07:50:44 -0400
Message-ID: <1399377044-29873-5-git-send-email-tj@kernel.org>
References: <1399377044-29873-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1bPYtvX20j7w0fr/ijILVAzVwJAaQiq+CFn/GmslBIU=;
        b=qUwWFTIGlkKoepuAqbFrDZb5bViCQrjeTHFXUFExPReUqfmvqJuBoX1yABWBaj3Syv
         vNTPLVQIsUINeUA5WoAijrHjUYBiDgFAQq27Rfh3xUyHn2cfOau+1n5HPRjQCn3QyVaH
         g4PNn+YiUZcJvMdJjmGXjpqpjAjC3XMunLW7VjRNKLx4G75yTq99new1xWA5C6kTYLpd
         pRqwy2yDxFe6J7ktzHfE4w9KOnVmn1PxewuqRpJPVaW6zutgxFSoi2gh6LeJ5BUIv7hx
         BdOAXDezTubOPcrEXSYludFIJK0CA0QhOA+JnCT5PSv3Y7G6HTGUncWuGGro233zUbWH
         xLag==
In-Reply-To: <1399377044-29873-1-git-send-email-tj@kernel.org>
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
index 3ced79a..57c2021 100644
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
