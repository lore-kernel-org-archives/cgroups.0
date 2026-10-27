Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793141878;
	b=e2bv/3oD07bwNXqFAH71mSYb9ucp3AK58c43/6fO/Y8BHvB898JSvUlU0gBfZdKDARMx
	 Go5OoubWXhvizO9N5djKBj+sIAonyZWfksldXtG+N25kAv1I/qE3h4fH3DnoufVZ/MD21
	 hqJnge6fJdBqI4IIhbXJYFwVIMGZF2Z5Xe43GL7EbjR241sfoUex3OgGtFz0pav3velge
	 DhAjvJjHNQPfPe9R3vkVOF+32COLXLSUiza5NFLQLSUlxNQehrSltD/e4ghsiUKqyK00Z
	 ZtacfQl0F9jpdXk0gO0B+/NVFV1WF65J4pIMViSu0XO0VLnC0qUfWar/pbnZcBXZk6w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793141878;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=72+WHJwwpogSBR2Mae06gxZf+v4TqJlIK48WM/9xNMc=;
	b=WLclsL4FBz5apzJzJVOvLV9eB3yVe3nDVY9cwkR8e+9S3OpTwo1rmfE5/7g32dhkIRyc
	 Rp5bKdio7Se7PJkxOeMlxxRuyOlP0FMa6LfRu4FV3n1HOeq0ZyfUfK861WNlUYun5jOoR
	 RFFaTr0+sd4mhpEdSiXFr33azFPL+pYP1ulhSnRdOSjbFBTryR+D+vC12YBEwc4CAUirw
	 takdnLihFxImFoKE4G/SEWnoBY+x4hTOrdX4wj0Tshbqnemogu+RCSKzOtZHTJmURA0E8
	 E3riUGvhe0jqRG4mghADrqc0IJiSF8gK3WvEd6Kj+rLezOOmwcnuKuc1MgOkbkz3LCg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="fkP/0g1v";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD132606A31A
	for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 22:57:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD132606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fkP/0g1v
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48c4be28b82so308738f8f.2
        for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 15:57:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793141876; cv=none;
        d=google.com; s=arc-20260327;
        b=i9RmpGW5u6lSq5l0bTV/1lwu2mKr4Y+MEWeLJkB7AXOIjdbCGaHV7RtGB4q/KisZgZ
         deJ0ax/8BHzEs6F/fsoORsBx7WU6LcMb9GZFaw2MFCdC7zq+kVjSFC7Hg+lpXCYsqQtL
         9BXK3o+EOdkz3p5HvuUq5Ht62Cembb9/V/IesXXmGUEnWFxwVMraMGbWeU5tVhnUTQ1q
         4fXTkHBt7I8PkGsuptmYh5ruW8pBSz3LkEh+FbwknfC5v9TqtgAxS1VrbQ9+lRardj9P
         emoJLWD12V1k5S8i0CkR+YBvT6E7GXBlSuOIRbpI3ilGohzeNK9pdgwSMqSWSZ2Q0kaC
         Gg5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=72+WHJwwpogSBR2Mae06gxZf+v4TqJlIK48WM/9xNMc=;
        fh=j1g+SgXBASyqkySN33EMhFFwCjmgO38YCzizyIhM1IA=;
        b=SpESVBPbXKE64NbunULuicjg5wrTXerCG1tcyLZ9yhEzSwq6wIyDs/RroZbo5fdRuU
         SEzFngSc/K1bcPHP6nRDUDk1WS2G+GSOeBKSKTruGVyclsXGLKu8krXjjFlvM5mtUZBH
         4xNOQTnqIZW+alipC7xLRbbxeuhlfYduH7KxGzB+EcTHisp0nbJ6lP2DB3ulwR+A6KnD
         O0LPi1Fu3XTGgielml/JNVf+sDiSsM3QXb9a/3Ms3Nkp/1fKb1FMNe9JudG+XYVRDy8I
         iWxYD/3/zMh19HotJA9awZvbkf1SVb0zHsZkcs13XKDlWyTiSCV4QxYB2/oB5QIYAI5+
         k4cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793141876; x=1793746676; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=72+WHJwwpogSBR2Mae06gxZf+v4TqJlIK48WM/9xNMc=;
        b=fkP/0g1vgR1McjepsKF7f2ehDk4rAxj4Y/MmQ4Mvr6gc7nKKkrXr/d11CEO4eL10U+
         NyPv6dkfyCU7NT7JnpXE8V7IGaeV48uO8/FOT+lPBwA0CoOq9bbTaJxVgCFigL+5Ilfu
         8o2agiD13ujieaAG/fO44Y0K4daW17N4wLfAtAcho7b/uZWPiGuCdc+l1Udz7zq31V84
         AgV/sxz5g8Xl3ZaF3uMlrKorhaeDvl/Fmuv0NjJBhpNcelOStzUxAcfRb+XnLoYt6E7/
         6hoByaEtbRWAvUspUMokI1+EFO2M3hzSGyDvSlEBcbh1s//wdmahfkJyVI5JekuGXCED
         Gc+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793141876; x=1793746676;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=72+WHJwwpogSBR2Mae06gxZf+v4TqJlIK48WM/9xNMc=;
        b=z8F3wU1uKohayI8sNKaIsbiLGlXvYUT0PfEnfW2ZKmTMjyJltbKzYvEQb5MJKEZjyC
         mbunhFxoNDFHl6tbF/rOqur1BP7wSdFU2p47f0hnkKkSDOoyRlWLIn7SrLUUZN9N0IqN
         TZqthLsDR5qLrAk6fQ6PeeJUaQXhFQGBxqIi9HiljIcVtMUmIh4eB52TlKwsUqxIB2Nf
         NV/6IRQUNfoiE5Sll8P/xXsXwojw6Ppvm3w5M30fJU8rSsfC/Dp4l0RfOLmZzQ7a+kDF
         ykEfSSiDjmalxNrK1NjnLnsJq4p4o1ZZth+z5+dBTs+Jbrb2vU2XNvNN82B0E4dAYTNs
         MQgg==
