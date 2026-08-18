Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAB8367B85;
	Tue, 18 Aug 2026 22:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787092977; cv=none; b=U/2c57VFNBrfEQcY0sXlOMM0h6c3FdNgl2gZm8qzNUDTkqwAoe8jMac7N6TU2yH9uYeCYbKT23DJDMJmhETdTp0PBSeDsj3oOwcidr+3fzxGOfJQ3rcBaOBR1US9wqcXAm9Gh0WgftT+vs13rQ+IXAoLvJ+t/Krth74UCzdDxtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787092977; c=relaxed/simple;
	bh=dDJmq3C8TOVc9ldGKqnIh3Wnefv0/EWrcdN1qb+oJXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0JbdEqeiaPNk7jIfypjerrq1BrB8SCG8Z5B6JjBC6Ew6HJu+puDDteDKF5Y7AXdIGLSLGslttJOQJmYwIZvmsHTpKO62rtwNovUFUPWKv5mslRHGfHCyPypYAA33P5QNPKcHgV6jxbdlsRSdo5R1gjuBl9Dt2Q0+vLfobzilNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ABdmqOA5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ABdmqOA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644041F000E9;
	Tue, 18 Aug 2026 22:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787092975;
	bh=wODPEH3kAKyb/9wjK1hvQoUgCsHwZR7owm4hytEsFTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ABdmqOA5Jf2Kvvl0RGEYlvj7gmSRsU9j82m8CzRYedMsNm2EZ887wZIfYOdNDJrZH
	 xuWj7jOsavWRRNDQosNkbnatqcaKRYYo0EJ3Evt3W/fueMnWqXR67mmzLOvkwTZAWZ
	 cqn8BiFBmd2+81AoGsbdmxacgb8mamoIETHz3LoE8MiWZCmLWpFsD2AMwbY5inx7+e
	 Yz4/K+2KFcMhckk+zVSnoekCrSl9hkGN/Z+rleuY7ClCy5gg2Ovr4WSpZzk2tQZ0JG
	 rfwqpZQMrcc1e9LtE1+d9IOD2BNpKGnfvUdDrFBO1Ir4qqxg7+YkL/+lgC/VqcKdQn
	 jZx8AyQ9gDzkA==
Date: Tue, 18 Aug 2026 12:42:54 -1000
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
Message-ID: <aoTf7u20mo9s6ADj@slm.duckdns.org>
References: <20260817214205.723267-1-ziyang.meme@gmail.com>
 <20260817214205.723267-2-ziyang.meme@gmail.com>
 <aoSUob1s8WBQ3buO@slm.duckdns.org>
 <aoTdQeLZZuRirNHE@devvm16600.scu0.facebook.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoTdQeLZZuRirNHE@devvm16600.scu0.facebook.com>

On Tue, Aug 18, 2026 at 03:31:29PM -0700, Ziyang Men wrote:
> Ok I will add the casts bpf_get_blkcg() and bpf_put_blkcg(), and remove the
> check of css->ss in above functoins.

RCU_PROTECTED is probably better than get/put().

Thanks.

-- 
tejun
