Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4236F27FB37
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 12:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788265617; cv=none; b=u+try+8lgEBTtiSZYF5omEHRNuqfGOcWuwNMY2VZBS4JnszSLttMFKckWgv8nKpvJxhY24lPqTcWrMH6zWPfUaHCeU7YuanP3YPIMT/ScRpQQROR7wxldZ3f3fOaeY6k/yE/+QLzdP8JLy+BpRG93ebVC28SKUkr3XoSE5q0xUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788265617; c=relaxed/simple;
	bh=7Q34ACZX39BwIgyh4m+8rA64bsnZpabLgc3mbIx2n/w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Mhb5bqgM/6F0bwARM4MRzG3tBM7LiNc3EANfE52UhpUYgv2smNsBN3YEILKERg25Z37YzyYy9hmZMmbu4bkZ5c87A+A5FPCrbS6Qm0p4Hro3yV3d0aksaGLKYM1Mr6NbrahfPrkJ/zOnCrRpJcIFL57+xHdAG2nj5o3uHiXSrvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W+V8iEj1; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+V8iEj1"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f96c5b722so3000829f8f.0
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 05:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788265614; x=1788870414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f6qpjX7WWAJ2cweV8AeFtOfMeKDPxjEBYU+hvHsVykk=;
        b=W+V8iEj1SYJmqTRgLxIijEMnL3aHNyuEuY4C2dSOsK7dH1KZjC6zDmRM8n5GMKp1ZK
         SuX6ipU35B4rp7XVbnYm0cBV55Ix7kF7RniaYVbPHukcutZRJSknGi1lgZMhRNV589AU
         yszNSj4AlRy5PQxP6DeAIAE/paCn+pbNgUdFQ3EGAxZUMN+u810xqmPbUssZsNxE3QeV
         ydG1Ymkt+m2UNRaiuZ4epxzi99Ddl5Iu1SMCyiHWoRhJurLoIiRLoFmMAlVbREgm7xAe
         9gHXPwEEPXrkBB4q4nr95hcW0m3x/3EEoPac5ITr/zek8JWVnxkYBK+zl+dqcJoRHmpb
         LcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788265614; x=1788870414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f6qpjX7WWAJ2cweV8AeFtOfMeKDPxjEBYU+hvHsVykk=;
        b=F+1y00lbfFuVkNQAzZoOEk8SAkvEkYxljaICiskNHyO3H17hjgZNLB+DbRkc9XvrOM
         VDwBMw6cgOLsGKMkEs+fsNBL8I1p+WT/XcwnRTnwWgem7jINhn3m4OA4gcjOvjLKkJ2W
         QLbDmrvDwKSCC1oI68vhDZo5Jzm/dT+TKKQzDjW4Dry5oqaaBB19lSkXfOKNn+jbDts1
         apHA3VEtPZ2Pk3PHmIu8RZmjmbr3aSVUVZ83VNMi8rkLIVo2Bm19HGfi1+aWUR+rPviD
         rxhkG6EakSSk5j9wc/n8NXbytFbVSxAnwVuGBWnej6rkn8fazQeLX76Gk9PkFmZRDdQU
         EFvA==
X-Forwarded-Encrypted: i=1; AHgh+Rr4frf+ygzRYx/BMfQurMx5pFl32muN2mYGfyyiwxT5PnB3lPPurCoaFKD5iiWEHhN5WBWLYaJy@vger.kernel.org
X-Gm-Message-State: AFuF++nD8qm28IPi0XlxI/XvVM2yiAi1K+1myOqQ5vAXTkl2KYDN7GW8
	zhS9m0pKtSnThQSDUBmqEbvIPZBe7ziDLhQB8V2iRTw36Zq0dhTeyIEGfdWhhd26
