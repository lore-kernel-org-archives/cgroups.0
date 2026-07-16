Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D5663B9;
	Thu, 16 Jul 2026 03:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784172548; cv=none; b=jOUa1vnoOf1GkUTOOnel5F/Ccaj9AfJBimizFYZxS0LjOYkVXm+JOJ4ONZHRWnBeDv9ubESoBj52oAAJZ5JDkm30MOcVpV0/xNykzYIo9wBqyNiIlNEcjcG+vXcVnNp8kjRTEJ2SR7X5lrZvENi88Dnasz8/GErKS+/6kSEpsOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784172548; c=relaxed/simple;
	bh=J2YEnM4t5mLWU1Nht9balyGsc9rTwGqXXcNB1tF8TPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ya3cJ7nX0jMVuYJodkH9kHZGOsIViAEA5fP3EOzofixrAQhGW3Hq3Ro+WBzA2j/rxpxo5f1UJpRAAlArmmDyhYi6gvw6GOjIS5f5enlLoK2uQv9/xBjCYaZX0J5mexX71y0D6t1WIplMA2I37/fgZNXXc5kKwCmfwwUaECQZ+BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gYm7ML9t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gYm7ML9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DCB1F000E9;
	Thu, 16 Jul 2026 03:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784172547;
	bh=PUg+12QG4vSpX4SAh8HFUD5gRWGHLyJzN9G7+NNYJZY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gYm7ML9trISPjlPVSeDw88FuWYrGVFHjgNEcqlArcKET0eUo34FejkWcq07KvMA4W
	 9FAOWeM+XfiTWLKp0hqFVdwyCo02vHfbYPdHqvJLs6y7sMdgwd+3BOyLp5Ln6vj9FD
	 uziwxF3uNOVstrjkmjgpIOQ+I+cBz+B17zqyBxPBZZUZyLTe43+dv49ej3LSCKL0xV
	 RaHtkGSjpY3okW8zy7ZwrkJTKCOhcD42J8CTPbj/6PoxX88C9OvXurpLgOM9dGdCcM
	 O1iiIw8UsdT77+8vRyZtZJm3Sp/iTYUjKqGh29SnaY+Mp0ntjb619IHXEOiOnt6R+O
	 yg5K3GviAYOtA==
Message-ID: <0d191478-43fb-4286-a2e6-3e7f3047b42a@kernel.org>
Date: Thu, 16 Jul 2026 12:28:50 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/12] mm/slab, alloc_tag: reduce obj_ext memory waste
To: Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <CAJuCfpEVQU6s58s9XWCVDUXzr=7bbatmCi35vxnSiyA1pe1P6g@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CAJuCfpEVQU6s58s9XWCVDUXzr=7bbatmCi35vxnSiyA1pe1P6g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------2W0maZ7GPqqOL0PvX4GiTb0p"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------2W0maZ7GPqqOL0PvX4GiTb0p
Content-Type: multipart/mixed; boundary="------------tIgFmoxJ8ComLrftXtGV8HCG";
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
Message-ID: <0d191478-43fb-4286-a2e6-3e7f3047b42a@kernel.org>
Subject: Re: [PATCH RFC 00/12] mm/slab, alloc_tag: reduce obj_ext memory waste
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <CAJuCfpEVQU6s58s9XWCVDUXzr=7bbatmCi35vxnSiyA1pe1P6g@mail.gmail.com>
In-Reply-To: <CAJuCfpEVQU6s58s9XWCVDUXzr=7bbatmCi35vxnSiyA1pe1P6g@mail.gmail.com>

--------------tIgFmoxJ8ComLrftXtGV8HCG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/16/26 12:32 AM, Suren Baghdasaryan wrote:
> On Wed, Jul 15, 2026 at 3:10=E2=80=AFAM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>>
>> The recent fixes for objext array handling inspired me to look into th=
is
>> finally. It's been bothering me that the memory usage of struct
>> slabobj_ext depend only on config options and not whether the fields a=
re
>> actually used.

+1 one more person bothered by this...

>> So with both CONFIG_MEMCG=3Dy and
>> CONFIG_MEM_ALLOC_PROFILING=3Dy there is always objcg field and codetag=
_ref
>> field. And thus:
>>
>> 1) Having memory allocation profiling config-enabled but not
>>    boot-enabled means wasted memory on unused codetag_refs. This makes=

>>    it less suitable for a general distro config and the page allocator=

>>    side doesn't suffer from this, only slab and percpu.
>>
>> 2) Complementary, with memory allocation profiling enabled, there are
>>    caches/slabs that don't need the objcg field, so memory is wasted o=
n
>>    those.
>=20
> It's funny because yesterday I started working on a prototype for the
> same optimization. But your patchset is much more mature, so I'll
> focus instead on reviewing it.

Ouch, a race condition!

>> This series should solve the point 1) fully for slab, pcpuobj_ext
>> handling can be perhaps improved similarly, haven't looked into that.
>>
>> For 2) it avoids allocating objcg fields for KMALLOC_NORMAL caches whe=
re
>> we know they are not necessary because kmalloc() with __GFP_ACCOUNT wi=
ll
>> pick a KMALLOC_CGROUP type.

Unless KMALLOC_RECLAIM !=3D KMALLOC_NORMAL! (yes, SLUB_TINY)

>> The named kmem_caches are tricky. They can be created with SLAB_ACCOUN=
T
>> and then we know objcg fields are always needed. But also they can be
>> created without SLAB_ACCOUNT and then some allocations have
>> __GFP_ACCOUNT and some not and we don't know that in advance.
>=20
> Do you know how often this happens that a named cache with no
> SLAB_ACCOUNT is used for __GFP_ACCOUNT allocation?

Not sure about how often, but one thing I recall is xarray
(radix_tree_node cache), which decides to account the objects based on
xarray flags.

>> A possible future solution is to introduce e.g. SLAB_MAYBE_ACCOUNT, ad=
d
>> it to caches where we know __GFP_ACCOUNT is used, and only honour
>> __GFP_ACCOUNT for those, while warning for an unexpected usage
>> elsewhere.
>
> I wonder if for such caches we could create two separate caches, one
> serving __GFP_ACCOUNT and using extentions containing objcg and
> another one for non-__GFP_ACCOUNT with optimized extentions?

You mean transparently to users? (e.g., user thinks it has created
a single kmem_cache but actually there are two of them, multiplexed by
__GFP_ACCOUNT bit)

--=20
Cheers,
Harry / Hyeonggon

--------------tIgFmoxJ8ComLrftXtGV8HCG--

--------------2W0maZ7GPqqOL0PvX4GiTb0p
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalhP8gAKCRCGXBN6rc5S
1uJFAQCHO1N5GdmpwK5dT53zxVvqwtCPyRXEpUHeeKDpXt8rFAEArBwT5mE+9Ft5
DbFjx1ACc5qvWdtSrfYbbdZR8F1WNQk=
=SwZs
-----END PGP SIGNATURE-----

--------------2W0maZ7GPqqOL0PvX4GiTb0p--
