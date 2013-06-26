From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-3.11] cgroup: grab cgroup_mutex in
 drop_parsed_module_refcounts()
Date: Tue, 25 Jun 2013 18:05:21 -0700
Message-ID: <20130626010521.GE30407@mtj.dyndns.org>
References: <51C9D17B.5090208@oracle.com>
 <20130626010454.GD30407@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+NAH1LbI6EiPkADj20UUt8Fz0aeReXKe8nccJPYa0DE=;
        b=qSyYN84aLnDbjOINIcyAvf3i7l7966K88kHGS763JXj4DpI9DFXIxJIoz4xxRStU2p
         01d/l8qW25iAolnko2XRwsavRd/ah1QX9mqCLh4ehCJYiUdympa9BSREoKYYmUgquN4r
         T367Y7hkXRTa3uNnyTtemQuBt1WPrkCY+6iZbwAfG9xspTjViNLMHMCKnOvVMRSa0jL8
         +HiJ+NLHObd6oe5h059ImGOe8vtNw/x1HP3eBTRkartj7WuXwTZfksXS9MmJdPQg4nUK
         GSjKMilkTlgvLpOQkwN1Yj78x567nfIFXV4JD3tFECiPCvU2CAVUH7UncTRq7bu02KLw
         0ZJg==
Content-Disposition: inline
In-Reply-To: <20130626010454.GD30407@mtj.dyndns.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: lizefan@huawei.com, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, trinity@vger.kernel.org

This isn't strictly necessary as all subsystems specified in
@subsys_mask are guaranteed to be pinned; however, it does spuriously
trigger lockdep warning.  Let's grab cgroup_mutex around it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1325,11 +1325,11 @@ static void drop_parsed_module_refcounts
 	struct cgroup_subsys *ss;
 	int i;
 
-	for_each_subsys(ss, i) {
-		if (!(subsys_mask & (1UL << i)))
-			continue;
-		module_put(cgroup_subsys[i]->module);
-	}
+	mutex_lock(&cgroup_mutex);
+	for_each_subsys(ss, i)
+		if (subsys_mask & (1UL << i))
+			module_put(cgroup_subsys[i]->module);
+	mutex_unlock(&cgroup_mutex);
 }
 
 static int cgroup_remount(struct super_block *sb, int *flags, char *data)
