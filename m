Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795570338;
	b=h4lKkEzpwW6zgquEgUJR18oxopvgrQCwsx6ayoc23Gq5tWDuTH+kcODvDKkLeXtB0Bl4
	 XSYMmQo+9YiuJYU3CJVDfgBbnRZ8N9WRdK+FefYwrFO2oez26/PpPrITjy+FdL5fdjLqm
	 muZHMl2B5pHnmZBVkc5byIiwYldTDZdFvfPdRU+m5tJsLl7YX88Q1UOnnYFSNjy4ZvS94
	 /cVkCSwqX7PXFMesduAKQ2GqJ2OWh2lrnSL/cmUlDqEECCx2GgzzBgEbVt3GNjzOSOkKS
	 Vj3J6/Zwo8ro15grqNqoO6NDYMbb2Tzm45UohkoQXGTIKEQcX/U/klJBv9qHtsVsk2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795570338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=og5FI6XPTPwFhyPH6I0WYk7eOtsOgs0wLbpVaIplXks=;
	b=a6/mQm9Yds+PjmEtZOC9aQseH1NZaWtkz5z1M9HkWq5lChMcmaa7UWsYWWkSBe9DT3nh
	 qZXR515xFljzdlIXjEo/tM/SHEU8ecvpQa272N6DJ2giTIMKaszbWiP56nrEYqEtOdJiX
	 TZN43l3YjIy9eE3IBzYV2jEBQRagEviRZVViYJMW7THtvZ0Iz3X/k0w4BBASGhS7zVWpr
	 /qXOfPWGoGeE9fL1odO4ayB+MuduRnBekCrRnJcAMQJF1HCNkOYGOdUu5Mh/CoKkfXhx5
	 pXnb9m4xTj54HEkVcUSWFL2VvljTidr11PPISmkSycV+0IJHE2BNa608k1sRLWAzpRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AUrEpXVA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249A6606A31E;
	Wed, 25 Nov 2026 01:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AUrEpXVA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4D91F000CA;
	Wed, 25 Nov 2026 01:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795570337;
	bh=og5FI6XPTPwFhyPH6I0WYk7eOtsOgs0wLbpVaIplXks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUrEpXVAjM8bz2I2DWmDW2a2h7J84X+Q58Pkdgk4IdFrP8XGgwZcEnJBoy1LsUTiY
	 AMz4FUNqo5EpmLOZiikYpnpe6t96aHKMh4sQSuXJZcYPUGhFLTTgXemKdOiLVVDcr2
	 QmfEORqou1gCEsegiiOo7JrLL3NfHUybgf+bXhhe7T/1xN3HI4vzGa5G5QgFo1G9LH
	 dR1zjSrZfeY0WAOtxikEDFS8P2pYEK94IDviO9sMC372CSoYrdp9J793W2ByKcrSKq
	 NyESCGqoPviJQLWp0Yfyy3bdfISde/0fW1yWjKY5bdYnjWeWFG0Z4LKpGMNyG4Qo4s
	 qssgyk+G1rX+w==
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
Subject: Re: [PATCH v6 02/18] mm/memcontrol: allow update of LRU statistic without holding LRU lock
Date: Tue, 24 Nov 2026 17:32:07 -0800
Message-ID: <20261125013208.98216-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
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

On Tue, 24 Nov 2026 02:52:54 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> From: Kairui Song <kasong@tencent.com>
> 
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> the counter is eventually consistent and only serves as an estimate.

Makes sense to me.

> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
