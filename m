Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ED63CAA3A
	for <cgroups@vger.kernel.org>; Wed,  3 Jun 2026 18:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780511176; cv=none; b=lNvykN8PKXBr3xeCpjTaMystEi3Aszgq+bgXmo/uCBvXwWDoBwoqPmRQ7Zriqy/sbiprLR8V/f687Fw3v7DOmXhLHhsjGx5pkuXMdIH60UKGxJhEbd6gQAul/hbgncRPisShgUmi3BApruK/eCJl/Vm6FD1pr6afQOCcIpV+qCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780511176; c=relaxed/simple;
	bh=aj9xa8st7Hvx+2LGq6rt+CADlrLWll6a6d3QhFDJBzY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b4KyeNWoJPowTepU1Of3QNKpnOqVm/GTT/tUZMBhwYh6K4JPrX7IT8KnvOCTvmSvGFVcTNgKrEEamWii9WNw12tNqGupXUn/GeG2nAXPhPAxFE5QWMQ0ublmJ5QhDu7KgFekJl/0/jfWEUEGuHMqpftr+wbtLjUZ8o4yVpMfJxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lweSA3OH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lweSA3OH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9754F1F008A2
	for <cgroups@vger.kernel.org>; Wed,  3 Jun 2026 18:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780511175;
	bh=aj9xa8st7Hvx+2LGq6rt+CADlrLWll6a6d3QhFDJBzY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lweSA3OHcLDrQaav9lc6Wir64ubnglJerfByUmJE1p/Qu69+5AJT/2hrWKyHRtiIF
	 lMqxEfWzMxVu66n+z1AAurmnA7ZYRPIA0T+B2+5gupdwOosKscsY8OB1sqAIxDvGiS
	 PaaL4y9VAuVcz61GkMVMkSwDQOtJl2b/ksEKhe4NW1CxHbR6diEaiZ/OAeS60z2qqh
	 cRNOVUobhK+jt+uE+7MYWgzJFAaYRYE1uHJoe96cSXXUnLTTVvgcB96q5MiEr3ks+O
	 vj737IcIsmdD4cvOTQrupb2OMIcxPuW05kY+NRpARBBKdK15pTjVLdwTtr9n6WRrtk
	 dvcOoffxM0CPw==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-beb2a97cc9aso906263166b.2
        for <cgroups@vger.kernel.org>; Wed, 03 Jun 2026 11:26:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/X5aV/DR6aFxmfwJ/JeiTp/EOokBuk0X0IAg2dWnOJafOx4SKFIft5jKD7C1L8gVzx4urh1+vg@vger.kernel.org
X-Gm-Message-State: AOJu0YydVO2q+An9UuQuREWFs2K7EsX01JRWl6edNU4XoVV4X37DmKIf
	riSEjFLzfPW6rIljtiKzV8crVdqiHifKGHcKfBlwx6B3/PzcxzPgNqLTEJ7AuQHGTzmRAoVQyB+
	PcsvlDInmYqBzA+RiKkdYz/cwA9uPUcA=
X-Received: by 2002:a17:906:5a5c:b0:bee:215e:5486 with SMTP id
 a640c23a62f3a-bf0b3aaceacmr174660666b.36.1780511174539; Wed, 03 Jun 2026
 11:26:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <aho-Z6wshceTAYd9@google.com>
 <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com> <CAKEwX=PoBZ4ci30tKHQXs1o9=NDpPrtbe7RxxZTbnzVJf74ZYQ@mail.gmail.com>
In-Reply-To: <CAKEwX=PoBZ4ci30tKHQXs1o9=NDpPrtbe7RxxZTbnzVJf74ZYQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 3 Jun 2026 11:26:03 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com>
X-Gm-Features: AVHnY4J4j3oM4dD13IqQZCy-bYs_O4SfhMK6I0X3Uvdscn_9ZGq_oohrA-pnMhM
Message-ID: <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"

> > > Is the main difference that we are scanning in batches here? I think we
> > > can have shrink_memcg() do that too. If anything, it might make the
> > > shrinker more efficient. Over-reclaim is ofc a concern, and especially
> > > in the zswap_store() path as the overhead can be noticeable. Maybe we
> > > can parameterize the batch size based on the code path.
> > >
> > > Nhat, what do you think?
> >
> > Nhat, since we now have the referenced-based second chance algorithm,
> > should we consider doing batch writeback for shrink_memcg() as well?
>
> I just take a look at shrink_memcg() and realized it's reclaiming one
> page at a time. Thanks for the reminder - I hated it.
>
> Please batchify it if it makes your life easier :) We don't reclaim
> "just one page/object" anywhere else in the reclaim path, Sure, it
> adds a bit of latency to zswap_store() if we reached cgroup limit, but
> IMHO if we hit zswap.max limit at zswap_store() time, that is already
> the slowest of slow path that you should have avoided with proactive
> reclaim/zswap shrinker in the first place. And, setting zswap.max does
> not make sense to me in the first place (I can write a whole essay
> about it).

Should we batchify shrink_memcg() from the shrinker and background
writeback, but leave the synchronous zswap_store() path to reclaim one
page for this series at least to avoid potential regressions?

I think this change specifically needs more intensive testing (vs the
other code paths).
