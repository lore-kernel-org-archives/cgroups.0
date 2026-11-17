Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794899377;
	b=CjfosDGhCxFVqGSuzt+kJVt6gQbXhlH6dno0hMGVBgngCSiD3wovEugOPAdWV8Cpgvl5
	 TyI3/mxXqrJB+ANNNkiUYi6eGR5BwO05VwBfe5QQ23eQXP1VUYzIVg1FRTt/G6JE9oKGj
	 LmfshpIQ/drAg1Nk3gEUTQKOHX/egJk0UEur7Sw26qUX1pKDF6Z7NSWa9kjrP3/4exBGf
	 sAsjf5gI/iPWC9x7ZA6hR4H31XaKtLN2crAsPbD6pEiCyiMToLeYo9aDDWfWhPBVv3ZgT
	 8hwR3eWYAP4SZnakuk324ncoIdO2tX52nUCB5FFRh18+tVY+UYK0KCEZNZfOjyHUfWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794899377;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=WnR+cG1zrK99ABssRDEAQLG69JFukBqigLZq1PXp1Q0=;
	b=CO/4evl6NqJjpfz49MD8DOe+qfoXCtCnFPZrC4bozyn2i/uH5Iz/IVY08hrhbezlQaPJ
	 dkG8zh7ZYilozZOmj5l+5ek93RRk1e0/D6ncsEL7i8yGhyo4Xsz0G7V91pVazBEdEVV1C
	 fIeLUlDu3JKYKDkMcx3pSqE43hL+M94ztCeK5HUKjPxSsKoXW+pk01weUXMx/yjSTTkru
	 U3R0N5td0Z3Nw7vgPv9TUxkK54yRHMauY8d9vFD/IDyC9sJxkTZdTOaJKkSNnCOxkDk2z
	 C1WyPkN2OZCc+QQ/0JFW2BUa7Np6P3fWFDgzP+4NTWAhKl/wWBPRztIZ0qAlW0grv+Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=shopee.com;
	spf=pass smtp.mailfrom=shopee.com;
	dkim=pass header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=CTcpkO4P;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F35A606A323
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 07:09:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F35A606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=CTcpkO4P
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-3704d30b84fso5159922eec.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 23:09:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794899377; cv=none;
        d=google.com; s=arc-20260327;
        b=QUYrkQOXXreVFKJEBaDcWik1ti4LW+4o2SOy2XjzFLf2asDalerUPNTBGmeSBkcyXC
         7Tlz43TArW+84NqzMAp14mgP1KRRM/1UisbDBzIPbQYQopZ95hbvadcV9BE9fvGpSp5d
         tanlD+g/0y5QGbHV4xrNK4JTrGYz0F7jRPVpU/b+RAtlaZ0bUr/L02DBECZmSd2xCxcM
         KFRhdXlGGokECYvDc3pSV1QWDHMk4MBeTvDu5CIV4ylB5wiuP0Im7f3bo1SstitHhXGR
         Vn8fXP2TvVbGlc3AdBVBW7zQWyJt1ve1iRlqEW0/SUkXBo1IYyStv24kvyIWqyhwdgGX
         Bz8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WnR+cG1zrK99ABssRDEAQLG69JFukBqigLZq1PXp1Q0=;
        fh=hr31zMMg4Hr3Ir4wmWc36cbMHKE7ezYNaum9c58V/eY=;
        b=sMy6C4X4x/9PC1P8lssWM4rt2y2T1RQ0zdR8e9dXHIWbOs/9eQhgDxW/HW7QbdJLsR
         rCTxsF2p8u2zW7ybr6P7smDR8QxNZcuFvSukOEEjbXn9OFD2+TC58ulXgSeMof+NUd1M
         9tNxz735Cxi7sDtZcO67FJ0UtJGFcs/pLB6CT8tlxgfouZ1Tr4cMemmZYgnF0ojVPxyV
         moik1j+WaUpsBd6E2hdLcqpfBUKcfKTSeRj6rX8osFQO47wBj9mDp4nfZHQ7KAKgxH9X
         64MTHbIITn5RUURtln0V6gzPTJUKy/MT+M2uV9ioeHmfKW4NZrBZ+lfnYwelo+Mj8nSQ
         /YPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1794899377; x=1795504177; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WnR+cG1zrK99ABssRDEAQLG69JFukBqigLZq1PXp1Q0=;
        b=CTcpkO4PLCpBqPK8o80jLKsvFQ7xoxL6FJfwDu1B++lsZ2e8LKBao0dTLIBjOVXc5G
         1MtSy3XS+Q78u6mk9/LeVoJR3RgH1uihf0LZg7ooTscb6j/7W7kCVNveoWF9URiYpaRu
         O7cWDNVZMt44ArumJKf5LKdGeY+ZmL6hhEy49tNx1R7FAiQ3efC7KJSy32cmAt8pKU/O
         HYo6/8b1DnQorFswbjMHlgrn6+wPAA5bNcg5IzLIPtB3+ykbWdjS7jlPPsnl69B3X3YE
         zihJh9dSKzipTtcb5nYz9bI/WTJXzaIdJrGXlPC9Ki98kDRbccd5lKeedywjQHyof27W
         42cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794899377; x=1795504177;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WnR+cG1zrK99ABssRDEAQLG69JFukBqigLZq1PXp1Q0=;
        b=w1W+cgLf4FC/uorn+TMEpixwIN+QdPUFNpalsb6Bck6g4/XTgpnWcNrQ/8daLpfMrX
         NTGswCXFAMI8QaEZxvnNsUcvHeofVKkuZFy4PIUvlMufmaDiKeH3fFj6CDcR2L9ce6MP
         aYCX0+f42elHgQbChJfzNWQ4wCWdbD3GiCj3/Xaqp8TmOB6zex4YE2HvxjWbu4L4DqL7
         LVWGi808pAjzZmoy18rW+/Zv2MOU+ZHUBN3t7r515y0CFS4PdQY5420pgKbHFfzY458i
         QWD5K1CWrAeDCTAVaGfgk/gXIBtc3+0AHy5SsKdrSkL/FMa/Ts8LGuKKPd+3YQusCK3d
         9uIQ==
