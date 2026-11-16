Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794859489;
	b=tw8Jmm1GM9xOwwdNYgQYFpDlMxzBXSTOkP9pYtCTiqZ6sdlrjUdbRTBQVKkwSgw4SaKt
	 dj75z/N/P3nPvy4BH9eaBTgWfGS+dnBa7HYq1/5PcXkiQjK0E7wPy3UCVoteutnDhuD5G
	 A2UaXOSH2Wv5p/CyvJgePo3UNm0UxX71wc9FTWEI6jv9+P5AjgxrH8lD4h+ajqWBpiGGQ
	 tAv77VtF5MEN9NUjy/xkmDgxRMUDeI/+SXd/kLeBmDIX+5gNMzRnwmQS4kWOMclXUcgzk
	 pLuGWwHOTllEvkiGUKa2sdMsHif+HqWzAAXnpGzQ9U/v3qnELiLq/feBsiGLQwJB59Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859489;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=l1O1HZxpH9G+QLlqP5hHi+3OIw9Mj+HNTrQPUqx/Be4=;
	b=rbSXh123mlqTS884byPjDDsSIZBCucHSxzgXD2QXle/aWjGkgqUcZLOaLIW92hg7w3ai
	 9tLKXuP/wnNykWeIyBXKPfztBGTTKU7JSNzxx0MpqUN5N69/DNaJ2XCkNoitEYU1Q1ySD
	 xhGE38011HEYHuaI/lSbI/zTaLLnI7efK00vTYgpSl5wwYYgB+PGTUPgpZxsfhjj/TgHu
	 KAlUSgy1zS2M/frjJ9P1YobrKdC3mC8axVBoT+ao0Gwy2KWfppSt/3BCNVc1WAGn6+MbD
	 qwM+LlYRw7HbYa+iS2FaJWhXJLLWUHgS97BNLrSFGGXM3MzZ8E5jNi6ovk+f/yFR1Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkckWrFr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECC8606A31C
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 20:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkckWrFr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3A01F00925
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 20:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794859489;
	bh=l1O1HZxpH9G+QLlqP5hHi+3OIw9Mj+HNTrQPUqx/Be4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BkckWrFr9tlTlp2/HgpPCsgRrHm6mXU8p99lK6aelhAkoxLvDvNuiWQziNMeGdXAj
	 +ORximax4Kex8zGBcBcLWA7p7CKV9BRI0/E6mJzfI5pYFuVb+PwdtAO/JsyonyJsW2
	 H9m1Fi9w/PsSeALr7xQ6r4VNCuGhDwQctkoUf+hQ2LeN2Non0dX2OGoMlAUF+sfoFj
	 kpV4XCB/24G1JAgcwXOpFi2PSO6i0vfEAYSHF4Y4E+aXIzKeh+z2RtfEq34pCDaTDX
	 Ono/Fq8vnf1NZz9yx+v+8za/umYNM19GASNZEwWrouJqhd9Gv94SNGqlCiEdVQHum5
	 XP0GuPlE40L1A==
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-77bf892b496so1173828137.0
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 12:04:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErErK+iI+u494RmnK5te5ip/dIW0ABoi9N/MeMqWbegOsgRSlgP4Ibf6fAD3QM6KBo3Tr108A8Uq@vger.kernel.org
X-Gm-Message-State: APuU4Z97kMyu9lZ07jGUevn6IaeFj6gIpWabI6ZDHXqE90IKEGNjePul
	yiSAS8kdSb53DBRhbZpBdVR7qg6hU9YQ+mPJDN7WhI8SBWgHCLmk9UbzMHWGN/94lY0Qwqw4297
	sQxp/uWrpq2OXL5IjLNa3s7cscsJUIZQ=
