Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0393DC4A0
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 06:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789626606; cv=pass; b=EWuWPGohKJvUs8unHy3En9GYXrSZwRf0Hfv84JcO1zmgWV8lBocCiAMERIL/9uvD9xLkBwoHv/AoEy+HBID2dRaxdbKKszDiRQISTJTrkrBSgd9l1yQbTrTM48riSQMRQNitM1PG0E8wKl36znHaCcZ0N1AJM25L9XsC7ojJbHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789626606; c=relaxed/simple;
	bh=14DeJiHDqVDuShiB4b4utgOdPR8celAz9YDhj3X9wIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pnEBlYswzw2vFpW/+V0cpyqsQu3CHBCTQ60r3n4eK6kdyu2gmsCT9e+yg7/Oa/0vNjypwKGV6pJ3zufA5k6OpPQoIKtMmP7J1repoCpd2VKluWjP5/rLszmAoCnGSB85shu1v9ffBQ8GfPyRArRZkT+dkQ6sySu/WqLOF/8wcSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dBZ6WhxE; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBZ6WhxE"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469b355ffso327937b3a.1
        for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 23:30:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789626604; cv=none;
        d=google.com; s=arc-20260327;
        b=rSecevT8KdLIWQEN9wV6+Ym6fQHejyShQgDWPtl4PiHf18BSQOBILGgdvJdUowWguq
         tGX5lu+5uOeu7lFwtzPNS5q/RtTRI1vmpKILPZumUxG7ngkC4qsoA+Ae2pWlR6LRZSaj
         nbMVMGZXPrWzaJWVah/ZhXcypRIX3AgcHqnbH7nxbdw/lvFCKJMmdpRPJT4YYEk70J1C
         /6AHcz5SWppbFrntej6kX1msDlvEBBLpzj7YRgpMxIwXFSPKAwl0xc6c8Y80yyIGPPy0
         Mjtg00vMQhwTNUr7bEjdaT727YC/65Cn6/Bxc+KANHFwuSxlcryfDn1cJ6z947IZkYYW
         8Xjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f6s3jd19IN086xpWWaFW+yKBtO38Ikk4W70kReBkn/M=;
        fh=TcnyuS/HCTOiq3o2o+7eSzstYhrfDAQBlbpnJQu0XTw=;
        b=cbzQsJ0r6ui9kjGmK+1Nc9GAnTnSlL/8V4jkMW5oQ60f+94rYAL9BeNBzNeKzN4H+y
         jpZfGb2uzCWY2F27aUzNRXZJroG7bZQQh7NwFDRmpZP1/2OtPNI76DbP0mizA43JOeAg
         hGk/mm3fcm2HDce5DmIADsRsEvAasLfyWTO34xSwLuNHSzO7PTwqqXFRfbuyLYXnLj3Y
         2LUgAfw8d430Be7kmB9ut/DF2YfynXvc4ba+HlX0xjyoyPyKV0fLPnGw2GzLwnABKs0s
         cgX3TEpiCeCpt4EabHh1DDG66cyNMsTA3rKpurs5gr/Et2kTtqceVqZFUKugushuBdPD
         rBGg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789626604; x=1790231404; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f6s3jd19IN086xpWWaFW+yKBtO38Ikk4W70kReBkn/M=;
        b=dBZ6WhxEMxhEERov8yQOsmoBtnvBzuxjW27HcY/riElgStvbqhPgBUh5L6XJ7o4V55
         wSBTfD/stwQ6kjjKNlMb73X/Va57vlB2DvbKBcTLJdVcKqaGl+ivOmX5UOvgkGIVMDKd
         k1wL6qHVc/pMqIJxpnzwTiGFDl2/XXI2o7SgiIE1vKsVZMJ04xTNGFGv7pxn+udYmR+h
         CM98qJKjPJjwURt75dRZsrMtVKcszKj923r6PC7msP0aYBxePidewRDk2Ep+9XAdp+9+
         4Qt8atCwt9yEmQXSZo7WoEZ+FlpM4CvgvcNij9rdi7INrhHgjkSOWumdvG9uteBYuloL
         e3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789626604; x=1790231404;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f6s3jd19IN086xpWWaFW+yKBtO38Ikk4W70kReBkn/M=;
        b=nWCF9L6EOtcvXKGrp9LC1N7X6p+Tjv4Tw4wYAPV4lp1u5+ThQ2e9LUHAq0lICYL5h2
         iPvMute6uGuacYrks3p+e85KKVKOL0n1vLggBDhkiIdeVbxt00aYAsMoL+QDTLcMmlzc
         QEFFAWNZx6iFaKu/HH7z6bEt5Nvhf70B+AV0gzw9miKWJHud7Gtgnwj0Mj5HqcgySh+I
         Udjv2HfBqhxftqzoPqsruAcADqOS1JJ3EXs97d/A1pqO7wEct7FcS/b6EmdEEiHPWFee
         hpce97KtgEpSLjOVLdE/JAWKQ5jCA3MenXwsLiz0LyKWeytb44jFZWhc8dn8uMPIxbOo
         dUwQ==
