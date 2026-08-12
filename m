Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6572B1922F5;
	Wed, 12 Aug 2026 02:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786502021; cv=none; b=XOAnGfYK4gM1X/9sf6ZkbKWJlE5CLKtBT19nNQ28tCLFYAfoT5xSbykkGs30d9K2i3Ygv5gKX17Wxsj47PbAHz+v5aBNXz0lYn15ieeQkoCvKr3Noum4SMqFksVxQ8MdFH8traF1uZEB0tB8aaf1xKPSQ5oZHGN37rB0PQ2zVao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786502021; c=relaxed/simple;
	bh=I1/vSJ9Qb76ZtUvTgRy1ooNxWqENw3nHX0V5zhE22bY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/ysdBT4K/2VaimEE+xIpPpO7Gu2J/SwsmB+eOvGtbv9DaOhLQoB4CrRNz0dTSwhqYCCiG/tO+DchTRnoJDzm2sSBGRnyKL1LDAaUnUCJz9uEq7t2kNN1UXJeQZ4sWhorex5njBRtSRMQGJ/ni/QZzNA0F8TMpbNqXkRXYtlfqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gm7GedII; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gm7GedII"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 826121516;
	Tue, 11 Aug 2026 19:33:33 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C591E3F86F;
	Tue, 11 Aug 2026 19:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786502017; bh=I1/vSJ9Qb76ZtUvTgRy1ooNxWqENw3nHX0V5zhE22bY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gm7GedIIorUPLyBhPS5niPq93LLVW9k5r2o7AlI1nh61cX3lx3MAKeWKcLIi+UvjN
	 BBUqgn/lI8amZCy1Sr65v8R2dQdUU5qqNYIn7npIAZww206VT0z2W8yu8ZODZsqbYe
	 snbDPrvByhfGPQW1mF3X4RcYLevGcg2uTRARDVLY=
Date: Wed, 12 Aug 2026 08:03:34 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wilson Felipe Pereira <wfelipe@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: test_zswap: skip
 test_no_kmem_bypass if debugfs is unavailable
Message-ID: <253tvq2rhxl4yedcacabve4x333rajpcqvqwlot56ddtvpgrl5@5ifjgjkfgza5>
References: <20260811051434.3805648-1-wfelipe@google.com>
 <20260811190611.c72f19ada3912791a81a7a90@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811190611.c72f19ada3912791a81a7a90@linux-foundation.org>

On Tue, Aug 11, 2026 at 07:06:11PM -0700, Andrew Morton wrote:
> On Tue, 11 Aug 2026 05:14:11 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:
> 
> > test_no_kmem_bypass() needs to read
> > /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> > verify that compressed pages are charged to the memcg.
> > 
> > When running in an environment where debugfs is not mounted or
> > CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> > loop to terminate early and report a false negative (KSFT_FAIL).
> > 
> > Selftests should not fail if debugfs is unavailable, and it should print
> > a message when it is skipped.
> > 
> > While I'm here, also add a warning message if the test is being skipped
> > due to totalram size and make the check for totalram more readable.
> > 
> > ...
> >
> > --- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> > +++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> >
> > ...
> >
> > @@ -570,8 +571,16 @@ static int test_no_kmem_bypass(const char *root)
> >  	/* Read sys info and compute test values accordingly */
> >  	if (sysinfo(&sys_info) != 0)
> >  		return KSFT_FAIL;
> > -	if (sys_info.totalram > 5000000000)
> > +	if (sys_info.totalram > GB(4)) {
> > +		ksft_print_msg(
> > +			"requires less than 4GB total ram, sys_info.totalram: %.1fGB\n",
> > +			(double)sys_info.totalram / GB(1));
> >  		return KSFT_SKIP;
> > +	}
> > +	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
> > +		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
> 
> Super nittynit: "mount debugfs at /sys/kernel/debug" sounds like a
> progress message.  "I just mounted debugfs at ...".  I think the below is
> more clear?
> 
> --- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
> +++ a/tools/testing/selftests/cgroup/test_zswap.c
> @@ -578,7 +578,7 @@ static int test_no_kmem_bypass(const cha
>  		return KSFT_SKIP;
>  	}
>  	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
> -		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
> +		ksft_print_msg("debugfs not mounted at /sys/kernel/debug\n");

This is definitely more accurate.

>  		return KSFT_SKIP;
>  	}
>  	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
> _
> 

I assume you would change this while applying the patch.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
