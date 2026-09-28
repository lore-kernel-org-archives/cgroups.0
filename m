Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E33A4BE424
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 13:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790601884; cv=pass; b=eCAfrlMVUV0UUbTQ8lIVle8UnsaliqlqBPDhOoUGJfs1wWqDATGsgQJgwQPC+GqIp9/bXkSeaMoCC5nBIQjCPFCLWk42tLC0oo47VFjQsKm8XwO3CFZ84sx5bPzHhQaC9bX6bzpqCSXTYJxnQjUU8xvJI6O77Ds/hOBAtr0LKRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790601884; c=relaxed/simple;
	bh=GnZRje535Omjq7bTjfZY4Rt+ArD7RwaYq15aIzeRtgo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IJDSBwDPs+CCW/aGvw7yJKgT8QJRLM0DKvJslC6yEWbzeP1oV/AMDfWcEZqTqDbXb52N2IJrwYzM7yN/OAzP3kr76zsGsAWjlBES5pv0Nzvghc1+B8F2X8jmef0ikNM3DRG/Cfy9U76IOd1pu4XZ4fNEQaHGebz4iy6QNDuo5U8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UUXo8JBH; arc=pass smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UUXo8JBH"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48877902c99so2970346f8f.2
        for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 06:24:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790601881; cv=none;
        d=google.com; s=arc-20260327;
        b=jZOaL23Ouw37OCtJm1xDZy4Npg1t2faRTJ5ved/8nUBmOZy5MaoVbpv0UsH9iYE2Ad
         ONvQWa/3DF3QJW7NH7UbRPT+lOlNgdBzqEdT9BLw9mjXVM9r6GfDY017BZDpDcfOgA2I
         OzpTKvSbbMW21zR3Ox4A9muTNgaYze+m306oo0MsJbigtdEYDHVq6tnI89vLaVng9goI
         rb1O9c0e8eKFK+DLCUygxBTnYjj4ZTLIJmaDkWJwNEUiS1pDExn1l0QyJQ4LEnhANMe/
         mdrfo9lrUf/Dq1ils6LYnQGsGgYMRW7a5CbfsLOHzLcdpyHT7nBVXsOz7uwR/03SWlNj
         S0ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GnZRje535Omjq7bTjfZY4Rt+ArD7RwaYq15aIzeRtgo=;
        fh=WTizdTD7Pyg2Rz+Jqutqmv8pJSYIHJj6TfRZ4yw4NOo=;
        b=meW8JgwP3kALuDCgK1k07XX+jRevF6Snn4EPSRYIJp7oGIM3/LFtV/2PqpKGbdKFqQ
         pQAZvqRiq8HOjrDODuStnHnmva0FWkf7gNRKKRTZYRrPI2nK2vnSF92vNnvq/jmUsTwT
         CiNEyhFC9zsAGGybZazHeInqil2ENqDEQl2+dV4Aw2UTtMsZ1JaRor1l1nM6dgKxEaN2
         47/MJwU6kTK28/hkYZvvLGxr6clef309aGWVa5/DCbxn+F46k/s77P02xzfw47sTugRF
         b5pLyTFpu9RleIEXdLnZKpLe94rTtjL3aThl5kTzW6qmDwbVjlRPVq10rfluONRr68Bu
         mA4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790601881; x=1791206681; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GnZRje535Omjq7bTjfZY4Rt+ArD7RwaYq15aIzeRtgo=;
        b=UUXo8JBHEslABI7CGJ0PDDjiwm0LbNuMedQsOOZhGgkZmmvyfDKRcLzvjXqDtRpgjQ
         ZH3/8ECrJOFrcQ7qCQKOwnOoK0+70LmPsGLnW8hGk1ffkJLguP21c9k8q7mDXZUq1hNM
         AhKEcpOSD2dzC1LpINIK1azIpYQzPvMh1JqAa1mTiMBfFG2/vBQcUxfWpEPi0RGeFYc6
         UIedVqw/6selEJ7KDiw53OVkiDr+dZKeYmSqimqTdrj0e9yVBUPxdmLqLlIm8oAP9TBb
         /ZVDKY+dhqoDkjuNsu0VLWJFxafb+4g6cr1kfcEwX8P6c51EssXwLyDa/cE6SKCSBsfZ
         APjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790601881; x=1791206681;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GnZRje535Omjq7bTjfZY4Rt+ArD7RwaYq15aIzeRtgo=;
        b=cWIvbpE4gyKi1hqCEo2gGztulD3N/R3d0GAn7jnBJ/X3Lf7x+OsX6OAmTNRGZFoZ1v
         yg0hVsiduYB5jEuiuvWqVHEh+Suy2QuG8IxP9rNSDTQVdU1G0lbXqFT1wkbKyEwhm8fj
         ToGJSijpPczCtAuytSJ6tjBFErgiGRjKp7PwSGCfWvFyXMXPXDNl0ehzTL4bJ9wKjQr1
         b8HoGQVnvTMhu51W4KiwXwiy5008jJbv0NP6A691IYvyZ9o1CygGOKRN7tlem49LZxdO
         bk0rTNDeJF0lj2xOWu3CEDCL2G5nzq6NoLdRCKTQANCkWfev9d0jzwUqFY4VSlxHzHSp
         sFsw==
