Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794444959;
	b=D7kc4PXkUzx9y087yW/98ghGfu4sPgID4izcqU2IisWeZlcPptpPyPG3xycv+qFiMpcj
	 CA5xZwX2cVWOTFKb2DgvvW3DGypComNzA9rralYrtXL5aluazia2cW7WxgAILXNysHVeP
	 wxT0NVTqA8W9pZHmDmL+W2H6FpUYr6J01SA6AiLJNX9MhUMyeILNbRgniqoo75XRrcM4a
	 5P0xodhe6/W/JzqMFyRQ7c+0OjE4JLZ84mtbQ5yuSd+wn3JSaVB5W/fm+Wj6Gqrt8GJHs
	 hQYWp5ia8H8U7cKM+HwFJ93E7ZKLHWRj+z9O0mOX6VOPX95auqJBR6XWDHKcdQ9Xttg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794444959;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=bGlo5KpYncJxMag4TeoNCPiBlXpzDdXv/wZ8+6Y+c9w=;
	b=nSt8wXgTpdGAbPlARMp1tjOhHXLAW7pLO/oSRcju64K2P976OXMx3jqVd1wFjAXQ0CwU
	 ie9ekyTMibpP+bkyyGJUrE95ObmLuTmT2W03ecllj7R8i2M6DcoTtXfC9QdOyNapzpMJa
	 wotkdILfHfYI4E5Wbvq3EBxhT+VH1rGhiZZrYKZ1CFr7UwZnLM546TZ11wSp6oXUB2E7g
	 Iy1n0rCWfcvfHOBAe+c+B+VlA/7O1D/DwJ4dIsIuvp9XurKzX0/fXd1Z/TC+F+V6v2Lz6
	 VlJG4+O+PrdAzaGoruikhHI00Orm0OC0n323JX+cupzL98nDx5Hkk8SVoyuFYJJznaA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=perfloop.ai;
	spf=pass smtp.mailfrom=perfloop.ai;
	dkim=pass header.d=perfloop.ai header.i=@perfloop.ai header.a=rsa-sha256 header.s=google header.b=qkxUeQ4p;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.51
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D449A606A324
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 00:55:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D449A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=perfloop.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perfloop.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=perfloop.ai header.i=@perfloop.ai header.a=rsa-sha256 header.s=google header.b=qkxUeQ4p
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-843cf077f10so4637569a34.1
        for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 16:55:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794444958; cv=none;
        d=google.com; s=arc-20260327;
        b=iN9Zszfai77beLdiRLCYFKLc1hZkYjerFXZwU/S0PgEzRqYTi+ja0vRfKSzqBAiKqy
         bS6UcbQyJpmaQjLiJEEN3ujSF4mYzhuJhU6ciYMguJhBdx7TqKgBeAhdQl2yzsgviy2P
         QncCg2lBKjZDjPWdW/TJb13Iom5z3il4RL/ZPCSVdlIavSNdPW+mC3OwRm+guW0wnAyW
         7khZwJoivmR1jzM9a9neVN/nNJuYyIgVHkiwC+7CZ/HeeK3DiyQxvAcfCUbsWN2qUaeQ
         KP7SlhB9Jsx5z4iqWhof/tYv04j/kuyYdHA3Sr/u3yyDJhESyWSN7sHsxqeR9K0GfaHD
         AkPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=bGlo5KpYncJxMag4TeoNCPiBlXpzDdXv/wZ8+6Y+c9w=;
        fh=B48UQpU594SsoqnhN+ViNoo/nlNxg5PqfdScMWVrEaA=;
        b=qE5lA0vBDSSGA2vD5E8WjZ1cQn8AbCHXyby6pPoNj5diY2QCIdxFDoXQlgC2nVstFo
         zpc7oSJgL+YiplScz1GwFTNHNol8tOebJwVu0agNT1d+0ObqC7g/MiFr+NnyYuh/3WR9
         SydZAgH58ojPPdhkdGxuOB1Nb3UDjAX0h+iPhFVYidARatqzC+5uLGtGik4v6yUL+SsR
         JHKX0oMgRLL70tMrxlkvDGo5BjXpG/zufGJqGFetYn6zUzlQSNyjtPjjf6p38S80kwJg
         W1RUlVdr9gq4GL+ylcz+lWkgnc0Ggoi6lz+HhrOpS4KuPubOKjmyLOKOk1AbFynAF2c5
         IMpA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=perfloop.ai; s=google; t=1794444958; x=1795049758; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bGlo5KpYncJxMag4TeoNCPiBlXpzDdXv/wZ8+6Y+c9w=;
        b=qkxUeQ4pu+NEnEHiGqyXQxSiaV4qsKZk9ImyHB44v5FFuxwAH2jJ+hIOBK/H+kP1qd
         00Dbpsz2RQbcvxCwzCos65a2WzJCwXTVO08vDnphO2pnkru+hm+NeqWSv59xG3LWMI3i
         m0SLjJcV0TJ0nK9gJNi+UkdJ0mTf+JV54W4TzQ1+sSpWHIXLqQxK7LrrUKVmlkBABe4O
         yp+LMPuQOp0UCKBLX6gBpIgVBlXtpuywxr7E+Ntt4RBsr2eJJZNAWHrqht3gxWl1lx5c
         hg4PRMQMoe79m6un5YadjVWy/7vX27Y1jNoY8IiydKhkGul/QTt305NwdT2IPygqVz/l
         ADkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794444958; x=1795049758;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bGlo5KpYncJxMag4TeoNCPiBlXpzDdXv/wZ8+6Y+c9w=;
        b=MkaCJ/1qWA/VX1BPsZGkqSoemFK6CeXGLV11kzqefAczoXsrJc7HevM53Ci+1voXUf
         LRtz9M6872mL9218OsDMSVpk4JOMt+O+Nc4DVxjb16DzbktCY65iKkZpeL8f3KdmPiEj
         HZ0N8Lq7fgqzma/EQpWChjqUiVZMEjMqA/v0MaCQRQtrtzuoVN3pXbEhbzlzD79z5Zdm
         y2wvAskqZrmik8WL6t1siSA2xGGghMRA8Cms9+CjjnbJTdzrqaObEuq8hXbRJwl0sKcz
         82KNJ8hy8sE68Qa3uBU/5B61H3WJxqjtpWja+odMEY5xvCG601rDU+Z3PkviJYeE9bN3
         ifhQ==
