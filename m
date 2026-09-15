Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3A723BF9F;
	Tue, 15 Sep 2026 00:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789431512; cv=none; b=IiJVkECDCnZN+GYi931cLeCLtUt5gb3CCXhpcmf/4Y7CKX7I7Dd6iJiwIJ4mqCZkPMU8zmHoMxbOPSbqNdcyAVWjzS/z7VjlUCwPfxB45fZXRD+9ge+bGJc86kzCNDHxfo2YjQSz7PidSNcH3qGuFzWTVGWDDzQVmCvl9v/68N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789431512; c=relaxed/simple;
	bh=1iWLtX2o2HTdm6iWk8GEDWCbNPYYwZF3hhc7/8WFZG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBLpPu3nUk7JsJN+2JUMddhdg12bR6VEXRbNVgY1T1Ro2Te5//0kxYQRoBbb6wWlmlHcBLV/SYSOCy/vRGs/tc01AWyNfuTrZ0Lzsz8VFV3HOQC2JglWAs+n7fFnu/Vu7VZlFSBjYO3sswfae0pZwTHGoAZ10U7ce2HUy+S9TJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EAK46F4n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EAK46F4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FB91F000FF;
	Tue, 15 Sep 2026 00:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789431510;
	bh=8OrhICSN8u/RhjpK6xkumMZX+poXmfJW0hRinboZnoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAK46F4nt6bTyLy7tR9VugeUfayb/ObL/wGuJOegFUGF7UWPa6B/vSzVepsai0Pde
	 5vb+fDyUSFzgl6yNF0mFufupUfIHMUhq4QPeJkwEF/X35mjwWfPY7/FN65o6ErQ2Ka
	 lMztQGFBa05j/tCGrQnGW4BZhKZy0Nx6QggkGe5kAWidt77OFvnzYtd/zUtaEsxVPx
	 illCq9AN92R+uxmj1fDIe53EM8EcEKOwvUW5HBCY4tbiCf2M2LnjIKdj+Fl1Y8Ayq8
	 lU86Ka6hH2Svw/ZfHxgyRcY3gPaLF7O2o8SfRcOFt3WsTQSoszitm2uoI4gw+DZx6D
	 3zu/JsBsSOU/Q==
From: SJ Park <sj@kernel.org>
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test
Date: Mon, 14 Sep 2026 17:18:17 -0700
Message-ID: <20260915001817.101713-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Harry,

On Mon, 14 Sep 2026 21:36:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:

> The zswap_writeback_enabled test fails when a write to memory.reclaim
> returns -EAGAIN, which means less than the requested amount was
> reclaimed. attempt_writeback() propagates the -EAGAIN to the caller,
> and the test case is marked as failed even when zswap writeback did
> happen.
> 
> This heavily depends on the performance of the backing swap device.
> Reclaim does not wait for writeback (on cgroup v2), does not count pages
> that are under writeback as reclaimed, and memory.reclaim gives up after
> MAX_RECLAIM_RETRIES passes without making progress. On a slow device
> where reclaim does not make any progress before writeback completes,
> a write to memory.reclaim fails.
> 
> On a VM with zswap enabled, where IO delay was injected via dm-delay,
> the success rate of the zswap writeback test drops dramatically once
> the delay reaches 11 ms: 7% failures at 10 ms and 79% failures at 11 ms,
> n = 100.
> 
> When zswap writeback is enabled, ignore -EAGAIN from memory.reclaim and
> determine pass/fail based on the zswpwb counter because that is what
> zswap_writeback_enabled actually wants to test.
> 
> With this change, the test reliably passes even on a slow swap device
> (tested up to 1000 ms delay). This makes the test resilient against
> the performance of the swap device.

Makes sense to me.

[...]
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -346,7 +346,16 @@ static int attempt_writeback(const char *cgroup, void *arg)
>  	 * it can't writeback to swap.
>  	 */
>  	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> -	if (!wb_enabled)
> +
> +	/*
> +	 * When writeback is enabled, memory.reclaim may still fail to reclaim
> +	 * the requested amount of memory due to a slow swap device.
> +	 * Ignore -EAGAIN here. The caller determines pass/fail based on the
> +	 * zswap writeback counter.
> +	 */
> +	if (wb_enabled && ret == -EAGAIN)
> +		ret = 0;
> +	else if (!wb_enabled)
>  		ret = (ret == -EAGAIN) ? 0 : -1;

My humble eyes were unable to easily understand the change.  Is the change
effectively same to below, and if so, would this be easier to read?

'''
@@ -344,10 +344,11 @@ static int attempt_writeback(const char *cgroup, void *arg)
         * writeback as zswap.max is 1/4 of what was needed when reclaim ran the first time.
         * If writeback is disabled, memory reclaim will fail as zswap is limited and
         * it can't writeback to swap.
+        * Even if writeback is enabled, it could return -EAGAIN due to a slow
+        * swap device.
         */
        ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
-       if (!wb_enabled)
-               ret = (ret == -EAGAIN) ? 0 : -1;
+       ret = (ret == -EAGAIN) ? 0 : -1;

 out:
        free(mem);
'''

Someone might hate the second 'ret' assignment.  But I was unable to make it
look cleaner without introducing a >80 column line.  The file already has
multiple >80 column lines and I don't really mind having a new long line,
though.


Thanks,
SJ

[...]
