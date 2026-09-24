Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F33345D5D2
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 10:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244141; cv=pass; b=ak9RpgxMdN0uYjm+Bo7SddXWrWX47lbueugK3CbccxRXN6GDuJjbWWIL6Z189CygGUN18OtpxSO3ehwUw3gbaKk3yGQVrKm2xGiPvrDARDVE/Y0QOAXWQaM/QvQ/8ZScWPK3LjmsKTrirIzAGYp6ny+mMCyiw4RwsSHJSKBLyuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244141; c=relaxed/simple;
	bh=aF/YUsfn15Am1lyN4UTB4NRsRKQjq3M/wl+L8J2wO2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cQUtsHgXn+KgnUw2R0D6257w6wZNm0Z3TRuJ7SSZYUCJWWqP7pWfk/LTmjJpUmPPPHfloJuQOQpc9AInkvTCxC84xQqdQNUGLuOeBo1p1EspE1pi8sZMI+SFwLh9FDc2ua3SflbGQquBxICHT6SQ9v7hJ6JcqbiYYOFJgI1tVx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nYsq+CSd; arc=pass smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYsq+CSd"
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d43f9b120so25269857b3.3
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 03:02:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790244125; cv=none;
        d=google.com; s=arc-20260327;
        b=HgcFeBlvpqzmLNJwXlZN/ufp6UwKdjkepBvZUgH5rjEIk2BsMtS6Fhw1MDE25Zwwat
         IG1+okOkfQfegIwsKA7B1xXegfd9pCElaE7tTIMHnLgz5/sytqihmGzmoFkFZorSMHIT
         QrmqvHmhVHXJ6hk7IRQuKABvlz6JFLKXxxm5RrCwni19rdCpYUv6TA5rhkupJ7xA01Q7
         jD1ThN3UECvfP4Z7/v2sVKj26f0qyeVO3qv18OoQiF6IoHh9dx08YrJHEbUu+AYJ19MJ
         TNkRcw8Z+KDeXLSz1pWzNnAtusxQTyaNd5UNcjuGOXSqW3WFeVFot1rgZo2MVtOCQS1C
         Cxnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Yf2eXBIzfUAyDI8YQcFwCnYg3j6ep9DZNkN0GsU9MPc=;
        fh=fIqKHGnfECbzFDwxBW7h9AqeCBb08CGKebVlFDA+KG0=;
        b=RmA81i2UoqYqMDyyCba8ty6iDHBJf1BvzRyUprL/FO+hsY+EdpnLaNXLv1Iedyg3Or
         gsq2WTpXk8rx1ifPp4ynnoSRPBG/EpNdfBkVJZqM4E05PSw99V0z6ij4Z2bE64SaRuZg
         nhALgNf7LekNDlDIwuvQQFgQG0StxLLvPscDXH/UfEKEOAPREfkRb+JzMWSU7bv92lqp
         7zkPgxfjoPlWrFa9eLHojopd9wsLYlVW7rNTdN/Jr0FMg/2i12wGDpukI74BKCc9CW/o
         5GelySUNPkXnQ1dGMwpniakaLiYIqoMEbkr11Eyko/hFJeg++FNIbkKZV+PJf7UYfUyS
         tsZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790244125; x=1790848925; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yf2eXBIzfUAyDI8YQcFwCnYg3j6ep9DZNkN0GsU9MPc=;
        b=nYsq+CSdFf6UwoKKyCvz6nEEOorVQdkseLHJvEJvXDWZu7/Cd6KiZ3SybDgb2JJNBW
         o2QWy5B3QwiaPEdZr8GVaw6fjPdEDk4f9S/oNn/COfRmpqT0Z8nQZniv7LJvfs/lzT5T
         Mwnt7HFz71IsOcsMbZP34yEkgs5WFwIVJVlIZeJC0lQzhA5vG9PJPHfM1Vr1RPxRJdSN
         /b9T5exi3QnNlLXD+Hx0A/hfNIgJzwnztvyigFStDJBI4Xl7/kajYOvW3F0J7iS1tt/5
         84osfU5tUFwgk7NzYaNv5fMeiZIkXRVCE4zPO9eXap3NLrTRUe8JiN1JiOAZ19yqSmC+
         iSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790244125; x=1790848925;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yf2eXBIzfUAyDI8YQcFwCnYg3j6ep9DZNkN0GsU9MPc=;
        b=VdJFlZOamufQv20Nmg/EDM9jrvFwEnohlIkFk0AF1X0sMyOq0homoatgXp/Xar8vQh
         Z4YN9ALXfarPe2MYph19TV45a4PPPomncrPNaq3FCjYXP9gQ95X/oH9Vl9perdLWhl+/
         vQZMQ9bzfhd8V8AkWjloMaNPjIf0j6mquSj39mDOn3JAmVJS+/I5Vt6WlJI8tTNW1mEB
         hTY6pgpn9TnGr/u0qcfxf/C9C2qgqceU6Bq++gq/Ex4iExwkUAyChn4yoUGyjel8/hZJ
         Eq28PsjGserhvydZk5POnd05VIQrvKRaDQfl3XDZhCNhXbpL0v1VtGV3bzRVdu9BIJFZ
         Enhw==
X-Forwarded-Encrypted: i=1; AKwUvBwE/mV96yRYckxvAbHemkQ8nVXLF/MvxQEqHVTPHUPY8LnGXHiuzbclGS2l1rFmsJ6phKzAodYK@vger.kernel.org
X-Gm-Message-State: AFuF++nXmmA+71fGe9cXtV9IOAvNO0e+3qDL6W3xozXkCHoATcDWlDfp
	GOoG/XUWqsUwpC5YZiQupc+mpv0Ij3IFePcGzP0lVrCHPDCx58H79lzCFjgeKtlDswFQrXdSZ/k
	awzEiUDx3yffqycBP7wAdgL1rcYNyqvk=
