Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795696725;
	b=GX2HUmpEcQrqPdcno9/+gVNGH/mHF3xYGycIkM/hvnClKwUwn6VfaYyHT8sjcNAFLHGz
	 2RyE59yf5onOHpcz56VDT5R2O53MF92BfxszcBHj1GKTNOBzTSffK/ccdfV4DK5abti0E
	 4kGv81s24SXrQsI7CrgwmsdNB7TLCWg4zexZ0zBGlQKAqXC6L/BmeL+dMRVWEfYxGha0u
	 4cZ3TwALXK7Q5D/XDgXmcLjMAj53hm2HmgISELholfeQdkJnHq33sPvEYsE0Em76j7QO5
	 6JwADiQMRTGzUN1laAYLKcn/XgkC2LeaAHdqn3V4oRy18oB3ES45ejQl7IS8KyWL1xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795696725;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=C/AbZhSvVAtAuxRzfiAolPI8iaF2YFQe3pPvY/yniKU=;
	b=OXqC5V7OyoEIivZbAyuojtE4wxQWWdRPtV8cJeqAhRva92Dpwnurw4sI5AL2Ewq+pLhe
	 vkEizgwRNnfW9J++SzYFM5yPlLY7lJb8g69WLcqRo0OTwpMAAZVY3UDkIOitwm4vafWxn
	 BM20mVKBidJ5P/Nwxs0zynciiNeHN9S1WAVr8PraG2pNAd5EfN9xwQ1MkNLN34ffjvZvL
	 w/bLcDWT2GpI8Cbl6WX/ocMc47lIY7laQphRYwndzEaCsg+vaR8jrL7h6x5OPOwpqi0aS
	 x0Vigye97BpGiSp3ALDy3oFAb9IhKsd7JC4z+qhPJ6+B2feHzsqA9rFIhaBtv+/P/gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tFlToMll;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF31606A323
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 12:38:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FF31606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tFlToMll
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b49a6e8212so2737699a91.2
        for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 04:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795696724; x=1796301524; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C/AbZhSvVAtAuxRzfiAolPI8iaF2YFQe3pPvY/yniKU=;
        b=tFlToMllBmBUfovy3jCkelg96DvYyf0CcQSpDZvBXzBd4Wp4ql/V+h+5du6YzZVz4l
         ovhx//D+I2ED0lzcIzbvH4b2xf8LmuW7/9s6mFetj27G7h8RK4FBxId6P4wb7XbEZb7+
         vLZmJKp9khzUhfRChjBlpIhc2CT4AhN4IUOqqARTj9tg9PsLkpZHt1ylrb5LyvyVQOpH
         XGS/WSRKqOj4J6X06llhm68e9x2XvuFH4iSeyQ/tETF7jaMoLrcPX6XXJm9HGjFyCI5U
         w8tSS9GJZgx/iruyR1YumB/75n2EZozRvoaoGmUxgETJatQoDZdsq7z/yqnhWP/LzWZS
         WaRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795696724; x=1796301524;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C/AbZhSvVAtAuxRzfiAolPI8iaF2YFQe3pPvY/yniKU=;
        b=H9QLUXHHvYn6jz4ZwRfVrSt85WulnN/cw+cU15xzBclPwq25JUtFRNlnFLIUjQtJDP
         lih3xsnRtqG3fvs3R/zb/k2BxtPeeZP1t56bvN/y364h7ZqiAcakDHNGwtit7spZauW9
         OVzFkjUgEdN0xGFgtCa7ygJliiDP/jYRbMfjF39HO5wZz7e3YkdAwUa6beTfoA53rT7d
         uUt4CzQ8aF9krXHCcujLbbd8HU4Dnt51Q0OyJ5vNQdsFFgDmJK6M3wZGfWnklOCkiGu4
         PrvEcDXiEGb57t1uNEUwMamg1hbG+7n0Q4SJd6+1wqI4GLa1uYI6nh63ICMprow92J7k
         rnoQ==
X-Forwarded-Encrypted: i=1; AL+hErFI6X3xeR++/xPqhi9c6kW9t7gYe5iY9xdIxcbrrRJUFCFOJd+HCim3Opeoi1bKYR8AzXZJV61b@vger.kernel.org
X-Gm-Message-State: APuU4Z+yCIiF4IzB2xsZoiYFx6HmprNI5wQbJ4OGxjKVmFXbWRaoJz5Y
	CUkI4IBSt291EmyWSmxQKEWaYRL+YLD5pJX8ncP+bDFjr33gZqnISmZT
