Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCDF387372
	for <cgroups@vger.kernel.org>; Mon,  2 Mar 2026 15:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466802; cv=none; b=WWh8RVZ7dDdCkEktLdmToUtiaiJJdkDJF78mG0S30WbgqYtUNw7dVl8mTVwZfrOjeBCMaOJFEtjoqf6yP1UfvzlPCsVDntBlE9ldGnT0PzyjVSvXSTJ7ozGyzm62F/OFsnKqD2apMlnPWxLdOQloweU2yPqLNuJM4zWM72Rp+XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466802; c=relaxed/simple;
	bh=Lzcw9bSxmejm0gJDOTach+8XGgnELPRdfMZnwQFuwiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qtUPlPMicF5Pd4CuulORYKVH6s4/yl5cyu7f05tOPuqyoch2u39ZvMZT5zIBFrY8vN1pUIKiAYsgcwiM+oRmdIE8K9dMZwHE2gtHx9sObTqvH6/A4mlk0tuuGP9fLToGSTz8XtjsihQUgu0Zo+XfRi7p87FU4LpAOLWuWkD7yb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCB+SkR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCB+SkR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29D5C2BCB7
	for <cgroups@vger.kernel.org>; Mon,  2 Mar 2026 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772466801;
	bh=Lzcw9bSxmejm0gJDOTach+8XGgnELPRdfMZnwQFuwiY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eCB+SkR+v2AojvuGPK20HGDla7EykNAGMD5qya144xypRtN5GzUmuArNyTTTiJaFs
	 6IIYsGXW6bpBJvgMIwI/dnIrOGTDYgDijE01p81q0RHg6e7tLEuTtW3wI/qAF5DlCW
	 hwER0nCkM02bkQ45v78lSXTUHYd0U3U/YjmRTQOFs/2zSn3+MOoFDt0N8RyXIba0i4
	 GVpEMeLV5gN1v3kNRfJvfhsR/754C06q7sGynIQUOjasUyfRJgLQezitgBTEr+Z1dq
	 xdeVlklYTDmUz4N4SboVuIeuyscuKyaEc3qdtfg6Rnb0kjIR7kdTMU6ifFdnVllAHc
	 G+S+E0noPWL/g==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b936505e7a0so106583966b.1
        for <cgroups@vger.kernel.org>; Mon, 02 Mar 2026 07:53:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVljOQ8+M30HBhbtufPY6hp7QG3elLF4o9SMF74+sRyYqbcdp+pqJfxH89OwHsCVPkzP3GAHAtg@vger.kernel.org
X-Gm-Message-State: AOJu0YyyoBeJbGu3s4o0i3AyJuT3pc1V0GiDxznv8DyaQ9QaOCINMPYr
	fxW/pffNn+bItOsLrY3TqTcY+JKspm0NRwnsZdpWSEp4322lg6BgFCQdvJvvzC8/23AiE289HEn
	dTJDg4HIyXbTMcJgYnL9mGYkih1+Dyg4=
X-Received: by 2002:a17:907:7b8e:b0:b8e:a126:66be with SMTP id
 a640c23a62f3a-b9375932a96mr906965466b.18.1772466800366; Mon, 02 Mar 2026
 07:53:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <20260228072556.31793-1-qi.zheng@linux.dev>
In-Reply-To: <20260228072556.31793-1-qi.zheng@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 07:53:08 -0800
X-Gmail-Original-Message-ID: <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
X-Gm-Features: AaiRm53G0wvbwkndbhtmVzlFp2bgI26S0fTTYledhanzWTm5GQC0n2lE4RDJ0yo
Message-ID: <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"

[..]
> @@ -763,6 +851,64 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
>  #endif
>         return x;
>  }
> +
> +static void __mod_memcg_state(struct mem_cgroup *memcg,
> +                             enum memcg_stat_item idx, int val)
> +{
> +       int i = memcg_stats_index(idx);
> +       int cpu;
> +
> +       if (mem_cgroup_disabled())
> +               return;
> +
> +       cpu = get_cpu();
> +
> +       this_cpu_add(memcg->vmstats_percpu->state[i], val);
> +       val = memcg_state_val_in_pages(idx, val);
> +       memcg_rstat_updated(memcg, val, cpu);
> +       trace_mod_memcg_state(memcg, idx, val);
> +
> +       put_cpu();
> +}
> +
> +static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
> +                                    enum node_stat_item idx, int val)
> +{
> +       struct mem_cgroup_per_node *pn;
> +       struct mem_cgroup *memcg;
> +       int i = memcg_stats_index(idx);
> +       int cpu;
> +
> +       pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> +       memcg = pn->memcg;
> +
> +       cpu = get_cpu();
> +
> +       /* Update memcg */
> +       this_cpu_add(memcg->vmstats_percpu->state[i], val);
> +
> +       /* Update lruvec */
> +       this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
> +
> +       val = memcg_state_val_in_pages(idx, val);
> +       memcg_rstat_updated(memcg, val, cpu);
> +       trace_mod_memcg_lruvec_state(memcg, idx, val);
> +
> +       put_cpu();
> +}

I don't think we should end up with two copies of
__mod_memcg_state/mod_memcg_state() and
__mod_memcg_lruvec_state/mod_memcg_lruvec_state(). I meant to refactor
mod_memcg_state() to call __mod_memcg_state(), where the latter does
not call get_non_dying_memcg_{start/end}(). Same for
mod_memcg_lruvec_state().

> +
> +void reparent_memcg_state_local(struct mem_cgroup *memcg,
> +                               struct mem_cgroup *parent, int idx)
> +{
> +       int i = memcg_stats_index(idx);
> +       unsigned long value = memcg_page_state_local(memcg, idx);
> +
> +       if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
> +               return;
> +
> +       __mod_memcg_state(memcg, idx, -value);
> +       __mod_memcg_state(parent, idx, value);
> +}
>  #endif
>
>  static void mod_memcg_lruvec_state(struct lruvec *lruvec,
> --
> 2.20.1
>
>
