Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794216847;
	b=I1FMVt6+Lig1iNZxWOF/Hn4lhk77mcTM82mdZ7XsP0x5LSWZUyuKh1ChwE3yE1dtGSy6
	 HHjO3FN+KDxff/0+TCTED7J/s6qOvakre4PUYv2vyLCUTa6DHFPYsYobUTDwQZwg9Au7c
	 Abi4e7V+NX2QYj7IkeO545dknahiTCrziyLac8paMH1OJp86L2zjLETH0kyazhS4k86oL
	 T1lWYGONezgxpaqTOXG0WxruN/p6PRUB0Uqy2PaM+A7apBliu1T08bktaG7+UPiI9SBKG
	 dJu4UYLDS7xjp/pgX/MrLN1EY8tsjOmTkVJqytPBTzbS1YR17sgRedqBiQUItmzLZDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216847;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=mu/oofPDsfg+LaVc2a1HnbHK3ydvC97UTzMxPHDp3UE=;
	b=sazEOl5oOQW4nnJ+dxcHcM4TOhw25srP9gMT4kg9Ay1yxWwNB5vRqNYRYSoyB+fZaeYj
	 InXNViTD2PNB9bUSuVLXQ+PrvDXMHrl1gOukm3WglP6WrYbqYC1mlXowZvvfEQrzVUZZk
	 0cwhw2bJyAHEpAHsifmfHkwcFk137kRQz+YZWUEOJqX5dYt984Z4M2cuHOC/ZgZAoQYll
	 wlJlk2bFWLBk37L1+2Lzrih4JrKf5u8xgkTeVnaLHX2I+Sj4QG63Be7thgZPCbA/0jCGZ
	 wcHvFNSGye7s43m/dzzLPWnhvDnJ+rGX72KCe1zQm8NSSJywEDXVf/J/HnUC3+/D91g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MnaUT61X;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEF4606A321
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 09:34:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EEF4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MnaUT61X
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b58cb69927so1093839a12.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 01:34:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794216846; cv=none;
        d=google.com; s=arc-20260327;
        b=aup80swfQ8/kCBiG+3tkJIDOUbK24niaeT9kKv3vblTUBJ/ZgNMhT/sHyByozPX3c4
         CbZ6wqtNymbcNfOi8AbxRPya5JX5dOPzM0BMWQ7MBhPSmGHJGd9ynplzfK6Jz/DDVVNN
         HZOBhsP4rRnlY6lewSmP+izwdVpdbvH4Q4Ay4iClJ9lEDMLVQbcNEgzsJoglZDSS8J1y
         byFnza2ihyMvUlcqEMjHEmCgr4/w64C3KS6ZBYgI9JcVbtOCp5uUwScs3LOl3uUKDOJe
         mogSYF9SIHzZtDt4yQS0zTCQYi51G1GNwzjAy8xTsT+QXBSBhFXodPmoPcwDumWnkz/G
         92og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mu/oofPDsfg+LaVc2a1HnbHK3ydvC97UTzMxPHDp3UE=;
        fh=OfDtlEcU+cn+Y3bolHmew78hrFzTFE6ggg5rK6BqqZ8=;
        b=dGoOf2IAjRoaTWk8Q0+Ez1uVu+5iYtwCwYFQx/jUpe95UmARBfapke9386j7GvzUG1
         dwOLTWFxvY2kb4h2A7aY7RSkpp4YBUlC10BBS2LDKigpnD7Rme9jvSDXRMpT970uME1M
         AFMgddgxyjCRhqwowqunT1yb2zPoBpWgiFZ8qgdBzDWJPLN0yhuImNJO/eBKCCsI1QIK
         6kK59zOS1ONE0TkfleUKKJi0hayRAOjBJXDVbksLFzYNBazQBFbd6wnT1BxVrdMrRH5o
         TsB+Scm6ZzR7ZyjgoW9Lgp1nifc0oXH1enwr8NYDHGipEpDHD6QGk3P6tBqfQ9BfOqlX
         nsrg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794216846; x=1794821646; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mu/oofPDsfg+LaVc2a1HnbHK3ydvC97UTzMxPHDp3UE=;
        b=MnaUT61XbjmMlTUe2HIZqIdcwCgZdIt7+gn5d1HjnEI+O0sowDyPF+utpv6VNZwPFL
         TdZfQAXyxVDRBx9LyDDRBbyUIum5Z+7OIimjqyvotw5qjO4R1B9MjYG7PwjpdA6Z4YfF
         JRzRKd1WZEaYL+QvZSZQA0tJALA0spXVjEsx8oLkTdFpoVP6YyGiA3mBbZQQRMvPFzpi
         XtVs/XQ1kbBAjUpFDaIHJgKAmY61NbVs1yKCerV68ebWxyzag4j2hMzjMQH6+0jusscg
         AMke0mTaYSLp5cPKc3tL26EK0sIUkXGT4xLhaxLzuL0yOUIrmn8+xkgb6do3YS70Bt6e
         kDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794216846; x=1794821646;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mu/oofPDsfg+LaVc2a1HnbHK3ydvC97UTzMxPHDp3UE=;
        b=y55qJL/459pvLWgMYWhojLpYXI78U0hw8+Biko1Uggb07PhL0mhAk9L8Yvio6T8ESB
         vJ443VFL2d4YxeJkZteiOgyCYZkr5e41wCOYZZ95IKiUDMyPtVghG/ZQLLHCdK2JYv/v
         ktTJI5TwX+F0yRn9G4mn6XT0PA6vNt1sqonYFLdNyT2CF6bFnVKMJXqwZfdVySzI3f89
         VMK2D2Lvg3r4/uijzB1SdFKJ79jdxNSgOlH45dpAO/mm3DcqfzYpBKAzLttJjIxaooR/
         g4IQstc0g6EQIXU/OyoLyJDXr50kfjD515JiFolf47uvEghlEx8t4PdSxOIxvGMqzEjk
         VvKA==
