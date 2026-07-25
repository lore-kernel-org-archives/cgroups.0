Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A441302767
	for <cgroups@vger.kernel.org>; Sat, 25 Jul 2026 16:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784998153; cv=none; b=J8rHZt15yhHFCTSNPSEVv5aveFMZA6TcwjBGoXSjR6CdfL4OpI8ABFXZPhMPWOLcBIug6dM3y5VUQy8YhBHom5xfdiB81mzb/l/9ihxaBnfNbFJyg4GAPfWv7X2U7mlT+RQK1X1Svk1oqicAnIF/BEBY2owJp6CB6CpIkFOFbtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784998153; c=relaxed/simple;
	bh=ouBSfvzGDX/MnLuTg2wAWyc7mq1WLSPm70FpAIxhuZA=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=shugNNobxoSanefGDDus06hp45sYUQUat0BG1CxWT1Y8LDFsXS2PyaMpQbPB9Sn6le3xBrQu76XjNYaql4jHd3Osqk8F2VzTQWVGivQVicbGiRr+hsPCnuFyUX36oQ5QLrthS+QMYSveJacchZLOaFOPNqH7hDui2wXqRbTZTak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j02k00u9; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j02k00u9"
Message-ID: <a950d6de-5e36-4ba9-9935-692fd76bcf26@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784998139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=osUz5NvaT3FGAs32mY/lYpwGWCNa9YNVwmNpNNFj7Ds=;
	b=j02k00u9qlT7r2ki9rvmzywcNePRMabG8tJmiyqpztDKtWJKgaVks7d0YdnCXp94Tv8B6q
	sdM+77R7HIK1jQTdp35BOVpmRN1C2/HW4PVfeYY3bE32pvOtziGoK+goc4Zea0tn6aXjrP
	nbRSAFHsuaEWZGaKhDpOb1P43gcD+AY=
Date: Sun, 26 Jul 2026 00:48:48 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, Ziyang Men <ziyang.meme@gmail.com>
Subject: Re: [PATCH] selftests/cgroup: add PSI pressure trigger and validation
 tests
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
References: <20260724025826.504586-1-cui.tao@linux.dev>
 <amMp5Dh4iC4Kol-I@localhost.localdomain>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <amMp5Dh4iC4Kol-I@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Michal,

Good to hear from you, and thanks for taking the time to go through this
in detail -- it's genuinely helpful.

在 2026/7/24 17:40, Michal Koutný 写道:
> Hi.
> 
> On Fri, Jul 24, 2026 at 10:58:26AM +0800, Tao Cui <cui.tao@linux.dev> wrote:
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> The cgroup selftest suite had no PSI coverage at all. Add test_psi.c:
>>
>>   - /proc/pressure/{cpu,memory,io} trigger validation: a second trigger
>>     on the same fd fails EBUSY; out-of-range window/threshold and
>>     unparseable input fail EINVAL; "some" on /proc/pressure/irq fails
>>     EINVAL (skipped when the file is absent).
> 
> If you want to test each and every returned error code, I'd suggest you
> try adding this to LTP [1]. However, in general I don't think it's a
> good idea to ossify the APIs with so strict tests.
> The point of these selftests is for developers to have some quick
> smoketests verifying that the functional concepts don't get broken while
> having simple tests that are easy to maintain.
> 
Yeah, fair point -- I got a bit carried away enumerating errnos. I'll
keep just the functional checks (one trigger per fd, irq has no "some").
> 
>>   - cgroup.pressure toggle: disabling hides *.pressure files and
>>     round-trips; out-of-range input fails ERANGE, non-numeric EINVAL.
> 
> This is a good test IMO, except for the too constrained range checking.
> 
Noted, I'll loosen that up.
> 
>>   - best-effort positive test: arm a sensitive memory.pressure trigger
>>     under a tight memory.max, churn memory to induce a stall and expect
>>     poll() to wake (SKIP if no stall can be induced).
> 
> If you want to test the trigger, it might be better to pick a different
> resource than memory (also why you sometimes cover all resource with
> tests and sometimes pick only memory?), cpu pressure can be in my
> experience (and in theory) induced much more predictably.
> 
> Also if you stick to memory & SKIP, could be expand on the reasons
> behind selection of PSI_POLL_TIMEOUT_MS and the proportion of skip vs
> pass results?
> 
That's a much better idea, thanks -- I'll switch to CPU pressure (more
tasks than CPUs), which should make it deterministic and drop the SKIP,
and clears up only touching memory here. I'll also rework the harness so
the child enters the constrained cgroup rather than the parent, following
test_memcontrol.c's cg_run(), and cap memory.swap.max so the child can't
thrash and the parent's waitpid can't hang (the sashiko points there).
> 
> 
>> +/* Touch every page to force allocation under a tight memory.max. */
>> +static void churn_memory(size_t size)
>> +{
>> +	char *p = mmap(NULL, size, PROT_READ | PROT_WRITE,
>> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>> +	int iter;
>> +
>> +	if (p == MAP_FAILED)
>> +		return;
>> +	for (iter = 0; iter < 5; iter++) {
>> +		size_t i;
>> +
>> +		for (i = 0; i < size; i += 4096)
> 
> This would ideally be sysconf(_SC_PAGE_SIZE) (see test_memcontrol.c).
> Generally, this looks like something to extract and share across tests,
> also check [2].
> 
> (But as I wrote above, memory is not a good resource to predictable
> behavior of PSI triggers.)
> 
Good catch on the hardcoded 4096 -- I'll use sysconf(_SC_PAGE_SIZE),
matching test_memcontrol.c, and see whether the page-touch helper is
worth sharing across the cgroup tests.

>> +int main(int argc, char **argv)
>> +{
>> +	char root[PATH_MAX];
>> +	int i;
>> +
>> +	(void)argc;
>> +
>> +	ksft_print_header();
>> +	ksft_set_plan(ARRAY_SIZE(tests));
>> +
>> +	if (cg_find_unified_root(root, sizeof(root), NULL))
>> +		ksft_exit_skip("cgroup v2 isn't mounted\n");
>> +	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
>> +		ksft_exit_skip("memory controller isn't available\n");
>> +	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
>> +		if (cg_write(root, "cgroup.subtree_control", "+memory"))
>> +			ksft_exit_skip("failed to enable memory controller\n");
> 
> Here'd be good some skip-guards so that the test doesn't fail on
> CONFIG_PSI=n or CONFIG_PSI_DEFAULT_DISABLED=y kernels.
> 
> Similar for the IRQ test and CONFIG_IRQ_TIME_ACCOUNTING
> (which additionally would be IMO more uniform to have the IRQ test
> together with others and just skip the "some" part).
> 
Makes sense -- I'll add the skip-guards (PSI disabled,
IRQ_TIME_ACCOUNTING) and fold irq into the per-resource loop, skipping
only "some".

On the sashiko follow-up: agreed on adding test_psi to .gitignore. The
buf flags are only reached on a cg_read() failure path, so harmless in
practice, but I'll zero-initialize the buffers to be clean.

I'll put together a v2 with all of the above. 

Thanks again!

--
Tao

> Thanks,
> Michal

