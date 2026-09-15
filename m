Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A4230146C;
	Tue, 15 Sep 2026 10:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789467716; cv=none; b=rtaPdou+fL74Fvk7gJTTV4uCpSOzzF651yN1wUfiO3bFkeaym6eIYGFPcA/TTcjAsl8HSz10/RVgEMSet+v/Fyv8BYYcjMSBrMDZfaIboOaV/ueIBIwVN6MzFQT3ZM/QL9jVmdvmuvCbgHW1rM6Wc566z82tMY+0duTWnpl7EJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789467716; c=relaxed/simple;
	bh=hf8crpYjeJnwwOsNEbF0Mekxrkj2tylRQn9EriVaRfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXLngXEzE+xjcOzybvuVsgLqIyvRl6br1PPyJldEuI93sk1lUfEDqT5GpcC+x//AvYOl/+pF3oDwsmSpUwr/hnIYYTlJHDRG4uJurlxRL9rzdw6c3f4TEkUJK3pbWgxhF7aHbv1Z64/Jyi8fUQ05tXMPM39xLjCR8SRhO/nqf3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQuaEnvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQuaEnvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E3A1F000FF;
	Tue, 15 Sep 2026 10:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789467715;
	bh=fkiyvcxknqqa2FD78gZjvgffhDSvTiUS9a23EkmipXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cQuaEnvyIVzF1iyxdJAkXqhmxDCZYMNY9j2eYZJ07Mb6eI4uuD6iCsTsS+XpIax5b
	 wX76OJsUvCoHl44rzpGGKNbDUnkQZdxlMma60wLmSTyYPzGIgHgsFm1eUQU//wGMlD
	 XkLaNUmR9cJYUhhJcYebFLcWjw6QOfQ2MYSbJYY0ycp+xgVXdunHq6/e+yfNYiUdxE
	 E6pJrCmbnIC1vM+8lUjIKIleVNO8CY3bc05B66ou/M/Pr3PYwIiSk/KWDfEyynFjl4
	 Cymr2wIIm3yXem2ANvwX2ZqgPbMUlLxxmycHSORHJHSC2b7YT6yQ8S03CF/Yj4r8FR
	 9HL8UnSyELE5A==
Date: Tue, 15 Sep 2026 11:21:53 +0100
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
Message-ID: <aqkavo7OfQdMOpLf@thinkstation>
References: <20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org>
 <20260915001817.101713-1-sj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915001817.101713-1-sj@kernel.org>

On Mon, Sep 14, 2026 at 05:18:17PM -0700, SJ Park wrote:
> Hi Harry,

Hi SJ, thanks for looking into it!

> On Mon, 14 Sep 2026 21:36:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:
> Makes sense to me.

Thanks!

> [...]
> > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > @@ -346,7 +346,16 @@ static int attempt_writeback(const char *cgroup, void *arg)
> >  	 * it can't writeback to swap.
> >  	 */
> >  	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> > -	if (!wb_enabled)
> > +
> > +	/*
> > +	 * When writeback is enabled, memory.reclaim may still fail to reclaim
> > +	 * the requested amount of memory due to a slow swap device.
> > +	 * Ignore -EAGAIN here. The caller determines pass/fail based on the
> > +	 * zswap writeback counter.
> > +	 */
> > +	if (wb_enabled && ret == -EAGAIN)
> > +		ret = 0;
> > +	else if (!wb_enabled)
> >  		ret = (ret == -EAGAIN) ? 0 : -1;
> 
> My humble eyes were unable to easily understand the change.  Is the change
> effectively same to below, and if so, would this be easier to read?
> 
> '''
> @@ -344,10 +344,11 @@ static int attempt_writeback(const char *cgroup, void *arg)
>          * writeback as zswap.max is 1/4 of what was needed when reclaim ran the first time.
>          * If writeback is disabled, memory reclaim will fail as zswap is limited and
>          * it can't writeback to swap.
> +        * Even if writeback is enabled, it could return -EAGAIN due to a slow
> +        * swap device.
>          */
>         ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> -       if (!wb_enabled)
> -               ret = (ret == -EAGAIN) ? 0 : -1;
> +       ret = (ret == -EAGAIN) ? 0 : -1;

Hmm, no. This will mark the test as failed when a write to
memory.reclaim returns zero even when wb_enabled is true.

It's not the same because when wb_enabled == true we consider
ret == 0 or ret == -EAGAIN as success, while with wb_enabled == false
we consider ret == -EAGAIN as success.

Not sure we can reduce that to one line of code.

>  out:
>         free(mem);
> '''

-- 
Cheers,
Harry / Hyeonggon
