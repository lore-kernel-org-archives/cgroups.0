Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2853C2D8385
	for <cgroups@vger.kernel.org>; Mon,  3 Aug 2026 13:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764101; cv=none; b=YFeXGtkge6T71Gy+6TN8NGCQ9W5e2cjAWMIWVgx4lwmvsqgrc7IS02BYzHOGk3fQc2bzeGsNVLg2Iqveq/nJmw0loquWCPlLNIn8lWiFQqW/SKYBSoS+Ag82Cr7AqxvL9HaiZMwBB86YDFtV6CyMMiXnk32/WqJotOVNs8f5CcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764101; c=relaxed/simple;
	bh=hoRDu+4AbYAADt0EycnPH9qwHLgjeRK7yb4EPt4BOYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gJcgwppIO8dpHfrFfumtUZzxGuPZxlXIkfCsxgPs6a08d8gU9+13k5MJBGYFcjBnNsBmgPEAl6LNXo6BrQ6xzq1YH6ce+djsR35K0++KmjrAtjqOMTrZ3CBsvt9FkbZOQuS9JsXrFqdcjEFgbVR4nu+5wr7eJI78FuA8jSBtWDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E2sz/eqZ; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E2sz/eqZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785764087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9YKfwhfo+RFaoiEVukYoPcX+sccIUjyOjCO3araKEvo=;
	b=E2sz/eqZ+KixgqoE9VjP9ola92TKFg5dhmXMi+lhRaSbZC8ADlHE5A0Gxm1aeQSCFXRSNA
	zT2tDlLjvFXKqTRYAbdPUhtJjhr2R+MhkvN08u+vPx7JMq+RKZ7MdKLguU27r2kOqTQm3a
	FcmvEQpP/u+nfgSUvNqalEQANQmzHZM=
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk
Cc: tj@kernel.org,
	josef@toxicpanda.com,
	yukuai@fygo.io,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v2] block/blk-cgroup-rwstat: use data_race() for online test
Date: Mon,  3 Aug 2026 21:34:00 +0800
Message-ID: <20260803133400.137906-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

blkg_rwstat_recursive_sum() reads pos_blkg->online without the queue
lock that its doc comment requires, since blkcg_print_blkgs() stopped
holding it in 56cc24f59c14.  Concurrent blkg_create/destroy flips
->online, tripping KCSAN.  The race is harmless (RCU-protected, stale
online only causes minor stat noise).  Use data_race() to annotate
the intentional lockless read.

Also update the stale doc comment that still requires the queue lock.

Reviewed-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---

Changes in v2:
- Update the stale kernel-doc comment that still mandates the queue lock.

Link: https://lore.kernel.org/all/20260802150413.29789-1-cui.tao@linux.dev/
---
 block/blk-cgroup-rwstat.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup-rwstat.c b/block/blk-cgroup-rwstat.c
index aae910713814..2e9bf081cce2 100644
--- a/block/blk-cgroup-rwstat.c
+++ b/block/blk-cgroup-rwstat.c
@@ -88,8 +88,7 @@ EXPORT_SYMBOL_GPL(blkg_prfill_rwstat);
  * @sum: blkg_rwstat_sample structure containing the results
  *
  * Collect the blkg_rwstat specified by @blkg, @pol and @off and all its
- * online descendants and their aux counts.  The caller must be holding the
- * queue lock for online tests.
+ * online descendants and their aux counts.
  *
  * If @pol is NULL, blkg_rwstat is at @off bytes into @blkg; otherwise, it
  * is at @off bytes into @blkg's blkg_policy_data of the policy.
@@ -107,7 +106,7 @@ void blkg_rwstat_recursive_sum(struct blkcg_gq *blkg, struct blkcg_policy *pol,
 	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
 		struct blkg_rwstat *rwstat;
 
-		if (!pos_blkg->online)
+		if (!data_race(pos_blkg->online))
 			continue;
 
 		if (pol) {
-- 
2.43.0

