Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045740;
	b=x+kzo79zx+rKjbLsuPMvpuIJBlSXxpHHv2hLh/csq8GH4YoVXZszStyXIqQ83tfLprz2
	 Wlk8dUBN5KMxKlCtdI+Jh3z1PqkoGqlWrKWs1WO9QN6hvV6MTbKZwQtZdC4pWHSdtqHFv
	 SyC3fLttvKH+UI5CnbsGkgsJynnlzCNbqbx229ouU1qVUmJZ/CI1A0SBrL4heZxxgs4+m
	 /MA/jNPCA2+WMoh8BchDfYv2dE2av1ztI424v9iZgVCUFRzSepg/yZ154dz+XGaFI5+Tg
	 L5MBzRKpagiDgwut+vqbJvuaPuuHO5r2oeuQk23zTKR12BQugfITnZ5vMzPYlGS7gAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045740;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=JokRczt5mVEgHxRUZJg6jCnvGvoAs9YtaIgcq2+6nkw=;
	b=ge8cOXn5b27dU2MpsTQj/hZE23UVO/flblageQ9qMY7R2BBd+srx+ZcQS+M3zC8dO/Kf
	 9tZH05B9alibG66cOCmWDyXYwHg+xwEtmgCpl1+1COpOIhqAXtdEwt2I+FFeLlfhWxABu
	 wTRqCIUCg/2B/Q1IFA9fIYZ71F46MMo/cY39Y+1vT7/kaCy/xD7liKqXWTUGe2mCTS0lU
	 TMPu7L4NUwetPGYVm8rUZC/oz59zjAtcQnuezQxNJ9rLNwUbZe5zEd7zU6I7nJTOGOtyR
	 1e10l1r4LCiNskjzqaNN8qhE8oJ+FWyBDBPKtiP+RtLUcgJj5yr7Ebow4ZEuJH9h7Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRzAvX+G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3010E606A320
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 23:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRzAvX+G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CC81F00929
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 23:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795045740;
	bh=JokRczt5mVEgHxRUZJg6jCnvGvoAs9YtaIgcq2+6nkw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QRzAvX+GjIXVj5+Hx8Av5Mt96NukUSriYFWx33adE98bNh3aqW5ZBbTkdyuI6uVes
	 AZ2BpGNU4bG0idO6iWixvbACU6nv1xDZxEKdh79PNgNA2ZyIKe+rufUMjwRZ3l+Jog
	 o5taUCxSyqcATkv/IZWLVwKCWKxIB09nTmDFe5S/jhjhbcYkQb6N2TvYk3ghlFtECo
	 mszmZnlh6uEBfFK11E4rUAg5amCv8XAKURFyHS8or/C7+Fl22UeCuuUCP6NO4QVn+o
	 XSpf6Kq7jiyCphDjybDyyacHCLnTlLnLU3VQDgdeWAUt6vXpHi9UkEE42dFg2tjRZT
	 PxZsCRVA+Boww==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9497a167a6aso45330785a.1
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 15:48:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHWnGh1nk6OWeB4hhKF76JGMgvgRyN3YyA8LKK1S2L98CC9i79OWe+3kwdOuiUERVowzMr2i05G@vger.kernel.org
X-Gm-Message-State: APuU4Z9GADCeF7pwhuvEoGj+o4yF+iIevRoiLYbpG9bOHJISmI7FoI9p
	ZAQyZOA/u3a6h7YlUL/JMGNOG39goNHgicAFswD32a9cDZd10vZ0oQQWuvazsU5VL+jdAExjd8G
	iWWqDBp27kQpItqb6v0pNsJGRMan34uQ=
X-Received: by 2002:a05:620a:260a:b0:949:6b5e:33ee with SMTP id
 af79cd13be357-949ad938bc0mr22211185a.31.1795045738801; Wed, 18 Nov 2026
 15:48:58 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 19 Nov 2026 07:48:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yUH9EG=kPWkkp_jm2Fy7e1D20f+uod1_9fUypW1G5sgg@mail.gmail.com>
X-Gm-Features: AclHuK8u8pAmVqW9yFgv9yKvnlXrt2QgHUMeTnuokLmXwaR9lnc-LtRTxLtZGq8
Message-ID: <CAGsJ_4yUH9EG=kPWkkp_jm2Fy7e1D20f+uod1_9fUypW1G5sgg@mail.gmail.com>
Subject: Re: [PATCH v5 01/17] mm/mglru: rename the generation offset in lru_gen_folio_seq()
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> lru_gen_folio_seq() computes how many generations below max_seq a folio
> should be added to, but stores it in a variable named "gen". Elsewhere in
> MGLRU "gen" means an index into lrugen->folios[], i.e. seq % MAX_NR_GENS,
> so reusing the name for a relative offset is confusing.
>
> Rename it to "age", which matches what the value means: the newest
> generation is age 1, and a larger age is an older generation.
>
> No functional change.
>
> [kasong: dropped the comment table part, the series rewrites it]
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>
