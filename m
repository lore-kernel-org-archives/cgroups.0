Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D413438A1
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 06:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790319346; cv=none; b=QcoKs2A9L0QQrAmMiSIbL2aHGhtP5cc1T9/GGBwRWAl9v+v6fnXETNGcJFOzbKzqX5AaTMNcy9aBxMHCrbpIJREJFYQgY1sHbi18xHyDGm3fmnLlexAJn4imHoVP3msnV8vt6TF2gG/R9svS4TD7aNKmCmSKXYEGlauyNN4GSRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790319346; c=relaxed/simple;
	bh=tx5lnhA+lxgkmkf1DN+MC9Y5ctB2DhEwgjJwGzsdzag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOM/fEH8TSfhzuREDgvqpbA6ejZNPvXPIN0TZ/nENiDuLjKFkK4lWvjqxzKNDgcmH9sfIxdaFrjArQtVxxhZlo/ON/vwcNMQ2GT45Oep5D9f/grpYG6aKZWbJq8KY3+c+qZzZHjQxTplg1/VkmMvbFy2bJtL1L6S+sXhCD8vEpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=luAfLzH7; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="luAfLzH7"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccd5cf02so331431a91.3
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 23:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790319345; x=1790924145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tx5lnhA+lxgkmkf1DN+MC9Y5ctB2DhEwgjJwGzsdzag=;
        b=luAfLzH7f6/6J1iDo8xZEbXyfItnFfrYBESMykfpD/YxsqOzMvxR04zQGQLE+QVvZj
         73pZsBDV5h7cCWWl0SyPYpkuOZVr4H6/jkxGfYqIJGl911pmyeooHVrMZithh5WV0YY/
         rWvY2wedCpvJaS9EeuS49JtvCtM7aJ0w6KmZ7VcicdH0WORx4IjGt8Mu2bLCT0z+JosI
         l4kRvprLXHIQ3a+wLSN2W2FvQlxAA/mkBT+fWcn0y4pbGH/8NpW00+n76ZS63/njaHzf
         oan2LyEY4mK4gSOtFIjiXcIlM/WdkJSGkckQtJUCKF7ynXLQkfBoIdNg1vbH+N1zA2sx
         I+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790319345; x=1790924145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tx5lnhA+lxgkmkf1DN+MC9Y5ctB2DhEwgjJwGzsdzag=;
        b=MVsImfDPtQlFWy92JRL6ugJK1HQVq3LVLP8Hlik6xMEJz1iK3S2TI0R7T5iYfl5VJ9
         2hBfepjs/SNVjfpou55zYNYRMNTUvW8fYJOWbVAoheWD8AqCGMRCyBWCnT6Av+JULkoI
         ZTn3ygc40LQ/4abIZ+RYwkTY2xBeK9oS3EOkbPtQJURwyx/5/wyqt18RvQD4uXeG2As+
         0zv1Gg9U0dU3h15RMizx+PhqCFtUSVvrIpHVwbMvZz7XJUA8M/Y5u/pVeUB3s+cCByzl
         M9octqi+Ns21t6ublb250a3pT6Axq+04iIS6WUFDY+pxOwxz3eR6p444WPcGWjtJVwld
         2HDw==
X-Forwarded-Encrypted: i=1; AKwUvByng7jGSsRuIJDC3eCdiXczzSDy/fXLrfeYwgupzopJRG4NV/xoynnDtcNm+YB9CSQv8ZaIIuqk@vger.kernel.org
X-Gm-Message-State: AFuF++nD6WUYOYa772PxKdF6Bhg4WS9LHUyeS33+zLHqU1BTuPi88NEP
	rAoFVlfE/TIAyXN2SQCL41tzKGZRcavhwbkCV2nY7j7neaiAYwqqKphe
