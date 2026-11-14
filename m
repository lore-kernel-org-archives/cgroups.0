Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794673152;
	b=HXkr7A2kYfH2ILNP8HsGrtcMHeloJVZkcNEuDax0GavJNfG1aUZsyNiBAHxiDoP5Fh6B
	 29cQbpqnN3+zHIdXFuTXk8mizuDnQD+KLlWQGdFVSS4vIbaOz05UiYG8pvPJAk1qXkb32
	 bnS+5Dx1Qv8P8yX43/DpmtHLzgrKTzZAMWT30RqVtGZjoP8FE/8Uo6R0wq2NvxjO0Erb2
	 atCIySy89rFmb71zOr7oV2hVq+KE7btb81x9HyGp1TYch0VtyFqbWtZ/+SPiSFhHCiy1A
	 7y3mWrIMMVx8fPY85/tERNXe48D8vvozkZNTCgnPK61MCBgLtI1Yz0uZVlLm27dJA6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794673152;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=szGS1CeGbYGPkWuMoRnLaZZO05Fgspcv4JaKgVqioX8=;
	b=hXaVfH+LzSf4Uf0kKo5CVADBt5lOLGOGM+rYPBImTFhFvHa5AHm9INZpKYCyw68F4OZ9
	 MNO6osBoJ4T+ymKhOMfUOR8pSTYVLVAd+57GnHi6WqByhAudma9YZ2EJfqPAlBpTS/JgS
	 81n3wsr4xX0TU9szZJb3CGUYgfRzDEe1CO/iIoN81iIB+MKeT+VStR6POpAjeIS9ogDq2
	 k0fhO8ef6ZZ7l5Qys1F9gK73ZMcxHbNmaEuDqb+u2FkNDTpwttPfLdvBUGuKYt//9pG5f
	 umQrYNp7eCFjzd/w1zCWNIAB+8J94+tZA4BKS3dxEJ6M2JZajoxBVFTSVoaoa1YDVuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jd12V7r+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35350606A334;
	Sat, 14 Nov 2026 16:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jd12V7r+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D811F000C4;
	Sat, 14 Nov 2026 16:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794673152;
	bh=szGS1CeGbYGPkWuMoRnLaZZO05Fgspcv4JaKgVqioX8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Jd12V7r+vrzapn2IZRbFJR/sbCR5TzTLJWCErWJDigzmgTMNu/l29Jb66myp5H/v2
	 ecp1DUFbBgvzJ2mLE7g1ouBu/4glAz4No0HFxfDRU3SyGw4QIBmk2T8YDeySpKS88x
	 x35rMQ+HBMJRIi0l1EqP4twHkC5ttwo+wvRQOt07pLF4KR3//EEBdeubxiKyxdn+SG
	 /nUMhMkBNRBDaIsGkgSTTjS3iK76rU/NYIZHpvYnhtQRc8sZf+ZXHKJ2N6NxX9g0jj
	 kpGNoP9GT0dETMfuBbiIiLE8AKg0xAmTjBHD+QV2bfm8Ng07fF6r4FYz4SrvTy1QXS
	 ZnvGBHME4+Xvw==
Date: Sat, 14 Nov 2026 06:19:10 -1000
Message-ID: <ec53c6d48e537677b488f5d82b3f3f0f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Amery Hung <ameryhung@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/3] bpf, cgroup: Don't wait for cgroup_mutex to read or free cgroup bpf state
In-Reply-To: <20261112172721.440275-1-shakeel.butt@linux.dev>
References: <20261112172721.440275-1-shakeel.butt@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Thu, Nov 12, 2026 at 09:27:12AM -0800, Shakeel Butt wrote:
> In the Meta fleet, BPF_PROG_QUERY callers, link-info readers and the
> cgroup bpf release work often wait minutes for cgroup_mutex. The holder is
> almost always a cgroup mkdir or rmdir stuck on kernfs_rwsem. In one day,
> hung-task reports showed this on 1,075 hosts (query), 94 hosts (link info)
> and 458 hosts (release work).

For the series,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
