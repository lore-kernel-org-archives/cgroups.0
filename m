Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795593501;
	b=QA+pb6wxTlx1ZgbUXSf/FV1e4J6apKgJ85nOzSbGyEszPdtKJuBsdf917Q5bvgkNrHjB
	 HBWTj4+PUskf1UsCw+EvBFDGdtcdF7ILCvllj/VzxXGfgEHzd4iVWNja424T9Zwbs5t3e
	 uBNbvTR2k5n0dT3HxZhyA1qOcQB/RxPQnwpwEIzxDEiuuv8qbYcjKZCyHlsEjSgDRB1zm
	 8GQamuiS3cHCDsj9m8yww0quJT2OOLuqDgOArVMVO7BZa3TE7emLApr+LC7ANZYyrJSQZ
	 WxlO4sv8lgVndruCXCSjFOheiN1oN0WLElcJnQAc7zgkd0yXcMWE58c7Er8k5+Mqqdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795593501;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=ERfJb3qF0+sgEEuK6tJL1bCyE1JjReykvfA28PGir+g=;
	b=ebcXYAaOcW4UXEOO9r+BS6FBhgyYlN+iJqg3CebVG57VjUec7vuOWGfzK1CDbY4v+3rq
	 lOTreJ5Ro+OimjIZfUZfBW8g+26Yxl85F0QnosOT5LKZjdtCFPAYhBpEZImWKIeQW3sB6
	 5zUmzMAV/IZYBt1wjROJlvNhgeIju0m4We0ZFfOe+6E+mthEwjX3JCHDXmmCcC/7Df6Z7
	 DPdW2mc1wWUqExvHeTIju+pNHPNaDaIUku9aGk8O8mJw62wsLaMDSlIYoqaemhiN2Gny2
	 1Og+Hf5JtiGwT1GcfHFH2MJsh+XAI32Hwk705B7cLFNk8Wj9ZrsP668gEEb/Xnn4b0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=v+SIytma;
	arc=none smtp.remote-ip=95.215.58.41
Received: from mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA53606A323
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 07:58:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AA53606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=v+SIytma
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JJb4V3QmzElV+J3+lTvVhXCbEVNDcL1viNTlfeP0Wlc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795593498; v=1; x=1796198298;
 b=v+SIytma8dOQHqmZB62ikezj2CXVTIhPAIXBPy77bQ2S6LMV1nCrDFsbY6MWaY+8UYEIeCPK
 BsZg37nSHICyHPmU9JS8RSfP+1PNzNtuD40bmveUrCYfrUArq2UO5YGgjNpqnWN1iXR9biOqA0M
 gKEeOmbrQA/+xTA/2oNcP0BM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d6c3d85e79e38a6d;
	Wed, 25 Nov 2026 07:58:18 +0000
X-Mizu-Trace-ID: d6c3d85e79e38a6d
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 25 Nov 2026 07:58:18 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <8f0abedb57eb51b09fbfca232fcc0f6eb0dedd03@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 0/2] mm: memcg: fix memory.high allocator throttling
To: "zhangjiao2" <zhangjiao2@cmss.chinamobile.com>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Hui Zhu" <zhuhui@kylinos.cn>, "Song Hu"
 <husong@kylinos.cn>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Chris
 Down" <chris@chrisdown.name>
In-Reply-To: <6e73ae4b-5400-4f6d-bf5b-2892827ea144@linux.dev>
References: <cover.1794902513.git.zhuhui@kylinos.cn>
 <avzSkT9-jsCrMoeX@chrisdown.name>
 <6e73ae4b-5400-4f6d-bf5b-2892827ea144@linux.dev>

"Hui Zhu" <hui.zhu@linux.dev mailto:hui.zhu@linux.dev?to=3D%22Hui%20Zhu%2=
2%20%3Chui.zhu%40linux.dev%3E >:


