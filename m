Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2B938BF6A;
	Wed, 15 Jul 2026 08:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104373; cv=none; b=JtSmiPEBpHNOaKyyJ1rUCi4hBYCHi3ydovWkwXIAAcR60IqVKyz6gLcEwmK1Ccm5ypJ5xy1yY+iZEG3T+JXXd5MlnH30Q/LNW2dlAn0DdDGH2ZG7LYInHcEGovBKrHuRS+Y9csS5YPvVh2quIHcnTbBAa/TBUuhiLZNipdZLHZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104373; c=relaxed/simple;
	bh=jYyNf7jdQ6Kq27ZTcM89OY3IiaCJpkGvNgIyNj9yIvo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vBJa9aYavmIFGpLjRMq3ALiLw02La7AMBaCXdeSqhEm62FARvKPmfXQnDc+E1qggm4w1bmGbSi+3VifQfBTWJXhQVUT3bfLHHO+moWdtf7EDKVe4jhnA/yiF/53YNx9Ect80DxMUUFGK1nBzM7nxpCA1VxKxpavII4GvXz3IyOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=x9mEQ4Qc; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="x9mEQ4Qc"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784104368; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=GK0Rc0oB65P7V7VYtRhPsG+gRmbfmhqvct0X2gUSOC8=;
	b=x9mEQ4QcIIwT12CYo0D6GAj0Nei3amdUJaxhCwyUrrZ4tboVAbRgWY5OS/faXjDlczCtxdjLuzrT+GpcQ1/we7KlwrqGzRulzLr4/bG9JI0SjxiOy7UzR+lZ4mtnn8qH7l/i6J55dXHfph1pMf6hN+yPgtxLEjgD24xEWZE0DEA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=lulie@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X78Q1GT_1784104367;
Received: from localhost(mailfrom:lulie@linux.alibaba.com fp:SMTPD_---0X78Q1GT_1784104367 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Jul 2026 16:32:47 +0800
From: Philo Lu <lulie@linux.alibaba.com>
To: stable@vger.kernel.org
Cc: chenridong@huawei.com,
	tj@kernel.org,
	lulie@linux.alibaba.com,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	eadavis@qq.com,
	chenridong@huaweicloud.com,
	akpm@linux-foundation.org,
	surenb@google.com,
	dust.li@linux.alibaba.com
Subject: [PATCH 6.12.y 1/2] cgroup/psi: Set of->priv to NULL upon file release
Date: Wed, 15 Jul 2026 16:32:44 +0800
Message-Id: <20260715083245.32115-2-lulie@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20260715083245.32115-1-lulie@linux.alibaba.com>
References: <20260715083245.32115-1-lulie@linux.alibaba.com>
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
index 3c7d466f13df7..3ce02650f9484 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4162,6 +4162,7 @@ static void cgroup_file_release(struct kernfs_open_file *of)
 		cft->release(of);
 	put_cgroup_ns(ctx->ns);
 	kfree(ctx);
+	of->priv = NULL;
 }
 
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
-- 
2.47.3

