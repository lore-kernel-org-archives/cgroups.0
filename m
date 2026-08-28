Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FE737E5E7;
	Fri, 28 Aug 2026 16:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787933638; cv=none; b=kzrMkdrWrue95RC4rM6UKZkUuwP3KXXGdxbOf8OpcbIgmLjkstGe57zQWWvQ0Mzy/en8d3f9e2DzzgNXysxikMhN257flSgWUYx9eofZnH62ck4l3uO30/ayNnkzpDAmzZvEe+jEoY7VSfjlbtOrhTAaARMKRu+tisnkBQPA9V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787933638; c=relaxed/simple;
	bh=IFcfwBysJINcxMfSNDFyM7b2wk60J46XwABn1gllY0o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Lm2I9RC+2igAaL+XHGQCLM0K2iA/U0JXkyIL6WzQk6OSjuZUJhfTNjAByY19uxTcqwgeMe+H6o3E0X5Ckv4R8p3Xsxe+mnV7wuKRbyz3cjnFDT57PyBwNLP/mQn5s6WBNJysEsS9Lk9mdS4NVqsGbd5KKe7WqXlsqeOp+uNMUA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=D7QqSmOb; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="D7QqSmOb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=2TOHanlDmqs1MCHJU5mQ5YIvRXJl2lupzJtXXmLOVuc=; b=D7QqSm
	Ob0+hY6lYjhI0Mzw0AH2csJnCE+N3S4MXGbqzhQ59iETcGH/paxg1sekw1Ygx1ZKzTXEhTRgQGH74
	2+Hjj+2rJ31B4kZ6geCR5VjVJ1ECb5Y4zN2O61xgAyM1pECogqFvNTczfLyeY5zUhLzYI5xjGZDl+
	rDEyeUw+8BQx91da9opjZX/b5GK0YyyTWRKNs6kmDjvgN0yc5KhvnFDayjmbz9rpytl+SpzPzmOFP
	KcZMn+JX2emjqoo9RBmWuAxjyi71NAC5WTDZ0daFU2aTGlu+Gifv053Xdb3qgbTPgih7rDEqpnvGi
	Nog8LJW6h20W4JwnPPoFtvH0VH1Q==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzzDA-0000000927k-3eII;
	Fri, 28 Aug 2026 16:13:48 +0000
Message-ID: <35008c3b1d00766116bc9b6768d42238099117b8.camel@surriel.com>
Subject: Re: [PATCH] mm/memcontrol: avoid stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
From: Rik van Riel <riel@surriel.com>
To: Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, Andrew Morton	 <akpm@linux-foundation.org>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, 	kernel-team@meta.com,
 stable@vger.kernel.org
Date: Fri, 28 Aug 2026 12:13:48 -0400
In-Reply-To: <apGro0MJ-brPJfoa@linux.dev>
References: <cover.1787890328.git.riel@surriel.com>
	 <a611f2bc40d30f9c14a6f41b173185975c46a203.1787890328.git.riel@surriel.com>
	 <apGaZdxAPH68kkCc@tiehlicka> <apGro0MJ-brPJfoa@linux.dev>
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

On Fri, 2026-08-28 at 08:41 -0700, Shakeel Butt wrote:
>=20
> Let's go with this patch. We can simplify above by inversing the
> check:
>=20
> 	if (cpu_is_isolated(cpu))
> 		return false;
>=20
At that point, we could also clear the bit here, and
have the function return void again, so there's no
duplication of that check and clear in drain_all_stock()
> =09
> 	queue_work_on(cpu, memcg_wq, &memcg_st->work);
> 	return true;

Let me send that.

--=20
All Rights Reversed.
