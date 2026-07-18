Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B063D175A5;
	Sat, 18 Jul 2026 17:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784395479; cv=none; b=KGbxt8fJfRWTkpF0uNL1lRwaa0tnhmospIIinFlepg4zkOF9oQ4YRaGhDuMIE0ywCv/cWHbApMYjWLbGNV4tYeYTgEW5RPBvcn4mvNkxtwIdn6i7CMQqi12et2UmqcNgcpzpQrNXau4dLHDRJKcX2bMTURfBtJG39vUKMpC7Oj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784395479; c=relaxed/simple;
	bh=cqR8JikmrswSNqS04pYli1YM+ApLbSdN2Em8CMf+Eag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=upDKUASgxAYugg7w96JdiNK96upxrdJgr0dR/tLZNm6zvZrFR46+C9FY2zHIAJcsQu4SS3MXZYSJ9Q5L0Q6LlTggT3RXC5acFrReDVHJ9EdL7Ch+IFWchnwNtPWYLT0Xa501GL9H24e1olBtDUNYwk2G/8urIV/1lzAybpCuksM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s8HrN7ba; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s8HrN7ba"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=YfUejeag+x8hccV3Qa62JJochWWzcrdg8iAgBKzRx4g=; b=s8HrN7baK8JpoaoduYsQa2NMJt
	Ry8E3Q4RnCUD51ayTrlE2ZSpwlSw9fkgcPm8QsEWtlaO911FRW8F67CcYaQ9wt7K/Ic9X+BIHpGIS
	QkCThdXg2Be7gJazOGzNTpB7+Arh4dAoYCK74uvzwJYlEk9wNhJLah8PJiGk4VeLSi9XFgSZoE4kd
	K/wV4BL25F4xAoWTid9uR9Ezo6o4KgU3fhE/TiQix6mYaPQIy07+dzrewndtQ7lI7uRCl8fy6y2Mm
	IHDz0dQ+r9hfGlV393/ZVD96FWkMq0HOSPy1Op+r/R3UVuHE5u0b6OtDKSv2SDkZeDTbDC2YPzxtj
	fmjuo2Fw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wl8m7-00000004PH0-1RnD;
	Sat, 18 Jul 2026 17:24:31 +0000
Message-ID: <0f225a3d-b10b-4576-8880-2f3759e9fd22@infradead.org>
Date: Sat, 18 Jul 2026 10:24:30 -0700
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] Documentation: admin-guide: fix trailing whitespace in
 cgroup-v2.rst
To: Yahya Toubali <yahya@yahyatoubali.me>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
Cc: Weijie Yuan <wy@wyuan.org>
References: <alumXzlDApA_iMbY@wyuan.org>
 <20260718165614.1923568-1-yahya@yahyatoubali.me>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260718165614.1923568-1-yahya@yahyatoubali.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/18/26 9:56 AM, Yahya Toubali wrote:
> Remove trailing whitespace flagged by checkpatch.pl in the cgroup
> memory and writeback sections.
> 
> Signed-off-by: Yahya Toubali <yahya@yahyatoubali.me>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 14b8c571c0d1..481658cfef40 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1332,7 +1332,7 @@ PAGE_SIZE multiple when read back.
>  	cgroup is within its effective low boundary, the cgroup's
>  	memory won't be reclaimed unless there is no reclaimable
>  	memory available in unprotected cgroups.
> -	Above the effective low	boundary (or 
> +	Above the effective low	boundary (or
>  	effective min boundary if it is higher), pages are reclaimed
>  	proportionally to the overage, reducing reclaim pressure for
>  	smaller overages.
> @@ -2194,7 +2194,7 @@ of the two is enforced.
>  
>  cgroup writeback requires explicit support from the underlying
>  filesystem.  Currently, cgroup writeback is implemented on ext2, ext4,
> -btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are 
> +btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
>  attributed to the root cgroup.
>  
>  There are inherent differences in memory and writeback management
> 
> base-commit: 1229e2e57a5c2980ccd457b9b53ea0eed5a22ab3
> prerequisite-patch-id: c8aee5eb39e3cd6f2b2f28c82163565665288d2a

From Documentation/process/submitting-patches.rst: (paraphrased)

Don't reply to v2 of a patch with v3 of that patch. We prefer that new/fresh
patches begin their own email thread.

thanks.
-- 
~Randy