X-Forwarded-Encrypted: i=1; AKwUvBz1Afvg/hTgp2bw0c1m6u05uIIHuxzTD/ktZlo3+KHm3w9wzVQANPn0Ss3GijtxDgfEu1BJuoic@vger.kernel.org
X-Gm-Message-State: AFuF++ki0Z2E6+K793DZqY8pXj9lzXKEyXWSLqQ3UUsNdqLniEmPva03
	0RGJup8wCo+pLvyjsARKaXHmbar6TskZS0VziYJHG8uOlWPNeoJ1bKZr+68XqK+LuJAVSKgAWOR
	mEo0YzvcA5VGktjIfEdmI9nBGlOOmZp8=
X-Gm-Gg: AYBFou0Igi/7rplHUT4L4cNg2Eq3Ra8fHLa19/xTbZuAsn1VzbD8RX0JMcl2uTWQsEm
	CzQDG9n0wsMlcFpZx4g9GbRHRBIo0AeL3+mKEN1hPJVSr7c/bctLTSL/cLK1RbNveUWkIYjwyDd
	eL7dxuxjyrcweXYb4p4bgc9wLhKDTyQqs4PrlFX8SbTI1HxVOufEX+wYuBjcg+o2e8F2pwqLhx/
	iDYvVpYVnV+SDmarG+nd89fyGwldwkbTgtW+cs0cNUmo3BtNFMfqf3CxP6vq5dkBfsP2hyG1h6G
	D8hxT5YANwQ9P1PPzZLyL7ckvDiyEStgueM6tC/XvgzgG0cwReCIzfsaag==
X-Received: by 2002:a05:6a20:d70f:b0:3db:2c66:6638 with SMTP id
 adf61e73a8af0-3dd5f471e3emr15031230637.10.1789626603999; Wed, 16 Sep 2026
 23:30:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com> <aqQZus_Cc3mRiuXn@localhost.localdomain>
In-Reply-To: <aqQZus_Cc3mRiuXn@localhost.localdomain>
From: jingxiang zeng <jingxiangzeng.cas@gmail.com>
Date: Thu, 17 Sep 2026 14:29:50 +0800
X-Gm-Features: AcwNN1UARSNuee55eRj5g9Q9pOjCPBt25LiYNXQWqlZv1UTyIwozsFpLVuPTTQA
Message-ID: <CAJqJ8ihb71wv9qaKvoP990oKmoA+ErB7MB1sksjNhJf3enwJww@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: page_counter: move hierarchical protection out
 of struct page_counter
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linuszeng@tencent.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Sept 2026 at 23:17, Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> Hi.
>
> On Wed, Sep 09, 2026 at 05:44:18PM +0800, linuszeng via B4 Relay <devnull=
+linuszeng.tencent.com@kernel.org> wrote:
> > No functional change is intended: protection semantics and the cgroup
> > v1/v2 behaviour are preserved.
>
> It is not clear from the description what is the intention then :-)

You are right, and that is my fault for posting these three patches
without the context they came from.

They implement what Johannes asked for when I last tried to make a
combined memory+swap limit available on the default hierarchy [1]:

  My suggestion is to factor out from struct page_counter all the stuff
  that is not necessary for all users, and then have separate counters
  for swap and memsw.

  The protection stuff is long overdue for this. It makes up nearly half
  of the struct's members, but is only used by the memory counter. Even
  before your patches this is unnecessary bloat in the swap/memsw, kmem
  and tcpmem counters.

  Fix that and having separate counters is a non-issue.

and, in the same thread, about the cost of a second counter [2]:

  It seems like a good opportunity to refactor struct page_counter.

So the intention is not the cache footprint on its own.