X-Gm-Gg: AZFdTZeA1iG/3pZW656F7bjh9u0sOICOPRWR6HYzyekBYziSPARqWmfMemsDRkjoZKz
	AIKVPodbuvXIwhcNebxS84D6Ext97/Y23g8CedTzXyK00AXTXns8QlI624xvVmOBVqnvzRofTmE
	BQ24DtD/drX3J6fmKG8gFu+u2tnkrBQaFeolr8u+7h2dp2k1pIhrAYTAfrEs48D7Zm0PaZKZaGk
	5G2KZ9AoDttwM14DUWtiZoAG2rdotqVsj9smM0crebCaeOgd21a6mRUu9jv//FV6Ii6ybRpnl6R
	ZkmBQEIb0zjHw5ILWF7oTvECCI1LIyLVb0qFU0zi/31GiK4DiK+JuohmhTqsSdY5ZOY/rz5TIAW
	r1g8qWDorGghZolAGs8Mlj8QM2nGuSfVTHDfCfTYYcZqeo/pyNI37AR69zgIcie8lptTm9EXZS2
	KTdYqRAzMoQWCKIvDiiQY3efGl/csroI/MM77DHb5pcQA6DAzk56WFHVheo9/HwGWSyNGgw+Lez
	WgjSqFPmZecOWXXtp/tuXoHHRkg9Tx1R6olEk+zNdZ5l32xm/0nkAUC2nGnf6paQhYAfHJDrstK
	jgGg98y7FnDTosKBsHTcbn0RvvIp5AtqSk1DpwF2aBK4woMMiHThftwBsgliiYiwM7GWTDI=
X-Received: by 2002:a17:90a:d2cf:b0:3ab:2737:3395 with SMTP id 98e67ed59e1d1-3b41cafd604mr18006258a91.42.1795696724285;
        Thu, 26 Nov 2026 04:38:44 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm33352174a91.6.2026.11.26.04.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 04:38:43 -0800 (PST)
Date: Thu, 26 Nov 2026 20:38:16 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
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
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>
Subject: Re: [PATCH v6 02/18] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
Message-ID: <awgnMVr6GHt0XKD0@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
 <387237c3-c2f8-4782-9ba6-481f459cf7f2@linux.dev>
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
In-Reply-To: <387237c3-c2f8-4782-9ba6-481f459cf7f2@linux.dev>

On Thu, Nov 26, 2026 at 05:43:14PM +0800, Ridong Chen wrote:
> 
> 
> On 11/24/2026 2:52 AM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > To enable moving file pages in folio_mark_accessed directly and lazily
> > for MGLRU, allow updating the LRU statistic atomically without holding a
> > lock. It may cause temporary counter underflow, which should be fine as
> > the counter is eventually consistent and only serves as an estimate.
> > 
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Tested-by: Andrew Morton <akpm@linux-foundation.org>
> > Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> > Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   include/linux/mm_inline.h | 5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 2395ca8ee305..2edb9beef6d3 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -47,12 +47,11 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
> >   {
> >   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> > -	lockdep_assert_held(&lruvec->lru_lock);
> >   	WARN_ON_ONCE(nr_pages != (int)nr_pages);
> >   	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
> > -	__mod_zone_page_state(&pgdat->node_zones[zid],
> > -				NR_ZONE_LRU_BASE + lru, nr_pages);
> > +	mod_zone_page_state(&pgdat->node_zones[zid],
> > +			    NR_ZONE_LRU_BASE + lru, nr_pages);
> >   }
> >   static __always_inline void update_lru_size(struct lruvec *lruvec,
> > 
> 
> Hi Kairui,
> 
> Just a heads-up: this may conflict with Joanne's "mm: move LRU size stat
> updates out of lru_lock in folio batches" [1], which is in linux-next now.
> 
> That patch makes __update_lru_size() add to a batch attached to the
> lruvec by the lru_lock holder, and relies on lockdep_assert_held() there.
> Once this patch lets folio_inc_lru_refs()/folio_reset_lru_refs() call it
> without the lock, they could write into another CPU's on-stack batch.
> So the lockless paths probably need to bypass the batch.
> 
> [1] https://lore.kernel.org/20261029204157.117879-1-joannelkoong@gmail.com

Yes I'm aware of that, the fix is easy too, something like:

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 4ca8011bd288..fb5e3990402c 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -64,6 +64,30 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
 
+static __always_inline void __update_lru_size_lockless(struct lruvec *lruvec,
+				enum lru_list lru, enum zone_type zid,
+				long nr_pages)
+{
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
+	VM_WARN_ON_ONCE(nr_pages != (int)nr_pages);
+	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+	mod_zone_page_state(&pgdat->node_zones[zid],
+				NR_ZONE_LRU_BASE + lru, nr_pages);
+}
+
 static __always_inline void update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				long nr_pages)

---

And I think that batch design could be somehow improved too,
holding a stack variable in a global struct looks a bit odd, could
be simplified if we audit and update all users for update_lru_size
later.
