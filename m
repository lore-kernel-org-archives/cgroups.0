Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D7526AC3;
	Mon,  5 Oct 2026 18:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791226231; cv=none; b=BrO1WWhk6vZiu6MMzLtMWt9PphO1ELDQ+HZFpG/+g3W+gbo227z1eZ2ZG1BxQ7PJ7F2pOBsWsT91ZGC9xT+UB5heADBEzECNZTdvjgiM+tmzTOvw4exAnQDYpqDiG95M0S8qdz755hgxxOHDGW3dJON/BopAAauNpgaw6KEADko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791226231; c=relaxed/simple;
	bh=7Esv7UIvddDrGvDBQ12d3e2SEI05Tow3/227mVjVrkI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZOI8QQQ0nMRwLhfdmrTx/yfD8d006bzyhwPbMr5AYzG+ekb2hPigl9sUhyS992/f73VYFSi6mBl6feRzDUEhU9a0yAehw0LDWsFOkorL/iJr2v7TEwKEvzFFd6YxNiMw3Cxr2XIAsVYzrm5/Ua0P/OfbhVqZItxf9FxRl/2+Tv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=UFaEm4i7; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="UFaEm4i7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=7Esv7UIvddDrGvDBQ12d3e2SEI05Tow3/227mVjVrkI=; b=UFaEm4
	i7kbzszQvBnUlHBsuMJfNnQEsHikyiuJjCuatz3gHX7wE874iIvFEczHql0jwbJ8p8GFughTIvemv
	w1N5F3XHAUlQYVT3HTsyypUuXyM/hBopS31NorW8EWRVM/fDTrXUsdF5LMB6aFIvuRyqhIdM0VzdZ
	GO/OZoGExMmrKlqmVxnXciadGcb6cu7tIiGwGdt+DcomOX/ph8QsDq+5JbHNYx5wODiRZs/ttjvOU
	v88Jpo4cyp6CVmpVPmFbuu5omVG4lv8T1F77DXWFnCIaHwyCkYka8FB8ZRe2VxsHmuhMoo4xUCVJH
	HCICj4WpnktyxBUQRfOkAvnCWRXA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xDnky-0000000702h-1a3P;
	Mon, 05 Oct 2026 18:49:48 +0000
Message-ID: <822e26563419d8e3ffc13c43603ef79d4820503a.camel@surriel.com>
Subject: Re: [PATCH v1 1/3] mm: memcontrol: factor reclaim logic out of
 try_charge_memcg()
From: Rik van Riel <riel@surriel.com>
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, roman.gushchin@linux.dev, 
	willy@infradead.org, jack@suse.cz
Cc: mhocko@suse.com, muchun.song@linux.dev, david@kernel.org,
 ljs@kernel.org, 	vbabka@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, 	linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Mon, 05 Oct 2026 14:49:48 -0400
In-Reply-To: <20261003001555.3498357-2-joannelkoong@gmail.com>
References: <20261003001555.3498357-1-joannelkoong@gmail.com>
	 <20261003001555.3498357-2-joannelkoong@gmail.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-10-02 at 17:15 -0700, Joanne Koong wrote:
> Move reclaim logic in try_charge_memcg() into helper functions so
> that
> the next patch can reuse them.
>=20
> In memcg_charge_reclaim(), we can call memcg_memory_event() directly
> instead of passing in allow_spinning. allow_spinning must always be
> true
> here since memcg_charge_may_reclaim() has already checked that the
> gfp
> mask allows blocking, which implies spinning is also allowed.
>=20
> No functional changes.
>=20
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>=20
Nice cleanup.

Reviewed-by: Rik van Riel <riel@surriel.com>


--=20
All Rights Reversed.
