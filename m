Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221025;
	b=Q75wL8aD9w0gWNjF57Wn/tlosVbrysummvT86uAu/xfj4NHTqw6NS6Cdj/OBRlht9AaF
	 VppdkCzOz6bqPx0jZe5m4tQbxPe5NGeg/PJezI98mjxO8b30g1DFgsK4DiorC7HriHeBI
	 uBmBxNtscxh/Z2MD/WSIuXJO/qne4jzIi2vvpq5qQKe9k7YVblQV5WH7JzaupZpLDOT2C
	 EUBBb1yotW+nr6k0KZ5LmMZEPV/mU51cEOJE/NDjR3oBzqubDcul8+GbWXGAqiAHUm2su
	 Zs8tEc2JB/yvrVH0OvSjtWPnWQlV8BIN1PRNdlOrTyhoCHkde7GGfPgGZQHilGkzNAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221025;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=1l/q9mD+UZ0LKwfpiCWXfsaYI4tdxarEWoloUn1RTbM=;
	b=QRIfXxuW4nCVw9ftYLsKehPsBhgohtYQGMGKRb8IgqiWmDsfpF3KhLeb7YFdp7YeCtYF
	 TKBjrblEbjhOraKtSvQ0BQhRD+61g1OYVW9yHnK3snfMntbKDiUl0WiPXE5DgzXzV8gco
	 EQWvfyDufe/MGTcW/hf9Vs6R7gwg5mTdWezba2j27jH60d2h1gK16RlG8i7DniJXGxRQ9
	 Q3OgZIbTIuKoOCS1cBFwt/o+qmj89np43WGqON4UehhdfOQkOkhfmhBMQbWPHhOxncF0O
	 84oKnu6OORnSeFbS/gd5waZVt8hpxOmhlUFawHZMzBDU7WpDIZG1OhyB+NvP5qKxX+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bAo252W2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42B0606A31D
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 20:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bAo252W2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372FE1F031F2
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 20:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793221024;
	bh=1l/q9mD+UZ0LKwfpiCWXfsaYI4tdxarEWoloUn1RTbM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bAo252W2QRAa0s7Lc6LTKanJY7VuCqKvL/jR9XT+digCiXnXgxe5eLnXt+/xNB/eX
	 gjy38nCEHhsg0t3L/oArc3iiBY78AdM5qcvIXWUK9XwJKMkOwy9AZ58OqTvMiblN1u
	 /YaXNQXWG6Ia2Xygw/XoeAGnHi/dzUyCye/CZ0KeMxeTNgLe6+CJ/lR/nqU9sic8nV
	 ljX5F6nDUyALjT/gHm5plnrchivHSxJUTzl6CWXCwzriV5JPqimffxqS+w8jxRi/N0
	 l9GsCUeVInL0lP72tfzIldZKaJEnBirPtG4i5mZo9i3jsfLlBv5xMRmto4dd7leZVz
	 ETwHT8m8sWE9g==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-943e8d35f74so115534585a.0
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 13:57:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzJ0DgalT8yTQ5vzrxRh9pVQMIIemGD5onTDoPhrxlceRlg640iGHJATpMCSxzwwccB3H1cNxcX@vger.kernel.org
X-Gm-Message-State: AFq9FYIaTOaoMEcGbCgz7ald+gd3e5cjXMiPcE/mKMPF+spQWjuN+Fzt
	UYERGNvwW7+rfjIMdpbnEUP6fZNK7zrMHqPs74MhCMO11i/uwIpSs3+ug3jz9tTaTsdxtgbgdVA
	lpORzmh9HXN3saPAPNelIYkg1QJJXCp4=
X-Received: by 2002:a05:620a:2849:b0:93e:5821:2c5c with SMTP id
 af79cd13be357-94408cf1bf6mr528393385a.60.1793221023470; Wed, 28 Oct 2026
 13:57:03 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com> <auHMXBwnwuRwHLmo@KASONG-MC4>
In-Reply-To: <auHMXBwnwuRwHLmo@KASONG-MC4>
From: Barry Song <baohua@kernel.org>
Date: Thu, 29 Oct 2026 04:56:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com>
X-Gm-Features: AclHuK_r9gV6TTj6VxggfDw1Rx1dq7FXiQbSIh4_WBWn2_zzCiGKkwAo5h87zro
Message-ID: <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old generation
To: Kairui Song <ryncsn@gmail.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 6:43=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Oct 27, 2026 at 06:06:06PM +0800, T.J. Mercier wrote:
> > lru_gen_offline_memcg() moves an offlining memcg to the head of the old
> > generation of the memcg LRU (MEMCG_LRU_OLD), so that global reclaim
> > visits it first and evicts the folios it left behind.
> >
> > Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> > dying memory cgroup for LRU folios"), those folios are reparented to th=
e
> > parent before lru_gen_offline_memcg() runs, and nothing can be added
> > back to the offlined memcg's lruvec afterwards. Putting an empty
> > offlined memcg at the head of the old generation no longer serves any
> > purpose and only delays reclaim from the memcgs that still have memory
> > due to additional shrink_many() iteration.
> >
> > Remove lru_gen_offline_memcg(), so that an offlined memcg is rotated
> > like any other memcg below the reclaimable size threshold until
> > lru_gen_release_memcg() takes it off the memcg LRU. MEMCG_LRU_OLD has n=
o
> > other user, so remove the op and update the memcg LRU comment as well.
> >
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> > ---
> >  Documentation/mm/multigen_lru.rst |  4 +---
> >  include/linux/mmzone.h            | 14 +++-----------
> >  mm/memcontrol.c                   |  1 -
> >  mm/vmscan.c                       | 20 +-------------------
> >  4 files changed, 5 insertions(+), 34 deletions(-)
> >
>
> ...
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 636152d8c94d..45a2c1021f4f 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_mapped_w=
alk *pvmw, unsigned int nr)
> >  enum {
> >       MEMCG_LRU_NOP,
> >       MEMCG_LRU_TAIL,
> > -     MEMCG_LRU_OLD,
> >       MEMCG_LRU_YOUNG,
> >  };
>
> I think there could be other usage of this LRU_OLD macro, but indeed
> offline is the only user currently, removing it is cleaner.

I'm imagining an Android use case where, after LMKD or similar
userspace killers implemented by various OEMs kill an application,
we may want to prioritize reclaiming its memory by making it more
likely to be scanned and reclaimed, while the killed application's
memcg still exists - not offlined.

Similarly, a foreground application might benefit from a lower
chance of being scanned and reclaimed. This suggests that Android
background-to-foreground transitions, or LMKD itself, could
potentially leverage the reordering of memcg LRUs.

But anyway, this is not a reason to keep
MEMCG_LRU_OLD for now.

>
> And everything looks good to me, thanks!
>
> Reviewed-by: Kairui Song <kasong@tencent.com>

+1

Reviewed-by: Barry Song <baohua@kernel.org>