X-Forwarded-Encrypted: i=1; AL+hErFeQ5JZpZzYfRDlpPoX6FSthDrbC6e15HzieSUtS94seejbrnJGJLPckvrqHO4/2YZMGKK2qA1y@vger.kernel.org
X-Gm-Message-State: APuU4Z8v406rQq1c+lQmzPHCSkcrE/vevZnLY4jX0uz4tQRRKXlkKTXY
	8ZEVI/9UfrvpP1QHMyV34p3OnY+XxGLblQavE/YRLma4+B0JCoqdHDscqFlvqpHviFZA2jUcj7H
	KteSqTivSkwNyrOC2QfqM7OJoqMuQP+I7fhRQk0Z6Kg==
X-Gm-Gg: AZFdTZe1TILhozju/cvaeZ/NX6djchRyZtcKwC22qL1P0vytTjAoNxJZBiHjd08mDCB
	W9z7MH4IP4ZHK6CTH6nSXrhPLd2sDA6wK0neawtc0m2vGaNzlRDIBK2ZBezap4HO+qUE+fLBgvN
	knABsBFWM7zLhn448DePEsCHVBBUGA/0psQdQh1VQXrmbnabT5vMgMYsmdm7P/1hEfZM0nfjY1/
	Zo6RW+LuEG3gqIMNFUiIqi6ucInvgorQioLzvxABgKWh3lifFiPlYtVuFTZDqIP7CH0X1/qPpAJ
	YQRYKxe6vFxXnoY3EDW7ECQI/GgwNGCgIO5yoSIKm73ulh6be2Wn4Xojz8VpAxB4g4oQFBbaTJO
	fhyE+osZFN+AQWoUxCqDYt6052kijUiXhCxRz
X-Received: by 2002:a05:7300:de01:b0:369:daea:812a with SMTP id
 5a478bee46e88-379682c2053mr10636754eec.30.1794899376652; Mon, 16 Nov 2026
 23:09:36 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112041348.66915-1-mingyu.he@shopee.com>
In-Reply-To: <20261112041348.66915-1-mingyu.he@shopee.com>
From: Mingyu He <mingyu.he@shopee.com>
Date: Tue, 17 Nov 2026 15:09:23 +0800
X-Gm-Features: AclHuK_OdWVIh2slf7tcPI8uUm8C9Xejgxejc9Hqh6QFSCrmh8eY8O7vcMROZXY
Message-ID: <CAAoBcuTiyvYHPpKNzYsHdLTGmkQmrKUZPkJAkm1qEdOeu18hRw@mail.gmail.com>
Subject: Re: [PATCH v3] mm/bpf: Always flush memcg stats when explicitly requested
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hi, I wanna gently pin this email, thanks.

Runli
