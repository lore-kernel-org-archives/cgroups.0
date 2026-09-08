Received: from mta0.migadu.com (out-165.mta0.migadu.com [91.218.175.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D196551C352
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 10:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861782; cv=none; b=m1qzx763Dwt9yaN0ohXOO5DDdrTDsXB7O+Wvy9fi5HfqeS3T6jRly8+k+w18uUkLhYLTl6pd8pppHIxO+WoghfygugTnFJYy7u3v15MyJFUiIbXC7pVYvNdUPQTVKL5MenwdtZMKkmnS9WUEBnaAQUcES/rd5QilkaZMYJ9Y/e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861782; c=relaxed/simple;
	bh=zn+RVb0VJos1Q3KLxQmsn4wBd6PEVCA2uEn2zoudQF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKMUEHP7Edcurtpx47zlzZPprSITyyzzKZ7uvWJghcfhiA5ZRbZyHXn0ogC4CjdDYfnJQd0sTaefgrJsHGO/STEGE4tHCE8T62DMYr7xUIYFt2Zt/g7RfN8pkqO9C9FS2x2U8Z7nQastxyUkvWX5P9pj9T4rntwrJIhSfnz2mro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uBrIayhg; arc=none smtp.client-ip=91.218.175.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uBrIayhg"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zn+RVb0VJos1Q3KLxQmsn4wBd6PEVCA2uEn2zoudQF8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788861778; v=1; x=1789466578;
 b=uBrIayhg1qvLnKlAUemR5sWSSxvzazsdFvetTvEU27PAKa3tiQFtW0bUKpS++U5qoxgt4TL2
 Tuh6txrY8dpVr7IK5iV3sb48eZgD5rRyi/rszqufsvjKLB5YEkkuHAlCWJ0AGzNbU3ZXQthCJU0
 LbEXDq1+4caI5Ogq/H7UCdQM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a502f24c1c2c7d6a;
	Tue, 08 Sep 2026 10:02:58 +0000
X-Mizu-Trace-ID: a502f24c1c2c7d6a
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	andrii@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [RFC PATCH 5/8] blk-iocost: add ctrl=bpf per-device opt-in
Date: Tue,  8 Sep 2026 18:01:40 +0800
Message-ID: <20260908100143.47598-6-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908100143.47598-1-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Add "bpf" to the ctrl= options in io.cost.model.  Writing
"$dev ctrl=bpf" to io.cost.model switches the device to the
registered BPF cost model (if any is registered); ctrl=auto or
ctrl=user switches back to the builtin model.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index bdb4bab86a116..a58c16fcb29fa 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3465,7 +3465,8 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
 	seq_printf(sf, "%s ctrl=%s model=linear "
 		   "rbps=%llu rseqiops=%llu rrandiops=%llu "
 		   "wbps=%llu wseqiops=%llu wrandiops=%llu\n",
-		   dname, ioc->user_cost_model ? "user" : "auto",
+		   dname, ioc->bpf_cost_model ? "bpf" :
+			   ioc->user_cost_model ? "user" : "auto",
 		   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS], u[I_LCOEF_RRANDIOPS],
 		   u[I_LCOEF_WBPS], u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS]);
 	spin_unlock_irq(&ioc->lock);
@@ -3505,7 +3506,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	unsigned int memflags;
 	struct ioc *ioc;
 	u64 u[NR_I_LCOEFS];
-	bool user;
+	bool user, bpf;
 	char *body, *p;
 	int ret;
 
@@ -3536,6 +3537,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	spin_lock_irq(&ioc->lock);
 	memcpy(u, ioc->params.i_lcoefs, sizeof(u));
 	user = ioc->user_cost_model;
+	bpf = ioc->bpf_cost_model;
 
 	ret = -EINVAL;
 
@@ -3551,11 +3553,20 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 		switch (match_token(p, cost_ctrl_tokens, args)) {
 		case COST_CTRL:
 			match_strlcpy(buf, &args[0], sizeof(buf));
-			if (!strcmp(buf, "auto"))
+			if (!strcmp(buf, "auto")) {
 				user = false;
-			else if (!strcmp(buf, "user"))
+				bpf = false;
+			} else if (!strcmp(buf, "user")) {
 				user = true;
-			else
+				bpf = false;
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+			} else if (!strcmp(buf, "bpf")) {
+				if (!iocost_bpf_model_registered())
+					goto unlock;
+				user = false;
+				bpf = true;
+#endif
+			} else
 				goto unlock;
 			continue;
 		case COST_MODEL:
@@ -3580,6 +3591,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	} else {
 		ioc->user_cost_model = false;
 	}
+	WRITE_ONCE(ioc->bpf_cost_model, bpf);
 	ioc_refresh_params(ioc, true);
 
 	ret = 0;
-- 
2.43.0

