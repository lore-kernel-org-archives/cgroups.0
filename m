Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A73241A517
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 12:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787575502; cv=none; b=fVZ+ljuMxejnrHjFVS+3a3mmwwKQyP0CHTGajfixWLFKnXEBywy6bzMRSA8V/LWs4Qqm0e1J3t4I8GbZBFcglCHUT9GGxwLVeE08P7FXGKo7KEZo6rIVESv15zUmX/QP1JMn3q55kZGKZ4p7aADhpyqa6oRVyYNDSArLNGzr7VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787575502; c=relaxed/simple;
	bh=DW3UtFqD/zu7mAy58si3FQbh8UaK2UOfbrSUpkOwrLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sgT5ujTAyI9fZ+j0B+ZrooXugEEl4vOPJJfDr5N5z3y8pvdrCk3JJyVn4RDPO1/0yyhfhBAoR7I8tYNNhp9fgIJcsOQNRUR0CskZm3KM+MABLA57kWnOLTNFSgcWtliNblVUZsUnI2/u3pcIPwNZTm9SEfiPUwRi1gs/Cf2uNuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E0ryj8B2; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E0ryj8B2"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-848761b5897so1291529b3a.3
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 05:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787575501; x=1788180301; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E2yHo0M2FJBuTCpqN8VZyJQ8Wot3WXvI786J1PIQoT0=;
        b=E0ryj8B2muDgi6S5xmFrd3XU9eXVxvuX6mEsoaaGAXFez5obMYEuGIVvsVpwQio6q/
         JMG4CBfGu2cUq3uKS6KKZ4s+5sf5Tpbz4Q7y7LAJ2G+OV721Q8JAcPcOHUWobRX+2C9d
         Yx9hlVkpLuzrpZRl8vh9I2bsNqETxztDhnrOuNGfQopjwwUwI/VaJl42OnjfUcsQ1loQ
         76FNF1SulznMRN/UVYZJg6BSk57//X05LdyZBRyEAyZ9WUAlKxTHlfRPRnyAw3FuZy3b
         zNabhPe7bhL1HHttbczIUNpBo2VSxXa9Bzvr7HH2B0uYQcL2hJxRaQGJo1NN6eYabNFt
         77Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787575501; x=1788180301;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E2yHo0M2FJBuTCpqN8VZyJQ8Wot3WXvI786J1PIQoT0=;
        b=nJAZdA7YNmBDEX7mHFXHZy+uyDK10o+NdoGk8FKmVXfGBhzjg5opqqRhKjVNlJl/MQ
         3ydAERbM1G90qx4e21Yu7PLWm3gS59yRMQWZyVN73G/uarPr3DmS7vAs8DCCHGSZA8/T
         ABxx2fsjckyH6xoiS3+Uh6w1LQg7Q71lTD/oPsDK4AzJOALnODVaZO7JG/hz9C/ejPEU
         EFafs3yd44ruwZpeIeYVYM++8gc2pAOfTE9Wyf5Za07CX5YsiqQZO4bYlrmYFM8ubgc+
         cx2MUSQhdMNmIIU0c85p/T8BpnS7P3uCpKCKN2MroHS7ulMmshprA2ePQ1A5nQWCvFLh
         /45g==
X-Forwarded-Encrypted: i=1; AHgh+RowKFXjXn8sgzCRVLYt2QBZiCkBtehFw5FlQ4WH85g7Lx3++BVP4H1wwY2bXVWQ7ycSgdSURuB7@vger.kernel.org
X-Gm-Message-State: AFuF++k2srnVUOJkjXQMWnLzsIel/fVkHFpT2Xld3xsigNhIbp/eu/4r
	rw97Y/SkR2DqqAmC/Lph2Sykz3YwAsM+FxsoskGPCYljqJ1sT3m4e4h+
X-Gm-Gg: AR+sD13h/fdW5svjTswRUDtvljceB2tTfF/DVaUBEA9BJYq8+7t993mN/NshnYD2zBc
	yCwDpLNS4yjTkXahdbQ6jZzZUO/d4lRb1n9ld6tckvqGk0ioOP3PAXs9FMkk2tlz2lddWkma5VO
	SrjiP5Rb8H5vjD8i7JaHr3eJZr40db1/hur9zH+yVxr6Us1+6yjRCMMmuVXGweYh6qbhQ15RqZU
	CCcZzC/WN/QAw6cyekSa0L1gWy8daiPTc4HpPSlIdd+KjJpL/cNdYpO7bGZdLzTA7By4Dgfq2pc
	bOqBL/3KNy/ybYjaz4RxiUasL9Xg9oBweRCCRLoICtFvqcinsE4p7VuC/5luo83nl53zSvCUJKt
	10pwe5E30kEwqqNMRq7vPWoOKBbPdy8eu65mTfk3cd9LYrlLZaTD3fIp5afQs7pD6aARcYHsz9d
	j1TEGOC5CYQ3i+0/ySmyRlWOY0yVBmEK5b9g1JQoRjBElkZWvSMB4pIL/GBn0ik3Xu1qts+GOO7
	PN1ZVyWq7JwHrF2dU6CWGK6
X-Received: by 2002:a05:6a00:2998:b0:848:2ab3:ddeb with SMTP id d2e1a72fcca58-851f9fc70e9mr45280869b3a.14.1787575500815;
        Mon, 24 Aug 2026 05:45:00 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8520f03b014sm1911847b3a.36.2026.08.24.05.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 05:45:00 -0700 (PDT)
Date: Mon, 24 Aug 2026 20:44:51 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] mm/mglru: move max_seq read into walk_update_folio
Message-ID: <aow8Z-fdVhy6mQ0x@KASONG-MC4>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-4-8dbbdac0d28c@tencent.com>
 <52215f41-9297-4197-982c-bec01b485bb7@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52215f41-9297-4197-982c-bec01b485bb7@linux.alibaba.com>

On Wed, Aug 19, 2026 at 05:18:51PM +0800, Baolin Wang wrote:
> 
> 
> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
> > each read lrugen->max_seq to compute the target generation used by
> > walk_update_folio(), then pass it as a parameter. Move the read into
> > walk_update_folio() itself so the callers no longer need to compute
> > or pass the value.
> > 
> > The max_seq read now happens once per folio update rather than once
> > per walk range, so folios always get promoted to the current youngest
> > generation.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > ---
> 
> LGTM. One nit below.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> >   mm/vmscan.c | 29 ++++++++++++-----------------
> >   1 file changed, 12 insertions(+), 17 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 080132997d87..a819be6b7ae9 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3517,13 +3517,15 @@ static bool suitable_to_scan(int total, int young)
> >   }
> >   static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
> > -		struct folio *folio, int new_gen, bool dirty)
> > +			      struct lruvec *lruvec, struct folio *folio, bool dirty)
> 
> IIRC, MM maintainers prefer 2 tabs, which is why I changed this earlier:)

Thanks for the info! I'll keep this line untouched then, my editors auto
indent always align any code I touched to the open bracket that's why this
line is changed :)
