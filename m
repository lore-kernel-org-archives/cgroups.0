Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795677406;
	b=OY39nYfE49729joQZvRJkJbFalKhwmN0GhbLkpZYhrKPniUJ6g6fHwZa+JOP0+kLwRiJ
	 EM41/F+3NtgVPZMnxvCU1HdRS4H4XUt3NTdA9g8d/L2B1C/pB+qkYM8fZ10n5kXRxD+r/
	 1LrL6Vsu8ghzI3E36QUJU3cnAjBW3Y/S3OBVNtQurzqeBQOMHQncs6jJs+gKQzgfyEaBo
	 eBGKqgmqH5PzbiWcEj37/2dKjL2/BgNWvNzrFMgwa68HL4cfyxT3hf3681l6RMkl6S6gQ
	 BSHp2yrsKaIykp+GaqX0quicCMOfmuG830dWPEhyh4ivKwB0wrbGukQac3DlgXowwag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795677406;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=tioXBSwm5pktLh4V7ZjeytUoL0urdjzGdHunvMaRHSk=;
	b=5ItU6fgRVtAtMxNLHlBKemMTyNCzpJBbLRQ1adQtUkfai53+54pCRJs2FHisW6LYY3ci
	 OHKvo+CxS+rN0rcATGbX+S1DfiX73Pa6EHC7sRQHFgGEla1laHQFwmoPHg7b5JN8s7YN5
	 gcWjX0Wlr6iOXxoBaGtiXrdq6N3dpEOsYsebzz0pxjC30pRSnLE0V8og+no/Oo0Pm0fWF
	 GpTzuoYrA7o2SMt5jnpOcT61+2GAzfxotfE3nrtGOGTHBTwezCHRgLgoZ4ClidI0yCjOZ
	 YEeDRz+Zn9P1zvFPnH5Na5ePWkWW32ivgbbS1rlFcXd5Nmj7KiICBdWaoABk87UxRKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oi2Ks9b3;
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8681A606A330
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 07:16:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8681A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oi2Ks9b3
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a4c72951b8so4314345b3a.3
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 23:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795677406; x=1796282206; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tioXBSwm5pktLh4V7ZjeytUoL0urdjzGdHunvMaRHSk=;
        b=oi2Ks9b3T4wlAj8zr6C3H3evvBHdgAPn4MlpNxzpJ39yFK2wco5D5Uai+HoB7RXilR
         B3329OrtXQcD9E13YoAoDRSV/mttgXULxSRf2+6fjDqsKkCTjsblzC4if3F2kuGA8NEo
         PV/OsLxIZSKzXnkMd6kb8yPaXCnzs3h8qHdiygf+M//zgca57HRzZm167dBnFxISbboN
         Knoyv/cC3Jh+HZY4+YgDlwQD8W+5mEvdM6dNEjQ4gizfbmedld31pW8jxgE9uA9XGvuK
         YSYpG56oLnyIMaDJ6ok858+qzM/jCAA8aJ9r51VbkzJ+1i8jflqPEFbx3ReNdkFqnRjb
         2AGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795677406; x=1796282206;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tioXBSwm5pktLh4V7ZjeytUoL0urdjzGdHunvMaRHSk=;
        b=qeI3bRoDiFUI7njFY3GNr0OsLMLImMh2QEKnau/PIF6m+CSWT3gmKQByJdtdfOyT9u
         5QYyqK366ajmy3yfiribN1vD/Pv2SXm9C4WqHns9vEYMHKcilxJXt/ttNbQ2aGq/l3xx
         UdtqqfEYe1ZsToPPF3WJQvDdnZE3Z05b7X6CHgnQQFYoHU0u6WBZNKzma91htR/ruWJC
         MYPtUQAdWBnwjYmDanabLmnV8gI54ABBmluIccmvIAX7MG4LFFdMieued6rIagnH7fm8
         Ut7m4WhS+OUDF+ZRa84sXT/MiAUPRAJHY2lrDIj7EQ37JgD6dCr3jPmqTgxBDhTS9O0u
         Zi5A==
X-Forwarded-Encrypted: i=1; AL+hErEHGmdaN8X0c84GTIcdapOunx2heKDymEfh95Lv41nTLKcQDPhTMnV2A5ZXVoEEldFRUOc6Px1L@vger.kernel.org
X-Gm-Message-State: APuU4Z+5MXUi3o26y6TJQxYsA7J7mdtER+66GYanWFSz+7HeKjom1q0H
	nSduegt6Y1SBTJIzA9Le4/6lGbDZJYivfeX8u7HnDvCjFVJ0+bbxGLjG
