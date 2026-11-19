Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795078436;
	b=ZLIo8lvMgkGVnATOSm2EMBK0TFGilM3x8UVbDPHlKAmmn77GgKDgaXnLyt64Q+QhKhpk
	 gmY1oYTo86NGZQ1TqXxNU0gVCbhqP5F53ZclikbkqR0dH7Bvwcu9dN/ozKFXS+8CZyIr1
	 DFQncpn0DGGasTNGuFR3W9/Ow+EVnOKht8Xt3P+lKyCXZGsBGYaz7vjSzgYL30s6ghTJy
	 HC9Tnt2JJop2oeQjPcezzEHYgPzoqUl9B99CNlwsSqCtBAGCRQ8OUA2q8oM0xsr8NJsfR
	 qyGCxasmJThTtfruGdU4TsRTscqw1Taf6NB7HbRaYtTFQvFdLfngHsrgnOawPTWKefQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795078436;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=cWV5J4xvs6iOHJRl3GmyFLPLpFYLz1h0yKGuTf7y6A4=;
	b=epxPsRLLHf5WIzJQw557Ha6A89pCvQAvUyyshjtui2QAvka6dxlCv4FHHkLvaJoeCuya
	 hixVOJEZBRg/Y5XEm1WHbk0dycQLY/Luj0kIvgfgonB26FwTVrql/7Y7LNABoJAJfn3hl
	 yezwhXaaRv9gZ0Bn3err+Czte9PHqEHf4wZZPXtTGbg2Zc19PfbRtEAe9UZjbGM+PI3Zu
	 bZRRFxD1V/0lO5x6jFxIo0YiZikV9ot3EHS7RpnyUd0029Ca8F9/KmUm6nO0TPJrf1Y0W
	 d2V895AMXpDGraS0YyCpTIx6ZkqYVtQzxC5Q+WyxlId1OFNpc6xqbiq88oDzS32eYTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aywVmztn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E1F606A32A;
	Thu, 19 Nov 2026 08:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aywVmztn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363351F000C6;
	Thu, 19 Nov 2026 08:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795078436;
	bh=cWV5J4xvs6iOHJRl3GmyFLPLpFYLz1h0yKGuTf7y6A4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aywVmztn6lCDhWsbgc4gtgi8iWWjN5vcmsHnF5y3sQ8I42pjbvqdMXtmN30PfZ0FD
	 CEzPxLz3uJw/JlppC6KA93q8Ojx4GyyViZSlndgLmSmyykXfprp7qXbEbp7OSOHLeo
	 wBFnuvVsiImNqVhE75Dwt44E/o5SKzu7fxJkRWvNaUtAokJPEak9GDB6j2AJNIFuxM
	 zVPGwIp0GZEDvgil+8ynHv1OBfJpSeqBrnjZ8PpUilF3bsiyRGXOJ1UyfHsEC1W8ve
	 0BjT2hUlyFCZszaUMgwmvW1kj203jynHnVeaii/f+FINcfWuK7Z2p59RVlIw37VpOg
	 K5qqDo8ymBFWA==
Date: Wed, 18 Nov 2026 22:53:55 -1000
Message-ID: <74ad05b502dc12632e7a831be7641388@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yu Miao <yumiao@kylinos.cn>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, jiayuan.chen@shopee.com, nphamcs@gmail.com
Subject: Re: [PATCH v2] Docs/admin-guide/cgroup-v2: fix npn tags in memory.stat
In-Reply-To: <20261118130537.750211-1-yumiao@kylinos.cn>
References: <20261117062620.346767-1-yumiao@kylinos.cn> <20261118130537.750211-1-yumiao@kylinos.cn>
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
Content-Transfer-Encoding: 7bit

On Wed, Nov 18, 2026 at 09:05:37PM +0800, Yu Miao wrote:
> The zswap, zswapped, zswap_incomp, swpin_zero, swpout_zero, zswpin,
> zswpout and zswpwb entries never show up in memory.numa_stat, so add
> the 'npn' tag to them.  The pgscan_kswapd, pgscan_direct,
> pgscan_khugepaged, pgscan_proactive, pgsteal_kswapd, pgsteal_direct,
> pgsteal_khugepaged, pgsteal_proactive and pgrefill entries do show up
> in memory.numa_stat since commit e4f4fc7aa8b7 ("mm: move pgscan,
> pgsteal, pgrefill to node stats"), so remove their 'npn' tag.
> Also move zswap_incomp, currently listed between the zswpwb and
> thp_fault_alloc counters, next to the zswap and zswapped entries
> it belongs with.
>
> Signed-off-by: Yu Miao <yumiao@kylinos.cn>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
