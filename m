Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F2B356771;
	Tue, 15 Sep 2026 14:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481999; cv=none; b=aekfohT6A5uvtTortzVAbPLG9V46+YtdzlphbFJie/ruuKl1QH0p8bOsrCcv+R1FIZXUfjXJUBs5aazus5Zf4vWbHxl9RgdtF/HAsCVacJndjM59rAIyAOBZh1SAKQxZ0X5Ixq9ukBQRrNxdT/d/8Nxb46fSE7eLSsE6yHTs5KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481999; c=relaxed/simple;
	bh=+6tvygM2RIk9WU1p/bgGC8tb1HBXX8t7UzpSPaVrj9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cUVNw84CG/8hzZNI72YzqreTPt35/EDiQ8ut9mo1QBRvIDru+k19oJ7EQpYcRNdZxfU099YDk84Q/n2ZFYM7pGFDxnfTA15w/fJOafqlR+YPgWfCSrxxjcQIOOHhRE9XnQz/C1TB2KW6OBdTt6IaaAVDN/X7kEc8c9NmZBksrCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XH97yrql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XH97yrql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CC01F000FF;
	Tue, 15 Sep 2026 14:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789481998;
	bh=QcgTXTTUvI8ONqxc9jbvCeetYEK34ysR8JYdT7Si4YA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XH97yrqlqW9680GKgc4K9WvLNVabunnNtw6rQYsqPH91xIeL7Z7d4PxLbPvUbyv0E
	 ksl92UZaozw0dst3Pt3Poq7XeAd3UcbsuPfVuomLzJS16NQydbeLwM/ahGUgrAICTj
	 +YaWlu0kKSq+05dJlFctlKjThXhPvglEOOAUW9U0eY/MJqIapFOVitZeZXyPcJQfXE
	 sRG9oh6ZKMajnuDxEpI4HWMWQ3VoOYeLrkbCzIJY/lx8OB5FzebLTb4KPY3Pl72Tyv
	 36ef6arjoqZ4RaPZGU7bLlGGms3Ni73RabSv4TAXq/dlJo1CxvK3U1kjniQiTS1zLv
	 L7jSoV84wcUbg==
Date: Tue, 15 Sep 2026 15:19:56 +0100
From: Harry Yoo <harry@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Usama Arif <usamaarif642@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: ignore memory.reclaim -EAGAIN for
 zswap writeback test
Message-ID: <aqlTZR90H-7OuSfD@thinkstation>
References: <aqkavo7OfQdMOpLf@thinkstation>
 <20260915141049.70696-1-sj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915141049.70696-1-sj@kernel.org>

On Tue, Sep 15, 2026 at 07:10:48AM -0700, SJ Park wrote:
> On Tue, 15 Sep 2026 11:21:53 +0100 Harry Yoo <harry@kernel.org> wrote:
> 
> > On Mon, Sep 14, 2026 at 05:18:17PM -0700, SJ Park wrote:
> > > On Mon, 14 Sep 2026 21:36:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:
> > > > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > > > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > > > @@ -346,7 +346,16 @@ static int attempt_writeback(const char *cgroup, void *arg)
> > > >  	 * it can't writeback to swap.
> > > >  	 */
> > > >  	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> > > > -	if (!wb_enabled)
> > > > +
> > > > +	/*
> > > > +	 * When writeback is enabled, memory.reclaim may still fail to reclaim
> > > > +	 * the requested amount of memory due to a slow swap device.
> > > > +	 * Ignore -EAGAIN here. The caller determines pass/fail based on the
> > > > +	 * zswap writeback counter.
> > > > +	 */
> > > > +	if (wb_enabled && ret == -EAGAIN)
> > > > +		ret = 0;
> > > > +	else if (!wb_enabled)
> > > >  		ret = (ret == -EAGAIN) ? 0 : -1;
> > > 
> > > My humble eyes were unable to easily understand the change.  Is the change
> > > effectively same to below, and if so, would this be easier to read?
> > > 
> > > '''
> > > @@ -344,10 +344,11 @@ static int attempt_writeback(const char *cgroup, void *arg)
> > >          * writeback as zswap.max is 1/4 of what was needed when reclaim ran the first time.
> > >          * If writeback is disabled, memory reclaim will fail as zswap is limited and
> > >          * it can't writeback to swap.
> > > +        * Even if writeback is enabled, it could return -EAGAIN due to a slow
> > > +        * swap device.
> > >          */
> > >         ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> > > -       if (!wb_enabled)
> > > -               ret = (ret == -EAGAIN) ? 0 : -1;
> > > +       ret = (ret == -EAGAIN) ? 0 : -1;
> > 
> > Hmm, no. This will mark the test as failed when a write to
> > memory.reclaim returns zero even when wb_enabled is true.
> > 
> > It's not the same because when wb_enabled == true we consider
> > ret == 0 or ret == -EAGAIN as success, while with wb_enabled == false
> > we consider ret == -EAGAIN as success.
> 
> Ah, got it.  You are right.  Sorry for making noise and thank you for kindly
> correcting me.

No worries ;-)
 
> Reviewed-by: SJ Park <sj@kernel.org>

Thanks a lot for reviewing, SJ!

-- 
Cheers,
Harry / Hyeonggon
