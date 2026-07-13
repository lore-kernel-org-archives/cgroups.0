Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E5E145B3F
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783955781; cv=none; b=lAsYAkFA9LsBnwmPsergabK9f/kWjZQOhCTVwe7u4gjVyU+ZOuuBP5fIbsZBns4WpacgyMqTlr4GwFJo8U9hvr3sfwcUo/JH/Go5ptcOzO+p66RFQYSw/cLDBqFXYovS7zkq8/p7YL4fZTsQ2nnQqMotnFOo2G6gLl+Le3yRCkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783955781; c=relaxed/simple;
	bh=5qE05eB0ZQfssmzd/uw9mL//PrTpjTo+knZ4kAQp2JE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gKwAn6khkstoWB295NHL/ThYr/6Qiym09rT7oCthpdaM9GJMpayBprjLb9eweFac1Ez0hAjvCR1EhFIctsyltDGGa3y7h3TzsjgrhVfunkP9sbEDywzYeeddzA941nk1UC0f9v2Y3NJ8ePyX9ojawQRbxH2puwfWZnKRMm+8H/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9CDWJe8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9CDWJe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC2A1F00ACA
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783955780;
	bh=ojhGJQPaI6nBpFdQttPysFIkfi9vO0mY7l/IBzOlU7c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=j9CDWJe85ze0JkTsEPuafeWzWeNjLamjkpx/a+xShYlJJmvBBQzyaYe/bPhdCEpxq
	 6fY3fYkBAdqHUGJzrcfsi8Cl2aym9oBacZdeDsYjAjQytX8qbLBwjIG/+o22V8AfLx
	 TTt6yF2kE5tMdymbsYB5WVBKroA1syuoNASMQ88wlt7f692jljS8nU0FJzri6XbgFl
	 5IZ2ozFciqdeNU+cLC/FFjtG9m6xhuM2buzoMwjjRW2tNQzLlKjFAd8dRY4PdTT+/F
	 H9JTMkP1IGPKdvvo5Tyx0hmqK7iTELOOZUVooY1Pxrs/lhzNjH06UzToxqri9+bdzs
	 wACYk2CDhjIpg==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9217d13c276so198389385a.1
        for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 08:16:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RruGVkaX6/U+4WMuQczGpwObu6dHD6n69+Mknc0g+2v5Ke3bEhpTM6nNszO3/SwFIkxZMQjQ8mX@vger.kernel.org
X-Gm-Message-State: AOJu0YwCKbMaJmQa7kO5tz6+3w60/sqYg3DS7eWQWqgiynRFk+hAjKAQ
	a5G2XQvllXnst9lUqsqMpg8Rj9jPZ9z2023UNNkyvPZj3n6QyTPfKGGS2il9CHiVUcwU9OAkYzF
	TJJu5yRNicV08zYvOeu7Vhi8urU2Xuog=
X-Received: by 2002:a05:620a:2894:b0:915:7fe4:cac5 with SMTP id
 af79cd13be357-92ef2c37670mr1010736885a.49.1783955779387; Mon, 13 Jul 2026
 08:16:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260711091157.306070-1-ridong.chen@linux.dev> <20260711091157.306070-3-ridong.chen@linux.dev>
In-Reply-To: <20260711091157.306070-3-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 13 Jul 2026 23:16:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xGKM3HxXw-mrtyr5HmwZL3L1QVZ27utCyozqSJr1F0gQ@mail.gmail.com>
X-Gm-Features: AUfX_mz2VOcvpjLP3Tfx3pg46LL6U7YJB7t4mtLV301pvgj_3RVhX_C9g2oKBD8
Message-ID: <CAGsJ_4xGKM3HxXw-mrtyr5HmwZL3L1QVZ27utCyozqSJr1F0gQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: vmscan: fix node reclaim ignoring swappiness parameter
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 11, 2026 at 5:12=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> sc_swappiness() had two separate definitions depending on
> CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
> vm_swappiness, ignoring the proactive_swappiness value passed
> through scan_control. This caused the swappiness parameter
> written to /sys/devices/system/node/nodeX/reclaim to have no
> effect when CONFIG_MEMCG is disabled.
>
> Fix this by consolidating sc_swappiness() into a single definition
> that checks sc->proactive_swappiness first, then falls back to
> mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
> and !CONFIG_MEMCG.
>
> Before fix (swappiness=3Dmax ignored, mostly file pages reclaimed):
>
>     # cat /proc/sys/vm/swappiness
>     60
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 1840
>     pgsteal_anon 25
>     pgsteal_file 1815
>     # echo "64M swappiness=3Dmax" > /sys/devices/system/node/node0/reclai=
m
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 18013
>     pgsteal_anon 337
>     pgsteal_file 17676
>
> After fix (swappiness=3Dmax honored, anon pages reclaimed as expected):
>
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 0
>     pgsteal_anon 0
>     pgsteal_file 0
>     # echo "64M swappiness=3Dmax" > /sys/devices/system/node/node0/reclai=
m
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 16283
>     pgsteal_anon 16283
>     pgsteal_file 0
>
> Fixes: 68cd9050d871 ("mm: add swappiness=3D arg to memory.reclaim")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Reviewed-by: Barry Song <baohua@kernel.org>

As pointed out by Johannes, the Fixes tag should be
b980077899ea.
