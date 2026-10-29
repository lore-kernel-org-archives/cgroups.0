Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793269842;
	b=RmnjcPXzkoeFQz3JyJxS6yBeZ40NDmY42zl7pMszBn6ePkrkjCslYfDmkg2W9xmlPSp1
	 jEFjlUvcQ4D8WgTF8FNRYphrae2SH6mCsj/PFsnUE/iDy0YZO25113ycr0f6voSDX47CY
	 1aWrWH8bQG7hMaEI3gO9g1nCROlt0Q+93JRhvHxl9+aSDrkUg31VO/ykAs/pMgkuiviqn
	 ac75c8LaZ86FNW8yFDcYFiLrCCm8jad4cJ42CdZydvnRICLT4iE9cDGOvSmYM6gHPq5xo
	 GzWGNDTRdOx+I/PVqHuOi+HrrbDaniu9euMhj7783Ti5PNDd/Se7EEn4CtuuhhetKsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793269842;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=giSLGDpNSYIJMqLP2qZuiYCwNonV14bhLRPCEf4xLns=;
	b=aZV/UDgbya55xN6xN/xH/8+ZuJYhvSVSWvHvPc5VfRqzx8NnuycHOSDlK+X21SOZ5170
	 L36XH+/cyKZPpYXH2pnFenhybjIBYNCeIpLxpv8N56jIdxf+j1QMFyUuFLFRV8KF0Mifm
	 6FE6i1bek6e8uQ3f9O8CAewAvMxYP7/SrDZ1UF/lBOhw0TcgEIdNobLTsEMj6TLuT2nPy
	 oOS3ojU3nHKph8eUhWLDsX4GArD18Z+V6g/0e3RPRbEmLpmTSJ15uaRA/a+Z1UW56DnIo
	 2mUG2gzEvP7N2C2oRiZ9FviiU2s1+Q6IVPLNd39TSQqNS7VgjVabVimWT+aVLG5AaHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jrgR7Mjy;
	arc=none smtp.remote-ip=91.218.175.20
Received: from mta0.migadu.com (out-20.mta0.migadu.com [91.218.175.20])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB8D606A31F
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 10:30:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BB8D606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jrgR7Mjy
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rBETPjh7f4oGgIsPGjEmPX6QCVG6xJt6OgxbpYhh3Wo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793269833; v=1; x=1793874633;
 b=jrgR7MjyyAT5L7x2fUlit3g0DEpIOcb1qWLM8Aaw27Fl1queNchzcw+OFLJggkf14D/hMKOV
 5ecI1TbvpxUqkP6vhrpOUUu1AiGIQ342Fmh68dQWBqveFo00ejp743tj/alhBfzH5f9THzz6i8J
 CNdecxdJCk0I1CRVpzT6ybpM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9e1c02ad49984eea;
	Thu, 29 Oct 2026 10:30:30 +0000
X-Mizu-Trace-ID: 9e1c02ad49984eea
X-Migadu-Flow: FLOW_OUT
Message-ID: <049090ed-48f8-4360-91f2-381357a0d40f@linux.dev>
Date: Thu, 29 Oct 2026 18:30:16 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [PATCH 3/5] selftests/bpf: add iocost cost model test
To: Tejun Heo <tj@kernel.org>
References: <20261028143534.135968-1-cui.tao@linux.dev>
 <20261028143534.135968-4-cui.tao@linux.dev>
 <b69d96a507aec382c279d62cfb038fa9@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <b69d96a507aec382c279d62cfb038fa9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Tejun,

在 2026/10/29 04:09, Tejun Heo 写道:
> Hello, Tao.
> 
> On Wed, Oct 28, 2026 at 10:35:32PM +0800, Tao Cui wrote:
>> +static bool iocost_bpf_supported(void)
>> +{
>> +	FILE *f;
>> +	char line[128];
>> +	bool any = false, on = false;
>> ...
>> +		if (strstr(line, "CONFIG_"))
>> +			any = true;
>> ...
>> +	return on;
> 
> any is set but never read, so every test skips without /proc/config.gz.
> 
I'll make the probe return whether CONFIG_BLK_CGROUP_IOCOST_BPF=y was
seen.

>> +	/* isolate the configfs and cgroup mounts from the host */
>> +	if (unshare(CLONE_NEWNS)) {
> 
> unshare(CLONE_NEWNS) alone doesn't make the mounts private, so the
> configfs mount propagates to the host, one more per test.
> 
I'll follow unshare() with mount(NULL, "/", NULL,
MS_REC | MS_PRIVATE, NULL).

>> +	ASSERT_OK(configfs_write("/sys/fs/cgroup/cgroup.subtree_control",
>> +				 "+io"), "subtree_io");
>> +	if (!ASSERT_OK(cgroup_mkdir("/sys/fs/cgroup/iocost_pairing"),
> 
> The "+io" write to the root cgroup's cgroup.subtree_control is never
> reverted, the cgroups are created directly under /sys/fs/cgroup and
> test_progs stays in the root cgroup. cgroup_helpers handles all of this.
> 
I'll restore the "+io" setting on exit and move the test process back
to the root cgroup before removing the test cgroups. I'll also switch
the test over to cgroup_helpers.

>> +	err = iocost_model__attach(skel);
>> +	if (err == -EOPNOTSUPP || err == -ENODEV) {
>> ...
>> +		test__skip();
> 
> -ENODEV and -EOPNOTSUPP from attaching to the test's own null_blk device
> are failures, not skips. The same goes for
> serial_test_iocost_model_streams().
> 
Both become ASSERT_OK failures.
>> +		ASSERT_GT(skel->bss->iocg_inits, 0, "pair_init");
> 
> This passes on the root blkg alone, so it doesn't show that the test
> cgroup got iocg_init(). The same goes for eject_had_inits and
> pair_init_again.
> 
Gone with the callbacks.
>> +		/*
>> +		 * detach implicitly by closing the link fd instead of
>> +		 * calling bpf_link__destroy() explicitly: the release
>> +		 * path must detach the model just like the explicit
>> +		 * call does
>> +		 */
>> +		lfd = bpf_link__fd(skel->links.iocost_2x);
>> +		bpf_link__disconnect(skel->links.iocost_2x);
>> +		close(lfd);
>> +		skel->links.iocost_2x = NULL;
> 
> This leaks libbpf's link struct. The reason in the comment doesn't hold
> either. bpf_link__destroy() on a struct_ops link does the same close().
> 
I'll use bpf_link__destroy() instead.

>> +void serial_test_iocost_model_streams(void)
>> ...
>> +	if (ASSERT_OK(err, "attach")) {
>> +		err = readback_model(dev, model, sizeof(model));
>> +		if (ASSERT_OK(err, "readback"))
>> +			ASSERT_STREQ(model, "bpf", "model_bpf");
>> +
>> +		bpf_link__destroy(skel->links.iocost_ms);
> 
> The test never enables the controller, so iocost_ms's calc_cost() never
> runs. The multi-stream results in the cover letter aren't exercised by
> the test.
> 
I'll enable the controller, move the test into a cgroup, drive IO
through the device, and assert that the model is exercised.

Thanks,
Tao

> Thanks.
> 
> --
> tejun

