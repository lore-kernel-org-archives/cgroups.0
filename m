Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795018201;
	b=107X4m59X+ed3dR/5RHXpzbq7PAzJpliWgpZgCEV274rRXlHkCkPRTB+N8fDCb9c3Rm7
	 cnH7nc0Z2mTjL2icxxCOPGwWr7igk4ANENq61I7EQc9QFF9twRXUcNyiL+Ho+ZJGF5FjO
	 sHJtjV3FspSULOLNkG56jNskyDK8RSPZzH8F9GQMOeRUrj4Dd3qC/3coCFxaorBto0wyp
	 98WDj7udnOvZn7MuYq3mfZCjkYcxeM1hJPZjqBUy4KlwQ1+ZO3Fl82JuF7gu2szPtd/hp
	 NdoOkBYpsjp+b/AOqSqtESb4x6BHWg0lVQnrNmvdYZ+0tXERtbk0LVbQruKanM1x2Dw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018201;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=HbYXoP2RPMw58RAwQCFRXLN2yd0B0w7a3Dun8Sb9Zn8=;
	b=mJetv82zeJP15iC+7Qvb0Wp7Qi0GltVa6YHLIcPoHuPDEAx1GJtk6XT7ec12pDTZlomh
	 5zsHfwm1kkJZjvqCOiEtCo7d89SfpdRnZIM7mdnWTXx2saDGFZBLMeIWLJk3TJQ943cz0
	 CAmIc6GL+0R+RuSvMLGzTC8CSn4z+2faFlRUjYeFK1zuHDVk/V3JeL/mx3FmA+I6ojbQ4
	 x0l5BlMQ0PcAD4SV3xk2MmbLW14nSW1jTLhLFc8zuPN4LnSVgSWoniiXreSHv+2B5PwhF
	 QU0vcKxGFiMrHkjmFJ6ZPj7M72Fg/2xh3dPn/ag5LmGlBeUh74VOEYYAtQ+HOToFtkA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pKpVVSBx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E49606A31C
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 16:10:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77E49606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pKpVVSBx
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so12323205e9.1
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 08:10:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795018200; cv=none;
        d=google.com; s=arc-20260327;
        b=Uqu0arA+Vf7iL6p2b16F6kOjp7KlBO/ri5dwFeJvwAuPdTqXQZ9VQLmtkOJjVbRW07
         miS/gi0A0gFX0MyT/EQsVD5lFBWxnvopcsiNSFI3PT5OJtLmqatwSFQAgHWLaZEoLgH1
         nzOgEoQAZWlm3fjj8at6j8rJ4gwzGbHzpf67sOJB40/+1KhXLzazFkkRLx0k9PkDtDdH
         bCBmvBC3LjTdUJLiFG372esJ2c6mGcmIi3qrcO8b+7N+NsX3SnK5zKXu/b2tJldovdBs
         KEj/hlhYc8lRnl1ayC9vgiGp4Me5a3KZTGCjQSHW52iAtSD4GRt3w1bImo4lyapLaJE9
         Ti3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HbYXoP2RPMw58RAwQCFRXLN2yd0B0w7a3Dun8Sb9Zn8=;
        fh=Zli8C3CxmBmTVtEGu8xuuzLA98n9lJO9kgBXzbJ2xQs=;
        b=awoznz0jzplVgL21cE9h5Zj3/yAM006WF3zXjsMPVUM9PgAVC0sGac+83IWRQQtS6q
         cqsAWVmvJJzFL22D6Hx99vOxrNc8HPv/U0ymVNHJEeewCQQRBs0oywyUNiulazYFc2D8
         be465FmxSw8wGc8hFRwVxlvJaw9cjZ26kPLZLW/75iF+QgD3Xlxap3IvKCkYC6EqgZ7Q
         +BE5of62fHaxqAP3iKxZ0DOaz4To+dTqkqhy9S5LyyK0S+MiSOXYsmZENz/ETfCJWd35
         moEIjt+BSJqijI0gYgabrCJUySMgaw7JrnozBOJMKq6QkgtVtCNgVsVWWWfOmBfPkDXe
         3ogQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795018200; x=1795623000; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HbYXoP2RPMw58RAwQCFRXLN2yd0B0w7a3Dun8Sb9Zn8=;
        b=pKpVVSBxsv0XSkTMIy8QhpV8iYfpJgFtuIOOMraAqkh6IoY/LmnCeoFY2+atEoT7Mm
         51yqYjvClrxz7PJEnwcKX+ag5vvKZvXQsxOzLhCYh4JsRBfQzN29l0NprtTdgWvsd6ix
         AH0QnRKu1GLZ31o6b5lUrcbRaETqVFDnyZJS7t3cmGzJhOaIhFJp2bMr5emwdD29hhJc
         RTs7I+nGHlyycNopVtnLI4PuG1cfcui/Xum192WTkqg+lt112F9t0Y4AcEwSdQ+g6qnJ
         fEyxFj0SlLXR+vzEfwDVpIGqxFUfo5VZRX4qXbDxIZEzPRytaBJz01a74eiTXZMyIuVA
         jVbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795018200; x=1795623000;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HbYXoP2RPMw58RAwQCFRXLN2yd0B0w7a3Dun8Sb9Zn8=;
        b=RVbXtJ7/nMyGt4ExXzCCZZUsOALv1uVynDrO3B4yBnC7LzSGwa7S4s4UBGz4bKYfNf
         6H8VxwjyRa380zjltZWTGHvyKW/sygA913AusYI6ubW4lWtbTgmPKpeZkO3NO2dxiXob
         8k0PRiQIOiJwzWHRgXK0QjxCw8BqObs9VrffTR2gf4dp5oxNcjPgEqR+XLs7nEPjYlih
         y5ukvCz6CPa4Q8TsaqrlQXZttlT/ttPcgYwPAgCPesKTbguGHCtrXQ+5yndo/zv0+ux/
         noEvdCrSWHiorf8m5kUiQHNYbJwvhyU5BEfPLZXvu0uWXYeOTThoskbw+d6G7wdEXOH2
         NbPg==
