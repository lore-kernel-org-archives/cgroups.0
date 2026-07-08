Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1581EB5FD
	for <cgroups@vger.kernel.org>; Wed,  8 Jul 2026 00:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783470708; cv=none; b=q9TojuSiBsw8gNzuvtJqigPNJrv12XEjvpNCdpO35CFBnwyOdxFbPxTxWRKpsnDDH6bIqLj1LRbNVdbRzxP7x00EbzRQLW0Ypj4jNOAv6BcZBP4iCm9ZeaFCfmYFb2mbeRGvuohJZMGoDUGdHk7MGW5Er1kNK/AsIk/5H5o0818=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783470708; c=relaxed/simple;
	bh=1pIEFUpfph2x0b93MBVHNonPuLGE2FMsB57c9Y4celg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h62kHU+PgObWjP6n3E55V8OgS0RDXLyNIOku6h/+b5f6HlFM+0VXN7xBkJ8PKSv1udE0oSTio8UFTFj8cxMoKhwAxFnXLtey/TElhyfqWMGWfas70i8YdYvzfjhcO3vh/MexY5mAbDwCrBjsxoyjNiwgBYYmq8SKmmgJNvdw2q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wZd7chiX; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wZd7chiX"
Date: Tue, 7 Jul 2026 17:31:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783470694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zryoqLpY5XcbZJXngdfeetx+hhc/I/xTEt/aoCxXbTw=;
	b=wZd7chiXqMIHJ5/8OfDPYrJ7LFoLqsDa7aEOq7QpzXPekS3QnHdYiZNSWF1vz8+QF4LbKg
	bWuVsOIsC2ByfC7tQZvhUVEv702FwmStEl9Fl/muJOPeOwG1Wt+KJchE+EGSWO2toNpgOv
	+8rkP1aaO7Fl54Svwvr0VdVVdt6SFSM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Eduard Zingerman <eddyz87@gmail.com>
Cc: Ziyang Men <ziyang.meme@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kernel-team@meta.com, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] selftests/bpf: compare BPF and memory.stat memcg
 stat readers
Message-ID: <ak2Wpk6OnhTyon65@linux.dev>
References: <20260704045617.487664-1-ziyang.meme@gmail.com>
 <bc12730fe6eccde10d36e6544607ae2464357e05.camel@gmail.com>
 <akxW5dzvR9e2CfGq@linux.dev>
 <eccfd9a8dd1af1668e142b9b866194333647b0d5.camel@gmail.com>
 <ak2LXDWoPFSJL2Q9@devvm16600.scu0.facebook.com>
 <bc47c75a00acab57e7fea72612e0f6f089ddecc9.camel@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc47c75a00acab57e7fea72612e0f6f089ddecc9.camel@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 07, 2026 at 04:50:11PM -0700, Eduard Zingerman wrote:
> On Tue, 2026-07-07 at 16:27 -0700, Ziyang Men wrote:
> > But the patch also carries functional value: alongside that comparison, it
> > checks the correctness of the stats the kfuncs return.
> > 
> > Let me first answer the main question -- what these tests add over what we
> > already have -- and then lay out a plan.
> > 
> > First, the static test (memcg_stat_reader) vs the existing cgroup_iter_memcg.
> > 
> > The existing test calls the kfuncs, but for each value it only checks whether it
> > is greater than zero. For example, in prog_tests/cgroup_iter_memcg.c:
> > 
> >      memset(map, 1, len);                    /* dirty some anon */
> >      if (!ASSERT_OK(read_stats(link), "read stats"))
> >              goto cleanup;
> >      ASSERT_GT(memcg_query->nr_anon_mapped, 0, "final anon mapped val");
> > 
> > It never checks the value is actually correct -- i.e. compares it against the
> > value in cgroupfs -- only that it is non-zero.
> > 
> > Besides, it also walks a single cgroup:
> > 
> >      .cgroup.order = BPF_CGROUP_ITER_SELF_ONLY,
> > 
> > and reads only five fields.
> 
> Arguably one of the the cgroup_iter_memcg.c tests can be extended to
> allocate some mem and check if the value is reflected in the stats.
> But there is a line between MM tests and BPF tests.
> All BPF kfuncs except iterator logic itself are thin wrappers on
> top of the existing MM functionality. Hence, I don't think that
> BPF selftests are a place to stress-test these things.

That is actually a good discussion point. Where does such kind of tests (i.e.
testing that bpf based memcg stats read functionality is equivalent to
traditional memcg stats reading). As more subsystems are exposed to bpf, similar
questions would arise more often.

In this particular case, IIUC you want only tests for bpf related code (wrappers
& iterator) to be present in bpf selftests, right?

Personally I don't have strong opinion where this test should live.
Functionality wise as it is testing rstat infra, I think cgroup selftests might
be better home for this.
