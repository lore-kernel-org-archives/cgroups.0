From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/7] cgroup: cgroup_idr_lock should be bh
Date: Fri,  9 May 2014 15:32:50 -0400
Message-ID: <1399663975-315-3-git-send-email-tj@kernel.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U/Q47VRoBYmQ7Z6zBmGEp4eYZxzrifDxpTlGF6HvgYg=;
        b=frLWX75NHE9nIXI7xms8DfxVFilVfdL857JhVXh1/jo/61GAn+iP9Ibpp7+ly26Vvn
         ghs0qJz1Ihw0Sz3wtNuu8qqeUgQUKegfWRX6+zOgSW/tLKHuMKwRBrg/cn1CyiD7vwGA
         9ReNdsCCHEo07RFN9+82wjdARiD5mYCmwGaOo9+xPjQHkqKRQ1Yy7vBlwH3YsTQXP2ic
         NxCNz6PIFNzCUWHlMhpQmp/SKFZ/h15/TWQdU5uR9KhHuLzPcAx44bOOJPfKXPwii1cG
         iVPYa5EGiasKEt0tUNjMZcGwXlD/nBr6P8v/qCvbhFzm5jhvZ6Fol7vvHXzRrPjm8ECL
         FuFA==
In-Reply-To: <1399663975-315-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup_idr_remove() can be invoked from bh leading to lockdep
detecting possible AA deadlock (IN_BH/ON_BH).  Make the lock bh-safe.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 95fc66b..e2ff925 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -203,9 +203,9 @@ static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
 	int ret;
 
 	idr_preload(gfp_mask);
-	spin_lock(&cgroup_idr_lock);
+	spin_lock_bh(&cgroup_idr_lock);
 	ret = idr_alloc(idr, ptr, start, end, gfp_mask);
-	spin_unlock(&cgroup_idr_lock);
+	spin_unlock_bh(&cgroup_idr_lock);
 	idr_preload_end();
 	return ret;
 }
@@ -214,17 +214,17 @@ static void *cgroup_idr_replace(struct idr *idr, void *ptr, int id)
 {
 	void *ret;
 
-	spin_lock(&cgroup_idr_lock);
+	spin_lock_bh(&cgroup_idr_lock);
 	ret = idr_replace(idr, ptr, id);
-	spin_unlock(&cgroup_idr_lock);
+	spin_unlock_bh(&cgroup_idr_lock);
 	return ret;
 }
 
 static void cgroup_idr_remove(struct idr *idr, int id)
 {
-	spin_lock(&cgroup_idr_lock);
+	spin_lock_bh(&cgroup_idr_lock);
 	idr_remove(idr, id);
-	spin_unlock(&cgroup_idr_lock);
+	spin_unlock_bh(&cgroup_idr_lock);
 }
 
 /**
-- 
1.9.0
