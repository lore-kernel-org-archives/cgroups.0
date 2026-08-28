Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449283C061F
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 05:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787894939; cv=none; b=FwZbdfyYtkvF+1oOeKLZucXwBov8w/71JhdZ2KkN4WoEnIkySytbr/qz4wRwpxmt4MBZPnmfTI1k1YBS+KIEcFCn09KuQPGd4VPRoAtyun/tS9z+yvtogAx5ZUIDu0HwPC8PcywZ/bLJP4L7UuU5lXxqDMgKzwqPZa63OFVIN9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787894939; c=relaxed/simple;
	bh=qL8bPsC0Bxb6J/ZsIWsNrLSKD39Bdrje+tlXzQLxk3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6KZLxsGbP7IpRm2eV0s1fXfG/1XEJm+PIDYXAi6A5fwVK1JBPivVv63i2dsaJHEW/caYEPsL5ylC0duKHR2lbYEZTbo6vj5A61f3T2mpKe7KillGPqzKxGF/ez5VpU16ZDr8Y3oYe0d18XsH46BEDGKukCtNTBTHY20pws51Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wv5Y2nSL; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wv5Y2nSL"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-39647aa9d52so644628a91.0
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 22:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787894937; x=1788499737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qL8bPsC0Bxb6J/ZsIWsNrLSKD39Bdrje+tlXzQLxk3M=;
        b=Wv5Y2nSL47pLSZbE8sbvRP9xuy6tfs/SjjsXYrFrqCXzyc7ntN7DmxaxjmdlLQUwhr
         UavosEWA0ZIAdVB7TL4kCSzspOUbCr8GxnyfcMyDMj+u5Kk8TwkTZrsX2LLjdODx5XCb
         D/DFoTVJm/EJKvQYalKfVjtBVTeiXiwFPu9nN9o2IZt4hPTiuO0wBF2qoaXmAJCVA36o
         j3K+k0V9iIG2iGQiSe0akDUQYwGTfd8xqBxeJ8GWwNVXks3rGrdAnpSiERIMDeCyvWMG
         l84KtQcKDU/VFqSFWd2n1xgHaDtehtz0OW3EXY68LC+6q5hBksKJz03yS5q3ceuNRIlg
         NiVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787894937; x=1788499737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qL8bPsC0Bxb6J/ZsIWsNrLSKD39Bdrje+tlXzQLxk3M=;
        b=eCHLwJnzDr3bn/CQokbRqasnQm78sUq+Rlh9xnKqHlao0/MeBTGfy4kZwCu5LZ3g8T
         ZEQyfC+FgLgFpZxI3I8zSnPn93Fj1Uvl1fP1W136ReGcFqiTStCMXsqp9D/7Pa2pwP2S
         vPaKKRiq724Ejowv+kxFnyRK+4COga6efJCIzCxvOPZI+1+h6nqPT2E8zz83XeXxkkVS
         1VaEOR1MniD9gBq/ifR1PLJL4gjfOokHWN4lY30tsxFA//HPR/H0IkhFvRs5KfFhX8tW
         Ftm4HgWd8NLeSdRcnH0Sz9cG0dg6RovqV4iTZ6WaF7Vb4XxRsHSTXw8G/Wm+u9wadpRz
         U5Tw==
X-Forwarded-Encrypted: i=1; AHgh+RogeAU/Fp45pShbG7DqvzDFUM0NE5cpAYEQwAWNeiKNAcZn2PE8+nUIo75J0IqeLRmbc5N8JJw8@vger.kernel.org
X-Gm-Message-State: AFuF++l0lDAeL7PJqqb7zWMJzGhvjeQ78he8hdCgCiWVLyH/cZvotCQa
	IrQZ1no+7BN02rWDh6wD87+HTsyug293mU87YsBpSYHKdZ2QS5689Gkq
X-Gm-Gg: AR+sD10hOPV+yAVfa8xmg1SRku7u7OoekgSG5cRycqyt+f6V/2OBP3Rc5CugyLTSd6U
	EclSqjPSN/Ur2CSCE18nsH6HDfKG7ATsQjlEncbdYHoRnyVXMCQYfO31WgQ7qFoLo7MSzXJZXy0
	whbZWBuMh0AZhj8KnsrWOhhdtJ5gfJlvTJi4CVoyS3jZWu+/L+mwQZDjDOEE5Orjckc5tRrgdCK
	Mn44RniAbk80o6NUtYu+bWq55MuXa0Z0k5VLOXfVZienmv4dTS4s6jIXvmsL/PbF0IhF4wkkRLy
	BYIEpLkLIlnB6KvPf4kA023Bnv/QjgntOFCsGNnX6surcmLej/ESUUEusaQY2tuSyu3kvULsFRO
	/KLIYD+ly1J3m0ApzAg3thBykObQ+OFUmcCDBhm4t+rmN4XZxuPuXOYBe7rTjfj6VBYqzhf6VPp
	k9SQcOPKAqZ9LjG4htQcpF7EP4/Xy4oB7FYzb+qCgJWjZXb3orA23Y2Do1wul9SVgnwyIJGkrgL
	I2WaJTcQZYaoXoyB5EseLx21AiK
X-Received: by 2002:a17:90b:1a92:b0:384:927f:3db9 with SMTP id 98e67ed59e1d1-396d0d35e02mr4591519a91.1.1787894937355;
        Thu, 27 Aug 2026 22:28:57 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396dda7eb6bsm1070263a91.8.2026.08.27.22.28.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Aug 2026 22:28:57 -0700 (PDT)
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
Subject: Re: [PATCH v3 4/6] mm/mglru: move max_seq read into walk_update_folio
Date: Fri, 28 Aug 2026 13:28:12 +0800
Message-ID: <20260828052834.52775-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826-mglru-flags-cleanup-v3-4-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-4-d9f1c75549c8@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The max_seq read now happens once per folio update rather than once
> per walk range, so folios always get promoted to the current youngest
> generation.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>
