Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646263CEBA7;
	Wed, 15 Jul 2026 08:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104998; cv=none; b=qPflbIPHwSC4Zle6qNFAXS1w7WUtEMacwXJm+G5zFHZLC+kqrSRrtLDMHn8dM6rdUmVjpyw85CHZq46g5TavcJ/3GUFLRSLYqmG8z31xWkhFnM6HUthXcuGPHli++VMGGN8YGbToCeNP/WB+cO5UhKNwR/TZIzSjrqp/UU4KR7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104998; c=relaxed/simple;
	bh=bp04IfpTXwqDWE4OiBCTCvLIyxvFPRFwzqQUSwDoc7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VfJU9V5xGQL/+kJWvmca98a9qJ9PMFDLs4sc1IowbgXbEarCprtWlUxtb57oFLBr5utUKiNTh32PO+RRhZfKYiLmf9R/8y+1Loz2ioa+bD+PxZVJMOdIsfMWV9gAQKpAVg3Bd7RjkAsws7IFMnODN7zwN6kTtIH4/DIJReA2tk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=f9R9IKsj; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="f9R9IKsj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784104976; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=12M2C8oNrX4W/lZsGpGf4St8yDFGlxVr32q83YO8G5A=;
	b=f9R9IKsj4roBzFSJ2WBC0l9zaMmR9SJpchM6Iz8rWwK2IvIBOtzB9+5VrnAvMpkufE3zoRjbK6n4T2w0BsV/y/mh2unZcVEJbMN1hN+tZZTdU74jNSH8Bnv549y5GAPk/AL8HSSU1XUTVgp3ttDvjvbX9Q50S+plxKYRD37Eeiw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=lulie@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X78YfRB_1784104974;
Received: from localhost(mailfrom:lulie@linux.alibaba.com fp:SMTPD_---0X78YfRB_1784104974 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Jul 2026 16:42:55 +0800
From: Philo Lu <lulie@linux.alibaba.com>
To: stable@vger.kernel.org
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	eadavis@qq.com,
	surenb@google.com,
	akpm@linux-foundation.org,
	dust.li@linux.alibaba.com
Subject: [PATCH 6.1.y 1/2] cgroup/psi: Set of->priv to NULL upon file release
Date: Wed, 15 Jul 2026 16:42:52 +0800
Message-Id: <20260715084253.43276-2-lulie@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20260715084253.43276-1-lulie@linux.alibaba.com>
References: <20260715084253.43276-1-lulie@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chen Ridong <chenridong@huawei.com>

commit 94a4acfec14615e971eb2c9e1fa6c992c85ff6c6 upstream.

Setting of->priv to NULL when the file is released enables earlier bug
detection. This allows potential bugs to manifest as NULL pointer
dereferences rather than use-after-free errors[1], which are generally more
difficult to diagnose.

[1] https://lore.kernel.org/cgroups/38ef3ff9-b380-44f0-9315-8b3714b0948d@huaweicloud.com/T/#m8a3b3f88f0ff3da5925d342e90043394f8b2091b
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
---
 kernel/cgroup/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5ff7619301458..fe6cb64e7c662 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4072,6 +4072,7 @@ static void cgroup_file_release(struct kernfs_open_file *of)
 		cft->release(of);
 	put_cgroup_ns(ctx->ns);
 	kfree(ctx);
+	of->priv = NULL;
 }
 
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
-- 
2.47.3

