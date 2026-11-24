Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541362;
	b=aOnEDJNPQzH8D9TCYWxZUFEnyY+/r8jSMYOlDFeYzyVKrADQIKOq7j4Kl/OUyyQ2yZ7a
	 SZeBFmuypc9hf1AqJN9g75acZllPdZASH8V7RwlvI0z1zQooNltkaRaX/ljMZrNLiNkiZ
	 TqvbOdMj84e1AnJAfxL+KZWBaSwbAxUi2uakuzWxXzuCPxO2I0oRGq5BItMvIGXRiG8cF
	 sAahWi7but3Ov+zsKQnt9KKP2v/HIyxYE+4r47+p1OoMEjoKCrjKbqDwgsFmzIhHncBWe
	 j3jXfhbas850SWhqic8AHCM66vGr3sCP+j+L8JWvti73GUzCuudz9W5N9cvV6vE6TWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541362;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Gh6CqnsQ+4Kge1Ge1wt7W5gV069TsTISbQWwZdpvMuU=;
	b=TLAYR60AfwBK69KcjAYjGKjHAzY7uhMdC0ztGDJt+4S/h5usxbld/7xvRIeuCf87uIE8
	 EYSBl2w2kG8+9zmGE9zsSfRFQUJ4SrYPuROtwYfqPvYb5spGMXrYCOivv6cLyPOOk9PTW
	 RtI7+arwc0lvxoRLQN4WEp/uW0DK3yXXywRC7b+Fc3UJVrDR4YS+2zz1huqc87gyySVOM
	 OBeeZN11h0WFn52xzcgTOhvBjXww2KeCSVKRyik05IWRLqMqEVR5JdZ7JhApcVgdywhhl
	 x3ua3+RlxjUZ9iKSApHd6P+0PBCKE72116/QphP6KvxdpOnk3czoRbwUDBkgb++1caQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C3a2BM8n;
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A221606A327
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 17:29:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A221606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C3a2BM8n
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cdddc79a4afso1889049a12.1
        for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 09:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795541361; x=1796146161; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gh6CqnsQ+4Kge1Ge1wt7W5gV069TsTISbQWwZdpvMuU=;
        b=C3a2BM8n3061p4sMZOMJ8Y1++2AGZZiH9JYuZvbQ1ruA3bG/0EZNMmcDp/Au9lC7ZJ
         4r92Y+doFslYiemisX5ngldE6XhXw8kw2ZHYv7N9/lc9DmuUWCdbpPLJiO2piXiV+MYW
         s9RW1RbmdQXh7QSgmJeSTl4QJoQdLiYrVKgk4TGnRMb0WSc3Di8exzY/ym4LeiBAIY4F
         c7mPMRBA3YPBPOYnXon2OZYof1k1S/oLnI5I8cIQcB5aoJOb1lIOFSoWx1AgOuB2VVlG
         gWG0KvOOBmeF6PC37XfXGWXqVoTdmP82hw2ertwKDYXQ8z6kid1rNVz9R0dtO3JCDTO8
         uYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541361; x=1796146161;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gh6CqnsQ+4Kge1Ge1wt7W5gV069TsTISbQWwZdpvMuU=;
        b=aOP6aiwY7yRqXvgCMGWh3uSwoAaAspOTAKv1Zd9bFWHBHQeC75QfCoox1QPnBpi5/T
         Wo/H8zEX6FPOMixKuTgce2FJYmQ/ZeMfyX916ODp1lA8MQS2rN4F2Bp3+QjDo1AtfAyX
         YIp2tqkiyLnVjMIP0u+Nqmzjj1xE/GX7xMnj4oy3O3HbqHnGiuOT56UDFM4e+2yTjeO1
         XLdGJ3AK1J1LVE8NQaDG0JXkpWNOQ7oOZMeyuKq3ZLm2balArIViB+5CnmeoovVSTn6J
         TGwED/nhZzlaWZ2bY8e290HreI2uaS409P3y3Kpbx6f3hRfzUWgkfWeEJ/3pOxwbehHk
         hlLw==
X-Forwarded-Encrypted: i=1; AL+hErHSCkuTo3Abk/PQr/VRKDWHyPbvWv6YzjtRLmsPUR5kfO1UTeWFzQDB60sWZwekT1WP6tFf3wTp@vger.kernel.org
X-Gm-Message-State: APuU4Z+VVQ/IIMNQl3gPcxu820HxAGa3V5dOlAgCEDqRYr0QNhyijHbG
	AUFDFTTVElNwm2ZvMEQ5UTHhfZyrxXKru7RF+H3A0OCsI7jzKvJFckGm
