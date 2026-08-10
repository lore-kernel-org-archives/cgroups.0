Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3DE39A4DC
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 09:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354970; cv=none; b=MHjIjherZC4fxhZKX+b4xtIRkcejzUAMHzuu569dhvBE2AK3TgfWxnw/0saNNsXSXysSBmEoDQfPW6t54zoHyVjKwMFe9yaiTpf1nAJ5ADgNrATcaDAYZdqs4Whtzk80wUMXc5Brt0byLMl2y+flRy8STiwu+OGy2e1sg/cb+ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354970; c=relaxed/simple;
	bh=pXvOdQwVcRI4o3cSBezn8YOPLrt2oF9EEnHUzSsntt0=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=W2DPgOFSkNfN4mHqvsRxs7c/s4dimZ6aIL1Hf187gjL2n7fN3nxgEuYwyVOqeeRIKrwk6r4B/NWQk2Vbt3+MzDBwTItDMQ4wiXtK4IEtNeljB8YyfenTHHZA9eK1RlxxA5pGJDHBdE1kGFAU26qBpY8knbYv9rGsjMut9kuzN48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U6avpM00; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U6avpM00"
Message-ID: <53467765-7ffa-4da4-9473-2ea770048f96@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786354965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2x97XEkL9/hfiKG5eM3hQ+3kNVvep8/7s1qs1TGOscQ=;
	b=U6avpM00iquNlfSe/eaFZcyMpH7DGnAzt+9E6RsiB++oTPNT7b+sKf3iwGakzmo0VBWDXb
	D4IrkPdKG0WGA5farBEIyqW1NZWZY2XW3+CXsukz8sP0ZD1SZ+rBABtBLoxWrzO66KLaeK
	Cvonv5c0xhi2vpuF2jCYufqxpW7sGV4=
Date: Mon, 10 Aug 2026 17:42:38 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ziyang Men <ziyang.meme@gmail.com>, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] selftests/cgroup: add PSI pressure trigger and
 validation tests
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
References: <20260728083742.2359320-1-cui.tao@linux.dev>
 <anS3saMkFog89yxy@localhost.localdomain>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <anS3saMkFog89yxy@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


Hi Michal,

在 2026/8/7 00:52, Michal Koutný 写道:
> Hi,
> thanks for continuing with this.
> 
Thanks -- though honestly I owe you the thanks. Your v1 review is what
got me to drop the memory-pressure approach and churn_memory(), and to
keep the runner out of the cgroup. v2 basically exists because you took
the time on v1. Still only my second selftests patch, so still feeling
my way around the conventions here (clearly -- see below).
> On Tue, Jul 28, 2026 at 04:37:42PM +0800, Tao Cui <cui.tao@linux.dev> wrote:
>> +/* Trigger smoke test: second on same fd -> EBUSY; IRQ rejects "some". */
>> +static int test_proc_triggers(const char *root)
>> +{
>> +	static const char *const resources[] = { "io", "memory", "cpu" };
>> +	int ret = KSFT_FAIL;
>> +	int fd = -1;
>> +	int i;
>> +
>> +	(void)root;
> 
> WTH?
> 
Yeah, bogus. Dropping the param entirely; details in my reply to Suren.
>> +
>> +	for (i = 0; i < (int)ARRAY_SIZE(resources); i++) {
> 
> This (int) cast is quite uncommon, look around.
> 
Dropping it, size_t loop var.
>> +/* Induce deterministic CPU pressure (more hogs than CPUs). */
>> +static int test_cgroup_trigger_fire(const char *root)
>> +{
>> +	char *cg = NULL, *cpupress = NULL;
>> +	int fd = -1, ret = KSFT_FAIL;
>> +	struct pollfd pfd;
>> +	long ncpus, i;
>> +	pid_t pid;
>> +
>> +	cg = cg_name(root, "psi_trigger_test");
>> +	if (!cg)
>> +		goto cleanup;
>> +	if (cg_create(cg))
>> +		goto cleanup;
>> +
>> +	cpupress = cg_control(cg, "cpu.pressure");
>> +	if (!cpupress)
>> +		goto cleanup;
>> +	fd = open(cpupress, O_RDWR);
>> +	if (fd < 0) {
>> +		ksft_print_msg("open cpu.pressure: %s\n", strerror(errno));
>> +		goto cleanup;
>> +	}
>> +
>> +	/* 1us threshold in a 1s window: any cpu stall fires it. */
>> +	errno = 0;
>> +	if (write_trigger(fd, "some 1 1000000") <= 0) {
>> +		ksft_print_msg("arming trigger failed: %s\n", strerror(errno));
>> +		goto cleanup;
>> +	}
> 
> When I see this, could you increase the window size to 2000000 (so that
> it has potential to run for unprivileged users)?
> 
Yes, "some 1 2000000".
>> +
>> +	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
>> +	if (ncpus <= 0)
>> +		ncpus = 1;
>> +
>> +	pid = fork();
>> +	if (pid < 0) {
>> +		ksft_print_msg("fork: %s\n", strerror(errno));
>> +		goto cleanup;
>> +	}
>> +	if (pid == 0) {
>> +		/* Enter the cgroup, then over-subscribe it with CPU hogs. */
>> +		if (cg_enter_current(cg))
>> +			_exit(KSFT_FAIL);
>> +		for (i = 0; i < ncpus; i++) {
>> +			if (fork() == 0) {
>> +				for (;;)
>> +					asm volatile("" ::: "memory");
>> +				_exit(0);
>> +			}
>> +		}
>> +		for (;;)
>> +			asm volatile("" ::: "memory");	/* child is also a hog */
>> +		_exit(0);
>> +	}
> 
> This part could be replaced with generalized hog_cpus_timed() from
> test_cpu.c (after move to cgroup_util.c).
> 
Agreed it shouldn't be open-coded. One snag though: hog_cpus_timed()
runs for a fixed duration and returns, but here I want hogs that keep
running until the trigger fires and then get killed. So I'll move a
shared helper into cgroup_util.[ch] and call it from both spots, rather
than using hog_cpus_timed() as-is.
>> +int main(int argc, char **argv)
>> +{
>> +	char root[PATH_MAX];
>> +	int mempress_fd;
>> +	int i;
>> +
>> +	(void)argc;
> 
> What's up with this?
> 
Leftover, removed.
>> +
>> +	ksft_print_header();
>> +	ksft_set_plan(ARRAY_SIZE(tests));
>> +
>> +	if (cg_find_unified_root(root, sizeof(root), NULL))
>> +		ksft_exit_skip("cgroup v2 isn't mounted\n");
>> +
>> +	/* PSI must be enabled (CONFIG_PSI=y, not default-disabled). */
>> +	mempress_fd = open("/proc/pressure/memory", O_RDONLY);
>> +	if (mempress_fd < 0)
>> +		ksft_exit_skip("PSI unavailable (CONFIG_PSI=n or psi=0)\n");
>> +	close(mempress_fd);
>> +
>> +	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
>> +		ksft_exit_skip("memory controller isn't available\n");
>> +	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
>> +		if (cg_write(root, "cgroup.subtree_control", "+memory"))
>> +			ksft_exit_skip("failed to enable memory controller\n");
> 
> The memory controller is unnecessary now, right?
> 
Right. v1 leftover, CPU pressure now, so that setup is dead code.
Dropping it.

I'll fold all of this into v3.

Thanks,
Tao
> 
> Regards,
> Michal

