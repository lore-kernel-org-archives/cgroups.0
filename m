Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE443CF054;
	Wed, 15 Jul 2026 08:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104987; cv=none; b=oKgulpVfgbXEaY9moUVXYK3g6SyQj/+BtDIgzNnB4ibn83pToqSAXrN41u7iEf1LenGJGSIwiHAlE1WyRICYDZ/eM0+dxBSFlilj491xrepS0aeLn+XIklt85E4z+unZs9ovEvAIjyPsWMWPBp0FczHd6PVvag026tfY6PwRld8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104987; c=relaxed/simple;
	bh=wM6CLola6B2GFF3988xRVkSeHvzK8Am3QE6zZhvJbBg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LKpgrj/5scD26Sqcw5wK8p7bS+B32KzYiWlp85OFyoGOsxJ2pWq6q5mP2nLWNbrmX/Xike8jC71ufbSkNr8SQ6i93XdRt8rZh4T0WLK1iu4+ksvOB+fPl0zbwW4Q5Jf+MkkKw6wXQXN4Gu7pRb3Yp3RPqyWWz6jQNGJ1PDfqqgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bg2JvJF4; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bg2JvJF4"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784104977; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=xfldyTNDHCFTa6fvmjV4MUiBwe8GJdvnuUp7ls7VEqg=;
	b=bg2JvJF4biR3W9ZJh876CindI4wb/wh0p8bh2iHz3Wg68zjmRwYJ7NrfIb7yVtvxXRlE2Glv3PxplCvBf0z57RI+MH6kHLAj6Mh0oczJiZOlv03TOohd9Zxn7zc5kZ52riS1aV4qQGSkaQm/5h0mLuT7DIdM/Dqrv/fDd7wZOc4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=lulie@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X78YfRf_1784104976;
Received: from localhost(mailfrom:lulie@linux.alibaba.com fp:SMTPD_---0X78YfRf_1784104976 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Jul 2026 16:42:56 +0800
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
Subject: [PATCH 6.6.y 0/2] sched/psi: fix race in pressure_write (CVE-2026-52991)
Date: Wed, 15 Jul 2026 16:42:54 +0800
Message-Id: <20260715084256.43412-1-lulie@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is same as that for 6.12.y.

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