X-Gm-Gg: AZFdTZc/DW9wdYPuB4eVXIsejf40LUqnR9QfR7ChBagaOX696RHfjQ6JyzZx8NkvSU6
	XK6ZcUAuRA+R5ZPYTyKgCOPotoQeJI5n7ixYkrqG5bvgRIlqVUW6fA1v1shiezMzwDJAn8XGVLH
	JEuJCIdeG+XECbyGFu4IV1H4PGEFwqM+nXav9QNhOcmZS1HK+D0099YUi0wSqHX0+Tv6R0dAiHD
	ywyKYZa6gse0FlmFjj3eBRkhv5KUB4N7TNm84m52H2IJ+i0JTlweyb4TbralkoGh19opWTKAeZT
	31zNQRP156bqo9pAxi4qBow6Ga62lGusz+q2cMXhfqj6AvuEa1Tl4utyvjvhVmFIQqzRrRBLeb+
	Kd/WEsmHL4dtvuWei5gc14Dk4mcbnprqbOPoMZTT+cVSkqBg7pYMACVpekctqr2TazuEoLSr/DC
	ESzmcQpsrZG/uuhecWo6D3Czpo+Qqhb86cANnhqCA1vkcRnhEVTkQIqQL03jI7BwDlclsKdwwY7
	ITSb3J+YYrYjbwJVaNiRt6asuLuAuasPvZqCM+wZz8qu9hiKgrkbLWK7BGhFGvNpMsTcA6+M1M7
	IV72H0ZDz01ZqEzu7ZO/duh4iEtwHP8AL0ky6Y4aaonQQHIpIcZLgQlwh15xWxaeAZXHs4U=
X-Received: by 2002:a05:6300:404c:b0:3fb:35d2:645e with SMTP id adf61e73a8af0-4014a27e70emr13896715637.5.1795541361413;
        Tue, 24 Nov 2026 09:29:21 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e4aca2sm7432265b3a.32.2026.11.24.09.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 09:29:20 -0800 (PST)
Date: Wed, 25 Nov 2026 01:29:04 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Zi Yan <ziy@nvidia.com>
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
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 11/18] mm/mglru, smaps: convert to LRU refs based
 operations for MGLRU
Message-ID: <awXIalgUrVIf5VP9@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-11-8ffea39934a6@tencent.com>
 <DN2UPVW6W83J.I1S5XXQ2DPLV@nvidia.com>
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
In-Reply-To: <DN2UPVW6W83J.I1S5XXQ2DPLV@nvidia.com>

On Mon, Nov 23, 2026 at 02:52:55PM +0800, Zi Yan wrote:
> On Mon Nov 23, 2026 at 1:53 PM EST, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > PG_referenced is only the lowest bit of the folio LRU refs count
> > (LRU_REFS_FLAGS) now, and MGLRU never kept it stable: promotion used to
> > clear it, and now it toggles as the count grows. But with the LRU
> > referenced count as a stable API now, we can use two helpers to provide
> > in-kernel users a stable and sane reading of the referenced status of
> > an LRU managed folio.
> >
> > Add folio_check_lru_refs() and folio_clear_lru_refs(), which use the refs
> > count when MGLRU is enabled and PG_referenced otherwise, and switch the
> > smaps paths over to them. The lru_gen_enabled() test stays inside the
> > helpers, so its static key is not splattered over the few call sites.
> >
> > Convert smaps as the first user of them. MGLRU now reports every folio
> > with a nonzero count, so the reading no longer flickers and clearing no
> > longer results in an ambiguous status.
> >
> > The classical LRU case is unchanged.
> >
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Tested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  fs/proc/task_mmu.c        |  6 +++---
> >  include/linux/mm_inline.h | 31 +++++++++++++++++++++++++++++++
> >  2 files changed, 34 insertions(+), 3 deletions(-)
> >
> 
> <snip>
> 
> > +/**
> > + * folio_check_lru_refs - Test if an LRU managed folio has been referenced.
> > + * @folio: The folio to test.
> > + *
> > + * Returns true if the MGLRU refs count is nonzero, or PG_referenced is set,
> > + * which is also correct for the non-MGLRU case. Kept as a separate helper,
> > + * to avoid splattering the lru_gen_enabled() static key.
> > + */
> > +static inline bool folio_check_lru_refs(const struct folio *folio)
> > +{
> > +	if (lru_gen_enabled())
> > +		return folio_lru_refs(folio) > 0;
> > +	return folio_test_referenced(folio);
> > +}
> > +
> > +/**
> > + * folio_clear_lru_refs - Clear the referenced state of an LRU managed folio.
> > + * @folio: The folio to clear.
> > + *
> > + * Reset the MGLRU refs count to zero, or clear PG_referenced, leaving
> > + * PG_workingset alone for the non-MGLRU case. Kept as a separate helper
> > + * just like folio_check_lru_refs().
> > + */
> > +static inline void folio_clear_lru_refs(struct folio *folio)
> > +{
> > +	if (lru_gen_enabled())
> > +		folio_set_lru_refs(folio, 0);
> > +	else
> > +		folio_clear_referenced(folio);
> > +}
> > +
> >  static __always_inline
> >  void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
> >  {
> 
> I assume this mean people should stop use folio_*_referenced() directly.
> Are you planning to remove PG_referenced helpers to achieve that?

They are still there for CLRU, but yeah, and actually there is an earlier
RFC where we can remove PG_referenced and PG_workingset, just like this:
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-31-913619b014d9@tencent.com/

And this:
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-32-913619b014d9@tencent.com/

It doesn't really reduce the flags usage but make the code cleaner.

The co-exist of MGLRU & CLRU makes it looks weird, hopefully we
can solve that soon, let's do it step by step.

> Other than that, LGTM.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>

Thanks.
