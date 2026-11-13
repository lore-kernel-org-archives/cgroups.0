Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794569056;
	b=awKz3xevCxUbGkP5MRiTJ4+JXYOrS5BJ1WlloAuPBAS0t8h0apmiJP6TrZsYdJWNfTph
	 MFYiSC4lyS7H1y/6CHxkcZCZHrTnU82d0LT/avFZbeznDCYonLQsysmvEcr4lj6qSItVE
	 I/iACSy3O8QxOlnmxqE12AJnYG0T4EddwMCCBYkNAUcMxwyK2i+0ZAFs+LVUoyZUBxPRW
	 Phxcp1PWULuBCPIMqlArlyW2STdY30zx51PcVINi5qGHD2IOwTe+QN96uCuczjKcfsq/W
	 Ivh3zjoQ3+pfEdHqEh4MWQEZV++fpqEWXILHu4REgWoULgJ89iVVVIr1wo4l4cILijQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794569056;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A2z7Tw5DHCFD+mcx9gw6v8Y1X48/h954fhMI36CiU8A=;
	b=uu1Bx4O4AM4g6AWrqNs5erjYGeNRHGskkAZbjeONJY+KBkRudyMlGAC7yVWOMwkCGfjV
	 bP3PNs7oIIJTeySBvG8bsmu7MD3OaIPbxaabcxFlce8u0JUVRJBQCQVHbUle989Ana+tz
	 lVPNvYK36mBe1Ja0f5dEVqBauX5E7UUnYeiXyGLtA3aLuoDBOu0iqMBBwxC6OywTknbuA
	 1joMROP14Gr5Ciqk5gvOeBx2YRYDA9o6Et1+y9eMXrpc+rBkS2dfY2OaKk09WNcTc5DpR
	 ezODJ/GwEdez/VKh22v6WcDMQ8do7LGoMPWZlwM5nPpdKePHg6qDsKsBjqBygFS+oug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0XKB7toi;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F343D606A323
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 11:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F343D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0XKB7toi
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso583279a12.0
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 03:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794569055; x=1795173855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A2z7Tw5DHCFD+mcx9gw6v8Y1X48/h954fhMI36CiU8A=;
        b=0XKB7toibmTif2MEATU8EZggVXApNKF5tJbXh7MpZRZKyI4pE7FaNOUowZOCzwzkVy
         S1NwmO7Y+wY60fXBsK5t/EkC1UBC6B0TnOgyqZDTBdhgJNn74YVQEC4qvH54McRUvSfR
         YGd99C+Wv57zzyMJnGyEJgUjGiRNCqR0/ic8VGHJD4R/ojC4IhQ+lhm7DqaCQ1MjJIEb
         AFrHb1RqjZ+0ikSTu5WI5sdS+7At98IO0TNPUr1dUBxQxdeQDmGM9fH/H+iKtkxdSdc/
         f/9tJKHqkV+Vruy7ktloYUz6MVlJH4aiHHGPUgQKf4IWWhIkNEg0qTuw3r5AqZQVW4Mm
         /Mvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794569055; x=1795173855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A2z7Tw5DHCFD+mcx9gw6v8Y1X48/h954fhMI36CiU8A=;
        b=ZZGw58VSAsIlylcuKYlnYoY31QlJAVR8sxZdVK0iZ/KP0FuVR/pTAR5k21O3vPuN3x
         5gu+TZcDimdDRmBWy4JkOgiMPlOxUPvXpvkykJANPT/4AFju7RA/sio8mYXWombVFRBf
         G2GJAx71CGTgUlRh3bKBMnxzmH4n4W13VvSfdLl7IuFXVXotvulEBsUm2TQV3O7fk5WL
         F2UxlJuFwwHbFz47Vn+ZqLTi6O55AOOERsz8gulUlgH/cXewTWoiWe04Mw+AFbvM+WGX
         w8J+41whVEqrlw68UL2+H0KbjAgAF/wGldLxM+QQW3JCdsMFZyGxSKPyo8ZsG1OhT9d3
         LBag==
X-Forwarded-Encrypted: i=1; AL+hErG5qxnx8JswY6gNSOlmkhUs1VWtYkpLnyRSx6MR9xvs43ZbkfcqJGBtlQ9g3j/tbYYucrk1nddI@vger.kernel.org
X-Gm-Message-State: APuU4Z9gmSNi7pGhf15na8no4oapdFrqEFoWQRQYBK6yH1/LphQLEIOB
	ZemW2Wq6kT8W2voASKTM5nZ3RDIcRTtnYB40JES5ANfn5kn8jefyGbnv
X-Gm-Gg: AYBFou3Rt386je26SZVL3dWRhOLfnmCZ/pJ2iksAeH24by+5kJP0MsH5EY7mM5Vk4IZ
	Lj7YB011Yh9mH+gUOvARi/msrbngqhwevs+OLzg+R5QzCXWnqJOSXubT9Mr51g7ZEjXqGLOWKTu
	XCwBrbO1sEOGr24OBJKniHFRhAGZsrQIc42wxYbHVtgTxIp6IaRPzH8NYfT4IGLlMVSh+9fXwON
	+rcs99JwLpDvmUQkejPGtrWxbcHcanMqiU46zlFIhlYb8mlcC+UZzY+wxULrbz/LvUg3Dtzvlrx
	iDVlEEqoxNvPnkBYg6DdbMG3owc1FwNx0k8D7oR6t85jaTt910ozjfRXIeei2VW/40rys0zt9Fe
	ElhyCyhMu7gk57bR4htEJRdAKlKKw+BC9NtWefl31Dav2KCdmYvFmsyi1XO9Z/82KzqoPzPglry
	s45NgpKtlq8jl5N9EtcG4kedRHLlpZOzUfxTCpN5nWTVQM9oOS55fcPsJq4lc3bv2g3RlVsgjSm
	RQEZ+sSuq4AGTp5xLfbsJ7upSQvYBWyIJ2ehzUSMJJRJvz55NyxM9Pjrx2JHvJKhTmSH06z+LSM
	+VIfvipzlF+jen+cP/2TsnXAE4QQYz6peoaCNMQyg1udAA==
X-Received: by 2002:a05:7301:2024:b0:36a:18e2:64c with SMTP id 5a478bee46e88-379655d3d12mr2185384eec.11.1794569055067;
        Fri, 13 Nov 2026 03:24:15 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3797f98b9b2sm6771786eec.6.2026.11.13.03.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 03:24:12 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: mhocko@suse.com
Cc: tj@kernel.org,
	akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp,
	mkoutny@suse.com,
	chris@chrisdown.name,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Fri, 13 Nov 2026 19:24:05 +0800
Message-ID: <20261113112405.1583476-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <avbIL86R61Lu2YVF@tiehlicka>
References: <avbIL86R61Lu2YVF@tiehlicka>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Michal,

On Fri, Nov 13, 2026 at 09:19:59AM +0100, Michal Hocko wrote:
> Do we have any conclusion on this?

No, Tejun has not commented.

The same case has come up for cgroup.kill since then.  da13e0e72a73
("cgroup: fix cgroup.kill for exited thread group leader") in the
cgroup tree handles it by walking all threads instead of the leaders,
and leaves migration as it is.  v2 does the same for the memcg scan,
so I would continue with it.  Chris's "mm: memcontrol: Don't lose track
of exiting OOM victims" changes the same css_task_iter_start() call,
so v3 will be on top of it.

Tejun, if the exited leader should rather be moved along with its
threads, this patch is not needed.

Thanks,
Zhan Xusheng
