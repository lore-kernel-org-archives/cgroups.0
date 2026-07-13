Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49F03EB10A
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 11:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783942830; cv=none; b=VhzTUh03VBt1DJZ80wgtVCZxiSmOuneY2cbshUjJPvpJmuSM+0tajFJ3Vcgt8Ltd9Kf6cGFoSKFTK90hM76G/sTMJljVKxauaApZrhwvdPSxx5X2jpKtRADwz5Z9bhDELS8/nnwBGcy6esAqkApBIQiHXACEiPCuDLZOrRb5naI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783942830; c=relaxed/simple;
	bh=Suv3ZZuNyYe1KNQvWBrDdR7EnsZedGRv7qO0rHD4oec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dNRC8szBhO5nTLXV8mdjPEbGvv+oquBnncVt+Iv3NCrLH2B8cfNkPj9USjnDYyceBScGSeiB+rLE/8DzbPaLt7YXULAbfQs8vHLlNvvSRPkH6Wp2hHX+bYFVDyB4vIsWbsqCSRYx0zPsYLIlQWC4jfu3VAeAZ1IU1S/2paka+Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=RVLVQcJR; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="RVLVQcJR"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47640541585so1415767f8f.1
        for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 04:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783942817; x=1784547617; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BLOEompixDXd9MerUC7lz4YUSr7Q/4Il60gdac1Zioc=;
        b=RVLVQcJRHf2kAhjs2U01STZi6RE4Coe7Im3hUaSSOC/9LK28GpeoWsA33xH7QRdS+o
         SUkhjoEA7frvNuekrXTWDc/ZsMQcUFoNQ0qjkhfGxOcSMslemlaKQ/7XqaLSKvJwHjjF
         xSiR85s/upbOz6Ywj1mvNql+fMz4P/IrnG1FCd5KOHP9vtOy26c5Lil+eIj40UMzszeU
         01hXKGOyLxe1x16NlXBtEJ4/pZjm9GtkJqOWn5LkOOnd4SwToKOeePDZbmPR19g6nV3S
         HjL4sG3bFAN88nkDOhy4cZfmuddOKQOFwj5HJCljP9fQjTdDl3QLz4LaEf/cBJE7FrO9
         Tkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783942817; x=1784547617;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BLOEompixDXd9MerUC7lz4YUSr7Q/4Il60gdac1Zioc=;
        b=G828wXYgId+GnIDvULPfE8CpnoOL9dOvmgXrbwnxt2W4x7pkX78FCInbsxOdXWvkyk
         ZTvA85+ow8WIm6rU2623FF3zqsiEAxSzMvUVEEwgthmQVOtJiSfqZO6IGcN3EMBvZefl
         axaecG9pmACANUQ+sEoMZrbiFma8vJtZje6uINOcLnZEb2ZeSX5MPw+y87jf54v9svl0
         pY7EvG2BrZ7MYF9aRGd5tRhsVk1LmXMn7+4zVrB9UurampvLf0xYhtJVssaTbjCOSpIS
         d0475qM/Et2iu531uozJojdSQr/TCJr2mN231TjLUfwvITLgVrkEShXVqPKpjRBznu+/
         Vy0g==
X-Forwarded-Encrypted: i=1; AHgh+RopFRwncqCi5eFo7INw7gK66/wF/bJ2U8B529pll2zpkDXGLE6m/qV5gnVqAcACfCavZllnWU8s@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2ooTIYRmqnuNGOrmph39xPLAyeOzgUT3c/YvVWN89xqIkYmXj
	RbkmO+fs2i1mf9aUbJ09GrcSk+F1cOzKGKhdWQCtMJLweEpUyCqBt6a1698Y8LaurHQ=
X-Gm-Gg: AfdE7cngP9n6JAp9OKjM1/ncIyefVeqBxhoCeLUQbS15fquHkBCFiQirdexT79Y5hXZ
	tt3ACD62lKHw0mJ7cY3tZwUq78XdyS9zmId/l7NaFUWa3JL6ki/nB+BIkILJ4PV0SnrnjN97K+l
	YlzOGKquZ5IDtpo7bFXgzHg7e0fQwKo63vFyMA6XNohiMzW5bPoSgJ6gcEfMR4FLvt+OhagxYhF
	yhssvOmEPalZEuWtBwzCE7zy2/YQYkr00pEzDcfuZRzweGKYBozIYy89UTVQ41fqv5936J7Hqs1
	3wbT0FUgvb02vcofwteworIUH/4svZfniAYNgCZkONRC2/taCngxBfnsH5ejfB192s29nO7POXC
	htawZxrSbR6R9S+nIxYm06vzKMJ1CgD7vAKQ81DK6dxw8LX2eyYLNraadrW6GKSdS4Z4Z4yaEFs
	2EBXDZhaFukQ==
X-Received: by 2002:a05:6000:4b09:b0:475:f0f0:9ef9 with SMTP id ffacd0b85a97d-47f2dd0249dmr9451318f8f.48.1783942817057;
        Mon, 13 Jul 2026 04:40:17 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47df6a31dd5sm41971514f8f.16.2026.07.13.04.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:40:16 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:40:15 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: fix wrong linux-mm list address in
 deprecation warnings
Message-ID: <20260713114015.GI276793@cmpxchg.org>
References: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713085756.2973549-1-guopeng.zhang@linux.dev>

On Mon, Jul 13, 2026 at 04:57:56PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The deprecation warnings for memory.oom_control and
> memory.pressure_level use linux-mm-@kvack.org instead of the linux-mm
> mailing list address. Remove the extra hyphen.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