X-Forwarded-Encrypted: i=1; AKwUvBwLkWpw8t8Ice2aSf7EgYyi6DmCh7uysAZ1R3vyVnsobQnIN3PpxrOt8ITQAkIn2EiphgdafTA3@vger.kernel.org
X-Gm-Message-State: AFq9FYK/d84NI2hxYX/wJTgvfMYHl2qccsB6M6PmPVfDkQ23nb8k1+dG
	JfoUrNTPNgi4u2eR1DVVF+6+oG0kIErl1128l2c6vrN1t06fLEcksIbk77PKhpS7louBzSwmd9d
	EKIHU21ObM+TpBmhxt4gBN7FfZvTPpv4=
X-Gm-Gg: AYBFou0l0cw5qdJAfARCtKWIviD1UvmyKJuOCy87gSz17bFRqST9BKwpDyqFb4IS+Bs
	G7j4XADm1EzHZfeyzIF8XIK1fHXMY3hWnCNVw6ZLQq6I+SQcWFxF7lPh0zHLp8KGnwh9eElpKkc
	devoNRsfvKV3cQ+znWmfaeDwwoJ6CIqY0/zizCPYTre2lfg8mo/iYcQAqPXd4F0e7y7S41SmZMK
	x5p87J+MM7OZECZp1oHA+KQNIhi1BLvQj7XKCB3hI1+5oObbdxzPFXEh4auyNTLyG3gKtsHRtG9
	rzuaGsmnuoWTDIWcAZZQiYomlNMeVhw9ULPfRH4t7h5IopMdXPf2UroXtL4I/KJThTCjGhWT+RE
	VhZlTfniK6GAgpxo4yuYvEGxSkO0h5+fmQFG253vTAHd8JLR/G3pSCWlv/zS2Agrz3O2tuq8E9W
	cy7DR0ee9TS6qM1Vl/QsHLEQUCKWMe2N6dtNWzNNk=