X-Gm-Gg: AYBFou2JxDq+M53W8wRC3omSxkNhbNDgxamTooWimDIX2MhdG/tnunRby9UfHVqr6jl
	9x1wgcfg/RPS4cxA5MN4lCyomAWsrJV/Q93pIF3rL3/24IUWfvF8tC/qWRBqXE+h6Ey4z767QIB
	+ft7JWvqSOaEwXRzyb86oVlM/bEIT0U1UdX+hF+HR2sh1CCT0DMJsjwgasjLgpr20I/eBhKWCei
	iQvixJTeWH/qs6ripqXlnUC88plwe9LTIJo7HziHC8bPJ4hqmU54kvFGWM4hZdSaui6o6PVnjwJ
	mB2zUSTz++utDeNS+Pk8GoSOMN9YjrDIrJn8qcd83rWzLP40kQBhJioTXuiBfTYmUMFHTHAZ463
	BmxJHUiVMSxcx5zjq5ispY0I=
X-Received: by 2002:a05:690c:e3c3:b0:869:1ab2:33aa with SMTP id
 00721157ae682-8a645aae281mr9464687b3.20.1790244124691; Thu, 24 Sep 2026
 03:02:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com> <arPyspcEFNkqfNyr@linux.dev>
In-Reply-To: <arPyspcEFNkqfNyr@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 24 Sep 2026 18:01:27 +0800
X-Gm-Features: AclHuK-I9uw-yPD5uF_5nJaKC0fsPFwXnig4t8YGhNpVyr0Q5duPYTUrOw96ia4
Message-ID: <CALOAHbDKRw9cPN_GxOYbp9u50cvr7PzPyoGPsSwoPDPAwBCGbA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached struct_ops
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Amery Hung <ameryhung@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 11:47=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> Hi Yafang,
>
> On Wed, Sep 23, 2026 at 09:07:40PM +0800, Yafang Shao wrote:
> > On Tue, Sep 22, 2026 at 3:30=E2=80=AFAM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> [...]
> > >
> > > Known open questions
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > The semantics of memory.high for remote chargers or kernel threads is=
 a
> > > grey area and this series does not aim to resolve that.
> > >
> > > Another open question is whether a bound on debt deferral is needed. =
At
> > > the moment, we think that rather than putting a limit on deferral for
> > > memory.high, it will be better to handle that through an async worker=
 like
> > > memcg->high_work.  We aim to introduce that later, along with the rig=
ht CPU
> > > accounting for that async work.
> >
> > Hello Shakeel,
> >
> > On the open question of how deferred debt eventually gets paid: would
> > it make sense for the policy to also notify userspace (e.g. via
> > ringbuf) when it defers,
>
> I think the notification through bpf programs is already possible and a b=
pf
> program deciding to bypass memory.high can already do notification via ri=
ngbuf.
>
> > and have a userspace reclaimer do the reclaim
> > through memory.reclaim?
> >
> > I understand one of the concerns for the async worker is CPU
> > accounting. If the concern is that the kworker's CPU usage is not
> > charged to the target cgroup, the userspace reclaimer could instead be
> > spawned with clone3(CLONE_INTO_CGROUP) so it runs inside the target
> > cgroup, and both its CPU and memory usage get charged there.
> >
> > One caveat: intermediate cgroups with the no-internal-process
> > constraint cannot take processes, so this would only work for leaf
> > cgroups.
> >
> > What do you think?
>
> I think all of this is possible without additional code and with this ser=
ies.
> With AI, should be very easy to prototype it. Please take a stab and I wi=
ll look
> into it as well (time permitting).

An LLM helped me quickly implement a userspace async memcg reclaimer
based on your series, and it seems to work quite well.

>
> Thanks for taking a look and also please let me know what other ways you =
think
> memcg can be customized through BPF in a beneficial way.

Sure. On our production servers we have been running a set of BPF
programs to tailor kernel behavior for different workloads =E2=80=94 all of
them global programs so far =E2=80=94 and I believe they are all good
candidates for per-cgroup BPF policies now that cgroup-attached
struct_ops is available. They have been really helpful in our
Kubernetes production environment. I have sent some of them upstream,
such as:

  - BPF-THP
    https://lwn.net/Articles/1039689/
  - BPF-auto-NUMA
    https://lwn.net/Articles/1054030/

Perhaps we can revisit both of them and turn them into per-cgroup
policies =E2=80=94 what do you think?

We are also running some custom BPF programs that have not been sent
upstream yet, such as:

  - BPF-async-reclaimer
    We don't care about the CPU accounting of the kworker, so we just
wake up a kworker to do the async reclaiming.
  - BPF-fault-around

Both are really beneficial to our workloads, and both are global programs t=
oday.

We are planning a few more customizations to resolve painful
production issues, such as:

  - The long-standing inode::lock contention caused by dentries [0].
    We have not started implementing it yet, but we might introduce a
memcg->dentry_limit or a memcg->vfs_cache_pressure as BPF policies..
  - cgroup-level readahead.

So, to answer your question directly: for memcg itself, the beneficial
customizations for us are the reclaim policy (the async reclaimer
above), the dentry/vfs cache pressure knobs, and fault-around; the
rest are per-cgroup MM policies that would need the
struct_ops-to-cgroup mechanism generalized beyond memcg =E2=80=94 which is =
why
I hope these use cases can help make the design more generic.

[0] https://lore.kernel.org/linux-fsdevel/20240511200240.6354-2-torvalds@li=
nux-foundation.org/

--=20
Regards
Yafang
