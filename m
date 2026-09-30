Received: from mail-oo2-f36.google.com (mail-oo2-f36.google.com [74.125.231.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A8A4E77F3
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 20:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790799828; cv=pass; b=AfyxU8nLN5hYFg/AMvFzOZCxUQadnFg7Yb1bi72rkR/L1wOdUAO354OkO8tRfOe+DbuAdsKEv/IwKdP0rKL3ubU2FErgfK0ibq/o0B1QaByJF8IDxBxPu8MwEk/nMwRZnPAxFFVvRbOzlQzYUY0N/9xGaCLfANWCbkSFTkbR7OA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790799828; c=relaxed/simple;
	bh=tjWVkCtWN1ksllcHQbdL3oVrHpjh5qWpPcUDOolq1cI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dqkXJqbK/7Y+uUEyq32D/GTV2gXwI+vuRXwrQ/Dk1RorENjuGOexDtnE/MjcuXx4uarEZtm0vSbBBm9fLiZUdVMTwQGOt2YY4CGRT6FexwHAvMt+o58oX7fYlCCiaeN+czv8PcBzpuTys6JjduYuYfNY5bMO+7sRKuHtYms8WIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sm03E8CI; arc=pass smtp.client-ip=74.125.231.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sm03E8CI"
Received: by mail-oo2-f36.google.com with SMTP id 006d021491bc7-6d77b3455bbso2354424eaf.0
        for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 13:23:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790799826; cv=none;
        d=google.com; s=arc-20260327;
        b=FTmpk+zV1sypurawRRnXHvvc+9aUh9ZumInZb69kS/PXalI/0XGMkyc5vKNLe+Esk5
         xwammVZTT6HXDDu+4+Cgqi3B5LyiIZyn7lb33YxK9V1srphBfONBB201J4LRFwBFlLoa
         HJWUP9SeE0PEW7lR1X6U1FfDQvZ/b6KpiciX3xLZtJUzRnp1NdJtQRJhdRrKyJnyTCWo
         LpDWDOSoyVnmOW7iePEa4ALJE8DqurffGQgOs0pYiCUw9KLjHb2AhEzulsBP1I9ZqXFM
         Hf1JYAs5bl+kha1Kr8I5pMl8NaTTYoF/RVne3u+nG+N3IArQyYf3ExyBo98+KKGrfczo
         kYLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3NFT0Auogh5UB9tx8XlsAJmBChn/jmV5eAEA0nyqDX4=;
        fh=eZ+SpOH8Cok8E5PgCD3Qug0/uRh10e7C5a0E8MahUnM=;
        b=RmDOnPZ8ouO3Q0ou0LhopRehWNZE3/OaPgittF4Ut9l5l19xVKXJqNlQjpSKF+6tnS
         iEYKAmjoZbbp4HdUJqbOKxU2hFZTlK9q2YAaPd9vo+5ZePHU2MMzcFj+LjEuh9FkTzwy
         Oc3O/TbqBSHAxW4Fx3dmOjeDLco8ri4yTtxjFyhaRbYdUoZKz2USY1fIdrbM9vgVWIr0
         bnc5qn2jsLth5I/XFIZM8ePgu0mZmrD94TB041Ncn0UuvxilhU1Zl85q+fukHk+QOTcw
         ZSeGxn2TBMSN8GPQMZkWOQWSHoKstoUd0rvyF1aHJNW5x+/ILZt/WVuu4ndmLYyRHF1J
         PHPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790799826; x=1791404626; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3NFT0Auogh5UB9tx8XlsAJmBChn/jmV5eAEA0nyqDX4=;
        b=Sm03E8CIiAErKAfcG0Ci7cfDCjiSCua7PP0hSuKhHEZdq0s5qxXQb8oxDMisK+LU/y
         pqyxaoj3mmm8ti3Mcw3mFjXdeB7fcC7oPzvZEDp9KAQpGE/sqzP3rnxFeo+CIz8hkV4U
         EdiPmnajp9YiNPwSQ78W/hQdr5FS//g971hrNLuOsTLJPKkNMvDMLPdSq7MNgM9Wsa3m
         V3cfmsKzV79kP5yvheQd5vONp2bthr/W6K63iTbydGgwH6RRmhatlxx9V6D3OSTkmQKZ
         TaPGsmQasVCz2NI+WfhZs2dUbaoDQJdfZ6WqeXZDN8OS1mGdihtwxnfRE0bwU1znk5g1
         aVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790799826; x=1791404626;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3NFT0Auogh5UB9tx8XlsAJmBChn/jmV5eAEA0nyqDX4=;
        b=rsIsWguQZybxyb8bKg/656zdB5//1CXTDH1H4tZiM5tmhViM94AOrseFAjoa8xuego
         pHOZ8WnjZCeRyI6AaW/KdOqcaSPz9x3xvFq6CMayIW3nD2UE6myIlmS/UE7q1Om1Ykof
         Opzh0R9JTm4tlYkgGi569/bfI8DtDaG15q5fB+cyKnatlUCmYsRrgSbP1/pSW94ZxAG8
         PAvLS/Dn2fCTyRXvicxRXhJx8Q/NiL7OFL7EJmabkWiFBc0JDcLNkq2gHUHLSKA+dkdF
         DlRyEoraEIl6pTxeozwZcbUwoeM2UxaRFKWq45Ld3+n7vW/v3Z3cpHmf5YD/3ryxsyPF
         bxAQ==
X-Forwarded-Encrypted: i=1; AKwUvByYAPLPp0BQiWlQt4QTsnhr/kNlB6XUtrW98O4fwD8pZtRvkDunYYXbP3eT6QFb+rc9MW+Kbwn5@vger.kernel.org
X-Gm-Message-State: AFuF++mPWkzbw9aeFs4tuAAIRZrlrJu+Wbo5/97xVx7gIUZrpOSxA3X0
	ffrEEMAwclvm3Pg/X7htlQbVfIKR9Q3RUWciO9PyklE7N5C+EZwl6856AOdQHtTsa6IH/fGR8/n
	fjhTKVGF3rVqeFuxxTM1fKDhDr9qwwhw=
X-Gm-Gg: AYBFou1/nRBOKc02IC1gMJ2HkPZsRnPaH0qpqWf3QgUzJYK3shfFQDPsCZ51m3ZvL80
	UXeL0fOmK3VamDuaadotnXmdCFa5AuifntmTp2fNscopzo+vBvycejEqXs3HVTyOKD86Ul7KPmn
	sgGoJ0P0CG9xXENaYDbLx7XoJC0ZsLxaJgoI1dc6b34efz3tyB+7/lgTauuG7atlH4rhTdGcq9i
	MsIAxjXejtZ4QzGolp9OZF1F5je5lCQIcob4zODjTAOUztgHuJZpWde+8kqo8rBbtyg+mHrYoAq
	GIC+bADQHBpQJCuBM32vHLzDCu51MS3KlOFw4JC4NkacjwAKFpl/Klo=
X-Received: by 2002:a05:6820:290b:b0:6b1:95fb:81e with SMTP id
 006d021491bc7-6dcf4559dfamr2868200eaf.22.1790799825918; Wed, 30 Sep 2026
 13:23:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930135159.3926039-1-shakeel.butt@linux.dev>
In-Reply-To: <20260930135159.3926039-1-shakeel.butt@linux.dev>
From: Amery Hung <ameryhung@gmail.com>
Date: Wed, 30 Sep 2026 13:23:35 -0700
X-Gm-Features: AclHuK-HRG7T7XdhgKdEFkDWm3u0VW3bj7sKHiJVcbdSbgRB_tt6JD2iyN6YLbE
Message-ID: <CAMB2axN6-sMPu++HPXXJmPp03f80G0WhgHPLe4Tx2N53V5REEA@mail.gmail.com>
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

On Wed, Sep 30, 2026 at 6:52=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> Two things in __cgroup_bpf_query() work only because CGROUP_TCP_SOCK_OPS =
is
> the only one struct_ops attach type.
>
> It calls cgroup_bpf_enabled(atype) with an atype that
> find_atype_by_struct_ops_id() works out at runtime.  That macro is an asm
> goto and needs a constant.  Today the compiler can see there is only one
> value; add a second type and the build breaks with "impossible constraint=
 in
> 'asm'".  Add cgroup_bpf_enabled_runtime(), which reads the key instead, a=
nd
> use it here.  This is a syscall path, so the cost does not matter.
>
> And find_atype_by_struct_ops_id() matches on type_id alone.  An attach ty=
pe
> whose subsystem is not built keeps type_id 0, so a query for type 0 finds=
 it
> and returns success with nothing instead of -ENOENT.  Skip such slots.
>
> Fixes: 369d9dcd8fb8 ("bpf: Add infrastructure to support attaching struct=
_ops to cgroups")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Yafang Shao <laoar.shao@gmail.com>

Reviewed-by: Amery Hung <ameryhung@gmail.com>