X-Gm-Gg: AZFdTZc1CrgewkNMPHlYXrRE9PJ+dO7EA7HIl8NFSPqaLci+c9SBIEnSDnomtg/FCxm
	59zMFiIrxG7b91VJGn46JZXrv9A0LADDAG9BvJNAKoFowrG8/vSP30+6SRQK/OijxTyD9fygA5S
	AfCewl1W+fDvIfsSZf9SAwqc+HdROWwaLQwC1B/7KcTN+VQ29kHqil8ClmoqQShQ+0RsA4JdmRo
	yXeYBCCZZomyjdT17x7PLnDDnlE9cdRkIbKgpo0ShJ9Ez952seAP6fk29mJhd/Ig3UB/ENmU2G4
	a3tdVEMldW4mj6rmJXuIms8UjXi1GndP1VOJL6yywRYDEQoR9rnYYpuU7zNv5q7VmmjTaJmjr/I
	XsD81MbvBmwLFUQK5iR6XD28WSVN1sTbK1fQ/OWCTRo/9NCH39TqeNt8qz6LJIFDCMz1V0f4LeQ
	l4nLVEk9c3/jKylYdwLmK4fdbSX6msFCvy6/QL0obofWQUrdALwPM3AfIBYDUycf2P0k6NZ9VIs
	nzDtrcqbfz/D+gV18SycKsiLrIqJXjbC/06MTlvQj6TM9B5BEbZOTD2N9WT7Wzf0swzjI7nw6WD
	JV4w/J14tP4dnJWYjUexLHRHFRfTq+6o1L6HUqXd4FMyYM6hhUnwvsUvpBy9kuXYCDhnZMpe0hE
	=
X-Received: by 2002:a05:6a20:9389:b0:3eb:9e7e:1ebe with SMTP id adf61e73a8af0-4014b65c9ffmr25687016637.21.1795677405734;
        Wed, 25 Nov 2026 23:16:45 -0800 (PST)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c86d821637sm10523020b3a.0.2026.11.25.23.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 23:16:45 -0800 (PST)
Date: Thu, 26 Nov 2026 15:16:32 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 10/18] mm/mglru, gup: mark folios referenced via a
 fast helper
Message-ID: <awfb-vGF62XvcX_F@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
 <6c3d32a9-3004-4a17-b854-7088e69f164a@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c3d32a9-3004-4a17-b854-7088e69f164a@gmail.com>

On Wed, Nov 25, 2026 at 09:47:18PM +0800, Vernon Yang wrote:
> On Tue, Nov 24, 2026 at 02:53:02AM +0800, Kairui Song via B4 Relay wrote:
> > +/**
> > + * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
> > + * @folio: the folio
> > + *
> > + * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
> > + * untouched. For a folio off the gen lists with MGLRU off, a plain
> > + * PG_referenced set.
> > + */
> > +static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
> > +{
> > +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> > +	unsigned int refs;
> > +
> > +	do {
> > +		refs = lru_get_refs_flags(old_flags);
> > +		if (lru_get_gen_flags(old_flags) < 0 && !lru_gen_enabled()) {
> > +			/* For CLRU, just do folio_set_referenced() */
> > +			if (refs & LRU_REFS_REFERENCED)
> > +				break;
> > +			refs |= LRU_REFS_REFERENCED;
> > +		} else {
> > +			if (refs)
> > +				break;
> > +			refs = LRU_REFS_REFERENCED;
> > +		}
> > +		new_flags = old_flags;
> > +		lru_set_refs_flags(&new_flags, refs);
> > +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> > +}
> 
> The implementation code of this function looks a bit convoluted.
> Would it be better to simplify it into the following code?
> 
> 	do {
> 		bool clru = !lru_gen_enabled() && lru_get_gen_flags(old_flags) < 0;
> 
> 		refs = lru_get_refs_flags(old_flags);
> 		if (clru ? (refs & LRU_REFS_REFERENCED) : refs)
> 			break;
> 		new_flags = old_flags;
> 		lru_set_refs_flags(&new_flags, refs | LRU_REFS_REFERENCED);
> 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));

Hello Vernon,

That's very good suggestion!

Only one thing here is that
`!lru_gen_enabled() && lru_get_gen_flags(old_flags) < 0` doesn't mean
it's classical LRU, maybe it's just isolated. How about bool on_gen?
Or bool has_gen?
