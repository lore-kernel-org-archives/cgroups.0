Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795132363;
	b=dupeB0qmVWzIjek8a7ittSnhdWBTpTWIP/foSm1XrRyzq8InGswMIQ4uriDn5GVobG+i
	 Xp1+ovjzbWfOfwrSEqHHFWOE7wGqPkHQiW9pPKMFMt8TCuiPjBQtgFK7Uiqk8Jn1MSaXg
	 weBjnq6rxY61v8gXu8gDSpUY2CdgAxHalOU38p53smnc9GmKhYs+rPBSjC/C2LkENGo67
	 NTCAY86TOQi/NscQrweWm0LOvr8KtTLVVHH2sJgQg84DhEw7n1FtJCKZA8T69b4pPbJc+
	 40ao79/lZKiyaJcvjp2/VsxWo3af4VUTHQPTsKeob3Hey2HRMAV4LQiPIFmkPdMZdHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795132363;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UJrHYEnQ0yy/ldYky5YEoQN9xI+McH+P9QT2Lj87958=;
	b=dewDJTGFXm2u1kKp0cYtTxYe217+UjxkUDnGLjS7P7OV5VHnMQLidvEhZM1RPoS/b1tl
	 jDFMg0qmMGzB+1Uu0Q77QaAeHj53G+jqE4QHHwV/WHlcyF/oURHEQkJS3fIug3H5qYw5s
	 SAFpUYmSAJ47r3ibnzzrkTpHJIHthF7YvmfLdaXJrbZdXPGL3tFMYHFZ5nGbnxW4uSJ9b
	 QKLtTx7M7XSY+vSTdiWgx85/XKWQ4IpsvGdTyjc2SFndJfoZDV6oqU1J7Y7E4vfZ7EXFh
	 VPqHUXotgK/2F4AO1qHGIisL/cSrzgGNiB/s+l1p9E1u0ybFmHwCBJDIpfbbchQojTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BrPIpaRv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16210606A325
	for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 23:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BrPIpaRv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B201F000D0
	for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 23:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795132362;
	bh=UJrHYEnQ0yy/ldYky5YEoQN9xI+McH+P9QT2Lj87958=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BrPIpaRvDbzd8Y7rMw46WOQFjLOZas3+Km8HCtgHamZekBAwZBP842rmER5zZ8UXk
	 S++F+v8K4swO+gtbPsJWH4+GbKbf6v9zckJgIIIn+EtGkCCox0TLyBsIoJwxmRidfm
	 pmdHZm6nLAzvirWhXqRtfx7JrliAFvpGZyOSNwOvpaPDoyd0XO96ybt7zPdIxpcV/y
	 DqreKbXIyRYm3dMV5znki7LnpZ3jNZDM6uAgjsAcvKxAMGkKya2k2oqaM97IBe6zKJ
	 s2qb4LHOFzBse+g1CWsS41v24g3LG0OYrOPWJn5anTmy6bhHOBMnLhN8e4j5FfkWMo
	 mwmloMU8T6E1Q==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93f3c616c84so30141585a.1
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 15:52:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGeb0PVP5qmtzwJJNw15xmnmcISGUYWrwxchl3vRzTlczSnZSV+WIXG3LGrjER3Ukwzvw1kv5hc@vger.kernel.org
X-Gm-Message-State: APuU4Z+i/rg2vD/0l6QaxYhC4+cZqbTZFeEFrPVjw7eI2hwh4n79HOAe
	Ux9/b/eUWwEkzOZ4SCgdga0FlGXWsI9wsPZP1uAf9gGpCeoJWvlg2vpyHllUv1HIMY8bP7dxpqk
	oyVBzIqoLINOyyUUO4XZz5LY9dofRiO0=
X-Received: by 2002:a05:620a:17a2:b0:949:6170:b78c with SMTP id
 af79cd13be357-949ba9addbbmr226598885a.39.1795132361936; Thu, 19 Nov 2026
 15:52:41 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119154001.9b9f953136935a09e8a50af6@linux-foundation.org>
In-Reply-To: <20261119154001.9b9f953136935a09e8a50af6@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 20 Nov 2026 07:52:30 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x1bm9AoB3PJ_CM9LxiHx-f85O3qYTvomROYcmYJ-ysPw@mail.gmail.com>
X-Gm-Features: AclHuK8MXJccupEkZyLKK4OZivmndEmD7ggxoROqdAHZoRi8ilS2fyKXpz1qOWc
Message-ID: <CAGsJ_4x1bm9AoB3PJ_CM9LxiHx-f85O3qYTvomROYcmYJ-ysPw@mail.gmail.com>
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
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

On Fri, Nov 20, 2026 at 7:40=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 19 Nov 2026 05:03:32 +0800 Kairui Song <kasong@tencent.com> wrote=
:
>
> > This series implements MGLRU-FG following the idea proposed at LSF/MM/B=
PF
> > this year [1], based on current mm-new. Depending on the workload, it
> > improves the performance or reduces IO by roughly 10% to over 50%,
> > fixes multiple long-standing issues with MGLRU metrics, and drops one
> > page flag.
>
> This is looking really good - great stuff.
>
> Review is thin, so I'll remain in wait-and-see mode for now.  What do
> people think?

I'd prefer to see this go in together with the swappiness fixes,
as the two patchsets complement each other.

I've been rather stretched lately, but I'm doing my best to
find time to review this. Hopefully, I can finish the review
next week.

Thanks,
Barry
