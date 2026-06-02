Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA611A681B
	for <cgroups@vger.kernel.org>; Tue,  2 Jun 2026 04:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780376150; cv=none; b=Dt4hXStHE9HoLJYOGauESZ3N8ygU/y4ixTSXU8UijTjgFmGNzVNDrJz5GX3oC6DOJeGcMpWr85RAy0FPZNAEsDRN9nAaaOVHNhPwiIMdvS1E2Rtn7tkdkuPmlWnhHmKz1IOEdt7n15W6q24jo3p0IFKyc0xoBQzGuzDMTeemdXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780376150; c=relaxed/simple;
	bh=W3nYw9ZyBotfc/X9g9iRqzsOr+50dC88Aj7n1Ud9nbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=anbHfvGNlAPjYHzsZhh0e67qGBtyocNUBCm5GTOIghuYoYmJLMawEMSWiJBR1FCidTSOwVmaymFw7cJufhYJ3siBETxwmCKjGY4Tx9o+W8HawNt/Qe6MuEpn69ZXrILoZvX8dfIC65gO80gujjtwFnYN0Rso4WhZhAkwNAxgZv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aSYI/QEg; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aSYI/QEg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780376137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oHT53n70Klifnktc+yk4vjapNQ2rD+4sNCRP2SaQ59k=;
	b=aSYI/QEgwMhM7Wlv/g67/j2WYwLZG27b9zGxIXG6qx3fExCeKtSz1JsMOZlVX0Byh77d7e
	CXYPz+9gcXVWSjnMmdUAHQOP1OAjXDCI2EYmK8H1uEdl1rJbsfLc++KQGIl6bgSJ1TwjOd
	gQDzTswduC46N7CFsHx/F5S/IhQ+XIM=
From: Tao Cui <cui.tao@linux.dev>
To: longman@redhat.com,
	chenridong@huaweicloud.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v2] cgroup/cpuset: Fix update_prstate() always returning 0 on partition errors
Date: Tue,  2 Jun 2026 12:55:21 +0800
Message-ID: <20260602045521.2381230-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

update_prstate() stores the error code in cs->prs_err and transitions
the partition to an invalid state, but always returns 0. The caller
cpuset_partition_write() uses "return retval ?: nbytes", so the write
syscall always appears to succeed from userspace even when the partition
became invalid. Return -EINVAL when err is set so userspace can detect
the failure immediately.

Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 591e3aa487fc..8605b4da610e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2965,7 +2965,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	if (force_sd_rebuild)
 		rebuild_sched_domains_locked();
 	free_tmpmasks(&tmpmask);
-	return 0;
+	return err ? -EINVAL : 0;
 }
 
 static struct cpuset *cpuset_attach_old_cs;
-- 
2.43.0

