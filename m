Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B287A2D5937;
	Tue, 18 Aug 2026 17:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787073699; cv=none; b=JoL2JsWC2gMKau+9g3f8+4iUoCBt6/cYy06ajrjenZsxr2CXlFXmaNMosXrBrp3pMpzhs9AfarGu2iQv2Z83MYgobH6TF3IKI94WBcqqA28u6Y2jfJ8yo9dvQTmkkPH2nYyE+kYT3Ne0RM/xuAwRXCsPe6ofZYyzJq+bY4L85HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787073699; c=relaxed/simple;
	bh=cFC9S6F2TS8WyV/RTtNYURA/EWXNWWvCFVpcPQO4wgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ME0dbbSOR+Sc2fpd4gt4MuDSZo7q/eGBbTH3XaecLiqr+Tdfc+2uKp5gTx3DCbfu3SNEjO0t7QVmtCfQiF50IQXNet2Ikk4DM2zSjtLd2ICbgIJHDc5neN8Rb47d2EhjeCZa69wEj26JGGf3p49FNSvzipoJb18qfwwYBG0ijG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ObzzZEAm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ObzzZEAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA511F000E9;
	Tue, 18 Aug 2026 17:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787073698;
	bh=s5DqaLQOyk1g4n+z2rMMhuxlOljgDJU8+GEr7IkwEx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ObzzZEAmoeqFNsGCmnYMAnDtxQbSjKPMhQnq45YhDOXyBFwvcW0CRDPCS4G4ZaO8w
	 aE8Mlrb0s51xBE6odWD2j7W7sUnCQp28a22q1P5U2tMDwkd0+602FlByuaFE6GW4AS
	 YPkwtaBWZXbNQFISY6H5yGa7q0fNgbzK1J7UNwx6Ciw0CuNLMAU6iSlB1UkPZfTw9o
	 7YWNIN0MGDfrfNDkJ5b9YQwGV1JLGD3o/QLkWgKMidYtOCLWr1pRhJQbhi1PTM5GiX
	 dSWsbg40UhdrKJtlS2EYpSu3RtUGVZAsLBTf4h2ryMFvLc8rfPg7Kc2qPRFm9eEoN2
	 bNa9t5aBwqQug==
Date: Tue, 18 Aug 2026 07:21:37 -1000
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
Message-ID: <aoSUob1s8WBQ3buO@slm.duckdns.org>
References: <20260817214205.723267-1-ziyang.meme@gmail.com>
 <20260817214205.723267-2-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817214205.723267-2-ziyang.meme@gmail.com>

Hello,

On Mon, Aug 17, 2026 at 02:42:04PM -0700, Ziyang Men wrote:
> +/**
> + * bpf_blkcg_flush_stats - Flush a block cgroup's io statistics
> + * @cgrp: cgroup to flush
> + *
> + * Propagate I/O statistics up the cgroup tree. Root statistics come from
> + * block devices and include all cgroups' I/O.
> + */
> +__bpf_kfunc void bpf_blkcg_flush_stats(struct cgroup *cgrp)

Either @css or @blkcg, probably the latter so that each operation doesn't
have to verify subsys again. I'd make this and the cpu ppatches into a
single series. Add blkcg cast there too.

Thanks.

-- 
tejun
