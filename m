Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=96.67.55.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785870;
	b=HrdSil7MhWArHnDfRLswQVRjkzKqMHvtjerASIo1mKUlP/xLCaetNZW+jyDWNBJTVm77
	 XTx2gCdMSWGf63m3+nzg+slgZ8bOmFDDx3Ky3nwUVa6Vgzb9al0mtTWqy716SpQXZjGCB
	 nmmGf0pgdtee0Z92ZCpCOzPnN9Ke798lKEBd7ByMvZjS5RCJujuTYu7NCtpQzAyOI2rmy
	 /wQiUd8fVVS/w/j439ZGIkJObTCQeknC85OwPywIttSv4tTCPqBRoOsPi26HjeapZZhvs
	 UfZIs7ov49MDBb/u3FyW9lTbQBxxks9iVCni/Rv3u7zHVwkFJSKVzwD0wAApEmsPu5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785870;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=L5AsRIiZMbrgA4PZqqlNr6o4NUAaZZjGSwOgBDqGUkk=;
	b=GAYvWVzrZf82UgRv0LcXQuqu4gctCvd7TcyS65yAJvxsK695Q7PaJAyDWkSEaVWEJOu9
	 v6rATK7KTvphmhjHcJNHXRAqC5Z6cH9QAnWZ30WU43m+/Ns/JKLezWtGPICZYJiL3Ix4u
	 UqY/7Mpur+q4MVHhk1GZOCGa9AOc8YqxbGk6fW7n9qcnsqcQ90gFqqk+YhLZ0uh+ujh0B
	 oIVm137et3zZw7ldQmaR6iS5LDIeK4IosQS0LMUhQeNcI+EgRLW0IAg9lfufEBwvn8sZp
	 Nejg8u0LzQYBp8SkOfMwI3M1jxnIOBtj2Mv2vHeM/DD+OPp4CFkPOnc+tKqLvc7twsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=surriel.com;
	spf=pass smtp.mailfrom=surriel.com;
	dkim=pass header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=Kviwx26c;
	arc=none smtp.remote-ip=96.67.55.147
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED745606A31B;
	Fri, 23 Oct 2026 20:04:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED745606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=Kviwx26c
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=L5AsRIiZMbrgA4PZqqlNr6o4NUAaZZjGSwOgBDqGUkk=; b=Kviwx2
	6czWisXsriXBrkBD9a99LPzObI0uncUBqAkxbr0AxsGcfrYvF6TM7eENn+2X//B3fZWQZAkWyAZZz
	0a1neBuP1wri6WTonSlsO6hqn7ogvS5EEKOg+TsfKZW+DkDDvpvPS9CjgkREH7pDUlY7aHgpjw5EO
	r3nwcBCJI7/4wPgqwfIZ0BYeV/fHzlCCE5yO9x4m0k4QP89kZIlJO1k6uY2T8flV1POY6/CT7fdRa
	mOEP+rpg9cZZOsKcszbuFTsXvZcjzY8+p2oBedFFecqcJEtLBqqzpnLl1A+NioHb1/wmV2IsLd0ob
	TK8f3hBn6n8c+o8k1wXi9EJ7UZQA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xKLTn-00000006rxs-0kX8;
	Fri, 23 Oct 2026 20:03:07 +0000
Message-ID: <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, Michal
 Hocko <mhocko@kernel.org>,  Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
 Muchun Song <muchun.song@linux.dev>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>,  YoungJun Park
 <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen	
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu	
 <weixugc@google.com>, Gregory Price <gourry@gourry.net>, Wenchao Hao	
 <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins	
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo	
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Shuah
 Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, Meta
 kernel team	 <kernel-team@meta.com>, Linux Memory Management List
 <linux-mm@kvack.org>,  Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn	 <joshua.hahnjy@gmail.com>
Date: Fri, 23 Oct 2026 16:03:05 -0400
In-Reply-To: <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
	 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
	 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
	 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
	 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
	 <aqgMCIOFi0dKx_6L@fedora>
	 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
	 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
	 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
	 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
	 <20261014195354.GA371161@cmpxchg.org>
	 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
	 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
	 <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
	 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
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
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-10-23 at 10:24 -0700, Nhat Pham wrote:
>=20
> * Swapoff: this was brought up as a request, but we ran out of time
> before we could discuss the motivations and use cases behind them.
> Folks interested, could you explain as a follow-up?

This is one that I really don't understand.

In my mind, we have vswap sitting as kind
of a swap VFS between the rest of the system
and the swap devices:

+-------+     +------------+
| vswap |-----| swap cache |
+---+---+     +------------+
    |
    +----------+-----------+
    |          |           |
+---+---+  +---+---+   +---+---+
| swap  |  | zswap |   | zram  |
| file  |  |       |   |       |
+-------+  +-------+   +-------+

When a page is unmapped from userspace by the
reclaim code, it goes into the swap cache.

The vswap layer then decides where to store it
at eviction time. This is configurable by userspace.

If the zswap pool is shrunk, the vswap layer knows
where to put the data next. There is no need to
change page table entries to indicate that the
data was moved from zswap to a swap file.

If we decide to disable one of the backing swap
devices, the vswap layer can just move the data
into the swap cache, and the page reclaim code
can evict it into a different backing store, if
needed.

Using vswap as a swap VFS would also allow us to
get rid of the page table and tmpfs scanning
code we have in swapoff today.

In that model, I really do not understand what
"swapoff vswap" means.

We cannot umount the VFS.

What exactly do people want to accomplish here?

--=20
All Rights Reversed.
