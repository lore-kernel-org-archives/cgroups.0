Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEC93382C9
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 13:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726058; cv=none; b=a6YWruFvWJtqN1THqBZVeRjdZOq9pQpNXZ/LWR55BTcZEzfR79V/3wsC2skd/tfEdc+SJKhvI6/uwUC/PDBlTcz5tm6rGGpkMSzXEygKP65Si+Jf09y5yoXjlpZYF2nv27Z5qku4ai1OuM03eAk1etUTbfT93LJIGh9LwURBfWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726058; c=relaxed/simple;
	bh=0BxbpvuOHxt9xk85SoAx5gd6wtsST6LyEZ1wRvXtZQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fx3w0oR2ulaZA1OFbnuhn2bPsvIoCu5ZSyN3grVe/cDQaijMc8671WX2BTC9IiZJCxkN+Q54WYb/GVe5qhWgu4mmTiCtd30+mR09X6Xnq1jIFiZpKzNiu67fYt/ZV/QcVJ5Dec8vGUA48iALfOsDftI/jK/iVcJHJUH/1KOzf+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=XP+jb2WV; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="XP+jb2WV"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so71269956d6.2
        for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 06:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784726055; x=1785330855; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0BxbpvuOHxt9xk85SoAx5gd6wtsST6LyEZ1wRvXtZQ8=;
        b=XP+jb2WV2x+kButiHD7WaAuL0TAonmtVxkfJgusqoIaFpuq6ilGr398raUseMLYrTZ
         R+85uYWrqQht05NACwirjjQYQ1njq928FEb88CLiP/8ZdxTnyIFIoszIiUd5VXFEEn8C
         t2LJlIvRfZoncAqAZe/SC+ism+zpwMAO0qjieP/AgZfkGIzFQsPfyu8qUYltlg34GuXb
         /3WYfYUSbgMtivi1fklZWFJ57JpCx5RsI5e5QpoFCI8682ajMmVmg2zEWAUu90FlRsJj
         xokxNk8iICJEzpT2q6+VBFfSg37HT6WyasCJ7GXKtUuxUlMgwcxOzDDrQVXH/1V6v2M0
         nngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784726055; x=1785330855;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0BxbpvuOHxt9xk85SoAx5gd6wtsST6LyEZ1wRvXtZQ8=;
        b=m/bnNOcWClC0WpEkSw/6WjynnqCmfmOrRnxD+lNk6WgXtsjGZNYAabuknC+MGaVShY
         0FsYvEYNooVdVvMMg58GuCE67Zp16Q75kZxW2G9kJuDdeXVfWwe03Wjkdq+PyqTxR+Tc
         QLDf1bQGjwNXQCo3haFfMr07St6fftEw9+dMzf+E9+MuuoUBGXVepmvkf45j4DlheqbD
         w1C5en9D8o8zZUNIIXN80wl8koBwqxRVYd0ggdGfKPX3vECTj8SKGaOKh0pCkyhMeMZ1
         DCNLwTbLpIOE/xmtKqDvuZseZnHx3/7V/xnJ/emk3V8kfTEwajirkJNZoQRUZEhZUBdF
         MI8g==
X-Forwarded-Encrypted: i=1; AHgh+Rp9W6YxZS8xNvqL8dSRNfOYsbnYxyg2yyr1T1j56+4ZUCzLeTtMe9Eu+u4xOJkMudWZxexI2pKf@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3hPWRFQs1Lqh12omIVCyCMrGbIy3ntPOJrB29O61ZeYWBISGs
	3S6AlNwgk2gpF7Mj9gmgUFe2wCP0whlbqh2ROj+GPHZR/MODszj1mv8gGAnBCMLQhCU=
X-Gm-Gg: AR+sD12/kuRAtgZjTj9NtAXN2H5ALYSy4pOM0mZ1JxYRVWQiV9kBBOwsgDCp76ifoj3
	PGN+jXvPeiejc3OLyenvbuQvEb7921/EQEyySiSMD32gKHtxt44n27x7DDIg4nSZIQU769Rerh7
	XrBq/6OJDt4EPmdZ9bABNcQJeyFEE1EZNTIToEyEoD1LdfQ0pYie5dFkv1vDd3U9kn9+0wk7mic
	wxOur0AYgcPFg1PNEYW2TZ96BQ4pLEDSTqrcf4bTsyI08xSmAmZWzQlxOCNeN/WEeppgUxoi6mF
	k4zl8u/7Y16D0ZTLeF+LmxUwZH3R2cYD7ROqChLVrWtncyJ+Ss0jA9WIyrXmpO/8X9PLR6DeTTZ
	k6d96CujUQvXVTbR6F1sL4LUkX5cxRB7ha+XrCRPqfS/HbtQ9InoZYfjZT5lFVrpzTTCkeM1w1/
	aK
X-Received: by 2002:a05:6214:3106:b0:8ef:dc74:91ba with SMTP id 6a1803df08f44-9077834c563mr253071906d6.13.1784726054877;
        Wed, 22 Jul 2026 06:14:14 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa0f4dasm20661136d6.41.2026.07.22.06.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 06:14:13 -0700 (PDT)
Date: Wed, 22 Jul 2026 09:14:10 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	yosry@kernel.org, joshua.hahnjy@gmail.com, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, baver.bae@lge.com,
	her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <amDCIl51NoNPL7Op@cmpxchg.org>
References: <20260713025644.170839-1-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713025644.170839-1-youngjun.park@lge.com>

Zswap is a first-order swap destination with writeback semantics. The
way the discussion around zswap has been going in this thread is
disappointing, and I don't feel comfortable adding permanent user
interfaces on this basis.

We will not be merging a memcg swap tier interface until the swap side
has a story for indirection and backend migration.
