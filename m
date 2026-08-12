Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F7C33508E
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 01:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786496888; cv=none; b=fJl+gOADz6Ph1GX6ZHEiJsWKM4zg/+VT2a4OGNV+MnWbNikYTW1Us57t84c33ucs/zYIb8dZ0ef7wrQxcxiKbFzovP5cc9+nunbkLLuR0abE2lvco1NI/Vb6Y+MHAHP/J/Tj6f5YSzlR5qY9spjxjFoTelhnhY+GX6Jjvx0sIYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786496888; c=relaxed/simple;
	bh=M8fbbsP0hIKLRkOmMm0hqgAyWvxRX5hrSQ/luFu7/48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kTPBi8W62RfqPxUSCmLjBYcjrW+P+jYufp0HNpmDzqysB2g/epQa8/wO2x3hHa0zGT506PGEjEoOQsnZBph+N6jKqQZ7JydFzJqRzW4UGv4I3LZzi1g7HZy9pfJaoNd+nYHsm6v0mBYClTEu+l8MrL5A/QeKHJma/FjmA1F3p9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ep8S3WPB; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ep8S3WPB"
Date: Tue, 11 Aug 2026 18:07:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786496874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZtDHm16tZ1AeI1JlccbZ5sxenZSs5J6HVIBDth4k+zI=;
	b=Ep8S3WPBKYvaqNZuQfSI9AJk8Mnjjnn/rtkrv7oROgDfuQ2WHBIrQRC2CtcvBDD1WdJn4l
	NbZWgXeuxT5GZ3+evpkisjMCmgeDZJuYLwxERo0Mo/ad56gL6JnlOT6DnxHPLj21G9SGsw
	OVVmALVE9+iUPxSofv9BFXRVYk+Fffw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Ziyang Men <ziyang.meme@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Josef Bacik <josef@toxicpanda.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Mykola Lysenko <mykolal@meta.com>, kernel-team@meta.com, linux-block@vger.kernel.org, 
	bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: add BPF kfuncs to read blkcg io.stat
Message-ID: <anvCwytP6-9z0tEF@linux.dev>
References: <20260807193732.4073299-1-ziyang.meme@gmail.com>
 <20260807193732.4073299-2-ziyang.meme@gmail.com>
 <anot9w6mg9538RWm@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anot9w6mg9538RWm@slm.duckdns.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 10, 2026 at 10:00:55AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Fri, Aug 07, 2026 at 12:37:31PM -0700, Ziyang Men wrote:
> > +__bpf_kfunc struct blkcg *bpf_get_root_blkcg(void)
> > +__bpf_kfunc struct blkcg *bpf_get_blkcg(struct cgroup_subsys_state *css)
> > +__bpf_kfunc void bpf_put_blkcg(struct blkcg *blkcg)
> > +__bpf_kfunc void bpf_blkcg_flush_stats(struct blkcg *blkcg)
> 
> I wonder whether making the above deal with css's would make more sense so
> that we don't end up with per-subsystem iterators. If casting to per-subsys
> type is necessary, we can provide RCU protected cast kfucns.
> 

Hi Tejun, (sorry for asking dumb questions) is the concern you have is that with
the current approach, we will have get_root/get/put kfuncs for each subsystem or
something else? Also how will the current approach leads to per-subsystem
iterators?
