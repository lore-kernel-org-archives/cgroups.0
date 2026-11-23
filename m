Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.241
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795436376;
	b=vQzv4D28Q9OzVG5QgwM0mH4hBSYWBGWyWXWD07NakA4B58faVItpuR906YsXUBo9OD6i
	 CJxk0OtM5LcFuhHgxG6ccgpFeyN+QHvhAvHHIA+H7S/31uPt5NvrTVdw/vmQfdsgY5Ilw
	 SchGRoW5Kl0xUhdJF3Z1GlXtGD56EYaHSD3678h7nT0FD78D3q/thjbHBCSb4Hzak+Vkd
	 Hk61+2qM42hAYCyHRzLK64mJYeTpkWGiWSHc3ERDuTo3cYh5YZa8pvo+yUhbTPOSVHqB8
	 9c4RmMglKxtEQAm3BaDjIxK5+yAeePi3cpDQrFhdnnuj7t++bjKR81mhdITY9FzT+OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795436376;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=qFwzl/gqyXB9gwRR8c2MAVb3Uw3fjAbSkoGnMFYVdKI=;
	b=M2nXvmuRz7mNXuWaicPH2MHSQFKiClKWxX8j+eoVFq/V8fAzhQgm5HDPHV4m+AkbiKNA
	 0MC5QXoYCfhbK1ZPjrNDUcQWnvmfKKTDB0qKXFki6WiQ28lEFf8eRU/SUih1O6GRypQGH
	 bQXjyu5xO2LjRcULc2jEibUUIaTpzb2DA1LnXz50fzKKMTDXW7LYuhYRyb5p0Ac3qVzuM
	 rlAxpQ3vFaXc3JsMT2By1mLZoH6i8ZI2uxdEJznAZ5mn/kuijjcLpGgjXhACW+YfuM5u3
	 SpKThO2P5g3Oaka/44EIEtk/uLQw3y+/FvvbIGd+wy2LA1KrwgJhei2ZeBGHN7h2tYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TrTLpHDI;
	arc=none smtp.remote-ip=95.215.58.241
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A1E606A321
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 12:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01A1E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TrTLpHDI
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=coZuep8pYTbxWk92faixoYVxpekvKhj4jeYY1NcGyIw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795436374; v=1; x=1796041174;
 b=TrTLpHDIS+60LkaiczefgRMgnky1vnxSFkb+C3x3RU+1Xq54nvmvlS5tejNuJVHj1SAUNZQR
 ziibhVNBTI3adYJwXeFCQqBRrWKep92qm7qm//X4sxxfYjgv4hdyh++l9VPoRQNsgmPmk9MKBOe
 fBuV8oEqLeCAkvPSrj15YEbM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 565cf6ba031b59a2;
	Mon, 23 Nov 2026 12:19:33 +0000
X-Mizu-Trace-ID: 565cf6ba031b59a2
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v5 3/4] mm: thp: restore SHRINKER_NONSLAB on the deferred
 split shrinker
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261123105334.2524066-4-qinyuntan@linux.alibaba.com>
Date: Mon, 23 Nov 2026 20:19:18 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 akpm@linux-foundation.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 mhocko@kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 mkoutny@suse.com,
 David Hildenbrand <david@kernel.org>,
 ziy@nvidia.com,
 baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev,
 david@fromorbit.com,
 Qi Zheng <qi.zheng@linux.dev>,
 yosry@kernel.org,
 nphamcs@gmail.com,
 chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com,
 Kairui Song <ryncsn@gmail.com>,
 gourry@gourry.net,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9BC09CFF-FEB1-44FB-B46E-FBE8B28E8CEC@linux.dev>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
 <20261123105334.2524066-4-qinyuntan@linux.alibaba.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)



> On Nov 23, 2026, at 18:53, Qinyun Tan <qinyuntan@linux.alibaba.com> =
wrote:
>=20
> On a system booted with cgroup.memory=3Dnokmem, the deferred split
> shrinker is demoted to a non-memcg-aware one.  As a result, partially
> unmapped THPs are only split under global reclaim; memcg
> (limit-induced) reclaim never splits them, so a cgroup under memory
> pressure keeps its underused THPs intact.
>=20
> The shrinker has carried SHRINKER_NONSLAB since commit 0a432dcbeb32
> ("mm: shrinker: make shrinker not depend on memcg kmem") precisely
> so it would keep working with kmem accounting disabled.  Commit
> fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> dropped it knowingly: under nokmem the list_lru collapses into a
> shared per-node list while __list_lru_add() still sets the shrinker
> bit on whichever memcg happens to add the first item, and with the
> flag set the shrinker would run twice per reclaim cycle.
>=20
> NONSLAB-backed lrus keep their per-memcg lists under nokmem now, so
> the shrinker bit identifies the owning memcg again.  Restore the
> flag.
>=20
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers".
>=20
> Link: https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/
> Link: =
https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.al=
ibaba.com/
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>


