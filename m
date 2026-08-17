Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA353C3792
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 08:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786955476; cv=none; b=oqy06WwVGza1Cmcy5tw1C6uyCYGcCCKup1pe/dD7J2e1vf84BAcHc262TT6Bit/nX4/b/rkBoE5YI4wTMuZbpyUNjOSOPsPpO8dQTyH2FG4AUs+7gPgoYMb2cFU8WfZPISe+wwDo4eVoEoNkAXBoGf2Hf5IvrvQn53XXQPyb7/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786955476; c=relaxed/simple;
	bh=Bt4/ejq02Ba4wIvtouSRDrqIFpiGmw1ZYb1G6e+d5a8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCrEFKTw9vCkl49rWfvO+QSh7as+ZYuSsGR9f8eQ0WufmwJqThpjdGw+74eppTMq5iH/IpgjuRnuqGVEH4ASO9YWzZy7kPBnGz5pivTVhyRVR1ecZLkfmyi+K4PO/1oJ4WBQYC4PAV+e9tQZo8h16ANVCRCO/HvsKxkgjpxg1as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aJ2dBSFW; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aJ2dBSFW"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47fecbb7000so1587748f8f.2
        for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 01:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786955471; x=1787560271; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ah5ew8DbE5Myy/gE+eNiI8cy5Ie1ItfK1DXj0IGZCH8=;
        b=aJ2dBSFWCmD3hkOD+SjumQsuddf1LCg3b4GfwkYxvQx9H9ENpK+D2ilg8s91/cjnBw
         bkMcY8Qt0CDr/tgRxJ6gCKQ2c4qGakST+fqLgCJ9+Y3UxLyyK+z8TKYi+XpKgLHzR+J6
         w+XxvbKi8ZwUUbeUgXOFKixm61ptLAmlovhmShhbpXpLBq/0ZvA+OIex/rwrZFwYMIPk
         OdP4TFb/xpvo/JSTU9gyfPO5/+xgKjcMbNIS2+XxGu78NsKQu1VC4b2c9UXYAZJAnmKe
         eTMp26Hm6hrXpwTXwlNbjeSYiLOh0N5ZCGkn1g4lx7Zb1OX13BVkv06cOZGUkGYQKDXp
         uhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786955471; x=1787560271;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ah5ew8DbE5Myy/gE+eNiI8cy5Ie1ItfK1DXj0IGZCH8=;
        b=FGzPgtSRhhauCCb8Es+hlJuu7Pe3sT3NKTtHXuj/sJMdMtydvDoNQ3fj3RHZxLhcCV
         fzy03ulGJUsY3kXaC30XvZfM5+3YTvupJ+TMFKqFx8LFWn0M8K++eIUJQQJg9eW/+zhE
         tu6sG7YTss0Q6r5CKZwFDT0Ia1IS7aEdgYoiZfwDSyAyFnD6KMZpbwNOsYb9mmbOABE8
         Civetdsgc/+uE+uy3GyVx/n7ZGiP3KxFtLLgJ5HK8CdbgBvvUmErn88UKaOp0Xi92Nu2
         eRv2tW37p+rA1tknVzKKDfxT/F6udFZ+CdpHGawiC5etKnsmP9k1pCX0C/AXk2SE7K1N
         8wqQ==
X-Forwarded-Encrypted: i=1; AHgh+RrZAX/tiIbZBqB3RP7zw+5UcZrTXdgzoo/lJz5o7HfhIE7a1aAaf6Fnjchb92clFoVotzaQ3MTP@vger.kernel.org
X-Gm-Message-State: AOJu0Yx014EESQdnBws2h+1YZaPv0f+SHPDjUE5gBFW/8nvNCatjmxte
	TfjmowLozDMODOqi+gt45n2kMzAGrA2P4SnFvLtx5lGUVyL/4ooFMjIVLpv0svtaR9A=
X-Gm-Gg: AR+sD124pFcvpmO5X9ZKQjr2HWhGBknpUC5w18IPpTc1D4W9wkhYedFU6aHXHAcKEWM
	g5eN3o5iscp2HfvpS/mMmnozzEO3UXZUDKy9qIRAke/JpVksDM8H6KxtevHXK76H1GU/OMTLOqe
	m363g1jNMP9Bo/Cy3OTMhp/sCjMmCMQWz1jDTAOyTwhGYJZtDuEIdk+3ebcR6rBQds+SsnQGqP+
	GppLQl1aLm1Ogw4848mBer9m4xsa15kKZYQsE/kwDPguIM3X/ztJ0fs+UWS89t0xmuEfv+1MJUK
	e8xYw0HfihUbE9v5YKMNuICuK/DBjQ+UcREaryldhw5/QVVVC1ziZBh9/IH8zETcGKli6qFarVJ
	Ee7nyuF5FVqBuiJhGVM/4L4oo+YMho3AJsocke7wzI/XEvX/y1n6aHu51xI3Urr43f+jwV7yhKU
	RBf2pyA19feNTve+NfUDnutAo1Ifwu4vMmNRllkI/eg18ZfCqHBnUNmT/7F1PG2sAIb9iEPWY=
X-Received: by 2002:a05:6000:460c:b0:47f:e886:6dff with SMTP id ffacd0b85a97d-481606f67e3mr39202641f8f.4.1786955470859;
        Mon, 17 Aug 2026 01:31:10 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5b816c0sm1827065f8f.33.2026.08.17.01.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 01:31:10 -0700 (PDT)
Date: Mon, 17 Aug 2026 10:31:09 +0200
From: Michal Hocko <mhocko@suse.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhuhui@kylinos.cn, joshua.hahnjy@gmail.com,
	audra@redhat.com, bingfangguo@tencent.com
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
Message-ID: <aoLGzZHS8kj53-ey@tiehlicka>
References: <20260817025917.66233-1-husong@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817025917.66233-1-husong@kylinos.cn>

On Mon 17-08-26 10:59:17, Song Hu wrote:
> refill_stock() takes a css reference for each cached memcg slot and
> mem_cgroup_css_offline() relies on drain_all_stock() to release those
> references before the cgroup can finish dying.
> 
> consume_stock() can drive a slot's nr_pages to zero while its cached[]
> pointer stays set.

Is there any specific reason why the memcg stays in the cache slot
without any pages?

-- 
Michal Hocko
SUSE Labs
