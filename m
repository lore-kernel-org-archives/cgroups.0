Received: from lankhorst.se (unknown [141.105.120.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52C63B8D5C;
	Mon, 23 Mar 2026 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.105.120.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774284400; cv=none; b=st5UWYXwood2fjtEPlHdx2yroi+iPwRe34SfrOY1gNrKr1hQnN1Gcyl+TvL8sNaecrmZ1Cd/g7M3Z3wJ2zsu3ZE80zzU09TIG17rhMKpjyYbyhmXFNtgN2zc9yzB181OetWyNp3tjbR0ePLXu3gngjWqSFQh0a08DbJNbkai1JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774284400; c=relaxed/simple;
	bh=qmg1nPZUUxwm/Z10Trz1LjJPIJku5DoJhWgq9/ietK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fap0FiiWPNq7vLzRqCo/6CgNzJwtG32Xh7ElXGsAlrs9GXgWYwvsp3o2jCtUKDCiXNQAzjyqyz3D3K/sMaUcB4KQmyvSMyPmw7aSQvQSYmO+fpzr27j0GWpVBku4L0+t1bv40U2mOiDExN58M8MqcYWBN2qHLYK/yIMK/rLOkiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lankhorst.se; spf=pass smtp.mailfrom=lankhorst.se; dkim=pass (2048-bit key) header.d=lankhorst.se header.i=@lankhorst.se header.b=YqEYhYAT; arc=none smtp.client-ip=141.105.120.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lankhorst.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lankhorst.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lankhorst.se header.i=@lankhorst.se header.b="YqEYhYAT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lankhorst.se;
	s=default; t=1774284390;
	bh=qmg1nPZUUxwm/Z10Trz1LjJPIJku5DoJhWgq9/ietK0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YqEYhYATKrEyMMtia5knDmEsnZmz8Dx6D7UxDLLaDBZfjviT7yi9v9pqkj3R21Seg
	 tkQnUjy1jXW07s3v9BWoSABzKqnQzu//wD5ymeGsK/ipY5SXyMj6EDZiHio1TRSGlN
	 XiOKImX6vEJY4wQ14ArsWJcrXTzH8dfTWQYBvn94gwOkor5iT3p8NfuxwoNM7s9K5/
	 Mm3Y2SvZUib0ha0/qTfxVepOS4MhDAmk3PdTDr2rF51p0m8qIk/DeT1MnD2LJb3FTY
	 kPFM8aahN9t24rknO+O3j3OecSk+9G16YdpjTnknRxMB6tLzdM9TwhrOKukcXYfZ3Q
	 ue9J7dVP6aHXA==
Message-ID: <88f89d75-1e1f-4457-8c1f-57e934c251cc@lankhorst.se>
Date: Mon, 23 Mar 2026 17:46:28 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] cgroup/dmem: allow atomic irrestrictive writes to
 dmem.max
To: Tejun Heo <tj@kernel.org>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com
References: <20260319-dmem_max_ebusy-v2-0-b5ce97205269@igalia.com>
 <b099d9248df084fed8d4252e3c6fc485@kernel.org>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <b099d9248df084fed8d4252e3c6fc485@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hey,


Den 2026-03-21 kl. 20:27, skrev Tejun Heo:
> Hello,
> 
> Generally looks okay to me. One comment on 3/3 — the naked xchg() in
> set_resource_max() needs a comment explaining why it's used instead of
> page_counter_set_max() and what the semantics are (unconditionally sets max
> regardless of current usage to prevent further allocations, since there's no
> eviction mechanism yet).
> 
> Applied 1/3. Maarten, Michal, what do you think?

Yeah probably drop 2/3 too since there is no longer a case where setting a limit may fail.

Kind regards,
~Maarten Lankhorst