X-Forwarded-Encrypted: i=1; AL+hErHGxgjKcgdqVlD0CKM20KeKbNGKSI0uODUXaSROENnCkipK0yM0PBQkLzrqS0tIYYvyO3SiiUBE@vger.kernel.org
X-Gm-Message-State: APuU4Z8ERd2cE7cvJ1cjA+y5PRLbD2In8bqnLUQaed9Cxl1ZVVPDSit4
	64XUz4T5Ahbf7AVnmfSVHyD6JRpnBiT9sDnTXhD2vpst8dKkwTYNBJLUjAYpky8zTAR0kXjDF+g
	WMWBPhPokIdOUPrP0rpOtZxEiRQEew2eiWfx2sfzTdqEshemDGZv9pQd0uCRgoA==
X-Gm-Gg: AYBFou3jracwK64mEja57ZL5wj5oiIGtZq/yyVGTNP0Oiem95N3/VmOfb6HUm8ChmOX
	HQDVTdFkH6DXuxC8cHCi1q2BLuvPoYaYFXslc+bMzbtY7U5o4HpM6qXmTlyu8ASsOsGowidhXk5
	QLj7VORS+Va6pNZsNLgVxpFuYlGKKiy3LVQrqJc7uuHT/lVxjOpopGQ5txgcAY0IvthGiYFFJRd
	VLxWIUndooRd231wun69tPKWCvtooegWp4SIR8nnkcVXie5a7KMZxuDj26CDYRtoRfMREb/chss
	rTzRlTls9wA6krStitYmRfehr8t5AQoa+G8D0p0JWnWeJCXLPeiWb4cFKhNUVebUqcegD1B9SpK
	smprXDOYjcFiVS60Wrq8jeTGrv1e8fJxrQT58ZbLmfniWuev4YaZZrzHQQL2tr8inbDojMnLpqn
	7KpLcMopZQgfWXo6OyEo7VxQxGRLoIgQZQhqowCbPCb0BcldCxLQeR1NBZjpmlrljK7g462CZdT
	3MjBMNpHEKqkg5VduHeNcQ9vmVokln0T71Rl+5C++ZouEKSFA8qS01N7iBfOY6t0XjJ8SHf6hXe
	V+IaCbLsJ/NdWQHiwho=
X-Received: by 2002:a05:6808:1a02:b0:564:22ae:a68c with SMTP id
 5614622812f47-56b968c7f46mr3958629b6e.13.1794444957543; Wed, 11 Nov 2026
 16:55:57 -0800 (PST)
Received: from 202080787392 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 Nov 2026 16:55:56 -0800
From: =?UTF-8?Q?Tom=C3=A1s_Senart?= <ts@perfloop.ai>
In-Reply-To: <CAO9r8zP1o+L-akRDJx80bgGj8bf9rdN09t5upPfkduSmNKwpKQ@mail.gmail.com>
References: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai> <CAO9r8zP1o+L-akRDJx80bgGj8bf9rdN09t5upPfkduSmNKwpKQ@mail.gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 11 Nov 2026 16:55:56 -0800
X-Gm-Features: AclHuK8o7gpgV7y1WpVmcJ6YTUQp2s3lnYXN5gQ-xE1Y6TctG_9wPrkhGrG_MY4
Message-ID: <CAEEBa3VA2vycMaRCe4K-qnO3SGCuvAqhECmjmk6PQC3xxERiLw@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: honor zero cgroup limits after successful reclaim
To: yosry@kernel.org
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	roman.gushchin@linux.dev, tj@kernel.org, chengming.zhou@linux.dev, 
	mkoutny@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	cerasuolodomenico@gmail.com, linux-kselftest@vger.kernel.org, 
	shuah@kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 12:28 AM Yosry Ahmed <yosry@kernel.org> wrote:
> Why is that a problem? Setting memory.zswap.max to 0 while the cgroup
> has active swapping processes is naturally racy. The limit can be set
> to 0 right after we check it again anyway?

Agreed on the race, this doesn't try to fix it.

The case here is different: with the limit already at 0, every store
writes back an old entry and then stores the new page anyway, until
the pool drains. It's bounded, so if it's not worth a special case,
happy to drop it.

Tom=C3=A1s
