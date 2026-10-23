Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792796049;
	b=k0HBUkMAeyKzFGUlmU7qk1YbxBz3UwUkh6sv/3C1a/P68cWriKasaUtXpUd0a1S/Kn/x
	 Sew6ThtkoRLupujW1mOPULTv048JyRLc9CiE/bu8IFtiOaCWurT013sLEuWsxG8kOT9EL
	 rud99MpStNAC5us3Ih7A2cXBJ4zl/HhjgmRGaHRousgTiOtpaG71ZlmwxeryNynf7Y7XI
	 OpGNUMsQdtlR3IH5CJaSvuqs5MDMwMwhpdQ9iF4GK+RvxC3kAcbF1mAUwDmT3AixBkme+
	 jwscD8ZDHaTccWab93gCZkYhtj0w1KCS98RaHGUmhLhjOadYlPqFwpuSuV2UM/SBv+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792796049;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=5mwl+mYd7E4jnirDuRC9766Hxb70zvCxQxMd7Bhm7g8=;
	b=A69FLmZLD0C6D2IusmVUE295fUHzoc1sVOYTgkivIT2xr5gbYmtG8ptxmx7dnwxeJUxw
	 LoTCX8xi9ycffMWZGS++93jUL56RUUTe5gSmOi9Tb6WToipsb+Ctawdo9IIfQ4O3C/WsC
	 Yl27xFSLtUcVwRO4oxo3AqH32aceHiOzsUzmMRDLHUQ+aCBtnNvCT2M6xIAS6CWhsEL9v
	 Vblcw4B/UWLd0wP3X6gn24LfRSDBMPgRouS8YsAtZcs1GVC17dEdtzHoBPjjYsY0z4IXD
	 cCaHe9ok9X652Q1YiBLrQrGf50EH4BelcuhPhqv6Yl6rnpKg7UCwx7Gr5XJj5X09aMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OPFVnYk9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A056606A31A
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 22:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OPFVnYk9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF271F01825;
	Fri, 23 Oct 2026 22:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792796048;
	bh=5mwl+mYd7E4jnirDuRC9766Hxb70zvCxQxMd7Bhm7g8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OPFVnYk9qwsMIDlbDPJ/O0aOlEvgcO9giJFr6ZDKNlmX/Iuf6a23CmgvC63l5mMzE
	 6OlQT0p5BVGUBYCfeCU7O8TZRB3URk+WtN5qYhUaRrR5xdlnPpnxuVhWWBi+M7p/G5
	 UpgLSt5oA15Z4Voryo7GJb4FdLuNhQtMe4YiV75o=
Date: Fri, 23 Oct 2026 15:54:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/2] memcg: reduce cacheline contention from lruvec
 stat
Message-Id: <20261023155407.0b519a3da7313137a0276119@linux-foundation.org>
In-Reply-To: <20261023195417.1391216-1-joannelkoong@gmail.com>
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 Oct 2026 12:54:15 -0700 Joanne Koong <joannelkoong@gmail.com> wrote:

> Memcg lruvec stat updates read fields of struct mem_cgroup_per_node and struct
> lruvec that can share a 128-byte cacheline pair with lines the lru_lock holder
> writes constantly (the LRU list heads, lru_lock or lru_zone_size[]), depending
> on where struct mem_cgroup_per_node lands in its slab. On CPUs that do spatial
> prefetching (eg Intel CPUs), this makes the stat updates contend with the
> lru_lock holder.
> 
> Patch 1 rearranges struct mem_cgroup_per_node so that its read-mostly line is
> paired with a cold line, and patch 2 makes the folio and kmem stat updates use
> the memcg and node they already know instead of going through the lruvec,
> whose pgdat field shares a cacheline pair with lru_lock or lru_zone_size[].
> 
> Results on a 2-socket Skylake (80 CPUs), average pages per second for
> threads faulting in and freeing memory in a single memcg:
> 
> 	   base     patch 1   patch 1+2 
> shmem, 20 threads  4.74M    5.59M     5.77M
> shmem, 80 threads  7.94M    8.66M     8.82M
> anon,  20 threads  3.04M    3.08M     3.10M

Thanks.  A local AI review pointed out a thing:

  One limitation worth mentioning in the [1/2] changelog: the slab
  uses SLAB_HWCACHE_ALIGN, which need not align each object to a
  128-byte boundary.  If an object starts 64 bytes into such a pair,
  its first line can still be paired with the end of the preceding
  object rather than its own cold line.  This isn't a correctness
  issue, and the measured Skylake improvement may well be real, but the
  layout doesn't guarantee that every read-mostly line pairs with a
  cold line.
