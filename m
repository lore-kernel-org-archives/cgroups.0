Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60282C21FD;
	Wed, 19 Aug 2026 20:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787172233; cv=none; b=hNmPP2jRqarOi1425wW8pRZ4UaG7BsYfVXxZeTLkotr49ddsuGV2EEYNSDhokmf152fAv10blYJj9dh/B1HlEFbctr54G4BWkrTRNC8w12DYmSPOel9HjPl4fZLwza+QezegbgiSUvb9H9e0vrX4c+Sy6yjmLqqfmdGpuUBSqZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787172233; c=relaxed/simple;
	bh=Fid7AxH9uI6nvxUFpdzYl7i92YyXJIdOCxhlEymPNPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qWcKftuH2WVZYQL7qiYeXZqsGVXXJiREV1PjXVjheqJk3LsVqEncll4Bh/rVtoqPUYQ6GuvDLdXzvOs0V05ciL5YJI90Lb8kCVU11caWYILklgwl/wsPnunQz7eZgUK1yOZBmU/Qt3fdE40gfr6wfD08bQGZV4kMRYV1PYd2sxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HYfNASxW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYfNASxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BB71F000E9;
	Wed, 19 Aug 2026 20:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787172232;
	bh=9PLl4id7OxDfMv9esI2Tn9DhkQb0PtEscSkhXUWvpuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HYfNASxW583tyR26TIXYW6Vm4HWHwbeqgtgcTYRALVVsnxaLyC2WTlWtZOBv/zRi3
	 CU/We1yx51+muTOGLm1Ohoq7F2UU6m24gM62dwNFHT2bzRH27gxDAqFANaLlbspgtq
	 5F/0/EMuwhwtmC0+MvXsl7SURZjfK/DZv6vj6udq1+Mn9SnN4OWo0skGa0LNaXnmBT
	 Bp7/hE4rJ2uAgarqLPXuG7jpDBGgcfyA6G977Ujk5xxX0cIoEGWSJ6+3kzNB2uTU3G
	 b/WByGAFtjeHNKcL03eJxa1+Ie153RDmcBZizzOfqO8Z0mqP0rVYzhFa1by8On2/qn
	 zXDHVKf5kXSdQ==
Date: Wed, 19 Aug 2026 10:43:51 -1000
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
Message-ID: <aoYVh1ihBH-TWvi3@slm.duckdns.org>
References: <20260817214205.723267-1-ziyang.meme@gmail.com>
 <20260817214205.723267-2-ziyang.meme@gmail.com>
 <aoSUob1s8WBQ3buO@slm.duckdns.org>
 <aoTdQeLZZuRirNHE@devvm16600.scu0.facebook.com>
 <aoTf7u20mo9s6ADj@slm.duckdns.org>
 <aoTkZhQDoaQKpPe3@devvm16600.scu0.facebook.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoTkZhQDoaQKpPe3@devvm16600.scu0.facebook.com>

Hello,

On Tue, Aug 18, 2026 at 04:01:58PM -0700, Ziyang Men wrote:
> On Tue, Aug 18, 2026 at 12:42:54PM -1000, Tejun Heo wrote:
> > On Tue, Aug 18, 2026 at 03:31:29PM -0700, Ziyang Men wrote:
> > > Ok I will add the casts bpf_get_blkcg() and bpf_put_blkcg(), and remove the
> > > check of css->ss in above functoins.
> > 
> > RCU_PROTECTED is probably better than get/put().
> 
> Yes we can make the blkcg* RCU_PROTECTED but then the bpf_blkcg_flush_stats()
> needs to take the @cgroup* since it is SLEEPABLE. Does this work for you?

Do we really need that function? css_rstat_flush() is already exposed and
css can already be obtained, right? blkcg_fill_root_iostat() is just
accessing system-wide bdev stats, which you probably don't need to begin
with or if necessary just access through bdevs.

Thanks.

-- 
tejun
