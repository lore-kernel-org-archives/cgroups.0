Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BA11E5714;
	Fri, 17 Jul 2026 07:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784273815; cv=none; b=pGQhJpQYiEzzPU3zcZJf1rceYO/OTyHIbXFI/gX3Mfl5Hffv24W1itAe6ifGPC5IvC3ViCvx2nLy0xD7rtx+xSt3mKPoUVLgzh6XY4N4HmCx1CSDV1Hkr4XqBtBa1RzbSpBGHeOvh3hLT+IZ9BBkvHyPDOyR/x987MqNMrP/DPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784273815; c=relaxed/simple;
	bh=dHxVnGRt+88jdj6BhasKEHLIa/iHX1TE22XKpmpdAI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Umof7TOhpqfadmJEtgrhwy1Cno2ZpgL7OO2Ut5ozehBIMvytWfjYYvdlDWST3ER7mQyhTjO76pd2dBKthksH6KHUS1ZrDjAGj0YDdf0m97ZslUbQjrhJGCIY/7EaFUb7/VSSFojCiPFOSWkW2U/6h200ja1NsKHY1zA05OIPJro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eTORVCg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eTORVCg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47ED1F000E9;
	Fri, 17 Jul 2026 07:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784273813;
	bh=YNAjdcvaa7gS4IYw+DsY8dj8TiKJE8dkpDnHDWNJNyk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eTORVCg2Ti8Q98ZZ8p45uMYF9lG6FF1OuXbIooRdjwU6PHSgqRmrCBGfITV2QrkPr
	 PzCf1z1TE/w6CZNaEjesXi30/1DjhOg2rbCqiX882ERSMVfoduP0nvh1zR/NMtH2LE
	 iYTbA516ZhVbhlXdbUGzX24JH815eVTRrcVjqXV0l7byuM3zr8t8HRJP+YgHxpv4tP
	 4LmEXA1qOWSYsQfDbrMdICwRvVC+jhZLxV+15k6aO7HlkN/Jr2yc0iYxpIltAqevJr
	 0dYc85lZe56fleeD3z+WG0Dp+lFIGCAw60yGrlh2QmE6q+lmkiAA9fG16xp92oP0Yw
	 CVWoKr/mS9pxQ==
Message-ID: <5d96283c-46fb-43e4-ac83-fb1b860fd6df@kernel.org>
Date: Fri, 17 Jul 2026 16:36:47 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 12/12] mm/slab: stop allocating objcg pointers when
 unnecessary
To: Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-12-9a49c4ccf4c3@kernel.org>
 <CAJuCfpHuXu3BDf93zeBQWSW_k5wApegp44rHoZwk5Ym6xxbqEA@mail.gmail.com>
 <e126d6b1-bed7-46bb-a8a3-cc555707b516@kernel.org>
 <CAJuCfpFicmMa54V5qVY7BYQuNih9u+-bQ+x51VDza7zWPK_mOg@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CAJuCfpFicmMa54V5qVY7BYQuNih9u+-bQ+x51VDza7zWPK_mOg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------juhReEuigYcjM4PhzvKkCSZ4"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------juhReEuigYcjM4PhzvKkCSZ4
Content-Type: multipart/mixed; boundary="------------3d68Z9z4SzjRYMjj4IDJtfZ9";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <5d96283c-46fb-43e4-ac83-fb1b860fd6df@kernel.org>
Subject: Re: [PATCH RFC 12/12] mm/slab: stop allocating objcg pointers when
 unnecessary
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-12-9a49c4ccf4c3@kernel.org>
 <CAJuCfpHuXu3BDf93zeBQWSW_k5wApegp44rHoZwk5Ym6xxbqEA@mail.gmail.com>
 <e126d6b1-bed7-46bb-a8a3-cc555707b516@kernel.org>
 <CAJuCfpFicmMa54V5qVY7BYQuNih9u+-bQ+x51VDza7zWPK_mOg@mail.gmail.com>
In-Reply-To: <CAJuCfpFicmMa54V5qVY7BYQuNih9u+-bQ+x51VDza7zWPK_mOg@mail.gmail.com>

--------------3d68Z9z4SzjRYMjj4IDJtfZ9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/17/26 12:32 AM, Suren Baghdasaryan wrote:
> On Thu, Jul 16, 2026 at 8:08=E2=80=AFAM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>>
>> On 7/16/26 06:46, Suren Baghdasaryan wrote:
>>> Maybe now we should rename static_obj_ext_size() to
>>> static_obj_ext_max_size() as it reflects the max possible size of
>>> slabobj_ext?
>>
>> Hm with _max_size() it doesn't have to be called static_ anymore?
>=20
> Yeah, static_ is an implementation detail anyway.
>=20
>> But maybe we can get rid of it completely.
>>
>> The only caller is calculate_sizes():
>=20
> I was thinking the same but either way sounds fine to me. Keeping
> obj_ext_max_size() would be a bit more self-documenting I think.
>=20
>>
>> #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
>>         if (slab_args_unmergeable(args, s->flags) &&
>>                         (aligned_size - size >=3D static_obj_ext_size(=
)))
>>                 s->flags |=3D SLAB_OBJ_EXT_IN_OBJ;
>> #endif
>>
>> We don't have slab pointer to pass to static_obj_ext_max_size().
>> But we should be able to figure it out from the cache via
>> cache_needs_objcg().
>>
>> So we'd need cache_obj_ext_size()?

That sounds good?

slab_obj_ext_size() takes slab parameter only to optimize access
but the obj_exts size is already per-cache property.

>> The static max size here works, but may prevent SLAB_OBJ_EXT_IN_OBJ
>> needlessly if padding can only fit codetag_ref and not objcg, but
>> we don't need objcg.
>> Which is probably only theoretical at this point as kmalloc_normal
>> caches (that have no objcg) have no padding, at least without
>> slab_debug. But still.
>=20
> Maybe keep it simple as is for now and then we can optimize it further?=


But cache_obj_ext_size() isn't adding much complexity?

Not sure why we would need something that represents
"maximum size of obj_exts across the system" anyway...

--=20
Cheers,
Harry / Hyeonggon

--------------3d68Z9z4SzjRYMjj4IDJtfZ9--

--------------juhReEuigYcjM4PhzvKkCSZ4
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalnbjwAKCRCGXBN6rc5S
1kz3AP0c8Fcvhsk6QCY076Qq9xU7Ajbm6fPXywxZG2uE2iNtXwD8Da200DO4Q7ge
R8RmBS3245J6QFXDzPNcrjCpLU1oPg0=
=loeC
-----END PGP SIGNATURE-----

--------------juhReEuigYcjM4PhzvKkCSZ4--