X-Gm-Message-State: APuU4Z9UVGBdNmX9SBPesJEy5jL70/Myzs2q8lNbkx6hdvXlOMNsCV0Z
	v/eDdDFOA6h9xkTPstRSM1ndY8jGRXkyQX+CppdcodBP8vbSJbjHc7SoZmybcaSWqxNoOeZSapG
	Tg8klx47oTOFiemcRs+glkpkqvdWozlM=
X-Gm-Gg: AYBFou0qHuEcPHYuz9Hg4mwnAuPuaScx74QeoEwVpzLLZ3Yr5iz3SEqL8TAlBcYbcWq
	B0zJ7g0aMnIddH6vfZDUeprJOx/WFKf9vawH+ihVvfiT4rEHOPVmCGEenn68xftV65/+xedUqeB
	xnRH+yH0pxUOigz2jL1V/1VmdDN7qZ762Tp2cVygUuQber3xtnTYnDgDv+0jqX6StrBVozC/2al
	darazelYkb+GkUdCPe6CTtqqZX2V8GhVuBgjcu74DDQauhXVWygP9rI+qI9OiD+ySNw43K3tI4Q
	cHJGz+ckB53qEQbCpwWnIXms5AYnC9Mc2dDS9+jdo0JGRfNQ/pvNwYXSu292u/8hX0nJtLt6gCb
	tU4CUbDRhv2JdDcz5gfcqsGfUv/kd449ehnMKFjd3FHG6BZzXhtP3+eltbWgPPKkXbhhgoRIls/
	nLEisBz3GcMiDO+OS1ckDvBsO/faV9UYrU+imMUn1Ap2NelZPZe3rMWzAv7pLAPs8RRyCMTLVcM
	8fZ
X-Received: by 2002:a05:600c:3b1c:b0:4bb:5d38:259f with SMTP id
 5b1f17b1804b1-4bb7da24a26mr60211045e9.12.1795018199716; Wed, 18 Nov 2026
 08:09:59 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117062620.346767-1-yumiao@kylinos.cn> <20261118130537.750211-1-yumiao@kylinos.cn>
In-Reply-To: <20261118130537.750211-1-yumiao@kylinos.cn>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 18 Nov 2026 08:09:47 -0800
X-Gm-Features: Aa3M54qRdo3OaZ77M4orB5mZ70nSvNFV6Jxp2gOAsd1jbRDwyTe3QzmeCNTj854
Message-ID: <CAKEwX=MssYOr0J7tk54qUF7DbNb550KZrFmwnBD40L+tWde+5A@mail.gmail.com>
Subject: Re: [PATCH v2] Docs/admin-guide/cgroup-v2: fix npn tags in memory.stat
To: Yu Miao <yumiao@kylinos.cn>
Cc: cgroups@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	rdunlap@infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	jiayuan.chen@shopee.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 5:06=E2=80=AFAM Yu Miao <yumiao@kylinos.cn> wrote:
>
> The zswap, zswapped, zswap_incomp, swpin_zero, swpout_zero, zswpin,
> zswpout and zswpwb entries never show up in memory.numa_stat, so add

For the (z)swap one:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

(but the rest LGTM too FWIW).
