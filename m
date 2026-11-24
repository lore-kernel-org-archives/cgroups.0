Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795502075;
	b=eMH2F9HvaRgISEcLjcVKHuTdhQo+Tbwetx0DNG82dQjUAVLvUwEE9/m5IdJxHK4AMDeH
	 BIbWgwAzL1XqlWJwDsvFh2NfgmPW5BpmZN5laJiPqZ99x9Vn2S4C67+mTEsgYDSfVFz3c
	 FW/CDLHrSd0ht++gWgNkmOEzGZz0ApiykZwWbqNUCzY4M4QCm9dCJPraD7oFJXNNJPAfA
	 /+HABzC2t+Hkdxw4uHLmARSCD51NDGKHpqwb5/OhuArWrZJVFO7ByYtkqmNkfU/cidNcJ
	 XzOUV1qOMh+O0SedTf2cEWdE68Q28A79pXZI8JvlPu6G+RfY0d2cgWIPrICXMemzZWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795502075;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=NXbi9yNhidHwh55GelyFmLkRwoKv3QmTo7vFxn6GgFE=;
	b=VUrhr6awS+txaDQ5n2Nj1OypzkfKVCpCqCAIjLYn6XcXgQMh44+W9/hDI0624xVOM+ms
	 MhLRIElOb5ZRPTIsZB9AKBLNkHqkjPde/7xjCy6jdjAfCWc4xVa8K5wKME2DOBi7WSUAe
	 YH8AGXZ/0eUa1gxLMR+z1NoCLiI/EyLl9jMZNevUykywqjyk7c9kx0Hiq0g6PvaYAa4RU
	 b3SNkpdDAi7Vuk0jLAAmmGlnkZFCkZD88zngZBUdKkp2gcwhqpwr1S0pcBhs8xwt6G3O7
	 ZwwOW7axK9ZSErSPU1zictp6tsSj5e1hOzzgwLEc1gspl1HCK8YkbM/nx4g3rl/32rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pn5hlMQ1;
	arc=none smtp.remote-ip=91.218.175.176
Received: from mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED630606A31E
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 06:34:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED630606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pn5hlMQ1
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NXbi9yNhidHwh55GelyFmLkRwoKv3QmTo7vFxn6GgFE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795502073; v=1; x=1796106873;
 b=pn5hlMQ1435ibB7vGL17lTJywWV1OMBli3vks0P/9aPI/NQGQH9MCfI1TTZnymEUdL3qTsJX
 e3csdSHtE0ulpNSUeTGPoZOmkGwODmJ+rHgaIHP8KOCPoXMrvUZcGRPlUXANNBPh87dNuhsfehS
 cOtFlBlRGSjfDbr1SpUsaESo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 80c8d8955432b0c9;
	Tue, 24 Nov 2026 06:34:33 +0000
X-Mizu-Trace-ID: 80c8d8955432b0c9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261124052054.GC555944@shakeel.butt@linux.dev>
Date: Tue, 24 Nov 2026 14:34:18 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <67C04BF9-9F11-41D8-AC98-1D6465FEE36F@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
 <F39B4A81-BB17-4C5D-851E-2740EBBBBA8B@linux.dev> <awUTKy9tx8nWJgXf@linux.dev>
 <2FE2D209-FB57-4191-A324-F179B2394DB1@linux.dev>
 <20261124052054.GC555944@shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)



> On Nov 24, 2026, at 13:24, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> On Tue, Nov 24, 2026 at 12:52:41PM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Nov 24, 2026, at 12:33, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>>>=20
>>> On Tue, Nov 24, 2026 at 10:50:00AM +0800, Muchun Song wrote:
>>>>=20
>>>>=20
>>>>> On Nov 24, 2026, at 08:04, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>>>>>=20
>>> [...]
>>>>=20
>>>> The leak analysis and the fix look correct to me. However, using
>>>> CSS_RELEASED here makes the private ID cleanup depend on a generic =
CSS
>>>> teardown state, and adds an accessor solely for this failure path.
>>>>=20
>>>> The private ID is not needed until mem_cgroup_css_online(), so =
could we
>>>> instead reserve it at the beginning of that callback? Failures in
>>>> css_create() before ->css_online() would then never own a private =
ID,
>>>> while failures after the reservation would continue to use the =
existing
>>>> mem_cgroup_private_id_remove() cleanup.
>>>>=20
>>>> This would also make the private ID lifecycle more explicit: =
reserve and
>>>> publish it during online, then drop the initial reference during =
offline.
>>>> It would avoid both the new css_is_released() helper and special =
handling
>>>> in mem_cgroup_css_free().
>>>=20
>>> Thanks Muchun. Nothing needs the private ID before ->css_online(), =
so
>>> reserving it there would work. But it moves the out-of-IDs failure =
from
>>> ->css_alloc() to ->css_online(). By then css_create() has linked the
>>> css into the parent's children list and css_idr, so =
mem_cgroup_iter()
>>> can css_tryget() it and cache it in iter->position. A css that fails
>>> online is freed without ->css_released(), so
>>> invalidate_reclaim_iterators() never runs, and the free does not =
wait
>>> for those references. Today memcg's ->css_online() fails only when a
>>> small allocation fails. With the move, every mkdir on a system that =
is
>>> out of IDs would take that path. I would rather keep failing in
>>> ->css_alloc(), before anything is visible.
>>>=20
>>> To drop the CSS_RELEASED dependency, I can test the ID's own state:
>>> !memcg->private_id_objcg means the ID was never published and the =
memcg
>>> still owns the reservation. Let me know if that works for you.
>>=20
>> You're right. I missed that the css is visible to mem_cgroup_iter()
>> before ->css_online() completes. Using private_id_objcg to track =
whether
>> the reservation was published makes sense to me. Thanks Shakeel!
>>=20
>=20
> Oh I just noticed that private_id_objcg is introduced in 7.4, so to
> backport the fix to previous stable kernels, we will still need to use
> CSS_RELEASED or something else there.

Agreed. Keeping CSS_RELEASED in the fix makes sense for backporting.

So:

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

