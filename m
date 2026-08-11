Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFCD2931E2;
	Tue, 11 Aug 2026 16:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786467289; cv=none; b=anOJ7TZznYP98YpdKUhwxAiURCMexnjO14GWV6yYVaKNRtAjPLbxN6J+NvW2GTHah6YfYqFUa0NLebuCK4+8766R7szku6o2WGB6lOwuslvxw8j9jnV/PfI93/FfJNaTW+uy+9OY+1ZSgu5wabuS5Fm+PbK55UiuPY9Jg1rUjgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786467289; c=relaxed/simple;
	bh=30LKNeNd4i8Elpft8MpybJD3r2hXHB7da18wxz4zo7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aErrMQzh8bOcKI5Fh0WfxGc4P7Flm4Cux/pRl/xP5y9hEI1CRESoF/HzyubfUW+1uinCHjBYBIRgCp+ORgFt7rUJmBtrIzu4WLe3pCgUPFi3HER67/caLOL4C0Wvy+rvs1DA1VCT4MaNe6WWarN0n6iq2zFuK3HUqvsfoVzPGLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lb/zXqFF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lb/zXqFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20A71F000E9;
	Tue, 11 Aug 2026 16:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786467288;
	bh=Z2TXg7aZhG/KrelMhIYVJ99hwjE63n3U7HIFuhBajkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lb/zXqFFP7B4P6AJvYySOls7y5MVu/gyDEHC+8hQqAxjmcIVfBmEi7CUjvJfbSA4X
	 U9IyNeDtDulGYBYj7Sra7AdBq6fRofOlSj8wO2NoWYig59yuOkvM0nAdfjbYxHKcKt
	 wF6Bs2D+x2a9S/XnqJf2FjvQI1Be9wKIn/mQCepQ4RXp4loOVx7sTRjRPQlsV9Of+Z
	 ZNeX7hqCuhimvkIucEKB2Gx0scaWdpKzLz1Cbwo6D97CX1JrVZV6LNtMTdsqjj3Vwt
	 kSiIKMFUS6gg8MArFb09BL1h+PzSlLLlGtsqUUg/iBNPPibFgVQHbmugfGLcHy3CBH
	 +iS/9a4/xIdIg==
Date: Tue, 11 Aug 2026 06:54:47 -1000
From: Tejun Heo <tj@kernel.org>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: Ziyang Men <ziyang.meme@gmail.com>, Jens Axboe <axboe@kernel.dk>,
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
	Mykola Lysenko <mykolal@meta.com>, kernel-team@meta.com,
	linux-block@vger.kernel.org, bpf@vger.kernel.org,
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: add BPF kfuncs to read blkcg io.stat
Message-ID: <antT1wtJEZ02CDx1@slm.duckdns.org>
References: <20260807193732.4073299-1-ziyang.meme@gmail.com>
 <20260807193732.4073299-2-ziyang.meme@gmail.com>
 <anot9w6mg9538RWm@slm.duckdns.org>
 <anpU4oV46MDVDixj@devvm16600.scu0.facebook.com>
 <4306439e-a00f-4b10-b8a0-9be6e046873d@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4306439e-a00f-4b10-b8a0-9be6e046873d@linux.dev>

Hello,

On Mon, Aug 10, 2026 at 05:17:26PM -0700, JP Kobryn wrote:
...
> The get/put kfuncs above use KF_ACQUIRE/RELEASE so the verifier can
> reject memcg access after the put. Replacing them with a generic API
> would call for tracking a new lifetime relationship between the css and
> memcg (or other derived) pointer.

So, if you need css -> memcg casting, I think that can just be RCU
protected. In fact, even for the iteration and access, RCU protection
probably makes more sense then KF_ACQUIRE/RELEASE. It's simpler and less
overhead especially given that most bpf progs that people care about are
non-sleepable and already in RCU critical section anyway.

Thanks.

-- 
tejun
