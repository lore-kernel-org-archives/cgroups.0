Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795571168;
	b=3ljaur+iT+J8EwEX9/cLWU5aEl13gtTMeZCxgxaipvB0WhFVlmxLU4Q/7fJ8b7aBCp95
	 NcBTYO+l0TTuw7KhM5Jj62EZuCI5Vxyuw8eZfgHsTL1GyjvCpCJXH72s7dWSGfoxrs8No
	 Ds9RSS5PPXHFqBRUiWeE3K6UIZ4Oif82aurdJoJ53PJJt9UJuaf4y89u0nYzAfZP71BiU
	 wVzzWqhkc0MrdG1KymmOG14SiWXR3HBu44RE0WxdLr+5qGGsZOwdWoR6faB75PjRbQr6E
	 6kqzxg2Vzoqy7Y44YNl3LLCr2tSB6UxE0Zi+EYPVVfn/U9ZJGxKq3cpvkgVcO18ZOLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795571168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=v8v8+B2s1x/OC+2e/Qjn0YMmUDX3uWey0kH3oGaidV4=;
	b=Uy/DoWffXRLqLfI64JuRbw17j2EiMPXTDRZ7zYrU+VWB/CT0Za4kZ4v4Lsm3ux9+NKM0
	 bL4Gxk+BJjLUPTiAwc824d0W1AH2WV2UTYueEhrZv+oA4YaLNUrvRPKZYWLuoDPpVK9Bf
	 ai/PUSCwZSm5ixVr/m6xgSus2E/G2m1CfCADfO+/xFCXCHZN/sxyIOkh2txsZvTKKPcTc
	 h/svfTEoYzamQAfoOcWVB0Ti2ROR1uWbrPStTactUwQuXNEMEVzLxuNW3mQSm7SXUPhQW
	 n6ooteBs4PP59PBnT3AmAyq5Bt8Z4BuzHvy3t5V7y//Wwd1h4AURT6YChmq3Vrw5fmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nH06Dx5P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83794606A321;
	Wed, 25 Nov 2026 01:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nH06Dx5P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4E51F000C0;
	Wed, 25 Nov 2026 01:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795571167;
	bh=v8v8+B2s1x/OC+2e/Qjn0YMmUDX3uWey0kH3oGaidV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nH06Dx5P0Yi4GgYiauESIEHDhrZ5h0ePu1XxUj6w9X3ipZubgua+BknUm03wE3VgQ
	 LbfPIPccvlhWg2C2vt/tZZuCh85f8uuaPj5MRM+VcYZF2D9jg0QtgOR+YTv07qoHzd
	 Hnj0e0/HGED3nzGUhIE2LtG3dgNucQ/R8hwcBKul55Ko2R6NfMgEWvEGShIMcqW/1L
	 5wd6iKhbeEK/13TwJ61qp/ZkqWfJBxEVGfHOM4dCoTrUliThw2bi3OqFNlaI/roYdP
	 cUB/KTngPRtJnE6Z1HVAnyHi4tbrC2P2dgMFOvALyqyWboRnne38lNMgRzSiOFWQYv
	 sVxKrHTC9Q/Fg==
From: SJ Park <sj@kernel.org>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
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
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	Maxim Muzafarov <maxmuzaf@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	Tianyi Chen <hi@tychen.cc>,
	Kairui Song <kasong@tencent.com>,
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 04/18] mm/mglru: make generation page counters atomic
Date: Tue, 24 Nov 2026 17:45:58 -0800
Message-ID: <20261125014559.98601-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com>
References: 
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

On Tue, 24 Nov 2026 02:52:56 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> From: Kairui Song <kasong@tencent.com>
> 
> No feature change, convert them to atomic so we can update them without
> holding the LRU lock. A temporary underflow is fine: readers clamp a
> negative value to zero, and the counters only need to be eventually
> consistent.

Makes sense to me.

> 
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