>=20
>=202026/11/18 06:17, Chris Down:
>=20
>=20>=20
>=20> Hi Hui,
> >=20
>=20>  Thanks for fixing these, I've verified that these fix the issues
> >  reported.
> >=20
>=20>  That said, Zhang Jiao sent a fix for the same two problems a few w=
eeks
> >  ago, and Johannes thought the overage cap there was a bit of a magic
> >  value, which we have plenty of in mm already, and I agree we shouldn=
't
> >  add more [1].
> >=20
>=20>  Could you please coordinate so we don't have two patchsets doing t=
he
> >  same thing?
> >=20
>=20>  Chris
> >=20
>=20>  [1] https://lore.kernel.org/all/auNrakxaET8qkuAn@cmpxchg.org/
> >=20
>=20Hi Chris, Joshua, Zhang Jiao,
>=20
>=20Chris: thanks for the pointer, and apologies for the duplicate. I mis=
sed
> Zhang Jiao's patch [1], and Song Hu's earlier report of the overflow, w=
hich
> already proposed check_mul_overflow() [2]. I've added Zhang Jiao to the
> thread so we can settle the coordination here rather than off-list.
>=20
>=20You and Johannes are right about the cap. I've dropped
> MEMCG_MAX_DELAY_OVERAGE and reworked 2/2 into the shape Johannes sugges=
ted,
> with calculate_high_delay() and the caller's penalty_jiffies both in u6=
4 so
> the value is narrowed only after the caller's clamp. That also removes =
the
> in-function min() from 1/2, which was undoing ff144e69f733 ("mm/memcg: =
move
> penalty delay clamping out of calculate_high_delay()"). The series shri=
nks
> from 19 insertions to 9.
>=20
>=20Joshua: the Fixes tag is the right one, though I can see why the diff
> suggested otherwise. The division comes from 0e4b01df8659; my patch onl=
y
> touched that line to add the clamp. The bug is the reordering in
> e26733e0d0ec, which replaced
>=20
>=20 =C2=A0 =C2=A0 penalty_jiffies =3D ((u64)overage * overage * HZ)
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 >> (MEMCG_DELAY_PRECISION_SHIFT + MEMCG_DE=
LAY_SCALING_SHIFT);
>=20
>=20with
>=20
>=20 =C2=A0 =C2=A0 penalty_jiffies =3D max_overage * max_overage * HZ;
>  =C2=A0 =C2=A0 penalty_jiffies >>=3D MEMCG_DELAY_PRECISION_SHIFT;
>  =C2=A0 =C2=A0 penalty_jiffies >>=3D MEMCG_DELAY_SCALING_SHIFT;
>=20
>=20Before that, the shift ran on the u64 temporary and the narrowing int=
o
> unsigned long happened afterwards. After it, the value is narrowed
> first, so shifting it right by 34 always yields zero. The division play=
s
> no part, and in v2 the diff no longer goes near it. Your other point is
> settled by the same rework: with the clamp gone, the comment goes too.
>=20
>=20How I'd like to proceed:
>=20
>=20 =C2=A0- Zhang Jiao: would it be OK if I send the combined series? Th=
e overflow
>  =C2=A0 =C2=A0fix stays under your name and keeps your changelog, in th=
e shape
>  =C2=A0 =C2=A0Johannes suggested, and I'd carry the 32-bit truncation a=
longside it in
>  =C2=A0 =C2=A0the same series. If you would rather send it yourself, or=
 split it
>  =C2=A0 =C2=A0differently, say so and I'll follow.
>=20
>=20 =C2=A0- Song Hu and I have been in touch off-list, and they are work=
ing in this
>  =C2=A0 =C2=A0area as well, so the patches under my name will carry the=
m as
>  =C2=A0 =C2=A0Co-developed-by.
>=20
>=20 =C2=A0- v2 will include what was missing before: a Fixes tag for eac=
h of the two
>  =C2=A0 =C2=A0regressions (e26733e0d0ec, v5.6, for the 32-bit truncatio=
n;
>  =C2=A0 =C2=A00e4b01df8659, v5.4, for the overflow), Cc: stable, a chan=
gelog that says
>  =C2=A0 =C2=A0plainly that throttling was completely inert on 32-bit, a=
nd the wrap
>  =C2=A0 =C2=A0threshold corrected to about 130x at HZ=3D1000 -- the 409=
6x figure misses
>  =C2=A0 =C2=A0the HZ factor.
>=20
>=20Two separate patches rather than one, because they are different
> regressions with different lifetimes, which matters for the stable
> backports.
>=20
>=20One number that may be worth putting in the changelog: the smallest
> exact-zero case is memory.high at one page with usage at 2049 pages, wh=
ere
> max_overage is exactly 2^31 and the product wraps to zero.
>=20
>=20Thanks,
> Hui
>=20
>=20[1] https://lore.kernel.org/all/20261029073857.974-1-zhangjiao2@cmss.=
chinamobile.com/
> [2] https://lore.kernel.org/all/20260818012115.65838-1-husong@kylinos.c=
n/
>

Hi Zhang Jiao,

Gentle ping: OK if I send the combined series with the overflow fix under
your name? If you're busy, I can carry it forward and credit you.

Thanks,
Hui
