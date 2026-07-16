Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7BF231836
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 07:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784186059; cv=none; b=Ia8a8GMgAxgMiGZNJPUaj+ZJrv9kWMc1053vGHSLafAUfrBj9ASjnuJkSKBy7ZLAvkbMQpaF5qW6gC3b2S8lYxarYBHZ0mog0mk924MuKMy2uE6MaA2slAD7mg/MlCi3c7RBQqfgBIsA0P1rakdf9kwToKmHGZ+zije8XgKWsqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784186059; c=relaxed/simple;
	bh=sg38uHEqZ0BVWcylcBxSIvhlKyQwVtyPy+91P+Bgcko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hpd66yGD3gxbOXLdO7XvnO2G4qlDztx/JCQ20HhcBs/iYmmAXGtyeN2H1oHUBf1tVV8ezh8oItI/PzAIo3bj+LIK1yiblSnSmDfU/1WnG2ie7QHKiLMW4F/eGzCnz7BqIEHB8DxWiNrzOwrjF+TQusRqvru6ZFdg+j1zB90o+j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HN9/r0sB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HN9/r0sB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806ED1F00A3E
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 07:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784186057;
	bh=sg38uHEqZ0BVWcylcBxSIvhlKyQwVtyPy+91P+Bgcko=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HN9/r0sBx/ZTjGEU7GCn3szzI49aJAz/nKsL5OngGfeUzG7CvQCIZeVunBkNcFXbg
	 202i1dGKW4tIqsQxbBVOf57EQrSsqDTUB3+NbLnCMFrxfsIgTjSaFEKNR0gGj+DgR0
	 PcIzbqZr2S7BfvxKk7oTE+QR4KFMdRthkYInwuGB8QyADUS5/q/ELq8gMRiaVRxJrf
	 rlOM+X4Sjky45M5KIKVrX4eYuXbvoVoQTrjT8LBcbfx5xewIqLwf/3Tls+oI6T0lOo
	 GIwmkh5OL1nPzpsak7bpsQFu1zRZh0bEPlh3qFhv8tljiwgA71aSAckj+kJ5oSAVe8
	 JvgvdXnIs5SVw==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e512a9a6bso328378785a.2
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 00:14:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpVxOL7jA8j6aNT9DQ543My87GpbQhlcCYUhfXq8VySC91ERDZasHQDDsqX6WfSN4exqTOpcZBX@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0TleiEfAUg2OgjhCY9van/b42lt+0Nvnk/VHLjxdT1v1iHIYl
	lL98AWtEGDJBvk4ojJZ0gD8UyoNN5o53kJqElo3xK1ZQowvrlvnvq5CwCMkybZkhSxhhPUn/RsS
	kLZk2kP1dAXPNnkCiBwvvAIY/exRLtQk=
X-Received: by 2002:a05:620a:3729:b0:92e:da7b:561b with SMTP id
 af79cd13be357-930868324d9mr1065821985a.19.1784186056603; Thu, 16 Jul 2026
 00:14:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716031729.1064007-1-ridong.chen@linux.dev> <20260716031729.1064007-2-ridong.chen@linux.dev>
In-Reply-To: <20260716031729.1064007-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 16 Jul 2026 15:14:05 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yYeLjgn5xRqfOeXiawg3WhrU3b1JMwpv7AQzOjjW7C+w@mail.gmail.com>
X-Gm-Features: AUfX_mxPZ5ESvxPIHvO4N3xU3Pi4Se3IrdnfkVFw-dLOB60tOa6S2kbk4GeY61s
Message-ID: <CAGsJ_4yYeLjgn5xRqfOeXiawg3WhrU3b1JMwpv7AQzOjjW7C+w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] memcg: move mem_cgroup_swappiness and
 vm_swappiness to mm/swap.h
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 11:18=E2=80=AFAM Ridong <ridong.chen@linux.dev> wro=
te:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The per-memcg swappiness knob is v1-only; v2 always uses global
> vm_swappiness and ignores the per-cgroup field.
>
> Both mem_cgroup_swappiness() and vm_swappiness are only used within
> mm/ (memcontrol.c, memcontrol-v1.c, vmscan.c), so move them out of the
> public include/linux/swap.h into the mm-private mm/swap.h. This keeps
> unrelated declarations out of include/linux/swap.h.
>
> Guard memcg->swappiness with CONFIG_MEMCG_V1 as well, so v2-only
> kernels drop the unused field.
>
> No functional change for v1; v2-only kernels drop the unused field.
>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>
