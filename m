Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5253CDBB5;
	Tue, 23 Jun 2026 08:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782204165; cv=none; b=N7+2PgjficteQTAncRJeW4sJWlyauzFXwHZn/8TxckLORlHgNgTTBKFhuHcgo/l5wfdnym76yAziiTyX+RlspXJXl2JlkljIs5J7PY8CMkYCIyXyQ6q6gpw8UwePGV+4o+wN0k35ANFuG/53uGpN8gYW9rz2Z2sh8CmV9tQnND0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782204165; c=relaxed/simple;
	bh=lC2a6gEk6DKNzfEwQ026hNRlUrmMZMPuXnV7OMb51bk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nLLoIyoz3RwncklXwxZwcTXzsjlmxTWOIdMtRJ0MxeJUh7kXtNikIPRR3bHnYw0mrqJzgNuFIzRskzG6eVbVw32DyMeut+H/dG5vIwVGdOmbBj/Lb5OLzHEf5negki3QmkFD97ML+D6L95Ke88J5q47c03NKDyzGmmX5+AbHCM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kH1EY9Ft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kH1EY9Ft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7D61F000E9;
	Tue, 23 Jun 2026 08:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782204163;
	bh=WvtWN1xiCjJwXiB3+SIzkmRkMwl7Gqj7f6Y9+Y6EJHc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kH1EY9Ft+UdI/ni3u57iqoC8MmP0qyZL/qIE/vbffZbyFWP2v014OtRjw+jgb0Zix
	 bKYQ4IgnCcmiMrvMRlBqQ7shfTmaZHA+9LmWCXohb/d3qwyD3IOKkn6BQN1Z8zwYHM
	 JUsCpm8HNwZMNC0EQvV4UOZDCHp+7PZPAnEM4pMJzVOevfOU5K7Hgrmv7qrub9pQpd
	 ppn1BjZ74vV6ZH7Q2Ug6Mz2CbEPUin3vpbK/IGNMqSQ8Lo0tu2FB56fQkJJNzb4ht7
	 cYqEczV8M2k0mH43v0pPgfAF0T6p7HGpapbsXmqNtxWEfTpTiQhen6xkQJ+1GyysNV
	 zxUWOpUpcOH5A==
Message-ID: <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
Date: Tue, 23 Jun 2026 17:42:40 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260623082614.81621-1-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260623082614.81621-1-guopeng.zhang@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------LgOrC2BRSzJunWsHWQMW456l"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------LgOrC2BRSzJunWsHWQMW456l
Content-Type: multipart/mixed; boundary="------------3PVOusf7gTMSTMxMX4UWEjnM";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
Message-ID: <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
Subject: Re: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
References: <20260623082614.81621-1-guopeng.zhang@linux.dev>
In-Reply-To: <20260623082614.81621-1-guopeng.zhang@linux.dev>

--------------3PVOusf7gTMSTMxMX4UWEjnM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/23/26 5:26 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>=20
> A patch filename was accidentally inserted into the comment describing
> the nr_bytes field of struct obj_stock_pcp. Remove it.

nit: perhaps add something like
"Fix a typo in the comment (target -> targets)"?

> No functional change.
>=20
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---

FWIW,
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!

>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..3eedfc4e84a0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2039,7 +2039,7 @@ struct obj_stock_pcp {
>  	/*
>  	 * On rare archs with 256KiB base page size (hexagon and powerpc 44x)=

>  	 * keep nr_bytes to unsigned int as uint16_t cannot represent the ful=
l
> -e patches/memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch	 * sub-pa=
ge remainder. Such archs are not cacheline optimization target.
> +	 * sub-page remainder. Such archs are not cacheline optimization targ=
ets.
>  	 */
>  	unsigned int nr_bytes[NR_OBJ_STOCK];
>  #else

--=20
Cheers,
Harry / Hyeonggon

--------------3PVOusf7gTMSTMxMX4UWEjnM--

--------------LgOrC2BRSzJunWsHWQMW456l
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajpHAAAKCRCGXBN6rc5S
1l19AP9QHR1322qFfoOBeJdfJ6IA6ZpZt3Tz6oa0N59Be08okAEA9sJXP5B7C9O9
pgwT4jOiILEhQIen/p8J71ZxryzPoQQ=
=MJe0
-----END PGP SIGNATURE-----

--------------LgOrC2BRSzJunWsHWQMW456l--
