From: Vladimir Rutsky <rutsky@google.com>
Subject: [PATCH] cgroup-v2.txt: fix typos
Date: Tue,  2 Jan 2018 17:27:41 +0100
Message-ID: <1514910470-4260-1-git-send-email-rutsky@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YRf7VVpfhi0idTgbHc9hDM2uwk09SDjq6JgY78EUO5Y=;
        b=o9s8dAILSnxrJ7bl7dJF9CqFHQGkkBvOBSaJ+0WTfUF2zXY+IetdjRPAxxEKtpvy6G
         KpQxfiuL/AzASh4Su75JS4Uei54Moxk/6oXSAb4RoQPsmdHgh68rk8q/x0Squd8UXg4t
         jkjJ9eZjKMY+wqS0QErJYKw5Td/DDzI/6xqcyzUDT12OAb49brAOJW8QcjG0fJk+vOMf
         us4hdFsAIKMzG+c1Z8Z7zycABONAOQmu/60tmh71GmVE+hbxTqC6fW4XtkUqhZIocLil
         9HTPV21LoJxGsseEQ4hln+fPsURrziSVAi3SV3e/hEAeOcEmz4knM2XWvk3Ix79nwjx5
         RIbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Vladimir Rutsky <rutsky@google.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Vladimir Rutsky <rutsky@google.com>
---
 Documentation/cgroup-v2.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 2cddab7..eb0b679 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -279,7 +279,7 @@ thread mode, the following conditions must be met.
   exempt from this requirement.
 
 Topology-wise, a cgroup can be in an invalid state.  Please consider
-the following toplogy::
+the following topology::
 
   A (threaded domain) - B (threaded) - C (domain, just created)
 
@@ -1063,10 +1063,10 @@ PAGE_SIZE multiple when read back.
 		reached the limit and allocation was about to fail.
 
 		Depending on context result could be invocation of OOM
-		killer and retrying allocation or failing alloction.
+		killer and retrying allocation or failing allocation.
 
 		Failed allocation in its turn could be returned into
-		userspace as -ENOMEM or siletly ignored in cases like
+		userspace as -ENOMEM or silently ignored in cases like
 		disk readahead.  For now OOM in memory cgroup kills
 		tasks iff shortage has happened inside page fault.
 
@@ -1191,7 +1191,7 @@ PAGE_SIZE multiple when read back.
 	cgroups.  The default is "max".
 
 	Swap usage hard limit.  If a cgroup's swap usage reaches this
-	limit, anonymous meomry of the cgroup will not be swapped out.
+	limit, anonymous memory of the cgroup will not be swapped out.
 
 
 Usage Guidelines
-- 
2.7.4

