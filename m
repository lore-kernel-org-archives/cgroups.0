Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B56A3644CA
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 03:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790220955; cv=none; b=qHLab+UvxcQeymgPArMJXuLAGIFFqZr3EzfhAo/82yw0H0CI2uJTwjRySaLUBzIGyVTAptnJqjJHwKeGqdZ3KS1pHunXYavOKR3MjlRhh5WpAA3gQbTMS7qS2VOf/bwA4iHg5agHOlZpdi7/u4/01wlOC7ZwX/0ogzHmBveR39s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790220955; c=relaxed/simple;
	bh=2qKcPAldJvEcWjcIJ43DM1SZXln0CDpiZsvgQYu9KuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tn/mJnm8zWUZcOK2dzKdFy56F0l2GDbJ1gB6Keg5DcIMG0mFJCftGbedydEO2KOEC3/WRNxonSYhu+6h1JfvZ2KFKwkxu1ohYqMga2/1KGXgEy7qpf6rcbVSl64diEeLiKinMG/fj6VwkGTp82OTDYsjonDZtRADe1pem8GpeTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6OVr1UH; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6OVr1UH"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469e2254dso229219b3a.1
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 20:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790220954; x=1790825754; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eUquMOTVJGW4FPAiIOleShFB3cqbL81WRJSG3Ek70Ew=;
        b=O6OVr1UHcothfQSIr9qxjCKd9Vllmykwhk0L2ArgrqxqShenQF8IbilB/dazrzjJkm
         k9RMx2YI0mRaP4d7uCasEgt3KqnMUaYNtFhnO72TtzgthzecZqxL0qGs4pbEkNmwFu7b
         UYNGFQzFp9HMNl2Qkt0u8vJ+m/Fd3lM8uMBKfOkualASgVIwm4xGaLxpSXYxhonzj0rz
         d8XEUJR+RTklo6DAKjdisSw58uQFLid7t8lFR0hj4O3PKAf3VTNCMyscARcLg21iOZ2N
         WMeX/Nwv7L4KVrLcUvTbPwtg5svrtSj7Xx424ewZmOjvJDYSGWkDDeFOpmaxZhd9lm4Z
         3MGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790220954; x=1790825754;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eUquMOTVJGW4FPAiIOleShFB3cqbL81WRJSG3Ek70Ew=;
        b=HPpGu1PkjMs5ESEpd9vgCHCC1SUTNI7bafWs85advhOZdsKHvamc5Vi/+ryqpiEv0I
         cEDhSxvd/6cefFDlyFUQdDXu15oBrexMDkXWXHIOG3eEHiWLylXtY/y8okg9wzdBRow/
         tGfc3RNKT97OBl2YQDkqxs6zwJ4HM7VYc1ozJ6ZKAypYr9gL07so/2lvLPFvKwATIM4n
         4Hfsn6IlkBfUBIfgvXhL7yJcb03wEDYYKXiFwimfpLlRJU9lzdWXvxQWI+T2pnBO2utR
         re2IQryE6eaq70OG+gOLYJ/2ZgHqXv2Pwuzo25xVPSoxopa5FdQVTAGDKEgzaE3k6Xbh
         /z0A==
X-Forwarded-Encrypted: i=1; AKwUvBwkVHE8ERGzIWNMe9h5pPO6JhcCBRMdl8xi7YSrRWPofSqbVjoxYJUjs6fDrgvLGCn+3uS3yxab@vger.kernel.org
X-Gm-Message-State: AFuF++l5PHX3IznAMrJZMwzHdCfVo5G/Y4Tt7agrgzI9yOooLZ1J/72T
	82K6My8eDZY4KXbfpjwPL1CUfCJd9f9+knJ1t+MriLeOrjjH0x/wv8aI
X-Gm-Gg: AYBFou1OVoafJC3VjEvAAPBQkcPoM6atyZerDlBpTYK2aNGoyXUvo4AdjBNQZCFnMRR
	KHV1/bkBqMhEz73s7vd7BpaVR7d515O5Vk2wt0fMkoU0ycUtUUP/NcWuXfPY/GTCypXog4THaGM
	teDaWlsjMlCuNRlWuIj2NbGC/ifTEJUOV7wKCxzzPltdiBYofZSnQyP6bc4MIHeZQdxYBSBk/RL
	nZMmvCvP102fdmtea/1bGDCr2qDC+WU7PXpfh6tt5Mu8RnRrzfDWI4qCau7ahgLReUZxjm5cjCs
	QXf057qTx0v8j32LZ+CPBq8dmfPyEtk3TnXNvNIQUjyXvHEmvySzfWWFnBCyxaW7vTnZyOaXA3F
	rXBMCA5ZqSh1NIU0WFuJ2SmeaW1/AZy/fycWdN3VjjgchKzSod4WEjy86KkhoewFzfyE4oT2kmD
	H2ob6YeQQsauj//ztSa3b9zfcEa5DT2gvBrrOQwuv3YHNfT27HZVvAs2LNEi4kfEq4/9TjwJwm/
	NQeVtoiaW8X8YAjKnn9w1GwMK5kQFLREYKaRIAfI4mNPWulM2HERG7lvF1JA4XvXVRCa4T9fCC6
	L12rlZO4RrTiLEJOLUImoKesUcJo+RCC89e2SfTeKvPHOWVuCLZs2zAEaCQ=
X-Received: by 2002:a05:6a00:14c4:b0:87a:1251:e58c with SMTP id d2e1a72fcca58-87e99e3be81mr652821b3a.0.1790220953649;
        Wed, 23 Sep 2026 20:35:53 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1dffd6ddsm2101289b3a.48.2026.09.23.20.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 20:35:53 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org
Subject: [PATCH] MAINTAINERS: name the tj/cgroup for-next branch
Date: Thu, 24 Sep 2026 11:35:49 +0800
Message-ID: <20260924033549.3625016-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The T: entries for CONTROL GROUP (CGROUP) and CONTROL GROUP - CPUSET
name tj/cgroup without a branch.  The repository's HEAD (master,
11260c335ec6) is a commit from 2026-08-20 that mainline already
contains.  linux-next pulls for-next from this repository (Next/Trees,
next-20260923), and on 2026-09-24 that branch carried work not yet in
mainline.  Name the branch so the entries identify where development
happens.

Documentation/process/submitting-patches.rst sends contributors to the
T: entry to find the tree to prepare patches against, so a branch-less
entry whose HEAD is already in mainline points them at the wrong tree.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc3cae2e378b..353e33d27e3e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6647,7 +6647,7 @@ M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Koutný <mkoutny@suse.com>
 L:	cgroups@vger.kernel.org
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
 F:	Documentation/admin-guide/cgroup-v1/
 F:	Documentation/admin-guide/cgroup-v2.rst
 F:	include/linux/cgroup*
@@ -6674,7 +6674,7 @@ M:	Waiman Long <longman@redhat.com>
 R:	Ridong Chen <ridong.chen@linux.dev>
 L:	cgroups@vger.kernel.org
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
 F:	Documentation/admin-guide/cgroup-v1/cpusets.rst
 F:	include/linux/cpuset.h
 F:	kernel/cgroup/cpuset-internal.h

base-commit: 40288c9206c17eb66a603262e06a58d300d0f279
-- 
2.55.0