X-Received: by 2002:a05:6000:15d0:b0:48e:1d87:f179 with SMTP id
 ffacd0b85a97d-48e5d2ee6c4mr1432863f8f.25.1793141876177; Tue, 27 Oct 2026
 15:57:56 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023195417.1391216-1-joannelkoong@gmail.com> <20261023155407.0b519a3da7313137a0276119@linux-foundation.org>
In-Reply-To: <20261023155407.0b519a3da7313137a0276119@linux-foundation.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 27 Oct 2026 15:57:43 -0700
X-Gm-Features: AclHuK_5vNE3lHaWIxr_pi4E7Lc0-zQAS_H7nZdBiLEpaJxcfp23GnfYndfnZ-E
Message-ID: <CAJnrk1Z-zzKL9Jebk4XMpfOBtyArppGPTv3__GTbCZXGiEJjOQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] memcg: reduce cacheline contention from lruvec stat
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 3:54=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 23 Oct 2026 12:54:15 -0700 Joanne Koong <joannelkoong@gmail.com> =
wrote:
>
> > Memcg lruvec stat updates read fields of struct mem_cgroup_per_node and=
 struct
> > lruvec that can share a 128-byte cacheline pair with lines the lru_lock=
 holder
> > writes constantly (the LRU list heads, lru_lock or lru_zone_size[]), de=
pending
> > on where struct mem_cgroup_per_node lands in its slab. On CPUs that do =
spatial
> > prefetching (eg Intel CPUs), this makes the stat updates contend with t=
he
> > lru_lock holder.
> >
> > Patch 1 rearranges struct mem_cgroup_per_node so that its read-mostly l=
ine is
> > paired with a cold line, and patch 2 makes the folio and kmem stat upda=
tes use
> > the memcg and node they already know instead of going through the lruve=
c,
> > whose pgdat field shares a cacheline pair with lru_lock or lru_zone_siz=
e[].
> >
> > Results on a 2-socket Skylake (80 CPUs), average pages per second for
> > threads faulting in and freeing memory in a single memcg:
> >
> >          base     patch 1   patch 1+2
> > shmem, 20 threads  4.74M    5.59M     5.77M
> > shmem, 80 threads  7.94M    8.66M     8.82M
> > anon,  20 threads  3.04M    3.08M     3.10M
>
> Thanks.  A local AI review pointed out a thing:
>
>   One limitation worth mentioning in the [1/2] changelog: the slab
>   uses SLAB_HWCACHE_ALIGN, which need not align each object to a
>   128-byte boundary.  If an object starts 64 bytes into such a pair,
>   its first line can still be paired with the end of the preceding
>   object rather than its own cold line.  This isn't a correctness
>   issue, and the measured Skylake improvement may well be real, but the
>   layout doesn't guarantee that every read-mostly line pairs with a
>   cold line.

Hi Andrew,

Thanks for taking a look at this series!

The AI review's commentary is correct but it doesn't seem to matter in
practice. In the cases where the read-mostly line isn't paired with
the cold line, it's paired with the line that holds the end of
lru_zone_size[] and the reclaim iterator, which are also rarely
written outside of reclaim so it doesn't see much contention. In my
benchmarking runs, the memcgs are freshly created and contain a mix of
both alignments. Before the changes in this series, the per-memcg
throughput was bimodal depending on the alignment, but afterwards, the
throughput is uniform across memcgs.

Here's an updated version of the "Fix this by moving the memcg_pn_cold
group..." paragraph in patch 1 that mentions this:

Fix this by moving the memcg_pn_cold group, which is only touched when
the memcg is reparented or freed, right after memcg_pn_read_mostly.
SLAB_HWCACHE_ALIGN only aligns objects to a cacheline, and the struct
is 576 bytes, so depending on where an object lands, its read-mostly
cacheline is now paired either with its cold cacheline or with the last
cacheline of the preceding object, which holds the end of
lru_zone_size[] and the reclaim iterator. Both are rarely written
outside of reclaim, so either way the read-mostly cacheline is no
longer paired with the LRU list heads.

Would you be able to swap it in or would you prefer that I send a v4?

Thanks,
Joanne
