Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2344D39FCDD
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 18:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787078121; cv=none; b=HPeTQku5Kh0Vk4576yO5EftWiN3S+OGBuFC8oFgUz6Y3Zj2TNSIo1EOqxMoZgi0c1oaCl3GhXr/jcMgA/wipW0jO72twCkECe7UgJRGxdQuMizG0HlweqqcDljluF0DK2z5q9BcwE3H/MeErH0rPqHm3Hc1uQE7owCr9IttKm+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787078121; c=relaxed/simple;
	bh=rJE4/6z2e+mz9R+4laIpwbHxk21Dgyf3KuCCFyHciN8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hEAJqaVgxqstAOLxYaKQnUuSRByBhEbMHN7A0oVR64r+fTWcrloqPjx2stFBj8rKHecq026t4SeVnQ9h2NcEQq7Ig9yG9ekdpwpKnsrrQgTfFH2+bumz3aVWzgWMN7Xb7KgvNFryWID7XdL4Fm5dD5PcgSWDc4eIfwXRNURW/uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ie1glb95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ie1glb95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF67D1F000E9
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 18:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787078119;
	bh=nD9alVem4M7AVItlV4nlRl6Uyfz7vLLSdNxJ+Yr1jCA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ie1glb95zaKBXlAb+RIz+qLby/qvHHBIXjQPQpf/Yb/lG0bftM8DJKG7jfyy7Rnj1
	 KsTrEhl2hhLcuyFzvLcYHEyMPxivzsEa2xC9Kq+k81NI3FOJI95D7sIYokTPTd4TBQ
	 /k90gZljqGygUNrwU7EpTXB5V+TyVgfKrLiLVLv+A7Opd5uTGt1KfW5rcG15SrRkY1
	 7xnwNhJJcoDleiZVAu1VGYZztB5G/k62h164N7gh4PAcMokq6Z7x9xPppobO2N0N3o
	 H8penjN1DDYWN7qLmMiJEYvmoGC5a1N8Cu+6p5YHJymdQRf/KBM46scApsWP+roR07
	 NGUyW5hDOGLwQ==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15d3cd51b2so15207966b.3
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 11:35:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RplXLyxWDcZljejJzLvw5gb6A+7fSf01COUuTszDVjMTePbrZ7nZNqMiIogFqfH9qZl7VA4gv9t@vger.kernel.org
X-Gm-Message-State: AOJu0YzdXfkLGNVDeMh9anFUK7KY0IEZEWxmrvBryrUDYgxymzfNBzNZ
	PRcfcUd7ljPzfZLtVXxBbGlOiMn/M/eNimbcnZpWyFedaiys3eH0skwlaKVspNvXFalzHJ27mzA
	TdFF9U/m2CVIfqqEKuCX26XITAslUTcc=
X-Received: by 2002:a17:906:9f90:b0:c21:72b:dec0 with SMTP id
 a640c23a62f3a-c2216dbea77mr29484666b.5.1787078118783; Tue, 18 Aug 2026
 11:35:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
In-Reply-To: <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 18 Aug 2026 11:35:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
X-Gm-Features: AcwNN1X0fMYlCQhwIAy4yXr2cG_a9NPX56FNrRgmFSglhsymz0fEqah-11M1DVE
Message-ID: <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Song Hu <husong@kylinos.cn>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 17, 2026 at 6:53=E2=80=AFPM Song Hu <husong@kylinos.cn> wrote:
>
>
>
> =E5=9C=A8 2026/8/18 00:04, Shakeel Butt =E5=86=99=E9=81=93:
> > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> >> obj_cgroup_may_zswap() runs on every folio swapped out through
> >> zswap.  For each ancestor with a non-max zswap.max, it flushes the
> >> cgroup rstat hierarchy synchronously with force=3Dtrue, which skips
> >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
> >> with zswap.max configured, a container takes the global rstat lock
> >> on every swapped-out folio.
> >
> > Any reason you are limiting zswap through zswap.max?
> >
>
> Mostly fairness on a shared pool: zswap.max_pool_percent is global
> only, so on a multi-tenant host one cgroup's cold anonymous memory
> can soak the pool and crowd out the others.  zswap.max is the only
> per-cgroup control over that share; memory.max bounds the total
> footprint, not the share of the pool.
>
> >>
> >> zswap_shrinker_count() had the same pattern and switched to
> >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
> >> where the same flush on the shrinker side showed up at 2.88% of
> >> kernel cycles under osq_lock on a 96-core machine.
> >>
> >> Measured on a KVM guest with a swap storm under a cgroup with
> >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> >> before the patch and 198,968 times after, while
> >> __mem_cgroup_flush_stats() was entered 281,017 times before and
> >> 80,445 times after.  The removed 200,572 flushes match the store
> >> attempt count almost exactly; the remainder comes from other stats
> >> readers in the swap path.
> >
> > This is a known issue. Using ratelimited interface also comes with a dr=
awback
> > that the kernel may react on stale information and the consequences mig=
ht be
> > unneeded oom-kills.
> >
> > There was orthogonal discussion on moving zswap limit enforcement away =
from
> > rstat. Yosry, any updates on that?

I am not actively looking into that, but Joanne was looking into
AFAICT. I will respond to the thread there and CC Song as well.

> >
>
> Fair point.  The direction I had considered is the benign one -
> stale low after a burst of stores overshoots admission for a cycle.
> But after a burst of writebacks the folded value can be stale high
> too, and premature rejection with zswap.writeback off or swap.max
> tight ends in a memcg OOM kill that accurate stats would have
> avoided.  may_zswap() is admission control rather than a hint, so
> the guarantee matters more here than for the shrinker side
> of ea80da363a1f.
>
> If moving the limit enforcement off rstat is happening, that
> supersedes this patch and I am happy to drop it.  Otherwise it can
> serve as a stopgap for the per-folio lock cost - your call, and
> curious where Yosry's discussion stands.

Not sure how much progress is being made there, but I would really
like to stop the proliferation of ratelimited flushing, especially in
this case where it can cause OOM kills.
