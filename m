Received: from mail-oi2-f41.google.com (mail-oi2-f41.google.com [74.125.231.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243674A6895
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 23:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.233
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790811188; cv=pass; b=cIuf+msPxADIYpejmKzi6zAr9hvGWICN/2Ks5HkNlRIZYvclMOG+pD5w56DqwmHYeFgCBeDsr77CNIupRun3nGXBRuuPgmrz0YmQNLEFDdDqi/BgaJaOWgpskPlpRWA6EibdUOb1mAXjYe7uZK+SfIFAglHsCS8z9xkTpQpGUhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790811188; c=relaxed/simple;
	bh=4D49IYAXZSVFvCJ88T4gLujZ0d1NNo8WHPi1MaZO/8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WnJ1IdduLNaJB2gheed5AMZtZQm452DBZWGvDPeX0ABlz9UF70b9Q3degqTowryGLnMq4sCAAvhJejdvkGf8Y1TunhOfBwSUGp4mPd0zXJT6lde01khuE12TYxx3HjyUERrt+bQ2wDyeDGQ1ehLXWKIi6PqoqD5MWRxhfmmkEZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VI1BTrFm; arc=pass smtp.client-ip=74.125.231.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VI1BTrFm"
Received: by mail-oi2-f41.google.com with SMTP id 5614622812f47-4e973221218so2707963b6e.0
        for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 16:33:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790811185; cv=none;
        d=google.com; s=arc-20260327;
        b=WkOJjSFVknlvO7h8w+6FufbSzcGF9wdei7y79+T2HN4OHgK/2Fh3QwZYOZrWPc1mFN
         P/+3GYk5CsPqWhfRvtnAzUTf23ZJ5f7HVhxF5mQBzGwdkeUGRSeRJ+6RAdW+pbgxeUx7
         6f+zgh9nrMDQmG76bUW9MOzP0pj/+vB9bk3VvnTZVfRgHmnU+786KREJ9kXDX7glHTXs
         39oyDe3MxdFPIOL9DJIQYrubRyn8F9HHW6vA4CyoxiZbQ6ezvkrBKHVbLIlELpwGv93Z
         bYx/YRQyV2jtBBL8+T/KUeKf5P7NXbUcxSBXK8v0lFrMhm8hLITgpWYzEr2j3N9xTTjR
         3ZrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LPTEm0bKbqUNKMZ37cgD5CITzNrHBkp5GSyeQAQbpHE=;
        fh=5H3q0VBZaKyjJHEvht7XDcsPtMKwfPuqZgcNQDj4Mb4=;
        b=HzalWnQFSyRRaYOQrqp7S0faupz+8hKCjDS/dl2UuNUTQUIWx0VoP0rOEN7mvgfrPf
         F991jD5Luqn41TSMToGNC391Gb+6MKfBsCiM9zZcx2EeolMTfBRM/10oA/5Mrb+CTQQo
         aOkMLxAJ6k1jhxECuZsnTtFR7ycfR9XcTzMaO+TucExcRB/FrFloUpYvp2TzArep0eJ6
         rK9i2ET/y0tl5AXeUOOhoioouIVj/uAkJw7uMkN5SOFAdQ0YvPaEqJMMhAfnHLX1JYTi
         QrN2xFGnzHxLeGjptwrZ31jCElVK3IuqxNpDOq/ZfHZlV1HIv4xktPCFv/liWp4xWxY5
         pH4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790811185; x=1791415985; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LPTEm0bKbqUNKMZ37cgD5CITzNrHBkp5GSyeQAQbpHE=;
        b=VI1BTrFmcIWd43yNIy4bN6hXEdImjostPTq0Llt5EzNxsM8bbyZ8P/b4xRXKsl2TFe
         G7cuBoLq6TPGRPNKt60D/Nj/7OyYTphrfd3orbWdiS1opegfdMHYeqcNeKGcFyv94+LX
         AADTHP3HAGdBLl0wFkkCUsXxBy3VvJiWQ3nsOagS18znf2i2uBsfJ04CpPj0nlPe7sXy
         eVumGhnxqClRuq8m/Riqc852m+mU+lXZYBmZJeY+SOrSWTbE9oqfskvmdlNZTdXP08KJ
         OAf3fIFMmN7TK+bszMNd+Yy4E+PjVYVgXH0Uwl+jXtVTkE+I+g56bPYDFX27IQdZztFG
         Y7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790811185; x=1791415985;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LPTEm0bKbqUNKMZ37cgD5CITzNrHBkp5GSyeQAQbpHE=;
        b=rxR90goCKU5U13lZ/h4UE8Ynt/9/fBJXnmuC28mBJs8SydP4JwLq0WK7BLJ94wHEr+
         MnczVZ/hxkhEUs0mNEOwiGf+pVK0wLsI+M8Me4BVGLwE1pCqw1WA04iRkHqmKMgN79Xy
         tiBiWCPnGeiVKM0JJhWrykIyoqLcWCnc22dZYvp4PC5f8FJthJ/HCp/HXKD6mRcWVtwd
         pQsnV1DPGAGc35Kf4jtxChRsbMakPP9pdMn69J4eAGf/4TeWJ5XVPdjrrwUUWaz3nrVR
         OWQDZJ+KN+uGXEw5kGOFv/aShcabtSGfPSy/1ff8A/WdcFPKYMQMPrQZctEZvsNN8iVi
         9PrQ==
X-Forwarded-Encrypted: i=1; AKwUvByReF92XxdgsdQ+kORHRK8IYdNb2VJIAsAef+BAHDxRI7lL485Ayi2G4ohJga1xa1qnqxhKN1nR@vger.kernel.org
X-Gm-Message-State: AFuF++m7v7txChZaKDFL9T5/BFbFrRCAjIbps9ourFqScnG7letXj4nF
	dOUfqtJrC+Ib/ajvUDO4dk7kKfRdhLyWGUGyM6WniYxEJLxp2vHZFhIZOMBEJQQUHoX4W6K3wMf
	kPJTGESqH0rxqKelvGI+E35kDsOL/mdM=
X-Gm-Gg: AYBFou29TNQjxdXZj0x3GbhlfbYU3AdnyMsFnJ7vW73UgWsj6AiXoT6qsudjdDBMSlI
	r9sJqa9FtUqYV1DL2PP6b++9fXl63wb5FgQzeV5+bqGzcdOEt6wXmfuGAdWnFh6VNAx/JJT7xMb
	oSUKzEUwP3vOLscvxWXICHNgHEyzAnbDPXB4SS6odnypeScvIFr7TwGoPLPj0CFqTWto1N9Y/gq
	nxgC/SVssDVYURb349eieNynhvW1grRUbvPj6OTPjnsFXiUvCw1MYkSyWLhFwlo/UtXgUcTeVb3
	cCNQDhr0iBjpGQ9HYI0iV+UQH2uouCAbQ6eWj2QJWcTOfGAtJMO+nLM=
X-Received: by 2002:a05:6808:1582:b0:4d6:9153:2968 with SMTP id
 5614622812f47-4f1bafc0673mr3201230b6e.57.1790811180876; Wed, 30 Sep 2026
 16:33:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930135159.3926039-1-shakeel.butt@linux.dev> <CAMB2axN6-sMPu++HPXXJmPp03f80G0WhgHPLe4Tx2N53V5REEA@mail.gmail.com>
In-Reply-To: <CAMB2axN6-sMPu++HPXXJmPp03f80G0WhgHPLe4Tx2N53V5REEA@mail.gmail.com>
From: Amery Hung <ameryhung@gmail.com>
Date: Wed, 30 Sep 2026 16:32:50 -0700
X-Gm-Features: AclHuK97hrec9RWHoEuiahRQWIqiU6qP3tiPiCVfaqtwIdccUEpMi4CzrnU1DEE
Message-ID: <CAMB2axM9ocD_Q=OL=FjpYhcDkz3PR2qyGZ8nWHVs4H8M-Lv38w@mail.gmail.com>
Subject: Re: [PATCH] bpf, cgroup: fix cgroup struct_ops query for a second
 attach type
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	Tejun Heo <tj@kernel.org>, Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, 
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yafang Shao <laoar.shao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2026 at 1:23=E2=80=AFPM Amery Hung <ameryhung@gmail.com> wr=
ote:
>
> On Wed, Sep 30, 2026 at 6:52=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.=
dev> wrote:
> >
> > Two things in __cgroup_bpf_query() work only because CGROUP_TCP_SOCK_OP=
S is
> > the only one struct_ops attach type.
> >
> > It calls cgroup_bpf_enabled(atype) with an atype that
> > find_atype_by_struct_ops_id() works out at runtime.  That macro is an a=
sm
> > goto and needs a constant.  Today the compiler can see there is only on=
e
> > value; add a second type and the build breaks with "impossible constrai=
nt in
> > 'asm'".  Add cgroup_bpf_enabled_runtime(), which reads the key instead,=
 and
> > use it here.  This is a syscall path, so the cost does not matter.
> >
> > And find_atype_by_struct_ops_id() matches on type_id alone.  An attach =
type
> > whose subsystem is not built keeps type_id 0, so a query for type 0 fin=
ds it
> > and returns success with nothing instead of -ENOENT.  Skip such slots.
> >
> > Fixes: 369d9dcd8fb8 ("bpf: Add infrastructure to support attaching stru=
ct_ops to cgroups")
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Acked-by: Yafang Shao <laoar.shao@gmail.com>
>
> Reviewed-by: Amery Hung <ameryhung@gmail.com>

This patch might need a "bpf-next" tag in the subject so CI tests it.
