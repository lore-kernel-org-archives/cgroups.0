Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD86447819
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 23:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788390630; cv=none; b=bwBod0omurX7LfHsyMBFWo8pdwGfKUXOXc/8duwKPKdLmFJF1dnQEO1xnX9aXbKr09SLAOjx72EaZZQ2S4A2lviyW7jlO8Jhaa+UN9Rs1062L/NnHKSS6cjp416eu7N7vbL3yb9bmHuaKK2K8G1pgas6arCO2IS44CNNSp1nBJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788390630; c=relaxed/simple;
	bh=gh0fIpKiPd0DP6/RuTzi5CpiJJOPRkFRWWSg57qcjP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/SIyQz1NOo4R6ujQKyDzIvgXEzEofwxppfqtjWxz5llxB/WKT6EaZ0ZZ9kyeLT6L52NvfLNZdLtzHVJDC+K9MsuUojRyvjHduUkZfmeW+f/l4I95p+aoCp3TeaoXm8AisK+3vIecq8oqa1O3UiptA6/B08hO19gv9vWW9alDmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=en/5X6vr; arc=none smtp.client-ip=95.215.58.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="en/5X6vr"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gh0fIpKiPd0DP6/RuTzi5CpiJJOPRkFRWWSg57qcjP0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788390625; v=1; x=1788995425;
 b=en/5X6vr6xE7rn64i1d5+CS20wAKSL+h+BXjct84mTDa8zt8teFHfihddw50BjJX6/CLniTM
 5sN0eGL2Jtx+Ot+o1YqHc4R+fxcAkRjIGg5zyMZIhWJQefgn7VcBLkhwhJXYj+zHHi0UA/v9xv6
 Vat4WVGuLukfhCDmSNSkUfG0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1b76ea144a7bccf6;
	Wed, 02 Sep 2026 23:10:02 +0000
X-Mizu-Trace-ID: 1b76ea144a7bccf6
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 16:10:01 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: kernel-team@meta.com, Jens Axboe <axboe@kernel.dk>, 
	Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Ben Segall <bsegall@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>, Mykola Lysenko <mykolal@meta.com>, linux-block@vger.kernel.org, 
	bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] cgroup: expose cpu.stat and io.stat to BPF
Message-ID: <apisezhyZe_3vp0x@linux.dev>
References: <20260820211758.3393984-1-ziyang.meme@gmail.com>
 <apX9KtGrmfA7u0zV@devvm16600.scu0.facebook.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apX9KtGrmfA7u0zV@devvm16600.scu0.facebook.com>

On Mon, Aug 31, 2026 at 03:16:10PM -0700, Ziyang Men wrote:
> Hi Reviewers,
> 
> Just want to follow-up on this patch series. Please let me know the possible
> issues and I will fix them.
> 

AI bots have raised real concerns. Please address those and then resubmit.

