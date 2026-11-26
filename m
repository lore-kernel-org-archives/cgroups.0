Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705312;
	b=VJFFxle3giTl0oWxWyM9dFIWk40B+0PDax+rZO+uisyVrCEquKO3X5GUxSlE+ThJuXu1
	 pHk6znFQIerV6viBckBlOf2/HqPWPCHUVA/QZGHEcGENuXF9oMsqAnG/eogSBEq8jbLYl
	 CqzZ9jpclVB8kVg8z8GnduJ7rsiRNK/uwDJnTVZEQFPdtS+aT3m5VDT4sCkj1++l/h1bK
	 NrEdyMgKlMu7FSSlLmoPfr/Fp6BbcaHMJ6dkWndqfsNNYMSGM/NYDSwK0fo2Jl1fb1QEl
	 TcxuY1yLmER6ugmu5wkd1lLL9/ptAvzYmJf/Ho0mMaBQdtz2Aa5zUZG1x8nMcZqPZHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705312;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=CnA3zlb6+Q4MfV6Y5oL8cXYKHj+wdTkqxg32r451qEk=;
	b=DBfxStMeqFTqsbhj8GKtyL/nh+SSji08io5BNBig7A0KY/98ioKUgEicIF6tvw7NqggQ
	 Rjk3aoxPlQ3RoJK+GgUWE/0i2MgZYtSFthtiAjwHkTOCx/M7WJ+z2WJ/xHH06VT94u/P6
	 pcAKSCAQj5gSmTSnJTG2ksRmfRpd4FjZXeANW/ATJ+ns+9/Lu4tZDEBTO+GrXNj+NgQh/
	 B+vk/7IAWVt+UiXg2YIj+m0akB9fYu92+a7JknWktxaoO8JchBs1Jxi0n6evshDv8o8Rx
	 rV+mfsUGEy+Gwm6Hdg11uTemMiO7WNbSqONrVN5U4a4hfZa9QKf4NLUBlQWTB/c1PCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="b3sZ+/K3";
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC04F606A33E
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 15:01:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC04F606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b3sZ+/K3
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2f01f296937so54067855ad.3
        for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 07:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795705311; x=1796310111; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CnA3zlb6+Q4MfV6Y5oL8cXYKHj+wdTkqxg32r451qEk=;
        b=b3sZ+/K3mFnawrjvx85flgmuT1zHOx3Wa6bQmig/FPG7IvWZnnPujUtt04UcCQm+tp
         YcbNqvBn72KW+GtFsj9T/6MBlkXuLF0S7bpw0gc6Bb8hhVQq2yHUIgIC2as1r1XxCewg
         55bEJ76AQOJHJlwW6zc2MZpJjZk4qgrzvXJmecel7U+zkoAjp/Fkh706tNW5xMLtzs5U
         Nz7YrwTQY15c4kchCoSiAdI7/oOsOEQHeRqHVF6CqoQntJEAghHEakYfz5f0vcztnUAD
         izPsxD9LCqUra0KUfUdOD/ui2YcGE6idNSNRt+CnZCHSV7AODbvljIuCrRBWKTVf0xNc
         X40Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795705311; x=1796310111;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CnA3zlb6+Q4MfV6Y5oL8cXYKHj+wdTkqxg32r451qEk=;
        b=f5eQTCTn0292Dq4XEoRrIVi+5ZyvKWhQ5ddcG+YbyycLEr2N8yNuFP04z8whgxa8DK
         mmwLYorhvCRhb3sHS7LuK0NT+EiMqKbUEI3+sXmrz7Sycs/GZqWaYWs8YCEl6pUyBtv4
         h0va2PbuwlVam0HoGEgzb/5HpuJvlXAxHe/GEh0SCcyKsxB5OZ65yuwvBof4ks3X1wCn
         KwUiHbwClbcqJA1LUBzJ6LOxkdL19sckc2JIJdZW0tUyxCtAR01zHkyyAU1x8Hi1PuJV
         HoCDvEChQs+PgH2sfP8ZqGsJSHSPhPE3U04SQUvgXGQ3TVpask6wguLPyeQdAH54k6nP
         iCpw==
X-Forwarded-Encrypted: i=1; AL+hErGVkNt9Dg4NeDYMf9k2saZn8BYsqt+Mf+EON22wWBpwOwdwNqLArvEuapa9HKKweVJx1xHioRPp@vger.kernel.org
X-Gm-Message-State: APuU4Z/ZtCbCCt1rzb/55HySI2cHfA+hPGayTyyzL8nPVQidwkO3lh6M
	6eKt8yuVe2sq0GmoSNwbX0YJC3CgNU0TyB3r7dKeQFGR67tBa4ODz4Z1
