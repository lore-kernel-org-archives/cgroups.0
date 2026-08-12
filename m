Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66860442FD4
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 16:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786552970; cv=none; b=aeF6w0eWVk6EKLrAhZGGLN9//tjiLrNwmtU1MUW1H8kbgu8KJy20DO0Sul/Ro/8RlSnkZVQjSzBRh5h0wd4SLbTFfATD/ItngSBm9uPgrQdkDsV6rzirVIRvrE7W44MKsMkwqAvKlfAWf/cVAo0xdf7kLDDOduRbGRc3KkYqb80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786552970; c=relaxed/simple;
	bh=jTBEJcKkHaGMEfbgRuVHcAiD7osuTPlGQ86vK3hD5B0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZFLTv/m8KndHn5CpilsJI/qzGs0wMmbPVR+CHerfO/erDEElL4tebXlLzJWmjcFO8K7I+kdJ3hz+x6SnfUczkzYJ63Mor+iu9JPS7BqcXBgDipJyQxgcZMISadLMH6RElcr5peMrtVv4KPJKj0K4Qq2IKWYAbGNwu8SWCHgubSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=NBuE6w0k; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="NBuE6w0k"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e533aacf2so68635385a.2
        for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 09:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786552966; x=1787157766; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x/EWoL2S0wFVxxUH9CDFZoGkIehfFWNIp7hAQk9bjwQ=;
        b=NBuE6w0kghiBry4Y6NFnJctmBBYwOl3VhaM0a/v0ssd4cEI8nMiaTRYZDXzuxyU5hD
         Cpcwp+2K9mSYAveQDQWaNfP18oG7h/T0tPvmbEYh+PSE7XLN3lfijX6umftdhAajQiv4
         FeOmh8D2dJkUkSey8bP93L/AHGliV3GQtx1Zp0v+jpzviHThhxq3cmJV4kQj8MpKfjEq
         BCDmUsaa0S6sO+LzrKi/ZV7hhugxZvV33xq0Htpw+yEAd1f8zX5KbWBJRWNXc89nrtlx
         l8tuuEKnUhApKyzSBkqPJUB2uR435MCq8shMoN0FH+ayPTKRXEbjiNi0ybtY1okJqfhM
         3VBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786552966; x=1787157766;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x/EWoL2S0wFVxxUH9CDFZoGkIehfFWNIp7hAQk9bjwQ=;
        b=mbJ6R/IrshbPcT7+KyayAxIWK/8AP+4r0uc8T0oRew5l/U//lfJ1H+tSqOQUvOrAPA
         gccAenE61vyJi1Mb5EWU0o4JvPOtF/PjuFTn67DxdPxdq2O0MHzcgssZkb58qfhNAvhi
         7h+JO7JJuUkSPNKglapV+oqV28HnDnfVrHyrfc+NclY6N03rIr1ylaSSFAliNkdgP8/0
         w0ryI9c59HRUr8kMZD3Sw4NwzkVt7c7RDCWLu2McTFH/GzO1f7axuBxb/TeLn0H2Slpl
         3hX0wbH826pMvTEnY7e60rLM7vIH8VMv0lWMbMoJvQWIPRGbxesc3e4kvcPgoAuQzd5H
         WwVA==
X-Forwarded-Encrypted: i=1; AHgh+Rp0wJPWDmy9mUKgomSayEwpTm/kKflk1jKzYjeLFJe4QJ8n7id1LrAE1jFdJh90sBtsg7odytHT@vger.kernel.org
X-Gm-Message-State: AOJu0YzVul5+ohdVxZyHd/BGpjm/MFvgmmu1YpcPkoaXLVaCxsMCRPh8
	KUOz6dCKN2XIbjFQhBQ3duDm9pzv41Mz86zLa2bUY//YnpQnb/4aoW+SGHxdNFR5Bdg=
X-Gm-Gg: AR+sD11TBqrBpjxHt80wuq6bZYAOdQeadggdvAFTPEJe+TsvtPxZ7H+bQYBvQC/H7Kj
	nxROxbL00IZqted0V5omun/iaWm+BENdWQxZHuKFVtRO2+/2N2DH7AIv6pJjmVr0GyPN2Ock/KQ
	/Hf0ZEmhBoiZFl9Gn2F2JIVzoKkn/6fJbKFiH1NBhW0EGxuAnmDlPPz6dU/RTHXCso0rZLr8BE9
	KGpZ0xVCMpF0Lcrff1AD0MoAS4rn4zcbUzmEpH7ADnL+zXIS1GTD8+BBCcHvqYuCNtO+SpIxsIc
	R5J8ehZb2T1gorbou/I9zyk554IsT127NbhFBNl6qYfHSXLJ+cLts5fk6gGKGKRQmvA64ITelt0
	Aig8XU8oPffPKSYcOZlDh0Q3gebApDUNSIWi9AuYDzMTnqmnYUgaS/IvFZL2JMvnQ73KnO3I1RD
	xLDxi1qtkDOsL2qodhwpBS7le7+ln83VZX3/evmRafzOcmsyp9SKYLjzJv7Wc=
X-Received: by 2002:a05:620a:1b8c:b0:915:f96b:8f5a with SMTP id af79cd13be357-936b3d9dee5mr568196385a.36.1786552965979;
        Wed, 12 Aug 2026 09:42:45 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936b5dd3f5fsm167905385a.8.2026.08.12.09.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 09:42:45 -0700 (PDT)
Date: Wed, 12 Aug 2026 12:42:37 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cui.tao@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 1/2] memcg: acquire peaks_lock when reading memory.peak
Message-ID: <anyifeWkUecN6Z0a@cmpxchg.org>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
 <20260807090000.1532495-2-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807090000.1532495-2-ridong.chen@linux.dev>

On Fri, Aug 07, 2026 at 04:59:59PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Sashiko reported that a reader can transiently observe a lower peak
> within a race window [1]. peak_show() returns
> max(local_watermark, ofp->value), but peak_write() updates those two
> under peaks_lock while the reader takes no lock. The interleaving is:
> 
>   writer (reset on fd A)                 reader (fd B)
>   ----------------------                 -------------
>   usage = page_counter_read(pc)
>   WRITE_ONCE(local_watermark, usage)
>   // watermark lowered to usage
>                                          lw  = READ_ONCE(local_watermark)
>                                          // sees the lowered usage
>                                          val = READ_ONCE(ofp->value)
>                                          // B's value not updated yet
>                                          return max(lw, val)
>                                          // both low -> low peak
>   WRITE_ONCE(peer_ctx->value, usage)
>   // B updated, but too late
> 
> Fix it by acquiring peaks_lock when reading the peak, so the reader sees
> a consistent snapshot of local_watermark and the per-fd values. The same
> race applies to memory.swap.peak, which shares peaks_lock and the
> peak_write() path, so take the lock there as well.
> 
> [1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