X-Gm-Gg: AR+sD11kvnWYEdbAlh47N96wcSrTC+cPbR6VJ+6NSi7Uf1DA1uNK/w7llYeb7S1Eedc
	7YgXqwCsKW2g74GNNx2RCUW2Gkbjoux0+WdHEOVPFo0k/cUhMPF+uTCBkmI7+vLMJRVewxoM0CY
	zXZ349iCWp4H/sC0FnNitmwrX95/zH+x8ZzU+NXu4TdnUbPHMyKzHJ5NXDY7GQBvZEMA7mtT4+a
	1bVNV/f8GWcsRoY7B2P3SWwr9qOMGQyHI631pUqL0LZ7m6kx8WWil9cWZsqK1DMNhPAnHAlT6D3
	n22sFYakRBrFkgnx8V7yyHrBCx3Zz3LiIzOcYdfifWYf1fXQ0bFy39eig9yhlqXZcXfL14EsfNe
	l+NH5YM0C/MaQ94phUq3K5zH4Ez9fADU31sXPk2aMxaOTQukhDCRR+WJS+H3FyZGXRADrkOyf9Z
	/uk0ZpnqRIe1ytjWTicKPNgHZxTi/sMqcTrObU5qSBRtEdseAeawx6572OVSVQ/51ICcoRZFhcD
	dnwoeqOEdzdgBXoX8DyPZ1no40X7oLvYyasb29jRdAwz2MuptsYjbpT3Gf7lAYV/XnI+5NoQOlm
	H5sHHEjQ+zgfdsx1bp2bd+q8X88x6sfQGcoS38dkKHoA4uexeO6VKVGPjNJfVc4K7R4=
X-Received: by 2002:a05:600c:6091:b0:49c:d60c:74e0 with SMTP id 5b1f17b1804b1-49cdc44a420mr156178575e9.13.1788265614057;
        Tue, 01 Sep 2026 05:26:54 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a16a-7801-fd8c-4b37-36b4-e53a.310.pool.telefonica.de. [2a02:3100:a16a:7801:fd8c:4b37:36b4:e53a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce089c2sm64755395e9.2.2026.09.01.05.26.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Sep 2026 05:26:53 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: stable@vger.kernel.org
Cc: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: [PATCH 6.6.y] cgroup/cpuset: Fix misplaced DL migration reset
Date: Tue,  1 Sep 2026 14:26:42 +0200
Message-Id: <20260901122642.11571-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mainline commit 4a39eda5fdd8 ("cgroup/cpuset: Reset DL migration state
on can_attach() failure") puts the common error cleanup in
cpuset_can_attach().  The 6.6.y backport instead placed that hunk at
cpuset_can_fork()'s similarly named out_unlock label, while removing
cpuset_can_attach()'s two existing targeted resets.

If cpuset_can_attach() fails after accounting a SCHED_DEADLINE task,
cgroup_migrate_execute() does not call cpuset_cancel_attach() for the
failing subsystem.  The temporary migration fields remain set, and a
later successful migration can consume the stale state and corrupt
deadline-task and pending-bandwidth accounting.

Move the reset to cpuset_can_attach()'s common error exit.  It is not
needed in cpuset_can_fork(), which never accumulates migration DL state.

Fixes: 14897ef9341c ("cgroup/cpuset: Reset DL migration state on can_attach() failure")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Applies to Linux 6.6.155 and 6.6.156-rc1.

A controlled QEMU A/B on 6.6.155 forced an attach error after accounting a
real SCHED_DEADLINE task.  The affected kernel returned with
nr_migrate_dl_tasks=1 and sum_migrate_dl_bw=104857; both fields were zero
with this patch.

The equivalent 6.1.y correction is submitted separately.

 kernel/cgroup/cpuset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f9c7178f51ada..bb413045d1744 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2630,6 +2630,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	 */
 	cs->attach_in_progress++;
 out_unlock:
+	if (ret)
+		reset_migrate_dl_data(cs);
 	mutex_unlock(&cpuset_mutex);
 	return ret;
 }
@@ -3462,8 +3464,6 @@ static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
 	cs->attach_in_progress++;
 
 out_unlock:
-	if (ret)
-		reset_migrate_dl_data(cs);
 	mutex_unlock(&cpuset_mutex);
 	return ret;
 }
-- 
2.53.0
