Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4D03C3450
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 05:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895018; cv=none; b=mpN4E/vAlp+O0C6bRb3vAh0mtEfpnCMNR4yNIw3QzW443kJM20se3I54by2FJpF07xW9Fl2s89HXfXDYI24A4XL4UbprvXnXYkZlo6m3MgGLO/3oUq2XV4MICrxj/gbHXdSBmxOK0z2gAc2tvUTiMI9Y4NZvUHcdyNhaqMUOlck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895018; c=relaxed/simple;
	bh=mtqi38h9DnqwhETyTcFF31oaSRnkxp4QlcAD58krSpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWFx7pOQSjI8VdNM8Kjodfp1G6j1HMjQc6P4V3i2YDjH0Hgni80E5LrIGYTNed6dE0betxl4sKekIDxyft6YFvEAi/WDca51urqPrzZhSM4cgEOhcfupfe/30dTVTzeUrP1qsVd1/9+wvfQ5uZrwA7qESmaawc9qc+o8eD+RkMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLvvsOj3; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLvvsOj3"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d712281f8bso7334905ad.1
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 22:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787895016; x=1788499816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zjyf211XtRs0nkL10Qp9VSObiEIsDLFDi9ZSA9jafOA=;
        b=FLvvsOj38MgqFBUciJ/vDSZ4XIo/6//8Nty+qFkdOR1C4WA9k+ty2xp8q5WuhY2J76
         P+s4lEWpXdAVRHearhDx3XmKkxA1cJxcPGjrGNwgAPv9gaeWiDwRvtz0SKtHRmKXfuvT
         YHgwOXBRSwSpVpCOfn5jT4vHA9qNZxpVLwyrybQaPbIXwyT+naM2rBZMLgWPL4vnKngp
         kU6f5dVA+Ra8oOrxzXW0QkvJCcdXm5tsyRx2/CtV8f6qwMfeBr/Fhv26VG7IC6LfdMkA
         JfasdCd6e1FdoLXNDI4bLFZRNbfjULbM+08tecsil8BfEq1EGUEY0saTG5KjRRPnwUqA
         RICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787895016; x=1788499816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zjyf211XtRs0nkL10Qp9VSObiEIsDLFDi9ZSA9jafOA=;
        b=iw1Jzkz4MuBG81MKy+tp73jpi2LNG75NkTn8jOUkTwHfDX5x+kg19BGj6waW9PcQmD
         i+bfNEyb/GvPwVy8TX2QKxTu2tVr6WwmtbBs+u3rjqHXNggXoA0e3GkGxIkyNrLNvuAG
         RA51FQlNt6i+jqKGg04tqS2IOdJUOT8KYX7lbFLRiDs6weot8xv1/+V8c9Bu6blghk+C
         WjvjxZv6uBn5ZS+dByg19yjZBfTrAqnLHUpfu83N2RW2MItPl1UVZmUWIs4zHJd5jJeh
         CdP8ACn7AKsBy9o6Dp4VXJP1mXd+X3VDlekLW3hVA9kf5oBmsmFqSGf35Pbtr9iGOUjH
         qrmA==
X-Forwarded-Encrypted: i=1; AHgh+RqIQJqqhD+yS/pdz81VGiTpKA1QWcozs+TnIZ9IWu2fhZ+ttF2bHqIZ+CRnFMjc40+yBSpZPfMe@vger.kernel.org
X-Gm-Message-State: AFuF++ngYHZYtBIJvj9uY+Zwcpnn7CNGGJPoeEtrrbBD7y1ZPCEN8eTW
	1ATZ1iMamrDyC25mRbDLlnwBWK/M8fEQZMir69wVWJcf52T58IkWWtaB
X-Gm-Gg: AR+sD10OhXAG0s+dJCOjV7CGCHbia7mjQ/unULEZHzpfgStY5tyEFbvVz9inHMNNhh7
	eR2JUinMWfmtNTSTlseP00AiEjm9Rmhhwrg85kPMA1RkZdOVpmCqioqXbk0QYFqgYQi1eKTcfMX
	lTTpDYwsDAtlLXYckcBcRKyEtTIkWZR6bZtYrvNqHDJAiKY56XGJlPh5dgdZOFZSL9qT30vehxq
	pN+Mgj3G5vRHMt5mEKMS5u8XNd+9v5ThjJqr8Q5h5AV9ysroDuT9naHRa5NpXmu11kzV12IzNrB
	LxcMF9CLF+oUHKlqEsHhnzwhCmSph3xGAbTxnFkDlxGcEQtseJKqhd+5IkEAy5REga5EzolLmTi
	dmRbncyp7oOGAEfRHE8+HRribZ1S2lc9eWXS8WlkTMIfnO7fWLUuw4qFlK8jJDb87YS+3YyoQTE
	NUVyiXeMULSVfNzg7ywtUppqoxNE8CAZSd6OAAFkkrfq33rR8l1AIDm5kKxHiYbVQITTWZI4tzC
	qlfp3PNnjg915SGCqzEyNzaywDH
X-Received: by 2002:a17:902:d591:b0:2c9:deec:f564 with SMTP id d9443c01a7336-2d74df52c1cmr1686825ad.13.1787895015897;
        Thu, 27 Aug 2026 22:30:15 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d75988cb5dsm2170415ad.64.2026.08.27.22.30.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Aug 2026 22:30:15 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v3 5/6] mm/mglru: use explicit tier range in read_ctrl_pos()
Date: Fri, 28 Aug 2026 13:29:28 +0800
Message-ID: <20260828052949.52874-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kairui,

> Replace it with explicit (tier_min, tier_max) parameters using a
> closed [tier_min, tier_max] interval

While touching read_ctrl_pos(), would it make sense to add:

	lockdep_assert_held(&lruvec->lru_lock);

All current callers run under the lruvec lock. read_ctrl_pos() derives the
history slot from min_seq and combines avg_refaulted/avg_total and protected
with the atomic counters, while reset_ctrl_pos() rotates and clears that
state under the same lock and already has this assertion.

Adding the assertion here would document the snapshot contract and catch a
future lockless caller before it can observe fields from different history
epochs.

If I missed an existing lockless caller, or if this is intentionally a
best-effort snapshot, please ignore this suggestion.

Thanks,
Lian
