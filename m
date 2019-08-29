From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] blkcg: fix missing free on error path of blk_iocost_init()
Date: Thu, 29 Aug 2019 08:53:06 -0700
Message-ID: <20190829155306.GV2263813@devbig004.ftw2.facebook.com>
References: <20190828220600.2527417-1-tj@kernel.org>
 <20190828220600.2527417-9-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ioZ+JfnsUUD8UiGNxKeFQMLhM3bnVtElsPe+wTUng7A=;
        b=ZGwkXiJHqAtV+JCPJOeiRPEL19aCTJG0iUo1GcyA13cQXILHAX71nOjecvBWnxh33S
         /I76lZ80uyyYxLB+BwAFHTIEgiWBKPQ4tbZ1PC6Q9VVA6sSFcrat7NmGapzjPQ0I3Bqt
         5rqWkN+uqw49TlREjShKZxY+d0FbxhvZciKk2kOh7bscxdTNuy00hZwY58BSUsnrcXE3
         +f9DP7dTz6EwsOJKQ6Q6uox/0PPe8w7wUbOkI8jky8+W8uXrkEhGHt7u//bpCR21cUxQ
         XvaShzQ4s4IWaclSTZ1kxjbU9BcEpx/jsKlyWeQ69iG44mLZJF0eEexc0vQy/GXrorhQ
         62Lg==
Content-Disposition: inline
In-Reply-To: <20190828220600.2527417-9-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, Josef Bacik <jbacik@fb.com>, Rik van Riel <riel@surriel.com>

blk_iocost_init() forgot to free its percpu stat on the error path.
Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Hillf Danton <hdanton@sina.com>
---
 block/blk-iocost.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index f04a4ed1cb45..9c8046ac5925 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1876,6 +1876,7 @@ static int blk_iocost_init(struct request_queue *q)
 	ret = blkcg_activate_policy(q, &blkcg_policy_iocost);
 	if (ret) {
 		rq_qos_del(q, rqos);
+		free_percpu(ioc->pcpu_stat);
 		kfree(ioc);
 		return ret;
 	}
