Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FC6477998
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 09:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791798916; cv=none; b=P05IZ/Gu8b19xrY77Ck6qOpCi+USUuhnXNqrx7DrgRvYKRMXODjByBgWzfkyWR8wCt/PlvD4nMNb7n99CcmR4c1QzuUWeR6LqPiC+KFWTmOje9Qqf38EJbBvzfScaWw7+R/ekee+2H5ermq3OVG/7ABIPiTcfMZ5fgIvyCtCZ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791798916; c=relaxed/simple;
	bh=xtHnZSDfSXA0zSCJVaX9x5fLipug2CyvRd7L9waXZBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diGy98VT/7YC5gDeOJ8QvTw4yZPXO8YakZoG3O8qBuwhFUqieS1pQeRZ371u2uxDxSN0D6wTsgvkFS9TpU/zgF9CiDggUb0ToG+g8RFLWpWa0gyWDWFOgUMclmkgsqdZ00+GXRPg8xxJ0MEkjNmSwdXGP4IOUymQkx5FVtTRYyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dM6djyTI; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dM6djyTI"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-886e61fa30fso501710b3a.1
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 02:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791798911; x=1792403711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xtHnZSDfSXA0zSCJVaX9x5fLipug2CyvRd7L9waXZBg=;
        b=dM6djyTIKJumxg5kAD8dIppFOl4iMXiMudeys60d9q8CFZH8gTMNzO94E5iPh9qiwx
         +XHjaK74RIQ/hFyUUz0T1AA5hHfaMGc01hINQPOd7v/j2ODelG2f9UzWiiq/Em3CPHTX
         1uH1KqUoUhGji/ah1g9NPSq09Qymld4Jtt1gXO6RVWOPhvfSvEdk/9Nhmiet7p7wbclm
         4MPzs97WEXoTRLcTdJNTWuClfov8HvcqIj3QDAf146AidBwfFI4Kw/65BJsteyYifGBr
         XUAKRwa6kmPq1bMfgzCpzlXGFOCrvUT7PZlsqxEatmTG804gxy6NQWr+Noz2zmUXsSLD
         dpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791798911; x=1792403711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xtHnZSDfSXA0zSCJVaX9x5fLipug2CyvRd7L9waXZBg=;
        b=SW6tz6ybG3iT37ptrQW1F2x1L8szzyfVGP03GpFwWUBVZ5UTO453gP9UU0zTO0DEqr
         zj+K+TxVmUSZHdzVqRCkabtXl4Pw31/Y1JmQKFj8Uq/nqirpblwtA+dPWZJsKvgck+k9
         Q+3bjwC1dfza3zbiVF2LF8BnofwYU+OKWssuZMhtjHa/MomWO2W5xJQRrLVmWHsQX5Bx
         cdZwdp6+/yC/44vKksU1gcTdLMbuvjzmDQBjxBBcYwywk0KtJWkFTJSfNmrB/RI3v/b6
         GaOqHUr7kgk1EpuwBZjdMPmD0Be6L+yHOSsEIGU4usUGEO0qW7W+2Sne+NYip9MZSnsW
         hiwA==
X-Forwarded-Encrypted: i=1; AKwUvBw81hx6UAsOrvdSU1u0huf6PWTd/g3b6u9iD8b8RqzFfo2d+CeUZU9liY1LAYoBDcly0+Bmw6f9@vger.kernel.org
X-Gm-Message-State: AFq9FYJosYj97e6zNfrIj0/C7gxA+Jj1uz8go44YE0IXxjS2IVinlV3E
	bXvNsUBuaBCoiMjrjjJWOHpJyUK75+vgp0DjqMGO42IbNIgD+LAOoO6k
X-Gm-Gg: AYBFou1SZ4x/qgMB0fTvtMvGmg7uPYbO+ywZ5OiNfBOWyvo75BA8kqC2H1XxcDQNN9q
	6ZR/d83pQGppospIERIlQeH/Mex/qsV0cpp2ReRgz+7yCC2OgZH4HZJM0dGzBN6tW82PquUIzGx
	j6fugGjLyG1/TzBhVl0YUbZ/ASUYXMnstJVBVWMql9608s6di1bgBQ4RjTM4iUXxE9PClM59SGZ
	GH1qLOIE8d5J/cueG3zXTmPqA0CYAa8rkuSbWUGsn4NDCKofkZOZygj0RpWLEnwnB+kdJ6T+U4N
	wT8c4LdB1EIKiazC0Q+TKyQuC+QYejwUuL6lD9nK23dG2f0CgJudooEuSgEOgrG3KBQHy4ZGdcj
	ZD//r5s6vgMji8bq822jczaO8DF8TJIaN0gNlmzvR5w7CklA8oWI85QI7yHi3lmyKGtcU914W9f
	q6NLhrj+eOi1akeY52k0DRU9n8ofUowLqzz1JPpZqsvgDYpbZM4CnE1C6Jel4RuKAZVyr4V9hi0
	sqqgG2Q6wb59IOZ8UnzmtJ+2ZMarUbDceNoDa81KNo=
X-Received: by 2002:a05:6a21:3296:b0:3de:b0cc:b0ed with SMTP id adf61e73a8af0-3e16bdf0facmr7208501637.18.1791798910939;
        Mon, 12 Oct 2026 02:55:10 -0700 (PDT)
Received: from obadmin-Precision-3680.atlascopco.group ([136.226.232.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c42b07e4sm3573641b3a.43.2026.10.12.02.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 02:55:10 -0700 (PDT)
From: Sahaj Chaudhari <sahaj123.sc@gmail.com>
To: sashiko-bot@kernel.org
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sahaj123.sc@gmail.com
Subject: Re: [PATCH] selftests/cgroup: test pids.events notification
Date: Mon, 12 Oct 2026 15:25:48 +0530
Message-ID: <20261012095548.3199009-1-sahaj123.sc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007063516.1192279-1-sahaj123.sc@gmail.com>
References: <20261007063516.1192279-1-sahaj123.sc@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The signedness finding is valid. The test previously compared the signed
ssize_t result from read() with the unsigned sizeof() result before checking
for errors. V2 checks n < 0 first, then compares the nonnegative length with
sizeof(struct inotify_event). I also exercised the read-error path with fault
injection.

V2 was sent as a fresh thread and links to the original submission:
https://lore.kernel.org/r/20261007063516.1192279-1-sahaj123.sc@gmail.com
V2 Message-ID: <20261012095011.3188830-1-sahaj123.sc@gmail.com>

pw-bot: cr
