From: yuankuiz@codeaurora.org
Subject: Re: [PATCH]cgroup: __cpuset_node_allowed return bool
Date: Sat, 24 Mar 2018 13:05:50 +0800
Message-ID: <0fee75e4a1b12f5fca30e04306a95788@codeaurora.org>
References: <d2f9fe6096235032f445ab88e562560f@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1521867950;
        bh=JNT26J/WRwrXMWO/PF2FDpOPKqbjgeb39zBVRAy4AEs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YnTiNzi7oex7kBQOa05Tw/35GWaHulGm3s+VRCY8Ln4yHU7lFAEtplYmsZxTUikrd
         sxu5s5zMgrkMmAMvj1lehlX4UWuzq7uf8PsZnxl73bYGwxE3VNRYSx2dudBTKWPZdJ
         lmqsbzTV+TPBpmWFRJ1EJ4KEKnH23/LViwG48qak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1521867950;
        bh=JNT26J/WRwrXMWO/PF2FDpOPKqbjgeb39zBVRAy4AEs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YnTiNzi7oex7kBQOa05Tw/35GWaHulGm3s+VRCY8Ln4yHU7lFAEtplYmsZxTUikrd
         sxu5s5zMgrkMmAMvj1lehlX4UWuzq7uf8PsZnxl73bYGwxE3VNRYSx2dudBTKWPZdJ
         lmqsbzTV+TPBpmWFRJ1EJ4KEKnH23/LViwG48qak=
In-Reply-To: <d2f9fe6096235032f445ab88e562560f@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, pkondeti@codeaurora.org, cgroups-owner@vger.kernel.org

 From 304cec1cc42255fbd9e231a810f4eea20ab74b90 Mon Sep 17 00:00:00 2001
 From: John Zhao <yuankuiz@codeaurora.org>
Date: Sat, 24 Mar 2018 13:01:32 +0800
Subject: [PATCH] cgroup: __cpuset_node_allowed return bool

as a bool, __cpuset_node_allowed(...) return should be bool.

Signed-off-by: John Zhao <yuankuiz@codeaurora.org>
---
  kernel/cgroup/cpuset.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b42037e..42338b7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2552,7 +2552,7 @@ static struct cpuset 
*nearest_hardwall_ancestor(struct cpuset *cs)
  bool __cpuset_node_allowed(int node, gfp_t gfp_mask)
  {
  	struct cpuset *cs;		/* current cpuset ancestors */
-	int allowed;			/* is allocation in zone z allowed? */
+	bool allowed;			/* is allocation in zone z allowed? */
  	unsigned long flags;

  	if (in_interrupt())
-- 
2.7.4
