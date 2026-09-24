Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB1D43C07E;
	Thu, 24 Sep 2026 07:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235379; cv=none; b=suN0vrHExMsI9IMSUoHztr2uhhopZP9/NFezTPiyTWPpj4apzdQ1cUJozcBdeEUuz6mx+GXjXXTNyU+QkpxocQ5ohYm7tTHysJSICFFi1ouhjt66cmsGR7gTLeK7NcwE7ogdSOtCJf3b2s7BTPtgLBFcxsXbG7v8XYPuUUCMtXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235379; c=relaxed/simple;
	bh=NUIWn8rwRUiOu7P3B2vlF9O9uqHo2D9P/6q7nbhOVVw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lY1+/FBUugagMpM69B5G8SU63UIGrOJGk5F8X13HczroU9ph4p2ON61j7NXyckFdArffzGZi2jk7QPklcWaryI2vEsrsOF43aUb1IJteNfjbhN91mLTVxc077Tef0EL9w7T3J0F5ETCKtbVCQfg/s6ekkiyvaDpUW1ah1pWOsC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=iYrPQsXd; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="iYrPQsXd"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0h6IJhcmiEtJdjoFG8xXoR5aFr6QBu55uhw+svnqeNY=;
	b=iYrPQsXd2Wy1Wk1bSiOR7getgDZXSDXLXyQ1wc59ropjoOVpb7McqRxbpvrLoS3QGDoWOo+Gy
	pUXez0EL4XNgGTZ6YsHvqxuXjoF9uCU0QGFCSqvesgGux/0HPrDIKi6D0JqtPnTUEeI1boGIFhx
	DO3LRhjVEfQqCVYRPpA1KTc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hr52741s1zcb4D;
	Thu, 24 Sep 2026 15:24:47 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 7EE9F4057D;
	Thu, 24 Sep 2026 15:36:13 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 15:36:11 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<edumazet@google.com>, <kuniyu@google.com>, <pabeni@redhat.com>,
	<willemb@google.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<horms@kernel.org>, <ncardwell@google.com>, <matttbe@kernel.org>,
	<martineau@kernel.org>, <geliang@kernel.org>, <mhocko@kernel.org>,
	<roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, <muchun.song@linux.dev>
CC: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<mptcp@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>, <caixinchen1@huawei.com>,
	<lujialin4@huawei.com>
Subject: [PATCH RFC -next 4/5] Docs/admin-guide/cgroup-v2: document upfront socket budget charging
Date: Thu, 24 Sep 2026 16:02:18 +0800
Message-ID: <20260924080219.1036588-5-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20260924080219.1036588-1-caixinchen1@huawei.com>
References: <20260924080219.1036588-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100010.china.huawei.com (7.152.184.41)

The "TCP socket buffers" entry in the memory.stat description leaves
the impression that the charge tracks in-flight packet buffers.
Since the budget-charging rework, a socket is instead charged its full
established memory budget (send buffer, receive buffer and
SO_RESERVE_MEM reservation) when the budget is created or resized, and
the charge is returned when the budget shrinks or the socket is
closed.  Say so.

Assisted-by: opencode:glm-5.3
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8d2603751c51..4f26a459cfdc 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1309,7 +1309,11 @@ following types of memory usages are tracked.
 
 - Kernel data structures such as dentries and inodes.
 
-- TCP socket buffers.
+- TCP socket buffers. These are charged upfront for the socket's
+  established memory budget (send buffer, receive buffer and
+  SO_RESERVE_MEM reservation) when the budget is created or resized,
+  and returned when the budget shrinks or the socket is closed; the
+  charge is not tied to per-packet buffer usage.
 
 The above list may expand in the future for better coverage.
 
-- 
2.18.0.huawei.25

