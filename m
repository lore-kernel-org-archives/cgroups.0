Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3E6379EC1
	for <cgroups@vger.kernel.org>; Mon, 22 Jun 2026 11:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782126459; cv=none; b=fpzjFOyNHPaVVpbMySeT3JwAVOszph4k6soTA+mu1cAWZz4nLNPTqwF4/LIUV7DtkX/M8WgtZLlzl6uNJ3dPxH5DC4Vd1A5MD84k5kjqED65DBISlTYuCOj+Dpnp+neYYtiylCWBeHul3kTXAZDeEHqN5wIOetI5PgRqvxZ9iDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782126459; c=relaxed/simple;
	bh=6DrBo8HhCAFr4ixdaoPdbufVc3tmI+R4bk3nuxCXq40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dSkV9MIph53UFn5AaXXvSQqMC5dXk/mAmsusN1LiZ65Irp2LLUW35jVclUSvYcW1kPkHDmmGqKrYRqmJ9sbf9XblYRFPFrIR8+H4clPBziRTRE8AdcCcyaQ9k1E2JGD5VaEa46tiUzqZoFjU2OJ0r4qC6jbO42Hw1aUMk9gMGtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xMzAngPa; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xMzAngPa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782126446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=J9tbcbEHAxEd0cLxohalzyjnZY/gZNSsc7sVRvTS3pQ=;
	b=xMzAngPaPeLLYnhq6fRhNG1YbzHxLoNIYijtry6bEuY0M4u+wKlLTV6cu4+H2/wym0E2gj
	60qrLoUwjXhxeXNKzCil2lbxvLoSlW2nU1Q6DaJks3kBaFF4g0tnEFhpJSBlz5E6e72JzB
	2W5ViYICij4Bz6Ye+o5u/HlnhKrS/0Y=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] cgroup: Fix a typo of the function name in comment
Date: Mon, 22 Jun 2026 19:07:08 +0800
Message-ID: <20260622110708.15593-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

... which was wrongly written as cgroup_threadcgroup_change_begin().

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 include/linux/cgroup-defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index de2cd6238c2a..7a631a257613 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -896,7 +896,7 @@ static inline void cgroup_threadgroup_change_begin(struct task_struct *tsk)
  * cgroup_threadgroup_change_end - threadgroup exclusion for cgroups
  * @tsk: target task
  *
- * Counterpart of cgroup_threadcgroup_change_begin().
+ * Counterpart of cgroup_threadgroup_change_begin().
  */
 static inline void cgroup_threadgroup_change_end(struct task_struct *tsk)
 {
-- 
2.53.0

