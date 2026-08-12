Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F226B2BD587;
	Wed, 12 Aug 2026 02:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786502758; cv=none; b=kLFYC3BrAnEVQRdmnadv7ua20Ogi/0mom11RjCniWKhVbAQZbCMA1EfESrrkdYLiaDtWtf24Fx9Fh0DEAAKuyj+flGBQlv4oEVGkQTa86H6pqvXg9h6cP/y6RklPyXhVz/8LyE3jNIHzZ4ZFViwAugE2Xm4aEeYgqzWfiNA3UyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786502758; c=relaxed/simple;
	bh=ZS9vPNZPt9dgbe4SvMHOBo9H0AuL8cxw1X3klDOzAxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WT+4Phb+X95ldomjNJPO3wqZScmko8zbX/tvf7ybRMVfkH7ATvHCXCm4qkAZyRogNtT6FVbQ0sUGnJui6MUH1BWo34+JKKzNWBHyvONGGAmehokO7s2rBI8MgNUaJLQfEgULRd0IGhkIYDFJ9rosFb52vqt+j7QPzwJ7WGX7m4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AObcdImc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AObcdImc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E07C1F000E9;
	Wed, 12 Aug 2026 02:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786502756;
	bh=+wN4tIqwkqpx5GNi0C8cNZGttKmLphAMJrFg1BPO7Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AObcdImc7khHLVpGq0Y9RAd14XKdCLpuqYepsxUdNSTw55wqUqKzNH2XBo7ZBtpwU
	 kVQuydSEH6wYUTkAA1yKrz4j4ROh34uG+vq67B6wI0UgI4JovGscNczZUhzSbANhcx
	 Kl6d8pFE9KIlJhdVbYVAsZUlKHxfr1Q4ugawg5zE26HAAQOXaHXxfHn5dDU6nKjPpe
	 yEAEoOzk70KaxTXR3LSCXy7/sWMxuTEMAS+0bsIyGvkb6X84JPkoqmSsqTjuTpQ/4y
	 BHv7Ydh/gKobIMa1i2qWB0oxmhoq/Sw+IG4RQD5+1Qei0pQWs9ClOMReLcrNThdfSH
	 dPNe5Z13Oonyg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tejun Heo <tj@kernel.org>,
	=?ISO-8859-1?Q? Michal_Koutn=FD ?= <mkoutny@suse.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: test_zswap: skip test_no_kmem_bypass if debugfs is unavailable
Date: Tue, 11 Aug 2026 19:45:53 -0700
Message-ID: <20260812024553.8493-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811190611.c72f19ada3912791a81a7a90@linux-foundation.org>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 11 Aug 2026 19:06:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

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

+1.  I was feeling similar.

> 
> --- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
> +++ a/tools/testing/selftests/cgroup/test_zswap.c
> @@ -578,7 +578,7 @@ static int test_no_kmem_bypass(const cha
>  		return KSFT_SKIP;
>  	}
>  	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
> -		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
> +		ksft_print_msg("debugfs not mounted at /sys/kernel/debug\n");

This reads better for me.  I also find this is more consistent to similar skip
messages in main() and check_zswap_enabled().

>  		return KSFT_SKIP;
>  	}
>  	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
> _


Thanks,
SJ
