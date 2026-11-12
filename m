Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794484556;
	b=XQOSuBp0Dwy9Bc9A6EOFnALOHfgxIPEvH8/kEIrrZn/1xUfTwYSEJ3h2ZQU3G9nxY8oT
	 qVovuZ4Y0NStFZFqNjpgDh6A+FL63WrGKif9KbqJkljJE7G2IkeWYxZer7QeZH4+LLBwE
	 zRRiSR+fBasZlJYqg1RBn+5U0EX4oOoWJCtazce1NqIeQBIDDm+53/SKxmbzAatHhfvpk
	 Ac6v8LDnY8yzSmWoTx5TON+1KBCKqUQcPdWodpi9g7RQBjvrTMB1Rha2oY2uImlpcG9av
	 SZly15WIQOl7W+DfT5S5TrlpGX6sVzZxfmlRDhZC9MAa3PhmBWYuNQsoCX7WyuArKbQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794484556;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=H9NIZBLJNCk3VF8bguUf3mZiur03yP583DFsDhIKC8I=;
	b=lLsyJoex7bjQDqg5QPk8aXI03qFX5/RZVd0Gmf4lrHiZSLgreN6SIWImSMkemqbWrqV6
	 JpHLYetRHK6GroYmZ8QM8TzeFna/k3XecJFrtD9il64dsuT/7MJrGy/zYOs6BYJJAoNdt
	 CLG483W3xYE2TsbaoxTrRg9d5r3i/8UVt1ZkWcAZFsEKZaW8kejUnliajmqqM53iCDcQm
	 RgYWcvcJBvUP+wmmSbBWA7uBNk/xdX1PCAosRqsJ1jCiTVFPMz0bu/oZpinQR+ZlZIMRp
	 U7QH9v6H7e4piLVVR7FKEo5xrmxZFFH5OR8R5c4GzfZMsu8qbdgNKNGO4G1pAaUPCQQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IC0NlgPK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.169
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF97606A323
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 11:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DF97606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IC0NlgPK
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b3b31a6290so10725367b3.2
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 03:55:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794484555; cv=none;
        d=google.com; s=arc-20260327;
        b=AWmHMgKS+ikJU0m1TdvLUrraSNdRkNPiMtr8H6BMcnsiQBHxAjj7c7xrGkObZbmkJB
         8PRB/POiXqoTgva0ml9dgb0nQLzfTlyhdAe7T6ISFOpKZ7Rg9Tt/gVoEStqrj6MVbW7X
         enRUHeCR5Y8p0f977ucIau+BW36uT4N1qkJDFgUST6BcfhWbyIcKwTp7hXNRvlqgdBS4
         B6ZWFa2HCbgAbTxkPL6RzEkAggoGRuemkyBk534QoV6Md75dawAYZ7rFCQmVvTp4C49I
         G5eZOCtmXr1p5X13TqAO+n0XJQsJgxoUyviyOq8XK62Hf9mQ2uDMoO2axl6rKx/8z/PC
         EoWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H9NIZBLJNCk3VF8bguUf3mZiur03yP583DFsDhIKC8I=;
        fh=+dqR3vDt9bYs2ZqbwSlLF65l3r+HP5xWRRW4JMAl61w=;
        b=DzHBDzFwOBV3VmwJp8iGPuzEnHlrt/FkS9XvIX+iqq8Z8LE4Y49kGVjLIbkSSvDalP
         sijnxg9VcF4gOCAniQAGtQyqoW17/q64dJEbjIlAFJmviCmPUq5uX9QXSFBEEeowKLMK
         7k/KNPGymfSI34maGuVuSR+iqsIxCYEgjL9xIMSmbo3YZYdxu/AGGLT41scIvqRSRquk
         ib5ZrmaKSsWk9oxg4RNzxk1lNeNw2se3xUC1oUr7Q03ovinU33w7Fz1t15KK5GKUrACK
         VzANpySkUYYcbOu1qjA6oFKN4fPAnDMfnNj80Cb9Q3RtTX1cDYD0xrViPy4jx9y3xNVg
         08Nw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794484555; x=1795089355; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H9NIZBLJNCk3VF8bguUf3mZiur03yP583DFsDhIKC8I=;
        b=IC0NlgPKpvkf0lwA4TKjI3IqNZVxUXnlcdFfmdT9eUIEfpssNU4lAby4Z+c12Xu0Wv
         Ae7DwZl2GoZlqUFR+YDpnTkvnCvU+2v933AKeweNQOsB/bQUQPoZfBgcVjRCMVYyqm1o
         AbCI4ovbRTHG0zmzRmxvfvvHcLG7GP3hZpqSxWsGDFCQpceE0Gbu4qezSLKeH2IGpMXp
         nhxY4K44tCHBO4soJCjvAWfYYHOVjAw017OTBceFYu0FV8Rkd8nrHSLB5VIijmCiwDRE
         hn3/HC9Cg87C79kiqkCOFh0fUVllLsMqEqqPKXPYRGmKzOduTiBTgdchK2WoBiqZhEZA
         ph0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794484555; x=1795089355;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H9NIZBLJNCk3VF8bguUf3mZiur03yP583DFsDhIKC8I=;
        b=v+/+JnZC4XOTKpl00QukF5+IO0CyNMhKVBbQIXS23EL/JlC7uT6uBKU8n4xNPMSJQ+
         HaclcKGcqf2z5Sz5yqv3dkjbDfUi/B4wh4m+EKzipGG/bwMcfkCloudvsKi4Ed6DudXo
         5YLrVf4X4+5x8aF+5bY961dsZD3Yr0F5MFFYaI10gj+rEv42k0AuFAqrwJTRRnDlB+NX
         VHL5ck68lXRLpCgH+4DazxtkBIJvqasoXYzjHbzAfrIAoQSp6tZ+MX39Y/XGO3dEzkE2
         bGslv7v909SX20s56aPaPLLdwZw+cK6LlYsuuI9LzyeyYjYwxoGobXTDdVKGw8zZkep3
         2wlQ==
