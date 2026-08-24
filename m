Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EBB40B0F2
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 12:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787574612; cv=none; b=ABA5+XLAMjwPa+vvF3ugOGJa4mN6BoU2uASrZFhXgLVxXfLjVhKlcMfI7rnP3Xz9gIbdyyQTORfmYXTYFsghj4Q51uijXdb8vvncbKdyUVvEvry9Oa/BuAwidlqBa/J+bq7WzFJ9oDVa7b9U7j6hxyWkLxw3FLsHclY1HgqfEiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787574612; c=relaxed/simple;
	bh=9avveLcrKkhK1W9rSYKP8umKyTKseZySIkXYM3VP2/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8p+8VppjdVZBT52pHriPY6ZM+CH/3JxIOkUm9/rJklNRKB/e9NF7mYMOa4KuyTzWCi2S6DSG3SP3TG5I1j5uNNPW7JHsM32Rp4I5nz4ExbS9AilJieHnqILrT6GgifzaPSRubWeiwWPtBRtWf8fbCYOZ1y8EomTnexkMRZ6qIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FMAtwmUh; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FMAtwmUh"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4799b3f7c83so2341713f8f.2
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 05:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787574606; x=1788179406; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PUk7KPHfvUyw9pUIUwd/E+D8sEbupQa09omQcDsDz3o=;
        b=FMAtwmUhSEDMxJShEkhx1hFBibflKnjtqMFzgZaAbZqR1q0+OFu6xS9qASpydQpQjb
         C8wiDorVQjObJqHHTF2ltkONPAOdXsqZ5sy01LX6CqZrVJ//sLxVh+zSs+FvWU1k0Pz3
         DLdczUVj+WMsePjttdwEcYSwfDWaJg3MScklyj3ZIDbNUGXz9bF1kip6OJV7WGK5rJ11
         Cqd8PZbS+toJzjYWP6xpHIAHWnHdp55c+X6pIhNUaVpgjz6ExqmYiUJ9DsuAfPmRWLZS
         wCKtJorBzjz+biqDv7cwIKxem8jO72jyvR/l3WGsCzZCEHs41jhUwOe6fWkjsab2sywn
         GZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787574606; x=1788179406;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PUk7KPHfvUyw9pUIUwd/E+D8sEbupQa09omQcDsDz3o=;
        b=GqFC9+BUu3tWuDZzVzHI2fJD7f+VhLzPRp7meIyeoWtbdK3TvIqWK9NRKNOBfpsHTC
         tmyFnqXKO0vXPobcgnVtblLoWzQ2rIg0r0YFr1gmE0rjOWMys8gD20US4D0zvE8oufhc
         VfCF3XIQFQ+k7u6LXfdcxHylYctBa2XBSuw8v130L67xR9UckyMrmrzC4XDoyNOy2JM5
         ha1SkCubz/AQHrdaPrZq8SvDduWpJ2tjV/7wCv97X1nUJP65Fp/gkE+K2oU0wkMVnNb/
         N3E00FVzB6oWdxEdKAFZWu/67emjDs0UCGOqS/v9xVD4KZJHBlyocFkuGHY0VspQ7jn8
         IiEQ==
X-Forwarded-Encrypted: i=1; AHgh+RrdVOZ24LJD4bdeSczQskRO4y4yz2/X/aIhaUSj0yLiVgWn1wVDtZwaxwXPSxsP14MpvsVCltbh@vger.kernel.org
X-Gm-Message-State: AFuF++k9Ne+spUR7EHTiJpB5p/dAtGIqRd6VEViqf42W0T6VqHVLosUN
	LpfLmJ5qULHe7b4Ft7zw2vjITBu0kztIfR7InTgZ/t9hiQ0SWtTeltfg
X-Gm-Gg: AR+sD13/anVuF49AWJc9Et2xW/w+fkeFOWYwzorRD9jYyZ6ZC0Ck/dKkKRSc4B5sSdI
	KO1pAQ7Dz2O0J4n/FJZAQu4/oSG2cIO0spden7D6dV/UMq4KpLyb6r1KyEdsu5FnCAxgR3xHgys
	XNIS/GxAxBiZPRtYMwg3kWjCFlKarsvlk5lnP6qW0F3ACfJdnotJijg4fK+ihpFykv6f1Nqi7iu
	OIlkYsGjPqU9x8xemC2/ByY7h+Bb+3bNC0D/qAtLTTltJSuPkVfJ+0PiA4STgI2359gNoqTCgld
	7xqWYkYudLt1i9JUx3okTABtGQyce5b/7S+AQEUg2FdDsMnnRLYXdtIwWiLTVkKjEp6yyj2kxXa
	LO7A31+sIUq/tzlx+ZVJwOSCQLb7yq9YW/qnmY1FlK1XY0/z2L++oYAcKCPw4qLHh/JHi0lHImF
	gfBQkaCzrh+Hsn/eXaNzWkpJi4HoufLxHAErZ7FvAbGRO+ynEvqS6bzDqB5lLbeZ2vsb+lgiun4
	Cqc5cpphnoWAj4BKH1aNTlz
X-Received: by 2002:a05:6000:2383:b0:475:3a97:8e2c with SMTP id ffacd0b85a97d-482c81c0377mr18786975f8f.16.1787574582551;
        Mon, 24 Aug 2026 05:29:42 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482c9c086fbsm7997186f8f.26.2026.08.24.05.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 05:29:41 -0700 (PDT)
Date: Mon, 24 Aug 2026 20:29:29 +0800
From: Kairui Song <ryncsn@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] mm/migrate: copy the referenced state via
 folio_migrate_refs()
Message-ID: <aowmf2OcDnayYaU2@KASONG-MC4>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-3-8dbbdac0d28c@tencent.com>
 <51b025a4-7da8-4b50-9ba3-1c25eaee7b04@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51b025a4-7da8-4b50-9ba3-1c25eaee7b04@kernel.org>

On Thu, Aug 20, 2026 at 08:20:34PM +0800, David Hildenbrand (Arm) wrote:
> On 8/18/26 07:38, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > folio_migrate_flags() copies PG_referenced separately, while
> > folio_migrate_refs() copies the rest of the reference state. Make
> > folio_migrate_refs() copy the complete state, i.e., PG_referenced plus
> > the MGLRU refs counter, in both LRU implementations, and drop the
> > open-coded copy so the reference state is transferred in one place.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h | 16 +++++++++++++---
> >  mm/migrate.c              |  4 ++--
> >  2 files changed, 15 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 93bf3fa221f8..df62daaa2ee7 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -366,11 +366,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
> >  	return true;
> >  }
> >  
> > +/**
> > + * folio_migrate_refs - copy the reference state to a new folio
> > + * @new: the destination folio
> > + * @old: the source folio
> > + *
> 
> Man, that function has a confusing name (refs vs. ref_count). :)
> 
> "ref_state" would be clearer (just what the description says).
> 
> Or better, "folio_migrate_lru_refs", because that's literally the name of the
> function you use: folio_set_lru_refs.
> 
> Can we have a cleanup patch to name that consistently?

Sure, I think I can just rename it here as the code gets consolidated
and kdoc being added
