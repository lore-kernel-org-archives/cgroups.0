Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEB33E9589
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 11:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783942750; cv=none; b=sFdH8GGgFSGaX3klBvfW1SL+KUyVR8qF8FgyzY/6YlhDoR/wxdkYnl57X7svlTfjvXZfcUlnIYncZDt//zP5pk2SgPuQR6tGEWxcoEhZt6V2OnMvDzE3kqPG71M+BPu5eMhRH80A277ZpOklOLL+/7fV/BxiDCAz8n4u/DvL434=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783942750; c=relaxed/simple;
	bh=A4zo2+xQeX1vbXQna3iVpqkY6KIz76I1W77x/MUxy0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrxOhpFbPNSHOu+L+jwmN+Nz3vmsR1DDromGSSfIg7PvqKS2IYd8UrBjDtkwVJVPCo5HApgupLIMIEScrCfxZI+8k9Ipfcy/X73kJO0YubGoZEKQ2hNZV9igbZSwvnBeeZeEpE8/crDw/IPC2RKpmizM7eGFF1SYJXQxZec+cuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=VA8CuCvg; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="VA8CuCvg"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-476a130c138so3672797f8f.0
        for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 04:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783942747; x=1784547547; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SyGrauJ6Z/D7QxLsQH4fnjbmvOpSdbv71QSALvp4E6s=;
        b=VA8CuCvgfGGkCyqKmHeOkFtpBz32Tl6QHxXPxixf9osP8opwAIWCbsAwwYyUxgIiad
         94hjON7VcI5h7qGfptpg+PsOVw1jSgDP1bsvQFGdho7u1E6mqFjVud2rSCN39mtGyFcr
         escfbKYAw5x+LNSXeZqEgzOAYNa7MIk5DED5rfAuHptJjeWGsrTgud1fo1CtNm+DBNHS
         fQSKKYbcA8zTBR/FPxNVAFzwjzdWmLOYP4uzmduu6MiwEhY3hAkyvM4ditxI8ZDtukML
         JLGTjmj7EQ2GVRPKux3PbRm2UK29kEOVVeWqtz33oV7tmYq7WmBrNQIQmbFIDr4eXmsV
         ylBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783942747; x=1784547547;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SyGrauJ6Z/D7QxLsQH4fnjbmvOpSdbv71QSALvp4E6s=;
        b=McVR68pnP+AgyZtGoLqs3Y0yCNjHeQwv9/PmQURGlkOGW+hhzgu6qHwPFZXruBXH96
         7agjG2akauoCPnj0HqIe5k0wEe41lrXTZlx+rLd9FZmPzRt+VbhcFiMn9c+vlu4U1aaq
         V1IiLAeXOqU7leAETLicowOu/YY56sHTWVMhh4ahRBrDeliRIgadtq/VG3Og05syImpR
         w1ddBTwwB6XdN8vnTNbpFxLzsr8P2bYAbEKB46lV1dHt4hLGWpUtM/64bnmPXLMN94Hw
         s6TCZ9wJA284ISltWUA+FoWUExTodQIDAANwS93ivmi/v6V1HWhJezYzTU7q9zCSywXd
         n6ew==
X-Forwarded-Encrypted: i=1; AHgh+RqZiVIFoCIlkaUi8lkIbKBinC1Usdr/6Y006zS0vIqn01b34YEJ3EbqbrY7KwQ9IzQ7mBRUPNFY@vger.kernel.org
X-Gm-Message-State: AOJu0YyutFoC+7DK2RTlt5xdr5WlZMIzU7fxI4RFRQWkbhhrZxd2dB4G
	6oZdhPrxmUrpQN4717Y0I/zFSRfSAEdFymHD4vPK9M6qpq4XhX0V0xCuSWevW8///xU=
X-Gm-Gg: AfdE7ckun0SMm30zv45XQwt5lcc5Hi3iUacuC7fkFtLzx93KjmPxUtZ3gVxTsbrCBXk
	kCUxtMRtUGWHFxV7n4o0QuO0hzE2T8XKscAJ5QfZqTZSObzoDE0koAaI2993DreNe2mEYN+JIQT
	54ob4P36ofJB4AxiToMeRFWFv+uXIia1cV1NxfaN9CGCAKfliagq8tLbA58ljubRUs7hwIKOva9
	IoWBd5Onj8tB2CBAxhpSBgaUyLTPbxHJDMf8uxCQSFjFdY3z3/iw875TmXQb+xwfW6QlrZbYMMf
	B3BFy2Ju47c4btMqoT1h7v8K83YBRIsY/K+wGqE4JQfrRzUx7B/db+5YM4D9XTIRiSBoESDVais
	IdyVc/1o2L9PPrzKK4wV5dK7Dw0BlAtUfZpV/9uvHSkHibpnIbC5njqhyT5iEQjacp9OFmV3l+J
	NZFC0p9HkEVg==
X-Received: by 2002:a05:600c:3acf:b0:493:f176:dc69 with SMTP id 5b1f17b1804b1-493f884f5f2mr85117975e9.37.1783942746646;
        Mon, 13 Jul 2026 04:39:06 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6ccdbbsm372032495e9.3.2026.07.13.04.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:39:05 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:39:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: update state_local when flushing NMI
 stats
Message-ID: <20260713113901.GG276793@cmpxchg.org>
References: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713085053.2916813-1-guopeng.zhang@linux.dev>

On Mon, Jul 13, 2026 at 04:50:53PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() updates state[] for kmem and slab counters but leaves
> the corresponding state_local[] counters unchanged. Local kmem and
> slab statistics therefore miss updates collected through the NMI-safe
> atomic path.
> 
> Update state_local[] together with state[].
> 
> Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

This issue affects memcg1 but also the workingset shrinker.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

And we should probably CC: stable # 6.15. Shakeel?
