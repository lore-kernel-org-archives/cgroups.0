Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7673CDBD3;
	Wed, 15 Jul 2026 08:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104379; cv=none; b=Z1in2WP9yNMj8s9BOFwMEeuCEIomfDiZZetJvWWaKX7K+fvLlnwLQ1JvCaC3/+NaQEE7kXWLMQj5oxpPGkx+FgRLxzirO846a1k7Gz9k++HRcv3vhooVTmlUlH12Nj9OV+0+WYe9366HPSATdQlDK6M2Dqiu6oXARCXJaiXOszA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104379; c=relaxed/simple;
	bh=Ezo4kpSOexsqvmKsAzG7XnZeQCrPBWkKyCwMiOE7nrk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jh5xy/gVWsINlewN9YSzkBppciztoepyudqrMm8tMwJIfdPRPT2bcRwS3cAzQ9iHb9DW/o1MHdqkiy+mJTOHL73DUcRNaqqIZZq9VW2VThGx++f/cQAXl57jCMYuwFyZ5w93m0BOY5ge3DV5ydLKF0GoUYE0mMVmkOTUIa0m1sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Krlh4gLe; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Krlh4gLe"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784104367; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=LpLHc0gQHrfcQjAgQsVGU8GKc379gROaUr2U1y9iHZg=;
	b=Krlh4gLetinfqlpFgQ4mxp3FxsqMMyRXzTifAK5zq7B8cjWMq8yuO13vrHFQPEr/ESnqXUew8Cuy1MtyG7bD5OKWVagY+y28LttNxmNUXpendpo0ZrqsJipDDTH4DCd1QfVH4cihWSHd7UUE1+qRrLtdIGDWZY6IX4tuzzPOQ0U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=lulie@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X78YblO_1784104366;
Received: from localhost(mailfrom:lulie@linux.alibaba.com fp:SMTPD_---0X78YblO_1784104366 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Jul 2026 16:32:46 +0800
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
Subject: [PATCH 6.12.y 0/2] sched/psi: fix race in pressure_write (CVE-2026-52991)
Date: Wed, 15 Jul 2026 16:32:43 +0800
Message-Id: <20260715083245.32115-1-lulie@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Backport of the CVE-2026-52991 fix.

  1/2 (94a4acfec146) clear of->priv on release, turning the UAF into an
      easier-to-detect NULL deref.
  2/2 (a5b98009f16d, the CVE fix) extend cgroup_mutex to cover all
      of->priv accesses, read ctx after taking the kn lock, and NULL-check
      of->priv. It depends on 1/2 as discussed in [0].

[0] https://lore.kernel.org/all/8a06c5c3-8f7a-4252-a3b1-0c0d812e2654@oracle.com/

Chen Ridong (1):
  cgroup/psi: Set of->priv to NULL upon file release

Edward Adam Davis (1):
  sched/psi: fix race between file release and pressure write

 kernel/cgroup/cgroup.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--
2.47.3

