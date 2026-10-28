Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793219755;
	b=cZuLie9KsOC8JIZ7ZlSTHi+kB4EmX1wgnR+8Grfn/tKe5Uxkb5vNXCWS4IYlbhx2owFQ
	 ryPzXKnE9b19Dd0EnorthXnsFFhe1U82KcpbeRkfC7AJk8IakuwCoYcbXoiiIDdwzWFFp
	 bFoODeuqkl56CukVN0Oa00JgJXpuJv0CEuXE6RomqnYt9//G17qD6z8gHdOkek5Kz2GwE
	 9TWPT5nzwjLKDsglANdBHBihvTqFY9vKzOyDgTuFfcOXb/PjMXx3Xgr+P6XrR6OVelZfc
	 h15vo7o8NWtEm/ae/G2VspTWV+TczQ8KA15TnAx9Ts7nMIsWmhMBbK+G6owJLPaCLCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793219755;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=4QAe5SGrIPwZ0tTzn6oh4wSWtXWrJvkc6TieHYKerj8=;
	b=PSUZkkn+2YVqMqHv5Fv0iphaU7O0n5a01LU0LRDbFo2d55FChkUrvDEATi+qtaCg5A24
	 J1+HqsVgYy9P2OKm8sQgddJEDETyPzn8AHj1o/FRelAc/3w2f5dum5hjb0qzY0teHWx0L
	 5j7MKJmnvRXNfp98b1ipYmWhJMknComamintLLtaALKnTzs9F35+k64MQnp3ZagcCwy5v
	 WIx7+DULYtBQwjRf2UJu4RR6ElUf+h/5FYCxn7JRPcwpvln7vGO9qVNw4K3NNNKX6qXb9
	 Pu4axOZKa/nnpNeedE+R9yimd1r8Q7bEnQ6abEMBwmD/BoFAZVpOauhHcixxa3lwtYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OjMR2woc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CCE606A31A
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 20:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OjMR2woc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8991F031EB
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 20:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793219754;
	bh=4QAe5SGrIPwZ0tTzn6oh4wSWtXWrJvkc6TieHYKerj8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OjMR2wocoM7Ox2qkxXBhUairznGYjwxxr+hvzFGtTgF6uMo9XQ1Cp0IajDgW9HZP3
	 0iVS7OpQC+B9dgU07dSzT7xN348tTAemsVTWhywiJN7fBeX6NliTGmrcukeQlf5td+
	 ObdnFDlHTjb2Ht4zhXAO9R12oYpBOy0QPgLEVI4bY6n9+Plys4IkAAH57manEN+vY5
	 CknM+ZKT4Pxf+cMu5QpPHFFFhi99hl9xoS3ALRGpcMAqOho/PtYRZyjfJy0Kmols1h
	 BKzasg01PyuL5ExBDmP4Mo7v+DQhCfgbMGPPRCGPZZOfoKlTlk7tGuq+AckrLCiU/C
	 FQMhpBEExti4Q==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f079a63b8so126113585a.3
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 13:35:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwLnnaocGi/BhIj6Mi1EjE0Bek419H0/GjvY1t/Q8lmQ4z8iHjRsl4C+BZDcPjXZCol+Qgm/+vI@vger.kernel.org
X-Gm-Message-State: AFq9FYLZhdE+W37NN3VT6Lwq3AToiPkr6Up7NFXebILicR1LJwzgw5xj
	uHWZqW0K8QTkbgbHHVbkdgKBPm4XBxhh3zEgk5hTn72qP6aJNxYObywKI9Mn+Zn5j9Ee4/JeNRg
	kQwbckRWSUZJir3IC1SdJCWNdb4sk6xY=
X-Received: by 2002:a05:620a:2728:b0:93a:1048:7d2f with SMTP id
 af79cd13be357-94408cd0363mr536255285a.41.1793219754031; Wed, 28 Oct 2026
 13:35:54 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com> <20261028010611.3929937-2-tjmercier@google.com>
In-Reply-To: <20261028010611.3929937-2-tjmercier@google.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 29 Oct 2026 04:35:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xGy4O0GdU1xwVURjTZ+upbZYGFsKwf-ZjKKkntOiwtHg@mail.gmail.com>
X-Gm-Features: AclHuK-kz9wxt-69rhz-Vpf7nKwcRzuuxuV15spsnkGsOFzx8iPMuvTrFEMb7zA
Message-ID: <CAGsJ_4xGy4O0GdU1xwVURjTZ+upbZYGFsKwf-ZjKKkntOiwtHg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online() checks
To: "T.J. Mercier" <tjmercier@google.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 9:06=E2=80=AFAM T.J. Mercier <tjmercier@google.com>=
 wrote:
>
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> move LRU size accounting on reparenting instead of copying it"),
> mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> afterwards. A folio that is off the LRU during reparenting looks up its
> lruvec through its objcg, which now points to the parent so it is put
> back on the parent's LRU.
>
> As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> when !mem_cgroup_online(memcg) is true, making the offlined memcg special
> cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> code. Remove them.
>
> With the get_nr_to_scan() special case removed, an offlined memcg that
> still has stale effective protection now has
> apply_proportional_protection() applied like get_scan_count() does, so
> the MGLRU and traditional LRU behavior is now the same.
>
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>
