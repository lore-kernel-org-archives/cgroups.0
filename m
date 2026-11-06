Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974619;
	b=gCbxLySc6Xa1BJGz7kMt0FV5j9WpKhlm0kHtGZM++B30LA8Eo9um5u/APkRoWxSktZQv
	 7qrGHtpLWKn8QmccK7LAwnNiFi131hGnC/HKN8LMk62Q26RWAYsNfwGSBbZcrJVeExU5s
	 NNXAvPri4mceYhg0eKdEeBoqEqDJavCvWDkpQ0RVUUGG8X/Z/OGzgxlPh2Io6PStWOCa+
	 is7Wr0UBU7FrNkQq5LTd2TGlN7Rc1InJcsHNHPBGgLGoVEc20u6aw4NJDmacQBl7JiRZP
	 hSV2p9OtN4+n3XC3fybhwET89ygkO9qVSdEPZGwHkSpEvGDRCFlKuK3NJE5KxOkp7tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974619;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=uecgvdcnBS0ssXlLSJ0XuUQT+Bqc+3M+IkCyY0hC8q0=;
	b=UQNu+nH8zXF9mgQpQNL+Cf2wcz2nWOh3sDQfMYUVOUQwknAYAx/2zhQOBrrC6HS+VF20
	 iQM1CZ/J6y6csjtgYztQG0DoRgye652EhVLA7qFTHxAk2Ws491N/C09/uXJWKSrdZYA1c
	 WfK+atKNx9xAH9fv2XjAAx0EYym5qGtjyoerd+2nRzW/P7CWVlfdWC9Qd3UV80Km5XuTH
	 gAoKWXdSohWVfFK27fyRFOMn3iL6jWSl/CefYG0ph4XhVjei4Atxp0O1Rwp1JBVyFfnJ2
	 44XQT0WLYwbjhmCqS1Z63GMtsA4wvyKhpg7SRbSkV54xqSF891oabbzbiopwoY3xh9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Brk88eoB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C393606D802
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Brk88eoB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B5B1F008A1;
	Fri,  6 Nov 2026 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974619;
	bh=uecgvdcnBS0ssXlLSJ0XuUQT+Bqc+3M+IkCyY0hC8q0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Brk88eoBEtDsQXHFyYUp+pJODIzkeWJ06z1vTkD7owXBB9aQ8/wPo0pGvH6yQsk5c
	 xoOXKyjgBNAXeP0LWQ8hA3QYoapPGEdJa6mNg2MZzIHFTnMFGVWRjYbgYBW8+a9JZ1
	 3kqtpzfbks3i/5u2/V+v7aIvPewO0SfbXGxvrd8ioj7V9ZDwvukpLn0Hg9qBHba7cF
	 V8YGjZpxNJwgnuIbwA+7z/QpzruaITRvV6/mV2JHGD1UkIKdJMGiD8Hz9lZvGilZBA
	 L2rUTnvzcU08BQINjJaG+G5BnhpAHMDbQ46VcMXUsLX7KEYD3od5CTRhpwP+zshTzQ
	 VIbGgdz2574LA==
From: David Hildenbrand <david@kernel.org>
To: akpm@linux-foundation.org, Joanne Koong <joannelkoong@gmail.com>
Cc: shakeel.butt@linux.dev, yosry@kernel.org, hannes@cmpxchg.org, 
 mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
 rppt@kernel.org, surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev, 
 baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com, 
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
 cgroups@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261029204157.117879-1-joannelkoong@gmail.com>
References: <20261029204157.117879-1-joannelkoong@gmail.com>
Subject: Re: [PATCH v2] mm: move LRU size stat updates out of lru_lock in
 folio batches
Message-Id: <179397461320.8873.1139979903597807353.b4-ty@b4>
Date: Fri, 06 Nov 2026 15:16:53 +0100
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0

On Thu, 29 Oct 2026 13:41:57 -0700, Joanne Koong wrote:
> folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
> once per batch, but they update the node and memcg lruvec stats for
> every folio in the batch while holding the lock. Only the LRU lists and
> the memcg lru_zone_size need lru_lock. Updating the stats while holding
> the lru_lock is unnecessary, and they make up a large part of the
> critical section, as seen in [1] where a change that added just a few
> instructions to the memcg stat update path cost about 2% throughput
> because the LRU stat updates run under lru_lock, and the overhead went
> away once they were moved outside of the lock.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm: move LRU size stat updates out of lru_lock in folio batches
      https://git.kernel.org/mm/core/c/ee65a1da

-- 
Cheers,

David