X-Forwarded-Encrypted: i=1; AKwUvBzkTpznS8Fjsgu5nedQo4u9QYDFdeNhRMNtXq7/Y/uss2+jsqopVZpp1ZkhMXP8973M2zY0DTqY@vger.kernel.org
X-Gm-Message-State: AFq9FYJOLK6S7bDs0w3eWjBRg4QOCtqMOWFRvmtmFKZKJn+4bzMZo2QI
	OX5Ca9zrdqw/fn3aqpEimTpPfPth0lLFYkMQ1cHkT2/vdDVx6D1NIhRx8iJCpIxZr5SUumGflmd
	fzGICvJuNedpkyeSuERDgFqabejBmNow=
X-Gm-Gg: AYBFou04EYR6kfVoLMJfPd6PxmmN59Jpaujfc3rBINsD+Cc/ye4B7pfR7oeytSAIXqm
	inLKhrFJheIgvrVA2oEUcLu+2ZiympPaKJE2ww0uNXF8TxV7WJo6pM8uOwXvNMgsRdl6hIrqYdz
	mwIqhMlUP9+H4xMwJ/FLca3eOZxBN5k37VXtRBX7WVwaWVUFoKZxiHh6itkXkLdJoEUVYxtxktN
	ElxZKiT7EB8E/fo6XnbA45zfT7CL9tgF+3ErskZoSWgrTSQRi+aXrSa0CY7L4GI4G204cEyvNgK
	GDU257eiebE7g8nb2EKKPSxlk1jjicFfYEdn18EXOmeEYYjo1eObBvZwYRCdDZMwaOqmbZcMRT6
	gLHuJHC1p45FnqN/5F6u9UHg2uEc=
X-Received: by 2002:a5d:59c9:0:b0:488:8232:d159 with SMTP id
 ffacd0b85a97d-4888232d348mr16059474f8f.13.1790601881245; Mon, 28 Sep 2026
 06:24:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
 <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
 <CAKEwX=M8pJUYhmADfvdk+09O53EROyDRC+_b05vtimQE5VN=qQ@mail.gmail.com>
 <CACePvbWTZgbL7U-hrgV=V0egHZ13EqMCOsUbnKTcLvqnv85zUA@mail.gmail.com> <CAKEwX=M1tc5fLSgxbq9S9TU1AKJWtRZA0AwGQZgNXJ_76hThFg@mail.gmail.com>
In-Reply-To: <CAKEwX=M1tc5fLSgxbq9S9TU1AKJWtRZA0AwGQZgNXJ_76hThFg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 28 Sep 2026 14:24:28 +0100
X-Gm-Features: AclHuK-U3fLTMhHK0pk3rONO7wDcH81pPs_iHjZbfq38GiuI5bJWs1UPQRmTG2g
Message-ID: <CAKEwX=M0afcz+b1pBd+R9Ddwqwcf2MuC0XUpC6seL=yU-cn57A@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 2:14=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> Vswap does not have that, because vswap is not an ordinary swap
> device. It's implementing the concept of virtualization (the "V" in
> VFS, if you want to make that analogy), made optional to reduce
> overhead when indirection is not needed. That gives you all the
> machinery you need for backend transfer:

... for zswap/compression backend.

It's a necessary condition for non-zswap inter-tier transfer, but not
sufficient. So it's not a solved problem quite there yet (and I don't
know if it can become worth the squeeze, as the data becomes
increasingly colder as you move down the tier).

> layer, where you can update the backend, without having to go and
> chase down all the external references - no PTE walk needed.
