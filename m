Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E36C494834;
	Wed, 30 Sep 2026 23:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790810614; cv=none; b=kW5S9yeDJvqj/OwqGxSZQiSs19iPNK1pTqmfTJLenHDB1bHInNx28+qw/iVLhBngvJkM+IynoZr9bxL7lEjue5bxNneP4NGY83+KlwVWzydR0rgsrH+uCNMGnl+PXXnRp78UtN8FHH7I8B+BJKphXmLP1BL/TNPQW7YT/7fVRVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790810614; c=relaxed/simple;
	bh=UnCo48ZDhnPDd4SBAC3AK47FxC93hosZz0DdLzttLbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdKjsA0+JcXi03HCzvpiT/eRdR7jL4lymcZl8mDbBZyiKFOTF1LJho0BTAWCgBmryd1chRxNoRp69Pk7xJ821TrJPAiMyqGWCscrQWl0Fh7nc8qSCHPfz5uu19hiC6pA/M+f84qTrrUXjslDjs8bZ94vhza6rIzTpxzbH6cAL2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aS19bbG8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aS19bbG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FA01F000FF;
	Wed, 30 Sep 2026 23:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790810609;
	bh=fZP1NRMB3JPcaMokjk4Mi47CTHALGDJvTzGhqKvT/LU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aS19bbG8avkKaMGRW8eA4zpnPPpQ7mQowa/bGDYeIxQMW9NTbCAMdDhTgMiye6d+j
	 Vk5RIvhbQTVjLgQ8c7pVhvGX24QBdtkE/PRRRL6KpvI4qY8/I6n4HHdbgqUX1kg/IB
	 NRNEjgOMtcj30OL2YCtEVdPTkrp9sJGfDTVDzeAWAjwb/z6nHf+5g8T5gUcEbon9j1
	 ULfCSUXWxIvDtxy9JgAT3zt9PjKNOiRmAEj8BKCGv+JeUlKb9gD1g5UslJb1X7qHF6
	 EKQgGoMh/66MLfDirJXwth1mgmECMigUttsyCMgMlCl0joJhuPzyfVIxYu4fDwGC1J
	 F15PhNRfg7kzw==
Date: Wed, 30 Sep 2026 13:23:27 -1000
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Amery Hung <ameryhung@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] bpf, cgroup: fix cgroup struct_ops query for a second
 attach type
Message-ID: <ar2Z767bSOsf8ST4@slm.duckdns.org>
References: <20260930135159.3926039-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930135159.3926039-1-shakeel.butt@linux.dev>

On Wed, Sep 30, 2026 at 06:51:59AM -0700, Shakeel Butt wrote:
> Two things in __cgroup_bpf_query() work only because CGROUP_TCP_SOCK_OPS is
> the only one struct_ops attach type.
> 
> It calls cgroup_bpf_enabled(atype) with an atype that
> find_atype_by_struct_ops_id() works out at runtime.  That macro is an asm
> goto and needs a constant.  Today the compiler can see there is only one
> value; add a second type and the build breaks with "impossible constraint in
> 'asm'".  Add cgroup_bpf_enabled_runtime(), which reads the key instead, and
> use it here.  This is a syscall path, so the cost does not matter.
> 
> And find_atype_by_struct_ops_id() matches on type_id alone.  An attach type
> whose subsystem is not built keeps type_id 0, so a query for type 0 finds it
> and returns success with nothing instead of -ENOENT.  Skip such slots.
> 
> Fixes: 369d9dcd8fb8 ("bpf: Add infrastructure to support attaching struct_ops to cgroups")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Yafang Shao <laoar.shao@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
