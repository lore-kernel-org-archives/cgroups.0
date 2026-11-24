Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795488622;
	b=1sX1j44XHaeHDTw1cOu2AtiqZtgr8WZbaF2TIoyNLWLT2SVVzBTqhVq9fmDH4mzOaw8P
	 /JFw4UZDjpgkPOQB8k5d2Sg3ZZLsSahYmETE7lVzoFYk301e5UVrYj+7UMh7rQmHzeMMw
	 L3xBYkDGLwNBg63T448eoT5d7QrZRd9/snOM/oHmAwuSFb77hua3sCF5gBDQRIWUBMe+6
	 ESYY0qZraV5x7McFRy0K/UbeIatpXbCeKcF9UEX5ttQqB9wYyCCua072qxdnfzyC3gGTM
	 Y9ySEmWH1HuoEEIyJBva6sbzsuqHAKQFOiUFbUc+LM4vwaOPJj9Ylz8ocHBe6TgDUmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795488622;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=FF+rLemNvQli8Y0SC/xA9vPWVsbRgVrCInJrQ5eKDu4=;
	b=KAJEtq4aNPbDaYcnPGQFMhZ8Q5S1Sldg6QVJ2jdjCfmyrDSu08gc3WfuGMeUbgpIn+xR
	 uS9lnlAZYcm4f+RKa2K+cDpDYHOz5xXHwPIzyqfHar7bWE3otnXIhfVArY+xJOQlc18ws
	 6AE0pFYTYEnaRh+uTKDO2lT+F92zW1HXCQiofCJNjisIf4BuyCVA0YBZCuwytMB6wYYR5
	 m+xbTRVbKAVgcJdHVbj4VbCyAfGV3oeOaLlitbEj2J1+Zn4sEt9Yp5sZYhWVVoEyhwWSy
	 5pQ2R/g87Ns4vpDMOojNqAFD/ursBJP0v20XKVo5Bre51/+6BV0gNNSoN2k5K0+Bk7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HeJxvI1c;
	arc=none smtp.remote-ip=95.215.58.113
Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95696606A31E
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 02:50:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95696606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HeJxvI1c
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=czFmZtebk+h8PB2klgzex5BMJY4BT8CV+nACYRQTDOo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795488619; v=1; x=1796093419;
 b=HeJxvI1cZ2wtHMS3o/BQsChKQVcXS9w8/EbKIcXEtW2rwMONJuEk9KLtUkhkkxtKBsD4S5qs
 SmVyaoUeaZKXHe6sUDpas8eqpiA/4dtzEQ5EFrzLVyE+xUAHcc54aa5HSZuUvMIuTJbN0s9odwA
 s1InIO7EZYASZJvrWPp8VhLk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 41f9a57973e118ef;
	Tue, 24 Nov 2026 02:50:18 +0000
X-Mizu-Trace-ID: 41f9a57973e118ef
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
In-Reply-To: <20261124000439.967403-1-shakeel.butt@linux.dev>
Date: Tue, 24 Nov 2026 10:50:00 +0800
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
Message-Id: <F39B4A81-BB17-4C5D-851E-2740EBBBBA8B@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)



> On Nov 24, 2026, at 08:04, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> mem_cgroup_alloc() reserves the private ID of a memcg when its css is
> allocated. The ID is erased when the last reference to it is put, and
> that reference is first taken in mem_cgroup_css_online(). The failure
> paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
> themselves.
>=20
> But css_create() can also fail after css_alloc() and before
> online_css(): in percpu_ref_init(), cgroup_idr_alloc() or
> css_rstat_init(). The memcg is then freed through =
mem_cgroup_css_free()
> without ever coming online, and nothing erases its ID. The reserved
> entry stays in mem_cgroup_private_ids for good, and each such failure
> takes one of the 65,535 IDs away. With failslab failing radix tree =
node
> allocations during mkdir, 1,500 mkdirs leaked 6 IDs this way.
>=20
> Erase the ID in mem_cgroup_css_free() if the memcg never came online,
> which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
> only set when an fully onlined memcg is released.
>=20
> Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure =
after many small jobs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
> include/linux/cgroup.h | 5 +++++
> mm/memcontrol.c        | 7 +++++++
> 2 files changed, 12 insertions(+)
>=20
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 2afb4cb2bb4f..123c713dcc91 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -449,6 +449,11 @@ static inline bool css_is_online(struct =
cgroup_subsys_state *css)
> 	return css->flags & CSS_ONLINE;
> }
>=20
> +static inline bool css_is_released(struct cgroup_subsys_state *css)
> +{
> +	return css->flags & CSS_RELEASED;
> +}
> +
> static inline bool css_is_self(struct cgroup_subsys_state *css)
> {
> 	if (css =3D=3D &css->cgroup->self) {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 091401cecf39..e7dfc96fd1b9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4545,6 +4545,13 @@ static void mem_cgroup_css_free(struct =
cgroup_subsys_state *css)
> 	irq_work_sync(&memcg->high_irq_work);
> 	cancel_work_sync(&memcg->high_work);
> 	free_shrinker_info(memcg);
> +
> +	/*
> +	 * The css_create() error path bypasses normal CSS release, =
leaving
> +	 * CSS_RELEASED clear. Drop any private ID that is still =
reserved.
> +	 */
> +	if (!css_is_released(css))

The leak analysis and the fix look correct to me. However, using
CSS_RELEASED here makes the private ID cleanup depend on a generic CSS
teardown state, and adds an accessor solely for this failure path.

The private ID is not needed until mem_cgroup_css_online(), so could we
instead reserve it at the beginning of that callback? Failures in
css_create() before ->css_online() would then never own a private ID,
while failures after the reservation would continue to use the existing
mem_cgroup_private_id_remove() cleanup.

This would also make the private ID lifecycle more explicit: reserve and
publish it during online, then drop the initial reference during =
offline.
It would avoid both the new css_is_released() helper and special =
handling
in mem_cgroup_css_free().

Thanks,
Muchun

> +		mem_cgroup_private_id_remove(memcg);
> 	mem_cgroup_free(memcg);
> }
>=20
> --=20
> 2.53.1-Meta
>=20

