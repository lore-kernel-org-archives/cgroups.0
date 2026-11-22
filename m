Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795353297;
	b=cke++WnJovpdVVbyJjgcJ+/M73XkCcnW/TxQadQFEij5uGUE8GZNur1fgl0Kp9ZEMzTL
	 HrV1RdyIfjWvtvn2wM3atcdPSIlLryuLW5SZEg/BA81oSDFoEdP/dL8yLLmOMJ2OtUR19
	 mzDRPudL8dHLixNsp7aO2SG4CBFVfyzQjbFVI+8teEDWUXzQLNmAKEFGrHxV8WihGuBwN
	 k6tQdHayfE3WX3Gn93XlCxFTB3YWE/bnpQxZJlnfdh6S58HApkEMRTDKqfIQojFYU0RvU
	 yNJV833nXuRchBoE0RJqX4lwH0Mv3WPZmTp6kSVDZ4dZkZRTfUSRMI4xa5/5PI3/E7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795353297;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Type:MIME-Version:Content-Transfer-Encoding;
	bh=8hD87ixJaXl21lUSGIciEwnoJt3nWlHx7X6q/vGOsOE=;
	b=IW1xkrjTHajy4ddS9rLr76/N8R34dQKRTKQ8UCzb6wTb0Nfr8n/huQfwLrxH4OCXvPIH
	 vvkTr0H4F8d0qTma56OLUYqxAfLuhFBxDUSl2dHNwWUROhN3aptAY0sqAB4eV3Od9oWqi
	 vTxc/PS155M/4Y/0TJY2n/vHqcwoz46jhkckHz63hYGSQgzd1YUratQRzngg9QDtti3t8
	 yikxo+ADwiLzbTgVfrX7cpTkm7xHVpy7v6imMVSifLBcOWgXKXUaqxCcfQ2udWz7HGluq
	 NGCvmg6lFV/qhWIE3/PfvJmBIbN1sUILFEFjrZmzWSDnPa/0f2myN79NWY221PqK2SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="dNi8/X4g";
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BC5606A330
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 13:14:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35BC5606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dNi8/X4g
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1b3ada81853so2678170c88.0
        for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 05:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795353295; x=1795958095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8hD87ixJaXl21lUSGIciEwnoJt3nWlHx7X6q/vGOsOE=;
        b=dNi8/X4glj8za8CHUyUTtNzOlgHGHp6QMd10zTC/TQr7AJjZerl6rqDTwp102Lewup
         1ittEsw7RgVIgBsb6DZbCBvqPrbP5YJmX2/qbh82cibbbdWMRNzmYbGy4kpHz9mLdno9
         q8/1br+pv9KTFDXwytSa4WMYQNsbFDN1S6OQCFA2oUgrZS+XuGDF+2uv4kg1KaVLvojN
         8hvHwbnsgHffAHWp8ZPzoZqqIa6lDM0aKKvgLF9n7EIZwdtKzrLa9QEJc8P7eZqhakHV
         z1Aq/zCMe2Uz5NUyUYu79/IRakePzC5KTLXUBsl2yc3GG7faXgOKuYxOPWFab5XvOZMi
         Npbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795353295; x=1795958095;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8hD87ixJaXl21lUSGIciEwnoJt3nWlHx7X6q/vGOsOE=;
        b=Td+k7BXa3DbdgSk8w4hw+NnroZRGKseZbppLHop7RHWA4neKUccmkJU8UG8IGFTADl
         OSUrGnjwVDq1tvFrGzVwCkgWxGCHbsOhIYoyUKi+ybAIC4/AwlK2MHC6E1BbIX2mBavQ
         3KABXwdH/l+Y7fvWV/hyyENTKjPXxvlsjCK+MhttRYtR5jqoNyWc3NePZCIj1aKe1bQh
         OUUOH6OHpZl/CBCakQauhrwes73HEohKZ4SoPE5SWcpyrUUM5W5FCH26fAL/rEyFbUWg
         S0Z4MygW4UQeNdYVhgs3nk6q9LUY7TUHEUTzRhER55mCfaIKT+dEu6QdWT+fdHeLHvkz
         +6dw==
X-Forwarded-Encrypted: i=1; AL+hErGSbgJjeHWkoCMUrdvvF3+oWY+mwpwEaBb4i2luxh8SAKjnfeg/hRmJc+v83Zzfw6d2+YA8t7pf@vger.kernel.org
X-Gm-Message-State: APuU4Z/wULKL1zL88k/HxLgMTU2C54JsP3KbM7dGQ4FOj+iMyPeEbePa
	PSnLHWzFFyAIbVAA39rdc/K7EZ4ZgdtXL9Sk9hIumlW971WQtvXRsWsH
X-Gm-Gg: AZFdTZfdOlWnbKRTb5V/aDJwtmuNU5YuDm6w+PzdAw3JCvpjkF6eVJe5h7bZNJVemXp
	JIWkJEKgb6yZ4Gk8wFH1gLKy0TDIbQtg8BHJ6guQpGlMRC+3oix97YloYUWcYdyIWNsKTllk3IG
	r/SCcrauu878XewTRmSy4dqNeusIa6PZki5tjuU054iiBOof9zGcCSxJHyTVDVggICHxl0Bg2XR
	FXb68m4okDULsUoUP4MRJTwinxWR4fWqMetxKxTCfGnyAFUUpgmxjqti5eP3ooZzG/kWEOrOOQQ
	aq/9DnbBG5+eQX89MUu0Go4n2EKkMEDgpVJBhGPJb02oDVOdxKbMupDkbvkncaWuE1HyLP4YGlG
	pAZQfrcV+PfunTjVKvh8M2sk75a5Z5ycc7dHggNGIf4FJav5zUgj18V226B4inARU7fs2whS5Jk
	r12zBN9DgI6iMrWU7u3GxDL/Q/VEyzMNA1d03rgAbkDi1hyZW0ydnItoVsfEWd42eyInqVdr+hN
	Sk4gBLiVpEB2EDNYsj3k+Ebxqnvs0F5mxz8V5CzrhQEQvTm2fnx2Hu0sdGL4sL3PlGv21jst+Z1
	TNwDQOJ1qcbrKB6+5x8/OYVCLrkWDdFH+MOPkILVgEwIF5/C2FSOQxxaEYB4tZCHzkKf
X-Received: by 2002:a05:701b:2215:b0:1b2:42db:8a54 with SMTP id a92af1059eb24-1b5568b3154mr8671867c88.23.1795353295194;
        Sun, 22 Nov 2026 05:14:55 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b55681301asm20797941c88.8.2026.11.22.05.14.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 05:14:54 -0800 (PST)
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
Subject: Re: [PATCH v5 03/17] mm/mglru: make generation page counters atomic
Date: Sun, 22 Nov 2026 21:14:27 +0800
Message-ID: <20261122131433.72335-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
Content-Type: text/plain; charset="utf-8"
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

On Thu, 19 Nov 2026 05:03:35 +0800 Kairui Song <kasong@tencent.com> wrote:
> From: Kairui Song <kasong@tencent.com>
>
> No feature change, convert them to atomic so we can update them without
> holding the LRU lock. A temporary underflow is fine: readers clamp a
> negative value to zero, and the counters only need to be eventually
> consistent.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM,

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

> ---
>  include/linux/mm_inline.h |  6 ++----
>  include/linux/mmzone.h    |  2 +-
>  mm/vmscan.c               | 26 +++++++++++++-------------
>  mm/vmscan.h               |  2 +-
>  4 files changed, 17 insertions(+), 19 deletions(-)
