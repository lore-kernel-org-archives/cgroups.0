Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533505;
	b=YsLI9D3vFuGy0tKVNmO9mnYYyPwVoaGTzroFlUYFcxd4cO65gBHyarEufrcbvQMvgDYz
	 AoXHAoOIFCRZTqQy/IY8JsqodUyDsWCtZnpDshZ0D2kd8Ek4p0harRJCfOC0lvhoXTKEs
	 O5QCp2DjS8NyTlA77CKyhmxgLezTWrE/djam+QPnMZRbPAaRVEz88OwISV/sl8XgOt3D1
	 UqvP4AUxbVhlYUi/mpDStN9gm78dQwAab0pXFsafg8KNc1qj1aWfKnsE5wdSgIouCZLmJ
	 ansuzbe2b6GXqYgfHCsCOSqj8JwDYYmthPWLAcIdR1+cBmLu/p1ilqNQ/g/o1H1lXDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533505;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=52Mb0SieUZGcAbpImPllQtaM7cC3W0vYtmFV0/PQ+bY=;
	b=IEUVtyG0jseetEXaC8L89yJ38hIDfnyfxSraagwUYddYsUt7SQXBNniKKSrBkrPTyJUT
	 TTbWkQojg2zWYQCDmbvhcC8Cp1IXjX5YgCsgnWYkmjyCctPnsvGY5pueDR5RNRYcPKCok
	 WlmW0i0EFUoxIAJEuDFS74KUyUNaxH4UndDS1+RXnHljgCTe+BEP8fsA5Aei+Uj0f+EC7
	 05Jj0CJz5MKDhkqBJMR4xHZJeNsnTkzs08mlMQb4fnmF5fNFJzDEPnHvWF2ajU2erPAQO
	 GQ08KZfDtoXPNWPw0MHHNqGYzJSr4OK9J0BugL7ZGmlQBlgbo9B9yl/Qo0g0a1Bf7ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xepePMzE;
	arc=none smtp.remote-ip=91.218.175.144
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B63606A329
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09B63606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xepePMzE
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mKXG4s48Cea/weAYc6oxABnfCFvbfykC7zPLW+/SpLA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533503; v=1; x=1794138303;
 b=xepePMzEGrJ5rr0OY0uHAXW+MJWAprs6AC0xyUA2YgVcLv3l2YNJniOSkjoDHYpHKtJvh6rp
 yo32iRVv7elan90ZunGuQEgYcUdhwfh9qpcxPr3WDf19c8H009/Su5ALa7DtAvCNVGZcvJzcIHy
 UIPBqprbeY6BXHioE5uLCM3s=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 27a4b692cad0f5ab;
	Sun, 01 Nov 2026 11:45:02 +0000
X-Mizu-Trace-ID: 27a4b692cad0f5ab
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Michal Koutn?" <mkoutny@suse.com>
Cc: Guopeng Zhang <guopeng.zhang@linux.dev>,
	Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ridong <chenridong@huawei.com>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH -v4 21/22] cpuset: remove prs_err clear when notify_partition_change
Date: Sun,  1 Nov 2026 19:42:05 +0800
Message-Id: <20261101114206.2434398-22-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261101114206.2434398-1-ridong.chen@linux.dev>
References: <20261101114206.2434398-1-ridong.chen@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chen Ridong <chenridong@huawei.com>

The prs_err should be properly set when partition state is set, it
doesn't have to be reset in notify_partition_change(), just remove it.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 29bce718ef92..4fd8b0025a5a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -262,10 +262,6 @@ static inline void notify_partition_change(struct cpuset *cs, int old_prs)
 	if (old_prs == cs->partition_root_state)
 		return;
 	cgroup_file_notify(&cs->partition_file);
-
-	/* Reset prs_err if not invalid */
-	if (is_partition_valid(cs))
-		WRITE_ONCE(cs->prs_err, PERR_NONE);
 }
 
 /*
-- 
2.34.1

