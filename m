Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3411D46EF6A
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 14:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814179; cv=pass; b=p80OFGDKFp0a/U9Yk7DksO2RlZ7yBKBz1eioVARJesm9Fzu6SFz2jIj7kC++DY0dQj3sK5Vg7b9t0TgOyfWqbfhyPt5jPmRRYGDE5rJlyluqg0FO7mN1Q7pz/pVZ0hDWjJJLlo6Fy4LQf96WDWRmnbaDWMy7h8cKb5OFltDo2J4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814179; c=relaxed/simple;
	bh=f//bn3Au1jT6Q43njaKS85w9HYMFtsLKrhgAT3zEK20=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AlKi2Tq3WFFFN4fGmCk73g8fFv5fodMBQqG3EvnzL3ef88s7UfFM7hBp0H1AkSocN0NcmBIwtdlh5n4uGIRxVhUEKNVqYqY8n1ey5eKKWu6PoQzblq/0I8HAVtU3IC7kLY5h17BzHFhAcl4k7n7UX21zqiG/DRXTl/Qzt0ZBIDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D3xm7Npa; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D3xm7Npa"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5337fa12431so388881cf.1
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 07:09:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791814177; cv=none;
        d=google.com; s=arc-20260327;
        b=gNVzgEunZ1z1RUAEhwbtObhpbs9+5rPdUnvq0nABkS5v8V1hqlueXVRZph+zdBBkkf
         8cVraOsbB2wRL45XKH510UKaqbTgElGFIBXaiy+WVoXGjRjf6cjPcq7JoCmS8LH4nkw1
         8bjlAgjIiS4i7EfDXyc8kzkThLwFBI7I6kwLNqOeJK4U8lCVX8178nwkH18CH6JyH6Lh
         c3PFfL0TKt0pEW2KW3F1gL3F0Z83grcY2t5f5omagr3Ugwf+VI4oyoAr8lJ8XsLLH+PV
         Jq37T9ptCa+sfYjhK0uuzXUtcfYOqTp648hnyck4d7HMUnwBqqINSRQO3jqnzZrLd8oV
         6yiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=234EAT9IzNiTaPSt/Xe9A57JM4OoTLyfezE2eXJPMhQ=;
        fh=9PplF3kQF03TLgi56ZDVR28wakT7BUjdH1WvDDXgDLQ=;
        b=BP3Mx6Kkx4qPYpP/RcK1SiDuT0C0SRjuNHx5Fu823SS5Av5ymv/JKGQ8iFkOMjdjvj
         M/NdW90diTf5+sk0+q+AfUBq2rW3MqvOA181poAg/svUBG+diOC6Ie2W8HHKR5rqTJ11
         cpNayP+1JNXGz9r6rycfi4zw861ZCu+nRlGVez0BNjvtFhUMVJyOB3/mnLKBry8sYy9M
         12qeJN+BBYwwJv1YXMUXc8rspAVvX+uhWdvieSbokMhROMrSw0KCfx29LLlwkKnm5IEF
         pSvz2EdGvQgVrCxJmJTZHyIzRu/CYRQmaSZb+akybYWj5yjn5GCbyoyoAva849H4mBpY
         f5lA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791814177; x=1792418977; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=234EAT9IzNiTaPSt/Xe9A57JM4OoTLyfezE2eXJPMhQ=;
        b=D3xm7NpaDHEtO/HB6QtEhOfS8W3GYYV+LWrxBdJTRlqjfjvC9BOx9iVpOm0xqTcSZP
         ncmbpWNbE1WESg0H6jnfDM8j7to+0oOuz+Ojjd/TtA1pwBJ97Trft86WWjkamOIA/fHn
         szx7pBQcqETdY+YhDQhIlycPFxdqsIqpdp9EATqRtMY+wscNOOG9EtPZa1AUukXLQHBz
         04VES/X+BBT2Kbpk9hoeyn+ppqqrAsi6kH46VseaBWm2jHGnErjl73K0OfBJmnfHWsiL
         TlLkws8hMUoF0oDldlrfJIrtth5dxGR0z2KEtwZlpO+YgzN5Vjr7NVcjZnjoH/4koi22
         /QGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791814177; x=1792418977;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=234EAT9IzNiTaPSt/Xe9A57JM4OoTLyfezE2eXJPMhQ=;
        b=N2UbNcOJk6A+JBXA3ZLqw4eJLT+0+ZDXiEtajkIDPM4K2I238tMmz6LX1TYCJyOFTQ
         Q+gwKV4WZs/McmKPrAEZDvOw1DqITwu/aRDKmKKsS6bEynSM+/pAVbux47M//toTkI4Z
         ltOpauvS8p3OpCYx8RZ4A3oxj/wMNLNvoVYBlmd3bm1UAualt4jPR84RJYliwvyQ20WV
         PZ4rr3dufG0Sz2QQjpNj7o2z4B1dOhg7/7bjshQnSpU2/FA8s84XIZeDLltqWcUeoRAG
         sbODYLdnQLk5sk8z6mQLgn/tnMui0kGfoFFxAj1jqaOIuUxnKpLiprbdz5dkiuutCY7M
         2B7g==
