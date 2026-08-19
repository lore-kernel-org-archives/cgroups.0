Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8125642A96;
	Wed, 19 Aug 2026 22:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787179919; cv=none; b=rqvenZYseu/GJP24YTv2yVM5MZNYfjMpZmP6XrPpvlo5HrEzE+ft24zshR9CAZ2qJqnvMUepk2ssS/r+1W9KViIErlUCQyq69HEEyq4UoLrB32XvFsj9hVdL5mpqybqz752Gid+witYeZHlgDUfzxzUkWbCwyO0MsexJogE2Iek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787179919; c=relaxed/simple;
	bh=a8znbGTtU25MC0b1skPIq2SPK/UcXJV63+Tidewo3pQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FwbSjUwaz7DgpTmc45UmTosWtEiRaHLy7q85aH9jzmwJ7Pac/l/e1fmk+GcCjO1/c8CO2JJyitQVj7i4ybHDLANRwK8C/YWsKpv93s21y62yvV+VRuDp6q18tQlTWqRhICp/1WmPfiUxwxmtWwuINK2Y5P4arLzdpQhNYxNDdbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=II0+Fkqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="II0+Fkqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F191E1F000E9;
	Wed, 19 Aug 2026 22:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787179918;
	bh=S2bKynL2yXaKWbSw85s0IvCAlaumC+saXxJ1IubC7yg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=II0+Fkquu7LRsweGUQSuyJTgMVQZ6C3z/+Q3jxlVSMVJKxXYFt5y0kZkM8v1lEhMn
	 J6bRUUE4+Q863+EoJjMwB+s2BNHElGRUFazo3kJ69ZPDullD72ViYWNcAaF2fKCo0P
	 Q6jInjg1ctRseROA+C/EW+l+gqm+tA1iorlaN7S0XMVAFnF/WZF6Aie21fqA5NqXDX
	 GpK3xSKBzf3402DgMYeDhkMRW5dNOzMzqzMMfvdw+sppEqU5geSflTS9uLbn2pRHGD
	 VyclfYq834A9SXqbyFu2YrbywNVjHqvTMaiwQYjnK3X86qY+m4fCrfXijpG4bNtET0
	 5dpJsybUli/hg==
Date: Wed, 19 Aug 2026 12:51:57 -1000
From: Tejun Heo <tj@kernel.org>
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: kernel-team@meta.com, Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>,
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
	Mykola Lysenko <mykolal@meta.com>, linux-block@vger.kernel.org,
	bpf@vger.kernel.org, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] block: add BPF kfuncs to read blkcg io.stat
Message-ID: <aoYzjaXQNmm9bDcE@slm.duckdns.org>
References: <20260817214205.723267-1-ziyang.meme@gmail.com>
 <20260817214205.723267-2-ziyang.meme@gmail.com>
 <aoSUob1s8WBQ3buO@slm.duckdns.org>
 <aoTdQeLZZuRirNHE@devvm16600.scu0.facebook.com>
 <aoTf7u20mo9s6ADj@slm.duckdns.org>
 <aoTkZhQDoaQKpPe3@devvm16600.scu0.facebook.com>
 <aoYVh1ihBH-TWvi3@slm.duckdns.org>
 <aoYsIYnoFDvjkzKp@devvm16600.scu0.facebook.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoYsIYnoFDvjkzKp@devvm16600.scu0.facebook.com>

Hello,

On Wed, Aug 19, 2026 at 03:20:17PM -0700, Ziyang Men wrote:
> Yes the css_rstat_flush() is exposed but currently it is marked as SLEEPABLE, so
> it doesn't accept a RCU_PROTECTED css we proposed. This is not a problem for cpu
> ones since &cgrp->self is a trusted pointer.

Yeah, bummer, so we get ref on cgroups but the subsys pointers are RCU, so
that means those refs are only RCU protected. I guess we can't avoid a kfunc
to get acquire a subsys css from cgroup. I wish css_rstat_flush() didn't
schedule but it does need that cond_resched().

Thanks.

-- 
tejun