The combined memory+swap counter is the one v1 exposes as
memsw.limit_in_bytes.  On the default hierarchy it does not exist:
struct mem_cgroup keeps swap and memsw in a union, because v1 only ever
charges memsw and v2 only ever charges swap, so the two never needed to
be live at the same time.  Making the combined limit available on v2
means charging both on both hierarchies, which means giving them separate
page counters.

That is where struct page_counter comes in.  Adding a counter costs a
cgroup one more of them, and at 192 bytes each that is 192 bytes per
cgroup for a feature most of them will not use.  Trimming the counter to
128 bytes first frees 128 bytes per cgroup, which is very nearly what the
new counter then costs, so the combined limit becomes close to free in
struct mem_cgroup rather than something every cgroup pays for.  This is
the "good opportunity to refactor struct page_counter" from [2], and it
is why the preparation is a prerequisite rather than a cleanup I happened
to do on the side.

The follow-up is written and tested; I should have posted it together
with these patches instead of sending the preparation on its own, and I
will do that now (details at the end).

>
> Do you have any measurements that the reduced cache footprint
> changes performance for setups without protection?

No.  So far I have only used pahole to look at the cache line footprint
of struct mem_cgroup and struct page_counter (pahole, x86_64,
64-byte cache lines, CONFIG_MEMCG_V1=3Dy)::

  struct page_counter             192 -> 128 bytes  (3 -> 2 cache lines)
  struct page_counter_protection    -  ->  72 bytes
  struct mem_cgroup              2176 -> 2048 bytes

The four embedded counters lose 64 bytes each and the one protection
context takes 72 back, which nets out to 128 bytes per cgroup.  The
counters that never participate in protection - swap/memsw, kmem, tcpmem
and hugetlb - are also down from three cache lines to two.

The reason I need these patches is the prerequisite
above, and those 128 bytes are exactly what the follow-up needs to afford
splitting the swap and memsw counters.

> And what is the positive impact on protected scenarios where the
> counters are in (possibly) different cacheline and one indirection
> further?

There is none, and in the form I posted it was worse than before.  Your
reading of the layout was correct.

propagate_protected_usage() runs once per level on every charge and
uncharge, and touches min, low, min_usage, low_usage and the parent's
children_{min,low}_usage.  Counting the cache lines each level touches:

  before this series   page_counter 3 + parent 1 =3D 4, no indirection
  v2 as posted         page_counter 2 + prot 2 + parent prot 1 =3D 5
  with the fix below   page_counter 2 + prot 1 + parent prot 1 =3D 4

In v2 the new structure kept the field order of the old one, which put
min at offset 56 and low at 64.  The two values the propagation path
reads together ended up on either side of a cache line boundary, while
emin and elow - which are only recomputed by
page_counter_calculate_protection() during reclaim - occupied the first
line.  That is how the count got to 5.

The seven fields the charge path touches are 56 bytes and do fit in one
line, so I have reordered the structure to parent, min, low, min_usage,
low_usage, children_min_usage, children_low_usage, then emin and elow
last.  Both embedders already place the context on a cache line boundary
- offset 384 in struct mem_cgroup, 192 in the dmem pool state - so no
alignment attribute is needed and the structure stays 72 bytes.  That
brings the per-level line count back to what it was before the series.

The dependent load of ->prot stays; it cannot be removed while the state
lives outside the counter.  The pointer shares a line with ->parent and
->local_watermark, which the same loop reads anyway, so it costs an
address dependency rather than an extra miss.

To summarise honestly: this series is size-neutral for a cgroup and,
after the reorder, layout-neutral for protected charging.  It earns its
place only as groundwork for the combined limit.

So rather than reposting these three patches on their own, I am going to
send them as the first half of

  [PATCH 0/6] mm/memcontrol: implement the memsw limit on cgroup v2

which is not posted yet; it will follow shortly after this reply, with
the reordered protection context folded into patch 1.  The second half
builds directly on them: it splits the swap and memsw page counters out
of their union - which is what needs struct page_counter to have stopped
carrying the protection state - maintains the combined counter on both
hierarchies, and adds memory.memsw.current and memory.memsw.max to the
default hierarchy.

[1] https://lore.kernel.org/all/20250320144722.GH1876369@cmpxchg.org/
[2] https://lore.kernel.org/all/20250320142846.GG1876369@cmpxchg.org/

Thanks for looking at this.

>
> Thanks,
> Michal