X-Gm-Gg: AYBFou2xGjWonsSU/qgchMtAuknDJwfTh0mkm+S9yadp0uhlbuevIYso+yS0w004Tpd
	zw6l7UOJrwYyLAxQx3HnqaNKXbY23iD9ETVwVDNtwHpy+RSap8ENMVNk/Lb07S/QzSCoadSYnzw
	heXTcU6UEkMYBNFFcwe8NIhg8bwVGtDCp2lvZYiM+wSLJslO+rvXMg8X7wHWIB1utSTdPxgqkkO
	jL2sdsIJOEiKeO/C/5Bp3V6YBdZWRNhYfLxHudtND1M9cZaanNyIAVs3WWGO1gcpJ15zvGNZDEC
	nDK3bnRAblg+pLtJsrys0XSL7yi7nZIdiYuUbgrIB05izHj+NwdeLhIFubfW1jpxKKZcpbnT39O
	cp9J695O2sGDQTkBqA/iST7+qWwQIAYLnoIJcYy1RbyPkgHt86nli+YXoxA69f+h5Y+s0FQBm/N
	b9XHQktbBQ6jOrBzYsiMZtVuNNfguMjRZ0ymFFzcWRQcmYIrK/KCFE7EwhMnKcb7Cn9RdVvkeVF
	sGUWNijr1lIpyjQp0C3xgryG93tl9RjV1o96CdH
X-Received: by 2002:a17:90b:3985:b0:39e:6c69:f482 with SMTP id 98e67ed59e1d1-3a098d5e61fmr4310895a91.65.1790319344531;
        Thu, 24 Sep 2026 23:55:44 -0700 (PDT)
Received: from localhost.localdomain (vmi2317699.contaboserver.net. [85.239.239.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998e2bdsm2718096a91.13.2026.09.24.23.55.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 24 Sep 2026 23:55:43 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Youngjun Park <her0gyugyu@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	joshua.hahnjy@gmail.com,
	taejoon.song@lge.com,
	lianux.mm@gmail.com
Subject: Re: [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with per-cgroup selection
Date: Fri, 25 Sep 2026 14:54:57 +0800
Message-ID: <20260925065521.36340-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arQJIjzE0BlUg0CV@cmpxchg.org>
References: <20260916183437.2946306-1-youngjun.park@lge.com> <20260916200434.GA5784@cmpxchg.org> <arAHu_BD5oqpZJER@gmail.com> <arQJIjzE0BlUg0CV@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Sep 23, 2026 at 01:15:14PM -0400, Johannes Weiner wrote:
> If you can think of a good usecase, memory.swap.prio.min would be
> certainly a natural extension. But we should get the usecase laid out.
>
> The requirement to punch holes is the one I can relate to least. Why
> would a cgroup need access to good tiers and bad tiers, but skip the
> middle ones?
>
> This would seem less like tiering/hierarchy and more like flat
> per-cgroup swap pools but with obstacles.

Hi Johannes and Youngjun,

Sorry that I am only joining this part of the discussion now.

I recently started helping carry Kairui's swap queue work forward. Our
current v2 is here [1]. Youngjun's tier work interacts directly with it:
v2 maintains a device queue and reader for each priority, while v11 makes
each priority a tier and moves device selection under that tier.

I did a functional integration test of v11 on an x86-64 host. The tier
mask, fallback, same-priority device allocation, concurrent allocation,
and swapoff smoke tests all worked without kernel warnings. This was a
zram integration test, not yet a real multi-SSD performance test.

One result seems relevant to this discussion: with a restricted parent
and an unconfigured child, the child could still use the faster tier. I
therefore agree that an inheritable memory.swap.prio.max looks like the
cleaner first cgroup interface. A hole in the mask worked mechanically,
but I do not yet have a convincing hierarchical use case for it; it felt
more like per-cgroup swap-pool membership.

For the queue integration, one possible boundary is for the tier to own
the queue/reader and for the swap queue to become the default per-tier
device allocation policy. I would like to align this with both of you
before changing v2. I will also continue the real multi-SSD tests.

If either of you has suggestions or specific test cases you would like
to see, please let me know. I have a few test setups available and should
be able to try some of them. I am still getting up to speed on this part
of MM, so please correct me if I missed some context or got any detail
wrong.

[1] https://lore.kernel.org/all/20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com/

Thanks,
Lian
