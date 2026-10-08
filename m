Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6993E4ED1BB
	for <cgroups@vger.kernel.org>; Thu,  8 Oct 2026 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791474356; cv=none; b=MIpHKkWBpfslpMw7xbVVeSUiePAqJoFLcBUixoSZmeR7dhG4C4E5XYrV2ekRgOxjnvjsINxgz2zGiF/b03AePwI4O1O4FpBGwp5gTprSXBFKkI8OvyAXwprjmRo7A/w1tf1MBa8p+I66uFEBY7yW2S0E/HvFLOHdJLTDMMPjO9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791474356; c=relaxed/simple;
	bh=IZdUbf96G819WDGQw084g+PCbAqnSBDJnT243HvYIcI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JMrftuY1m+/XbYbeZ1dYLLRWzmYKcK/QIK2QC6fODRg0rW2bvYzl+NvCl1UVKaa5tnJ5ro5pxssFolWrZNHpd+8U+xP/RxSKpjsOQViIMoRZ8wE2bhUqibCb2iadZ2/BpzxroeJGXvev+mh3O13TBYAz9EAfKR9WD5ZnA+KBd9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrIh4yf9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrIh4yf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DF41F0089D
	for <cgroups@vger.kernel.org>; Thu,  8 Oct 2026 15:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791474355;
	bh=RMnHgdALhTIdH335SS1JWqGcsAemorh3HiZSx2sD/OE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lrIh4yf92LgskJW6M2gmVwbxqg1gKrETOrjuH7gAwHETn02NnFkGag1WxWSWjIN53
	 FdSxRgEBV7J8yKwOVJwYNBokYkXIAClJ8UUFhNfwtj8w8JPXmq6GmK44zvBOz1v1X0
	 QwXn0BvGLuOl5xYt0rfqXgtt/lBTzQGT9GEGP/XfO77f3/XUjzxlJzP2u6k4wbJdpU
	 oNgda12bKpdtgJu3OwqHHNG86maZUIpQtaCeMx9zT3So+YVZuEKY+nzP0gnbzRNyYX
	 0YOtqBfJcBrSPQdbu/78q3rM4oI89cG9CxzNHLIb7/c3UfalPabcrrKyWGM36RveE5
	 CafQ7DMKN1F6Q==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93e027da22eso219057485a.0
        for <cgroups@vger.kernel.org>; Thu, 08 Oct 2026 08:45:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByMh17rxfJ25Zl5/dDNKFoTW0ZI0CkN8MYz9v9pQDlnDkyqOjVo91SV0Qld+5lO34eGefjSOGeO@vger.kernel.org
X-Gm-Message-State: AFuF++mqdVtR9hxAqogXltA3I+1AHk2Abh391eWG5NViAut5sQZjh7v8
	F5WrFw30lepBSV/f1FCZBG1SDqqpXChsMcGFJEPfySxQtJ7/6Gyy/X4epIcCXmkMCuJZT1AJW1t
	T0YOCzZ56Ndks+x7PouVRHdgJDkJFSOY=
X-Received: by 2002:a05:620a:6291:b0:93e:9808:8d78 with SMTP id
 af79cd13be357-93e9b89cc16mr1090696085a.82.1791474354476; Thu, 08 Oct 2026
 08:45:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789096175.git.zhuhui@kylinos.cn> <2ed42f96aca124856ea30f774afb55cbe6d8ba58.1789096175.git.zhuhui@kylinos.cn>
In-Reply-To: <2ed42f96aca124856ea30f774afb55cbe6d8ba58.1789096175.git.zhuhui@kylinos.cn>
From: Barry Song <baohua@kernel.org>
Date: Thu, 8 Oct 2026 23:45:43 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wcheb6SU+rLvytyYKTpgM+KJX7EkVdyHtrte+SZ8y+PQ@mail.gmail.com>
X-Gm-Features: AclHuK-9KNuqZwVP5bNEpa-Kkkx_AVc7sgo9C18bZtSYiBs0_n5VK9YJs40_Qi0
Message-ID: <CAGsJ_4wcheb6SU+rLvytyYKTpgM+KJX7EkVdyHtrte+SZ8y+PQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm: workingset: use lruvec_page_state_local() to
 count lru pages
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 11, 2026 at 4:01=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
> With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
> which only the classic LRU paths maintain.  MGLRU accounts its pages
> through __update_lru_size(), which skips that array, so with MGLRU on the
> four evictable LRU lists are always seen as empty.  The shadow node budge=
t
> (pages >> 3) then collapses to slab plus unevictable pages, and the
> workingset shadow shrinker reclaims eviction tokens almost as fast as the=
y
> are created, losing thrashing protection.
>
> lruvec_page_state_local() reads lruvec_stats->state_local instead, which
> both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
> race this re-exposes on cgroup v2 is closed by the preceding patch that
> redirects dying-memcg stat updates for all hierarchies.
>
> Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the nu=
mber of lru pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>