X-Gm-Message-State: APuU4Z8Z4OApWEGer0YIfSpL8BUy4XlD1sCC+kO7BXphsd3qXnNRyzNW
	8Jh3NK7wCjHQFOWBm+irV7FEESuKMmDrHKM7RI/gvYQvDJ7rT4Wrt438c5oUYANgt5DUWMi+JWB
	BTPBBRMc2giQYVyWvhlpik116VVsWEhQ=
X-Gm-Gg: AYBFou28iy0KnYNipI/Q1fNdsUrSfUrPnsWbpuzq8uvkDqKCHTESwVUVYjyDMDrYo6D
	gyisWOWhr8Zn443DsuC4hRrU+Fa/mz9YU9ycB6B+fcB1l0/jyG2At89RA+MBOKP9zUTW0pOwaZa
	pDZwMLqMicSmdoJK5PGBWCGoEMamWjsO5cIj8xrZGoSvja9WznneM+JVrpl+xcd8vSXximdHqEq
	jnaM0cg56K0naAhW2n7L1kGZ+g5g6mZJG36KX0jfyfe6S2DVxgWBxvD1NeI75/Rj4n1VVfgnRe9
	IWyIgKqLn7TdySQqt9gaFsCWDWw+rgulxS98GgCu0yJx1ewKDPH1N4zkDFlQIh5zuPvZtFxnUko
	0C0zg6jqlKtTMHW582l2odbgDQsgw4wjRtqjkoy1pKW6LD7nqxrBSOD7HbN2D3HILrQ==
X-Received: by 2002:a05:690e:1381:b0:67b:fa48:40c6 with SMTP id
 956f58d0204a3-67c680512c2mr3277682d50.89.1794484555468; Thu, 12 Nov 2026
 03:55:55 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
In-Reply-To: <20260918165601.1014666-1-ekffu200098@gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 12 Nov 2026 20:55:42 +0900
X-Gm-Features: AclHuK9PmUV8BrYAjnqEoTS4EvgydQ1Uyiy02kEKk-TSeQV6BgCr13vlHCGtulw
Message-ID: <CABFDxMEW7a1yxZJ5TOdP244gbMebCzHBFsF7w7qJhxfxJUZRyg@mail.gmail.com>
Subject: Re: [PATCH 0/2] memcg: remove unused page-based helpers
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2026=EB=85=84 9=EC=9B=94 19=EC=9D=BC (=ED=86=A0) =EC=98=A4=EC=A0=84 1:56, S=
ang-Heon Jeon <ekffu200098@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Hello,
>
> While reading memcontrol.h, I found two page-based helpers that have
> no callers.
>
> No functional change.
>
> Sang-Heon Jeon (2):
>   memcg: remove unused page_memcg_check()
>   memcg: remove unused mod_memcg_page_state()
>
>  include/linux/memcontrol.h | 32 --------------------------------
>  1 file changed, 32 deletions(-)
>
> --
> 2.43.0
>

While clean-up my mailbox, It looks like a later series with the same
change has been applied instead [1].
Either way, we succeeded in removing unused helpers :)

[1] https://lore.kernel.org/all/20261014-memcg-unused-page-helpers-v1-0-240=
b37c53831@columbia.edu/
