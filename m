From: yuankuiz@codeaurora.org
Subject: [PATCH]cgroup: __cpuset_node_allowed return bool
Date: Sat, 24 Mar 2018 12:56:48 +0800
Message-ID: <d2f9fe6096235032f445ab88e562560f@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1521867409;
        bh=sq1sm22mzHkGWaiXLlZ8nOeRSW5L49tLjX22ZgNxl+c=;
        h=Date:From:To:Cc:Subject:From;
        b=pAcTrPUPr5qWkHskOzWsFzI9YArGrIh8e8ukGAnw7z2sVsNihuibU982MdxF/R3oU
         bWGvQGZC6PCrGMNC0PwjtaSC6zkdioJLQTJu90EPJDFiNarLp05ZMPviIjfPCElzez
         cJnFVFRrRW+dVgauTPZZ57GWc5I5GLnkqMViEKSM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1521867408;
        bh=sq1sm22mzHkGWaiXLlZ8nOeRSW5L49tLjX22ZgNxl+c=;
        h=Date:From:To:Cc:Subject:From;
        b=kZUldzfVru5HjAKtcq7syG3JYj/FhLv5Dg7sNEOSeZLbiwqplDi2K67PNSRmFl93U
         SN/Qqpcb6ZXG6Mkpe2xhiM2uRi8quvKUk41KbRcrf1YFJdzaKMkh229slT7WCQ8a42
         pZPZK90Lp7lkPrreeOUV1yjog1e1wb3dZXhvUoUI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups@vger.kernel.org, tj@kernel.or, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, pkondeti@codeaurora.org

as a bool, __cpuset_node_allowed(...) return should be bool.

Signed-off-by: John Zhao <yuankuiz@codeaurora.org>

--- kernel/cgroup/cpuset.c.orig	2018-03-24 12:39:27.854178608 +0800
+++ kernel/cgroup/cpuset.c	2018-03-24 12:40:51.020708670 +0800
@@ -2552,7 +2552,7 @@ static struct cpuset *nearest_hardwall_a
  bool __cpuset_node_allowed(int node, gfp_t gfp_mask)
  {
  	struct cpuset *cs;		/* current cpuset ancestors */
-	int allowed;			/* is allocation in zone z allowed? */
+	bool allowed;			/* is allocation in zone z allowed? */
  	unsigned long flags;

  	if (in_interrupt())
