Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A403DF016;
	Tue,  7 Jul 2026 10:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783419737; cv=none; b=Ppjgq/zLMfHhxIBvwwykxhOoMYHK6AiPZORv/Kxxt1tY4gOciZq0pXGRvf2+SG4gxjLYCYsan54WF8AF6FhjHNFIfYnseI2tyTAOowXnhTntFUaRSKTLQR6mRaiodyy2hN5ut0NNpI9sZVf9ljjaqIInu94Fd6Mr0za+sI1nXBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783419737; c=relaxed/simple;
	bh=N3mlkE+V8OacYwpttMQ2zP/Vz4zdha1L7zeYJjcI1Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mXfGRf27h/TPe2McMVQNr7iNAWUWU7V9ZfnClI1o5kIueaEUflbZZ5ii/Qlmb9vRCU3auCKwLQMJY6qEE962zx3XkeTkkbVadhDLR6KLOSyELLYHgT56KU48sYsP4ULF/WFeCtWgNnCh9meUaqCxUnuDige9YAPt7L8E4ydTA+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n5/pMC7x; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n5/pMC7x"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783419732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eWcDQnYOYYrvM2ZYBY8bvALrAF2J5/f2P4vYcNggq1c=;
	b=n5/pMC7xiQirBMKCLQ5d5nmVfVzXRJFumz1+KMOioOerExgZhdvJ3fDoVB1ldAp8Md5NGi
	Q3kyRsrA/UbBjKtAbKn6TN+u6mwDhx2b+ekZGCPRx64pRkaJ8J60EII34xp1i9eNGWbk59
	M0ifxb7j2AdjwwNtu2D+wLPiSOvWV3I=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 0/3] Docs/admin-guide/cgroup: update controller interface docs
Date: Tue,  7 Jul 2026 18:21:45 +0800
Message-ID: <20260707102148.692250-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Hi,

This small series updates cgroup controller documentation to match the
interfaces exposed by the current code.

Patch 1 drops a stale interface-file count from the misc controller
documentation.

Patch 2 documents the RDMA v1 interface files that are already exposed
by the controller and already documented for cgroup v2.

Patch 3 notes that the io.latency-specific depth, avg_lat and win
io.stat fields are only emitted when blkcg_debug_stats is enabled, and
qualifies the usage text that suggests using avg_lat to pick a latency
target.

Thanks,
Guopeng

Guopeng Zhang (3):
  Docs/admin-guide/cgroup-v2: drop stale misc interface file count
  Docs/admin-guide/cgroup-v1: document rdma.peak, rdma.events and
    rdma.events.local
  Docs/admin-guide/cgroup-v2: note blkcg_debug_stats gates io.latency
    stats

 Documentation/admin-guide/cgroup-v1/rdma.rst | 66 ++++++++++++++++++++
 Documentation/admin-guide/cgroup-v2.rst      | 16 +++--
 2 files changed, 76 insertions(+), 6 deletions(-)

-- 
2.43.0
