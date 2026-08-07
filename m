Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1E42D2397
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 23:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786145207; cv=none; b=kyhprzw4B9lvQ4i4EsK+EoDVjXtV61Vqs40XIUJVWjJUicx4/PeC3kpp+9dgXYVv03v7RN77DvJ0ep+WtX97tFTHGbSC1gy7Vgc/C2tZLnDaFFpV3W6EiOi24/D4DBI1k39weDTg7s8aS6CFL9oqRABOwGo/VzCdDB0Y9C1lWpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786145207; c=relaxed/simple;
	bh=i4cxxvp0f8cy854qggvftBeZLtacFW5iIDEQ/J+cwkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nHvrLILGynPGavdMVqzTWDO0z9Pevg61u3Z62m8I6kzGr6ALdwDw1Ss+DTXuFTcGH3cXT1cd4J1TrX+HpklfVnXAkiIptRLUQBGagiOK2J27gCuZ+PIstHozJyWf2qy590bhSFrEeADItC0K+8hS364wL/zWh5+E1307Sxq0PaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPCm+Yt4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPCm+Yt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0E81F01559
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 23:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786145206;
	bh=i4cxxvp0f8cy854qggvftBeZLtacFW5iIDEQ/J+cwkI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hPCm+Yt4Vch5BSbQ0ClvEdx2L8AV+Rh6Da8o+gwueR9dldOfuvXngqs4keglQl8OR
	 u7RWoO72wuF7YIYPC6ffVgLfc5FDc3BKaPuUv52oQPKS4ZaJVYVfrI5vjN5jSlD6EL
	 DZi7V34+9toqGMXqvaG7PXsAnRacOOw3ZE9sD0g2n+7qrDQylkaMM3E9ct/OIm50ao
	 aRyTscTK/89ZPH5ZT63xlalYGAD8aOIYK1zRS42B6hx+XqCMw1cCApzjL8uZ+pVPnk
	 P22RkGoBQOJaucsY1oXieEexYBjvdngnk0KR5PdlZgBf+5zkKbtPz6MuEyHJNL82v3
	 9P3Ru7YX73FJw==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e7632b193so5453985a.2
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 16:26:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrU8NPQgVgoo5DyChN286SGi1+EUtEpsDcVE7C0FRqgEwmF3SznykERnkLaROuzBnOSGXI+Sllj@vger.kernel.org
X-Gm-Message-State: AOJu0YwGKB5JSs9NjfpXJBpD5XMdgoQih0cq/zqlA2ShNxOGJqk/Bd7O
	EJbZUb4f59RpiaTSsbbVJ4uhgfUtwWBM6UAqMfg9KEWjWlh5cWKjfY4KrKcRbR9O+o5OsGzAiEb
	5xCX1Zmrc2pz+bmfpX2eX/uXWbh9o4j4=
X-Received: by 2002:a05:620a:372c:b0:92f:199:b035 with SMTP id
 af79cd13be357-9367973f161mr458105485a.3.1786145205525; Fri, 07 Aug 2026
 16:26:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com> <20260730122304.2496440-5-xueyuan.chen21@gmail.com>
In-Reply-To: <20260730122304.2496440-5-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 8 Aug 2026 07:26:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zAWOQXzGv-4SAmCsWqDtpJNuZ=SMcX2e7Xp0QEU2DFBg@mail.gmail.com>
X-Gm-Features: AUfX_mwMd3f5s4Yz6hb8nRTt6VgnEA6ch5mYz8OPOzoAMZHEcwXwwG8U9wt5VXs
Message-ID: <CAGsJ_4zAWOQXzGv-4SAmCsWqDtpJNuZ=SMcX2e7Xp0QEU2DFBg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 4/4] mm/shmem: split large folios only on -E2BIG
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 8:24=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail.=
com> wrote:
>
> shmem_writeout() currently splits a large folio on every
> folio_alloc_swap() failure. With the refined return-value contract, only
> -E2BIG indicates that splitting might allow smaller folios to be swapped
> out.
>
> Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
> redirty and reactivate the folio as before.
>
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>
