Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6C03603E0
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 01:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785806502; cv=none; b=uOUmKJtaiZu0WuUIJtzrS8pqJcU5FLAdnYZLRt4SvZLKc/77QrNJsBzPz0irW4zvrZA3AikyrOXdx1Wjqwq/fdhkeFHYoLJvVpVDCpQrRdOZ0TrnRB/F0G2RE59Ow5rgfxWmTUkFvE7kzlCWIXlzLUlEL6Z6ImL4HEddASoT72Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785806502; c=relaxed/simple;
	bh=MR3AHJCTMuN/Cx4YUzod4EVODKq4RZJrK+vAu8CMS30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cgd/vesjqQJghpPAYrByAMH5VgWQ4pJ009odNidJsWNRu3Y40hZfjTNSQV/QqowgvYFVQv8yeaeoiTnzdBazdszLQ/vtvI8Jbh4+BZu/mmgyBExAI2fciq7hrwhx+Lhj6clACaWtQqc7vEqginWclrBYA63r6zqruA271Ow7jvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=tCf19/Ls; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="tCf19/Ls"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51bfad59921so26085841cf.0
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 18:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785806498; x=1786411298; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AguyGUwr4ziCw0A1INIvfSK+5JRD4S5eHUYfwjfXhZE=;
        b=tCf19/LsxdcDZGxq2f/q9FocFOTBaGDUGdUN9Q677ab/kT00QL+ImYAOtGlArotfhf
         ccYN+ynCmSjICFz3lPPWpkVbegT/yTe/3bOcRda20yQFyulGmLBEVWixBGzKsRNjWYKC
         OFQ+lG8XY1x5QHRRe32JqD50JJc8t+llCDymYc8wSdwutTksWurwbNJ9tSwnh2LvC+Z5
         fGH+SnsgZABFVACCdGERDdQboPrLo65s1vhwQnGAh0rk6f2hzJcT/HUXhzt5dD5lMbG0
         WK+MZu1Z8yrSRI5fGG9Mq2864JnMzajeWBPUX51kQSsd6J/156KbpdDwbJMO7xGA/45z
         VY+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785806498; x=1786411298;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AguyGUwr4ziCw0A1INIvfSK+5JRD4S5eHUYfwjfXhZE=;
        b=mGkFQlLHCcvrjCLhVDIETt3+R8dZX2LIVV4/3VhtvZ+jv+eg2u0+fjHB4q8Zvqu0Mp
         b9IyspICPJoxESrdqYu9X1kJdN/fFZX+G8ojwpPyDS6FDuXEkkp4SLk3z0vgd3vri/RP
         /9swBjiIl2KiaJf2tQbHCj52NlPhp3zqm8AwjnVGphsN+CNsQ6Q037UbWNqzLDRSodI3
         0vaVDlk0xLweI+BVHnNAccOaa1cPfUGw/DcqPflQbJlDzfsg5wB7akUuDSQKoFDU9Je3
         q1gGE934FxRlOkfxCYegCDP5hiv2P8pfeayen9Ce5vYsNBFwnYduaCrObvB1H8nPVD1r
         oFGA==
X-Forwarded-Encrypted: i=1; AHgh+RqzGNnB62GYeLi1rAgBI8k5GLceFKKXJ570Y6Onw3usBOCRcnL+efeNwGWkl1nZ4wceMvctCqWL@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9gVtazEWseKjdVR/MdJ+0PPXWTrMYfyneBE/Tr+oHXpt1QkcE
	Tq/QcMrayxhYmC9UuiOEqHNjBhVAdbgzmv4NIqDPnxC3SZthFxiE0swCXs2rvBoydGk=
X-Gm-Gg: AR+sD1246CkEbFHSzZ3BNPB6LGSKtRMN1K964X67CdAqz3/nak4nckVms4hawzjITre
	m0wnFvZJQF/Q5AzZxmptad2ZJUC5t7g4EmNqM4mst9p2Qs8ixShKtY6lBzsuvC7pJMQC4PYIFhF
	kS5BW4umGrlXye583FiCyxUeBNe6HJXrDpd/X/k51B3TJhFCPsogmpeGBdTEPQAR7sUMLIQn5Zi
	Sk1u5/5e4DEDAZu6LU5Bkb7PhAGTSXl/3DYtVHG/Zabl+iBd7EsmPjTgFOGaUvprwEoSAB/jyTx
	4JWieYJmoYXUU94kstss1fBAba9DQ5P3S5wJ7IZ2KFkeNDsjfn5NoKITSctpzt37RxZv5lYSFNC
	WiBcJ07BqY+vNsAWzqwRD/imtGrlzzSlvZN2LaIzXtxbTuG7h61Zh5R1Nmv6nW96X32ZYMZrElE
	EUeE68Q+tojAxepXCKlcwhmCeZ0A8Treo9A3Ajjck6t2bBfXobm+onDLNeN3Y=
X-Received: by 2002:a05:622a:480b:b0:516:dbf6:f8e7 with SMTP id d75a77b69052e-52b56738372mr234910771cf.17.1785806498544;
        Mon, 03 Aug 2026 18:21:38 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52b4eb96ad0sm72483551cf.23.2026.08.03.18.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 18:21:37 -0700 (PDT)
Date: Mon, 3 Aug 2026 21:21:33 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 12/15] mm/smap: report workingset folios as referenced
Message-ID: <anE-nSqyXcG1g5zQ@cmpxchg.org>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-12-4d8dad39dad6@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-12-4d8dad39dad6@tencent.com>

On Tue, Aug 04, 2026 at 03:47:08AM +0800, Kairui Song via B4 Relay wrote:
> @@ -944,6 +944,22 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
>  	}
>  }
>  
> +static bool smap_check_folio_referenced(struct folio *folio)
> +{
> +	if (lru_gen_enabled())
> +		return folio_is_referenced(folio);
> +	else
> +		return folio_is_referenced_by_bit(folio);
> +}
> +
> +static void smap_clear_folio_referenced(struct folio *folio)
> +{
> +	if (lru_gen_enabled())
> +		folio_set_lru_refs(folio, 0);
> +	else
> +		folio_clear_referenced_by_bit(folio);
> +}

I don't really understand this and the preceding 2 patches.

What is the benefit of a "shared" ref/workingset state implementation
when you then still have separate APIs for querying & modifying?

Switching some these callers from folio_test_workingset() to
folio_is_workingset()? But both functions continue to exist?

Why not make versions of folio_test_workingset(),
folio_test_referenced(), folio_clear_referenced() etc. that do the
arbitration (bit ops on classic, refs ops on mglru) and leave callers
that are only interested in boolean states, like here, alone?

folio_test_anon(), folio_test_lazyfree(), folio_test_swapcache() -
there are many examples where they don't just test a raw bit but
assess more complex, composed state.