X-Received: by 2002:a05:6102:3ec5:b0:7ce:645a:13a4 with SMTP id
 ada2fe7eead31-7d64d6f7957mr3166761137.20.1794859488504; Mon, 16 Nov 2026
 12:04:48 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106235904.1092712-1-tjmercier@google.com> <CABdmKX1gdOH8R6qyjw6XN5VdpAZKVR8NZ=R7Y9Db-BEhUrX-1Q@mail.gmail.com>
In-Reply-To: <CABdmKX1gdOH8R6qyjw6XN5VdpAZKVR8NZ=R7Y9Db-BEhUrX-1Q@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 17 Nov 2026 04:04:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w4rNzvaOK9f4D56opW7TtUWL_6srxJoyWXWDzhfgm4ug@mail.gmail.com>
X-Gm-Features: Aa3M54q72RthsGLTye2AqvS3UPHJXHKdMiJkUDrG0cZhY05KIR-RudBK2Cdn7-Q
Message-ID: <CAGsJ_4w4rNzvaOK9f4D56opW7TtUWL_6srxJoyWXWDzhfgm4ug@mail.gmail.com>
Subject: Re: [PATCH] mm: workingset: compare shadow nodes node-wide without
 kmem accounting
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jaewon Kim <jaewon31.kim@samsung.com>, 
	Jaeseon Sim <jason.sim@samsung.com>, Youngchan Kim <ycshark.kim@samsung.com>, 
	Dmitry Skiba <dskiba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 1:40=E2=80=AFAM T.J. Mercier <tjmercier@google.com>=
 wrote:
>
> On Fri, Nov 6, 2026 at 3:59=E2=80=AFPM T.J. Mercier <tjmercier@google.com=
> wrote:
> >
> > count_shadow_nodes() limits the number of xarray nodes holding shadow
> > entries to 1/8th of the pages that could be using them. For a memcg, it
> > counts the LRU and slab pages local to that memcg.
> >
> > With kmem accounting disabled (cgroup.memory=3Dnokmem), shadow nodes ar=
e
> > not charged to any memcg and __list_lru_init() makes the shadow_nodes
> > list_lru non-memcg-aware, so all shadow nodes of a NUMA node are on a
> > single list. shrinker_alloc() falls back to a non-memcg-aware shadow
> > node shrinker, which shrink_slab() only invokes for the root memcg.
> > count_shadow_nodes() therefore compares every shadow node on the NUMA
> > node against the pages local to the root memcg.
> >
> > When most tasks run in child memcgs, the root memcg only holds a small
> > fraction of all pages, so the shadow node limit derived from the root
> > memcg page count is far below the number of shadow nodes on the NUMA
> > node. Since the shrinker has seeks =3D=3D 0, every root shrink_slab() c=
all
> > trims about half of the "excess" shadow nodes. Most refault information
> > is thrown away, so refaults of recently evicted file folios are not
> > detected. Refaulted folios lose PG_workingset and the workingset_refaul=
t
> > and workingset_restore stats drop.
> >
> > In testing on devices with kmem accounting disabled, moving tasks from
> > the root memcg into per-application memcgs dropped workingset_nodes fro=
m
> > ~37,000 to ~900 and raised workingset_nodereclaim 4.6x while
> > pgsteal_file rose by ~12%.
> >
> > When kmem accounting is disabled, compare the shadow nodes against the
> > whole NUMA node, as is done without memcg. Behavior with kmem
> > accounting enabled is unchanged.
> >
> > Cc: Jaewon Kim <jaewon31.kim@samsung.com>
> > Tested-by: Jaeseon Sim <jason.sim@samsung.com> # Galaxy A18 LTE
> > Tested-by: Youngchan Kim <ycshark.kim@samsung.com> # Galaxy S27
> > Tested-by: Dmitry Skiba <dskiba@google.com> # Pixel 10
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
>
> I'm guessing there aren't many other nokmem users?
>

Out of curiosity, is `cgroup.memory=3Dnokmem` commonly used
on Android devices? If so, what's the rationale behind it?

As for the patch itself, it makes sense to me.

Reviewed-by: Barry Song <baohua@kernel.org>
