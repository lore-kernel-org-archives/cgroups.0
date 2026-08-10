Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABD837F01C;
	Mon, 10 Aug 2026 20:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786392057; cv=none; b=Uv2d7voMHODCksx5dIuYoNnLoUfsMI5q9plMtEU9iG5tOmxMIp2s9/7kvyaVkbQOQdrkIFMeJ252AJAcRitPs0D4eNBeyk6lLwEfCYTkq1/D3kCoo89LB9fOZlQ2nIFwdLvoa8B9USwY+D29WnGXlJOfTRsu8BxsSx0Gva4AhEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786392057; c=relaxed/simple;
	bh=HGRKtzF8/V4AsFCqnY3RDFsxWWDIEH9PipcvJ2CNS7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=py+LUYrmUcWR01y8zum+tOwQX7xwFiLkMI/g+gZPgfllpcjmysYtEjubkoRu9CnCof4CCfvcCewcLbDf8y81csHEnaqbVbB1VOhEW7tBlMhGtG1vySvZR5mCPe98zBwNj3yZ9NrxIzq04srKwthAtEQy5aSUudSaLt699D0V14Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHHSSgrX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHHSSgrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33231F000E9;
	Mon, 10 Aug 2026 20:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786392055;
	bh=fPgod6egbm1Ih0JWPiMV1OogLXmanmpK4kPFNamx3Fc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kHHSSgrX5fZxR2bZ2ZpoIM+he0qDIsjQ3MlQEQLndstfgRa3O4PgvSlxigjQi4Ae2
	 8B7nREP/KvkznEqvFdZRdpSo4GHt/5dnofF3adSCEp0+0o6GBqHPy0vY3pmRJP5Ys1
	 +bnoglFgq98hwCdIx27nnugT1aNB0d6wxzk0JOlVE9urqUHKxUfwOA0BuJRf/eT1iU
	 /wXhGSInwuxQ+qMrvVOHC9Xf9SPvcDrvZTpNrySrNrq6RMgIMzMRfkdcowmohgJFOH
	 mcE9gfxL6b2xVXlauL208ZzJtfDfjhVnNxt4M+foWO1BAZ8tNjith9iZuciWa2KvBG
	 We24FeD28CInw==
Date: Mon, 10 Aug 2026 10:00:55 -1000
From: Tejun Heo <tj@kernel.org>
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>, kernel-team@meta.com,
	linux-block@vger.kernel.org, bpf@vger.kernel.org,
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: add BPF kfuncs to read blkcg io.stat
Message-ID: <anot9w6mg9538RWm@slm.duckdns.org>
References: <20260807193732.4073299-1-ziyang.meme@gmail.com>
 <20260807193732.4073299-2-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807193732.4073299-2-ziyang.meme@gmail.com>

Hello,

On Fri, Aug 07, 2026 at 12:37:31PM -0700, Ziyang Men wrote:
> +__bpf_kfunc struct blkcg *bpf_get_root_blkcg(void)
> +__bpf_kfunc struct blkcg *bpf_get_blkcg(struct cgroup_subsys_state *css)
> +__bpf_kfunc void bpf_put_blkcg(struct blkcg *blkcg)
> +__bpf_kfunc void bpf_blkcg_flush_stats(struct blkcg *blkcg)

I wonder whether making the above deal with css's would make more sense so
that we don't end up with per-subsystem iterators. If casting to per-subsys
type is necessary, we can provide RCU protected cast kfucns.

> +__bpf_kfunc u64 bpf_blkg_iostat_bytes(struct blkcg_gq *blkg,
> +				      enum blkg_iostat_type rw)
> +__bpf_kfunc u64 bpf_blkg_iostat_ios(struct blkcg_gq *blkg,
> +				    enum blkg_iostat_type rw)
> +__bpf_kfunc u64 bpf_blkg_dev(struct blkcg_gq *blkg)

Ignoring 32bit split reads (do we really care for BPF accesses?), the above
can easily be done with BPF_CORE_READ(), right?

Thanks.

-- 
tejun
