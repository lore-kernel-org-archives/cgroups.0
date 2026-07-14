Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80283F7891
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 09:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784021538; cv=none; b=MqudnNJN1K8UPkQ6daxvovLiAv4lXkZqFUeyP2p6/8FnBzrMHlqAPPWwQjPBPITmGv2zisDNYjumdtdBEgQNUiBxh97D+ZectTK+kRUHgvss2eNbaVS20JqDLSs62snoTJ+51Sr04x3i2BDSvW6H/JUg2OKXXri1RCJ2L5qqBX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784021538; c=relaxed/simple;
	bh=I92yiOXzyb68qma0qhM4FYr4elXfxkrM60Dc5f3Vlro=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RBY00dxplpnJHMJsbAKn7fRnml3XSJX0CnXIEyqPfpaixm59A0t319p9soPgz8+Ru7yQls2ypWKANbCBUtttSz/3n84CBQ7KsY2UrhuEEcTF0NwxRZIsa6Ciei5fU34V8K0lcDm2mjqHrtJ14Fk0DwHA8Wc569wSbEdoRiBAt6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e0cWHm54; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e0cWHm54"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493e3ecd385so9287165e9.3
        for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 02:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784021534; x=1784626334; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZaT/U/JlP96J7BKuqsxBkutEqQ8OPKC1/nIHLPADppk=;
        b=e0cWHm54c+Jk6e7j6x2woHOqxYWlssYHqj71+eReyQI15cNSchv8YiugzTrg5aBkyB
         pJaRooDJswFM4OnjJNE7vP4Nr05sPJNBByait13yY/De+535qbocpKRCntE3HpPh6L41
         tCKJ9kK17cljDE6fSZKgmhYPYFK2N4QOPx/YFuvEFeW0lL1/4sTK1aB/8EHxLmfQhmbH
         x4p32gIag1zqeKxC8tMiNNHksQdHGSqOLSO6jjqa+uXwtC11y42cdhKnRVq78FUZqORJ
         bm2oSURV+KACV+yQYrZWxN7W7xlgEMFQgnS7x6g0lmZWe9ouKxpavcr1OwKfqUfKBNKr
         UjGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784021534; x=1784626334;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZaT/U/JlP96J7BKuqsxBkutEqQ8OPKC1/nIHLPADppk=;
        b=bnXHQGZ5aTd4QZtlxnYXxg/o2Y2BitVZqS5KADzbENRtu3mBe9jFaFoal70OgZtdSb
         2U262XotUei8V/zZVd4NNulvHHH2kibpdjc9tgeZoV1aFsfO+vDpeR2wvBwVAvdf3wj8
         ftMqsCvx3BGJoku56Cn0gKJtKVedyIp+bJHf1LMMxfWJSvKH6O73EH5LvEOLaikhSjj3
         EzZqGifEOSY/yocZin8zWfzMI5xuLa9oVV5vEPveE3CXTb0e6t+3th1AuZyCYdCBtY+c
         uaoVdIgx6+NoJVVc/7d4KiNxkvvVdB3G2c85o2XQwsR7KFn7S8Mnqupny7tx3F10Fu6t
         B1Ig==
X-Forwarded-Encrypted: i=1; AHgh+RqhnrRu7LyTncnFEGaDW2S/fxdasbO1E8Px9q1sGoa74oxoJW5l7LUPSGSkLP+N8IjFmcmmP/sq@vger.kernel.org
X-Gm-Message-State: AOJu0YwlgxAW/+aPqr2bUFWA1gCBez7cn4km3JlLOTw4J4BjtqDkoNQQ
	cYVwBe5NJjyhh1xF4BB2+84rmjXz//FL8i63t7x/zUNalGvErTfCJzBl10EakiMZEbEeNu5RdAj
	mPkGb8bd2s7Wu/w==
X-Received: from wmqh12.prod.google.com ([2002:a05:600c:350c:b0:493:f83f:e304])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:705:b0:493:9661:f55d with SMTP id 5b1f17b1804b1-493f8826bf7mr96781345e9.30.1784021533525;
 Tue, 14 Jul 2026 02:32:13 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:31:58 +0000
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAA4CVmoC/4WNQQ6CMBBFr0Jm7ZihBAyuvIdhAWUK1cqQFlBCu
 LuAB3D5kvffXyCwtxzgGi3gebLBSreBOkWg27JrGG29MShSGV1iwtDbDgc/O9FPNOKcvMcek0T
 pLMmY6jyHbdt7NvZzdO/Fj8NYPVgPe2w3WhsG8fNxPMW79+9jipGwNKZKDadcE90akcbxWcsLi nVdv/ubn83NAAAA
X-Change-Id: 20260710-spin-trylock-followup-332c636e0d99
X-Mailer: b4 0.15.2
Message-ID: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
Subject: [PATCH v2 0/4] mm/page_alloc: couple of followups for recent cleanups
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	sashiko-bot@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable



---
Changes in v2:
- Separated from functional fixes
- Added cpuset cleanup, comment fixup, VM_BUG_ON() removal from Zi Yan's
  review of [0].
- Link to v1: https://patch.msgid.link/20260710-spin-trylock-followup-v1-0-=
affb5fe5ed00@google.com

Based on mm-new, these are followups to [0]

The alloc_pages_nolock_noprof() comment fixup could be squashed into
"mm/page_alloc: relax GFP WARN in nolock allocs" - currently
11770f8836f44 in mm-new.

The VM_BUG_ON() removal could be squashed into "mm: remove
__alloc_pages_node()", currently fba100a6cdfc5.
[0]: https://lore.kernel.org/all/20260703-alloc-trylock-v5-0-c87b714e19d3@g=
oogle.com/

To: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Brendan Jackman <jackmanb@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Clark Williams <clrkwllms@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>
To: Tejun Heo <tj@kernel.org>
To: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org

---
Brendan Jackman (4):
      mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
      cgroup/cpuset: update some comments about the page allocator
      mm/page_alloc: fixup alloc_pages_nolock_noprof() comment
      mm/page_alloc: remove a VM_BUG_ON()

 kernel/cgroup/cpuset.c | 13 +++++--------
 mm/page_alloc.c        | 22 +++++++++++-----------
 2 files changed, 16 insertions(+), 19 deletions(-)
---
base-commit: 61cccb8363fcc282d4ae0555b8739dd227f5ad0b
change-id: 20260710-spin-trylock-followup-332c636e0d99

Best regards,
-- =20
Brendan Jackman <jackmanb@google.com>

