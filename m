Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795351455;
	b=uEHkTyYh541FFq0hmrFPPYIeE/GzTNRJO3pf9o5NZ90mPQMIXYi0fUV2hQOvYfxby2or
	 4lg/7Crnes4GB/pv6QuCEC2RemjPgIskoS6h9fmwHL9S91nddgevCsVY3zxy+Qh6W796K
	 shkDM/+qDvGlaW8iqAIxO8mb9FuqQNctFugGrSFjZO3S8zwb9rAbjBaT9VLYiqDFjseCG
	 c5zD4XVjRRqXrAFnHGxBOI54GqnDr5cyNb1vtZfwws14MUHdQFHiNthQd67xtAMbrmshq
	 CYytkP5L7r6awWLQwYjqGS6/YfL8DQkJM7H148aHsDeTHRPPw9oRYusxEhwfmhpPiIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795351455;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=14LnegLlUwns0/xDAhlDRDvD4G/8p4sFhn7pqvFB7DM=;
	b=AQ7amxeHy7785oKLH8As/ul7Rtuy1Oo1htJcLPCyHKVMmetoYVk+Y2itSU1CnemttEse
	 aHk4trmtcZto+qVcZoHSBdpqN2DoteLkAx68SrBSNEmJ0Fcr8hS6jeDpNXso2vfFs02Y4
	 APINpyjAplFobTxNRAv9mXrRtD4KZkbfHr00hhGMX0VACCPIAPcRyn7oBpXsF6+8/oMmW
	 B6N46M6AXfYhIZTcSr6ZsxKuwIEnhb5jkgHLPSWfcdmqFT6jQRxuO+w2dKEnhrRBc3VbL
	 HfU7wHP5fp8IxLl9VGJLXXUkBw01UEMdPbCpTEp0bKC9E6OUG18ihDJJWu2pLdBjLUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FAIZKY29;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC6F606A320
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 12:44:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABC6F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FAIZKY29
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-380b40312e2so5637417eec.1
        for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 04:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795351454; x=1795956254; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=14LnegLlUwns0/xDAhlDRDvD4G/8p4sFhn7pqvFB7DM=;
        b=FAIZKY292g4PLAs4iho8SWMuRLmqE93tsKmh7In+GQxH3iPQA8UPqNy6H44ekr1QjW
         JdXkCtltk8ErXk+K3Uw5mPsLyHA9B7h6Xnpc95BBC1yxrZ/2D1IWEjNB12RQtBnm3lzV
         N71BRe6DNpDLOEy0ekAvSvEdLPYTVZtYWlVTxXYTOY81a+c3lTjTZSdWztZ9sdV1VNgb
         0cFfgz2OEGp5yJOtKdeAnKge9RG7S4eZG3cnVG7c7oqAV4o9wfPO7s3ZrJ8ZXcJBG/2f
         krk6ftoxRawuc8M6IEPolfH6SVVj0WQAGltJApmtotnuruQcAyVQ6k1ZMsB2WlCJ0uj7
         AurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795351454; x=1795956254;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=14LnegLlUwns0/xDAhlDRDvD4G/8p4sFhn7pqvFB7DM=;
        b=hWDYbYJUpi2LupqecxBP4pfCvUMG/lNwim06sMXzZBpurBGSZTGqY8t/HZ6EDztsjs
         /aBAqtX7QoCrEn3vFQDoPtVWNrzf06U4M67DlSgC2F8OavkHwHrT5Puz+5SpLiwenVW+
         kA52fMfI2qnKmSNnHpuID7xZfxEarHwEckJbjI1RDMXB9KSzQLVc+ZEd3Uk3auolB5wC
         dDgVevwkfwOlR5y42BeODXK6BSmzwq/FhhDw7MNwVcy5EH9YBhKx8SWto9d7RfSnUE47
         tKVgNc1Jhl4Uu+6HuCCOBmm/ARe5UYzyEAEUFyN2N3Q1DbRSHzXLEarVDf9vn1lVCYqx
         rGRA==
X-Forwarded-Encrypted: i=1; AL+hErFPJ6XHgJCtOH+lUQNQ9GsgnEKJoZml3x4aShrQ3MDOVUtzPO3/V7l+J4Cz8ct9Ll3gxZ/WLe7l@vger.kernel.org
X-Gm-Message-State: APuU4Z8e3PnGwneGC0ZzCdNzX+jEyntnWXylqCarvbBxeH7AZdPMPBKC
	Mc0eLQ7jC1fFyXSkQ1x6DY46CtXYuvYRxtmPO0ZiSGoRTx9iGPj/dfy+
X-Gm-Gg: AZFdTZfD1q6f0eISmFrsw3mUYghpLKENbQioDIFk9e2FPlktn0kscthDzYCq8Y4tQyQ
	/rGisTYv/UcJa1sLVQIZ4XAqATpGc7dh6Bc/vYD1jxcUTmrWbIXK8z5b7ehyD+i4lIgS1sqyFv9
	+t9ZpGvh/pXYvv7Q/v5onIBuPPBXgvAiyXTHO4MViZerlp9Y+z0XdWwUyLN5s+seHdkZULJbnsV
	N+uSiigwIweFWsaMr1vAtv+bVd1NPLK+S7gar2Azii7xsgqFjjVqpLJ99QKG3MLHrlTqdRKEkc9
	D4kNIfTKjLO/8lXF5IiyN/phCVIBrhYePASRKSriXW2J8BNzDljywoGCcKxkcNUQCgwY7isSzIt
	EjFMNfETaJeXCPi0fugrXERU6y9I7NsIq1zCVTV1RtNYSey1oRyKwDoexGvV6xmuNTukifS8spp
	JYTehXZLPJmGSM6pJo+Av3bpXeZjHwr5C28j0k3hchunyiK/D/IFM3hcDolo3x1zJCTsFv4oCMy
	OdMMtq/f9mREPN1SzZWyEbvhkOKpl3tFVNZ02RHK4O/rfZxKNXs45W5zeQPTSkXzEm5KNtGvlIV
	TDh1UlLJx8eXtsVJm7nYD9noCbohIySFfzOSykOgr/8F+YLI2kmw97WuOjhIBGdDFyi/
X-Received: by 2002:a05:693c:880b:20b0:386:b025:1e1e with SMTP id 5a478bee46e88-386b02522d2mr110063eec.16.1795351453747;
        Sun, 22 Nov 2026 04:44:13 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e99fdsm33447310eec.5.2026.11.22.04.43.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 04:44:13 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	SJ Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 02/17] mm/memcontrol: allow update of LRU statistic without holding LRU lock
Date: Sun, 22 Nov 2026 20:43:36 +0800
Message-ID: <20261122124345.66978-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 19 Nov 2026 05:03:34 +0800 Kairui Song <kasong@tencent.com> wrote:
> From: Kairui Song <kasong@tencent.com>
>
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> the counter is eventually consistent and only serves as an estimate.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM,

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

> ---
>  include/linux/mm_inline.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
