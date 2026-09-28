Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D19A4E56CB
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 15:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790608777; cv=none; b=fdrny1n3RyvzGFBhPsOyy0D3LrJKbO6y7DC+cSYeRaLdxspyYf3fWquLfgT0Is7ObXXo/nMcNOr2eYc2NMfquUPcUGf9tzUr8z9Emzjz/uTlfxR7gsEowbD+8KbrJA2yNfjqQ1Giy6FHIrIg+z5yPuMm3V6kfskrEiS2Vb4exnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790608777; c=relaxed/simple;
	bh=0J9ld2otCYxgF2E0poGk2jXS68DDTyUBL9fnmP1RYBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfyRWZnS69EEyeaVJ5IjN5swgkZ6AETIZr2KjDJKcCR+2ihYOV32EDRv+Ic0/IGhdSIOgwOZi+x8iPpXNS2STv31Hy6W07XXQg4k+pwXm17s9cHyQzhbe46UwQ37CCetvKYXwLMK6vccoiAHbN0Oc98VJp4c3IicoGZ1P9630fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CzQHRlLm; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CzQHRlLm"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-3a49573b8bdso89343a91.2
        for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 08:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790608775; x=1791213575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b0NvfzIhMgoDaAcmLO9lnbeC2A03mNxAZEcGsZ2ya18=;
        b=CzQHRlLmV10nWoOYSD7sLJQVfLrx5JXRCrmSvfU9nR+C6zmf0py48vGNJpRLlA/Ct2
         jkBA800VFPvPt+ZC2aL5bq+LLCoYaqWAJrDYLpn0KD4PkvaGpmxL0E8rPbCkEpH9XgVM
         K3bHnP5lqCKmq8FHNLFGdOz+aldgmckp4p/MrXjzv8Kav6/Wj5bRaPjJv42jj3y79uPi
         ydBkyha1SZv/bfEyTpR2Ul5I5bTR0K9Qup9eWBd04QgX7NSCqJZipf0SmbEb1CDURQdP
         61xQ7P8yB6VxMzf3KigJxhGYUKzgYqILnrHJmoxKAXKJRladOOO2DcnShPRWE5zFHl0w
         LEiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790608775; x=1791213575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b0NvfzIhMgoDaAcmLO9lnbeC2A03mNxAZEcGsZ2ya18=;
        b=YBbFVYEI4f7obELVhMmMzfWdQkbNwuuB5SYsjPapF4yQmj01qg/s/cARBusBpewhXX
         Kda3Futmk2YLEF+2Br68wymfIQjtFWC//mDXEodyfmgmQEXum0JYcOCVPG/7FgpWQ7Ud
         0va5gXdAXw6fg1+h5c5nPUN5XbDz/S7KFHt8loRKYpmLv3TkDdYtuJUqe9im2wCtr8Lq
         ySqpATyiFN/GPoPHulEkGVWP8d4feDrn3SWxI8aaeAyLcOJT89hPnMOoalHYvGzqaPqF
         kyW1qblU5xbv9W1kGBvsHKi5iqAd/DXjKnu2XyRX6ACj78Rvh2DZ+7Mdjmrf1pFPMJAx
         md5A==
X-Forwarded-Encrypted: i=1; AKwUvBxruC9YNfo4YfUND0X3VFTPjrAmxhfX+4nBDRyu5lheGOV6Vhb4kodAR6vllLAz7snqsy0dwaQu@vger.kernel.org
X-Gm-Message-State: AFq9FYLHMq9eN+QvFhbQDwSk1Gxu7VPGprGKy42D9AMmNCDGOrz4kkmq
	4PyWmTd9LXNcRnrC702NtPBQ4i/dpuu7ES9ru1HihzZj2FUH2KVy43iV
X-Gm-Gg: AYBFou3nhlhQb09YO6CGLucZw70KxLA2uVfE0dfemOsplFa4bFMp693b5fJB6vIApXE
	Vrh9WRHMpGRiE8aFdBP6R0ve+KcSHAsdxPchab8kmi+9yI6njOOAl2XPgOLmic9XwesQ6lzqKbU
	BAIPn9j+nT8EKK3BriSunhQUz3LC7k7+Kjx81v+cisk1+oCQxGmlsksEMK/loWka+si+G6L3JKy
	aD0uYcW+b3MBMPIX21UmljoG2XL1YCE1FLMMHgmP7teHtXRS10pffZwdV9CUUkb0Zc0PStegsz1
	HU52vLLoZNByjk75JYyHrKzjRWjdzEI3Yhaeqcf6b1HTgNzucqd0oyx4H1owt+mBtPyMNhPnL+f
	oYgfTIban6+hQnlCNckMw+IZ0D8jH2krVnYDGSlEB4Vvce09HNAqj1JE9vdUyjnbwZMwXA8Wqxd
	5w1h2ajTavbULFS6zp5tBX2djpq5TIOLiStFu4o95g+eV8YACUUvyWRjlB0UVhxrbCT1X2niejI
	whauPzml7GHgWsmJcpuIanzek3h0KD7IRhAz0a8Ms5qx+CtW3xJaQZRLlEKKYpEKjrDZOBCb6Wb
	yC7n3J2+NgQ+Wr/RTdvoUhf9266b5tPpH677tw3m/+XhM4kkbAva8V7KRnA=
X-Received: by 2002:a17:90b:384c:b0:39e:5acb:2849 with SMTP id 98e67ed59e1d1-3a0bb576e5cmr8742632a91.17.1790608774215;
        Mon, 28 Sep 2026 08:19:34 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b99e5220sm20891502a91.16.2026.09.28.08.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 08:19:33 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-api@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org,
	Karel Zak <kzak@redhat.com>,
	util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
Date: Mon, 28 Sep 2026 23:19:24 +0800
Message-ID: <20260928151924.2686290-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CACePvbWM8kMjtJbH4vc6Qt=TBZQ-0d-Yj9NOtkepZmtNN3wd9w@mail.gmail.com>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com> <CACePvbWM8kMjtJbH4vc6Qt=TBZQ-0d-Yj9NOtkepZmtNN3wd9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Chris,

Thanks for resolving the conflicts yourself and reviewing it.

> What is the high-level user-visible impact of this series?

Being able to use more interesting swap backends and logic when the
machine is not under memory pressure.  It is much easier to write a
swap backend that may occasionally allocate memory than one that is
guaranteed never to, so today such backends are either unsafe as swap
or ruled out (btrfs, for example, refuses swapfiles that are
copy-on-write, checksummed or compressed).

> I am curious: if we never run out of swap file space on the
> non-offload swap area, does that mean we don't need this patch series?

No: running out of conventional swap isn't the point.  Without the
series, any active swap area may be written under pressure, so a
backend that may allocate can't be used as swap at all, however much
conventional swap there is next to it.

> However, direct reclaim can use both types of swap areas.

In v2 it can't: only memory.reclaim, per-node reclaim and MGLRU's
debugfs eviction may write new data to an offload-only area; direct
reclaim, kswapd, MADV_PAGEOUT and DAMON reclaim may not.  But I think
your suggestion to flip it round is closer to what I want: mark the
areas whose writes may allocate, and keep pressure reclaim away from
those, rather than tying it to what started the reclaim.  I'll work
that into v3, together with Kairui's suggestion to build on the swap
tiers work.

Thanks,
Matthias
