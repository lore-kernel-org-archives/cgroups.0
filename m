Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B86367B6F;
	Tue, 15 Sep 2026 14:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481458; cv=none; b=Dt2m3xPwWrs43/V+a0Kbf1gAY2spKZR43UyUnAAgpHZ15wZ7TNzXHAAcKUSLeic3fG/JKRYUiK66AJ384mHGcV91nuoeSQPZ8KDoHkPxqshauajsSnjR6oYYLWoqIUhJJdjOFY74Wy3o06WeIbxPRfM3PI/mFpHlNL49T9neD+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481458; c=relaxed/simple;
	bh=WgbaSjwYxvFVTQ4/3kyH9BX4CGx7OxX5Tfp0LUYeq+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lmhb3Uc1jGk6+Hvr9RLRBuJSinnkR6wCR4ls7DOc+ZSaCPS2mTLGHzXm63d4eMAe/1oy/bCwbB45S0WUYXNSV2M5m+fJbdNXUTemp5Omqv1ZN1mlzGBrYx073x91VOU+B/cksLV5ify9csgFUut8IiXNJl4UsQMHGT2jiG66xxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EtH4RCPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EtH4RCPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D071F000FF;
	Tue, 15 Sep 2026 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789481456;
	bh=aHSbmDD3j9xRZ2iJWMGKJ3aguz1fvqB4sLYlzipxP8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtH4RCPAGt8eG3YAeogfbeH4uqJlSWBkDjNf+0ldGQu2sW+ZDSssoW4DVtN8vXsci
	 0TuCYsbHtG0qtsbUZ5LwHtsJ18k/2dBxrJ9MdBXSZHMMZkYpQ5GJJdxc02a+OPMnse
	 e/X2awvw8y6cF12of+7uXMUcE5LsKFhd93XayEtx7fbHboYqBBffGlhkiHf046JwaR
	 n4hz1yqShHSRqdhqsYMKRjR3m2e2SNsNwdsoZumtQu5sXdEWz1ctbIzkqMbfI5iGRf
	 N/FPnYieXVGG58iZ66mMQ3krFQbnFHevuJZ3ZNdGXQ+2eG4X4PU472jaMx8leAFmjl
	 I9mblwyJgh4SA==
From: SJ Park <sj@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test
Date: Tue, 15 Sep 2026 07:10:48 -0700
Message-ID: <20260915141049.70696-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aqkavo7OfQdMOpLf@thinkstation>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 15 Sep 2026 11:21:53 +0100 Harry Yoo <harry@kernel.org> wrote:

> On Mon, Sep 14, 2026 at 05:18:17PM -0700, SJ Park wrote:
> > Hi Harry,
> 
> Hi SJ, thanks for looking into it!
> 
> > On Mon, 14 Sep 2026 21:36:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:
> > Makes sense to me.
> 
> Thanks!
> 
> > [...]
> > > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > > @@ -346,7 +346,16 @@ static int attempt_writeback(const char *cgroup, void *arg)
> > >  	 * it can't writeback to swap.
> > >  	 */
> > >  	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> > > -	if (!wb_enabled)
> > > +
> > > +	/*
> > > +	 * When writeback is enabled, memory.reclaim may still fail to reclaim
> > > +	 * the requested amount of memory due to a slow swap device.
> > > +	 * Ignore -EAGAIN here. The caller determines pass/fail based on the
> > > +	 * zswap writeback counter.
> > > +	 */
> > > +	if (wb_enabled && ret == -EAGAIN)
> > > +		ret = 0;
> > > +	else if (!wb_enabled)
> > >  		ret = (ret == -EAGAIN) ? 0 : -1;
> > 
> > My humble eyes were unable to easily understand the change.  Is the change
> > effectively same to below, and if so, would this be easier to read?
> > 
> > '''
> > @@ -344,10 +344,11 @@ static int attempt_writeback(const char *cgroup, void *arg)
> >          * writeback as zswap.max is 1/4 of what was needed when reclaim ran the first time.
> >          * If writeback is disabled, memory reclaim will fail as zswap is limited and
> >          * it can't writeback to swap.
> > +        * Even if writeback is enabled, it could return -EAGAIN due to a slow
> > +        * swap device.
> >          */
> >         ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> > -       if (!wb_enabled)
> > -               ret = (ret == -EAGAIN) ? 0 : -1;
> > +       ret = (ret == -EAGAIN) ? 0 : -1;
> 
> Hmm, no. This will mark the test as failed when a write to
> memory.reclaim returns zero even when wb_enabled is true.
> 
> It's not the same because when wb_enabled == true we consider
> ret == 0 or ret == -EAGAIN as success, while with wb_enabled == false
> we consider ret == -EAGAIN as success.

Ah, got it.  You are right.  Sorry for making noise and thank you for kindly
correcting me.

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
