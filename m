From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] cgroup: cosmetic update to cgroup_taskset_add()
Date: Thu, 29 Dec 2016 17:11:13 -0500
Message-ID: <20161229221115.31995-2-tj@kernel.org>
References: <20161229221115.31995-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LVdylKTsij8YUc0IdnFq+GLVL6lHDfuOxcsMMT7FTs8=;
        b=dWXeQQIn7cGeAvOqkVenvPaZK7ZI38N2NUiA1HOUphv2aAyQj6YbpH8f6gEI3U7h+f
         3n05+rCPnpqYMV8PyYjGY11NFl0sZ6ocfHo8qVSJ30ceDNSCYlfI0y+AB62Q7Z4nQVK1
         gmwZG7ma0/it7e3PTZsCLEUN1izwowNaugNFSYF+XzWDMmshawKjj37CjtUEAB9REfAy
         nulMuqIvasxWfpChe6LPusoHNfcdLjB3KabAp6Azz60dbj/TWOVxN2Y89ypIOxIHKvEe
         TwHl7H4Ff6H8yhll1+RZSH/8C98GCDkhhXFpLYeZntnwFC+u/tadPc2PoWNYTqtVdnC6
         H5Zw==
In-Reply-To: <20161229221115.31995-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup_taskset_add() was using list_add_tail() when for source csets
but list_move_tail() for destination.  As the operations are gated by
list_empty() test, list_move_tail() is equivalent to list_add_tail()
here.  Use list_add_tail() too for destination csets too.

This doesn't cause any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d9d82e9..aed492e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1980,8 +1980,8 @@ static void cgroup_taskset_add(struct task_struct *task,
 	if (list_empty(&cset->mg_node))
 		list_add_tail(&cset->mg_node, &tset->src_csets);
 	if (list_empty(&cset->mg_dst_cset->mg_node))
-		list_move_tail(&cset->mg_dst_cset->mg_node,
-			       &tset->dst_csets);
+		list_add_tail(&cset->mg_dst_cset->mg_node,
+			      &tset->dst_csets);
 }
 
 /**
-- 
2.9.3