X-Forwarded-Encrypted: i=1; AKwUvBwF8VyNHxCmDFKbSo9uYNvN+1teGGYDRshAB5sHiQ/B5Z1aRS+pJVzhIcTG4h9BOzZXX34fVkpB@vger.kernel.org
X-Gm-Message-State: AFq9FYLgeIQapijmdVBuGjFw6VccPUS5PbGDL9B0MqX8OERlmK73XrRV
	psO+PrYg52b4kdKPInK3dRMzauZB1MG9cjMjFUNFb9yJZ3mqvnxuKgNX4Nih4m6EBafX5BXo+mc
	ZaNDlPoOePZQ76VdDGoJSknVFn6Y4YMCYTcb9IFNe
X-Gm-Gg: AYBFou1kbWDufkhIGT0YnZRJry9L5ADkRe04neNEyapN6UIk6TxDsiysdSSD7U+qt9I
	rgWISKOeaqKBJs5if4CXFKD3Q+6H3FYMFv+rfC1yLH02T2RsA5uwh8vvcX0oY96K2CIpmZSFOZv
	vZ610Y9lE0WEl+3Lh2AOFjuD+PWfQZNW1jrNWkZDSH6D2ZK5JEs+64z6G3f6xAg7S9WzHTLRyOB
	yYoBh/teFfnXH/gC1RYQRDSMTkoJJk/KZ+2hGbtO/Z192d8VB1zohFwplwD4JuGIHCrnWyoUIH9
	I0HtQUax4At4juxZBin43W7eRqQGTnsWy7F1GckUgsamj/4Is5jScAxHhZTrL4Hq33CzRW5be1i
	JJF96ZPFP6Tc=
X-Received: by 2002:a05:622a:580c:b0:531:282:6560 with SMTP id
 d75a77b69052e-535b4fbbfa8mr31251691cf.15.1791814176455; Mon, 12 Oct 2026
 07:09:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261011223358.2327625-9-sashal@kernel.org>
In-Reply-To: <20261011223358.2327625-9-sashal@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 12 Oct 2026 07:09:21 -0700
X-Gm-Features: AclHuK_P4xsv10L2lCkSOtMkvWLnLa5t9EHv_n5RaY8Tn_1YY4noJVhURld5zAc
Message-ID: <CABdmKX3+V+kqgC8H3MHHsawkTYFb7ebJe8pO7uRS6-i4rijwNA@mail.gmail.com>
Subject: Re: [PATCH] selftests: memcg: don't close an uninitialized fd
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Amir Goldstein <amir73il@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2026 at 3:34=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
> jump to cleanup before the inotify fd is created when cg_name() or
> cg_create() fails, and cleanup then closes whatever fd holds:
>
>   test_memcontrol.c:1685:6: warning: variable 'fd' is used uninitialized =
whenever 'if' condition is true [-Wsometimes-uninitialized]
>
> Initialize fd to -1.
>
> Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and=
 IN_IGNORED")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>