X-Gm-Gg: AZFdTZfEnSC9GRweC0I72F9PYycNN2fUOPmSwNdws6WjVHMKPNx9u5xvb3KjXcvrlOy
	X+zqSglZ/k31yzK7tivj3AiMv+D7rbfaQUmlo9G232bNlh3vfIWoqcxVOwoKAC2LYbVzW9+Sozi
	JG1mkdM+WO0nvt391FXMg24m5+JWhWhxxox+hCZ3OeeTSjFth39lSpSVNAcrz1waK1TLSKVpqgs
	Ja88uD8U/z8QIqYE0/+i37nIyb8uHx5ohE06kfr5Smroi9kIKhuNk8vqsSbp2739ihpgzL6naeZ
	cU8o2vUmXkWTM95IWRVVjm/fz/l6cP8kGkk9PdB3sP+fOhpgfJ/jvgSN+DGi4sD/wz/I4rNYxST
	EXKD0yEMeHwcha5fb+gCCRfwxEBV3DVa/6ytTHjD/6Nwb1YM8Bx04Q0WMlvxEi2QZyB9d0867ZF
	SKmnlkPFHAgm94pR6Bf/vWPTpt1Cl4/WXPGNKA+fBNQY420sM+/V7xfoAUQOGiArTn9yt3Cl5Yq
	NeduoQ8MZlYXwbGQ9Qs4fSrgykHL4wA2zR4v8v9xuBWx2c81va4F58EjRKOF506H13rkf/oQiJD
	GU2juuY2wt5oy1aZk0bdT7Ao/ay/d+2jvM1/Qoi74Dcd
X-Received: by 2002:a17:902:ec8a:b0:2ef:e25e:e13c with SMTP id d9443c01a7336-2f03efb015amr233195175ad.5.1795705310670;
        Thu, 26 Nov 2026 07:01:50 -0800 (PST)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f15663fsm103299005ad.76.2026.11.26.07.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 07:01:50 -0800 (PST)
Date: Thu, 26 Nov 2026 23:01:33 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
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
Message-ID: <c37b9336-95ac-4787-8a7c-73f6ee9d17c2@gmail.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
 <6c3d32a9-3004-4a17-b854-7088e69f164a@gmail.com>
 <awfb-vGF62XvcX_F@KASONG-MC4>
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
In-Reply-To: <awfb-vGF62XvcX_F@KASONG-MC4>

On Thu, Nov 26, 2026 at 03:16:32PM +0800, Kairui Song wrote:
> On Wed, Nov 25, 2026 at 09:47:18PM +0800, Vernon Yang wrote:
> > On Tue, Nov 24, 2026 at 02:53:02AM +0800, Kairui Song via B4 Relay wrote:
> > > +/**
> > > + * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
> > > + * @folio: the folio
> > > + *
> > > + * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
> > > + * untouched. For a folio off the gen lists with MGLRU off, a plain
> > > + * PG_referenced set.
> > > + */
> > > +static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
> > > +{
> > > +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> > > +	unsigned int refs;
> > > +
> > > +	do {
> > > +		refs = lru_get_refs_flags(old_flags);
> > > +		if (lru_get_gen_flags(old_flags) < 0 && !lru_gen_enabled()) {
> > > +			/* For CLRU, just do folio_set_referenced() */
> > > +			if (refs & LRU_REFS_REFERENCED)
> > > +				break;
> > > +			refs |= LRU_REFS_REFERENCED;
> > > +		} else {
> > > +			if (refs)
> > > +				break;
> > > +			refs = LRU_REFS_REFERENCED;
> > > +		}
> > > +		new_flags = old_flags;
> > > +		lru_set_refs_flags(&new_flags, refs);
> > > +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> > > +}
> >
> > The implementation code of this function looks a bit convoluted.
> > Would it be better to simplify it into the following code?
> >
> > 	do {
> > 		bool clru = !lru_gen_enabled() && lru_get_gen_flags(old_flags) < 0;
> >
> > 		refs = lru_get_refs_flags(old_flags);
> > 		if (clru ? (refs & LRU_REFS_REFERENCED) : refs)
> > 			break;
> > 		new_flags = old_flags;
> > 		lru_set_refs_flags(&new_flags, refs | LRU_REFS_REFERENCED);
> > 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>
> Hello Vernon,
>
> That's very good suggestion!
>
> Only one thing here is that
> `!lru_gen_enabled() && lru_get_gen_flags(old_flags) < 0` doesn't mean
> it's classical LRU, maybe it's just isolated. How about bool on_gen?
> Or bool has_gen?
>

Thank you for your explanation!

For has_gen, looks to me good.

For on_gen, it could be misunderstood as "whether MGLRU is enabled".
So I prefer has_gen personally.

--
Cheers,
Vernon