X-Forwarded-Encrypted: i=1; AL+hErHLEuJ7EX1RBpKZR4/rTj7six81R5Rw151IVy7WtNX36h3xFadKvp9G9gpXzCO38glnWi/TNkrK@vger.kernel.org
X-Gm-Message-State: APuU4Z8ea5iPmIi26HX/lFRvpGPQ/u+MZpnxI1rBm6HtSHjx1zgO5nMn
	NtE/mwmkkruVMzo8mzxBeZVgpLnSvggg+p2Sz8P+O3rOgJbvNPLeiHhNjbAuXWskL/UqU16hiBH
	RDdRS40E05HOfMTgFMRDgeF9U1UTrWbA=
X-Gm-Gg: AYBFou3rHC9otEzWMtYVgX9MM9SSTLZQfVdlZCe2aTi789EDsUqYMuhG2WNkHAeWF2n
	2P6sEec4B1SYgy1Rxms0ewDH97qD7WY7goCtLARTDKYaWsTXg4tqpmDXc0xsw5svzrc52wx6apm
	pcCekNVGcpRjTc1ymcaHm+QKLLBEjIYtnKA2mnrHWzmfhu81d01OUucOf4AUZSkAUH23+TrcDw8
	DFd3H4La5kwWyJhjZ5NU1XczY6FC3LFZzuIG61hCK34pA6hl78cWyhTivbEDSPxypsQkSVAJKYe
	tOslInUDbLNrl4KQwmOx19GA47tsvkKBRIlpgSXsZ1JimBh9hq8/wJobHlt9ZmZzgSI4WQ3vXag
	2fwCyvU5F6Zy8iwfIecgW7vyxwPq4/0Vo0zwI9d+qJ/7W9jT0HbIizTj2ECLCMyOqhyS8
X-Received: by 2002:a17:907:1609:b0:c46:78af:6150 with SMTP id
 a640c23a62f3a-c4d523bbb99mr398017966b.2.1794216845494; Mon, 09 Nov 2026
 01:34:05 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-6-2106750c0bfa@tencent.com> <CAGsJ_4zQh0TnAxifWPo2+DcyFFOtpXM+2QW91A07oumfyrqVYg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zQh0TnAxifWPo2+DcyFFOtpXM+2QW91A07oumfyrqVYg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 9 Nov 2026 17:33:28 +0800
X-Gm-Features: AclHuK8oJGBgOQDKpdCDCogHbVwnPnC6cKJNTKD1XErUqqMirF8-gtHajt-txqQ
Message-ID: <CAMgjq7DeC23zak6Xur=E29qo7JPNvQUMtbbO34Y62jrQjQgStA@mail.gmail.com>
Subject: Re: [PATCH v4 06/17] mm/mglru: move add/del LRU size accounting out
 of lru_gen_update_size()
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 4:48=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Pure code shuffle, no behavior change.  lru_gen_update_size() now only
> > updates the per-generation counters plus the promotion move; the
> > addition and deletion active/inactive accounting move to
> > lru_gen_add_folio() and lru_gen_del_folio(), which know the generation
> > and can apply the active-window test directly.
> >
> > The unevictable case is untouched: unevictable folios never enter
> > lru_gen_add_folio() and keep being accounted by lruvec_add_folio() as
> > before.
> >
> > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> The patch looks good to me.
>
> Meanwhile, I've been struggling with the names of
> __update_lru_size() and lru_gen_update_size() for a long
> time.
>
> Given that lru_gen_update_size() now only updates
> nr_pages:
> static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
>                 struct folio *folio, int old_gen, int new_gen)
> {
>        ...
>
>         if (old_gen >=3D 0)
>                 atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][z=
one]);
>         if (new_gen >=3D 0)
>                 atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][z=
one]);
> }
>
> while __update_lru_size() only handles
> active/inactive accounting, could we rename them to make
> their roles clearer? For example:
>
> lru_gen_update_nr_pages()
> lru_gen_update_active_inactive_size()

Hmm but __update_lru_size is also used by CLRU, so it's not a
"lru_gen" specific helper. If we can merge CLRU/MGLRU, then maybe we
can rename them?
