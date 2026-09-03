Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D121A3FBEBB
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 07:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788420276; cv=none; b=JdD3OEo23an4J9MeNa0cbMMpV2W+WOk+8+UNbrh0/S16n9GHJrJxEiajZTNIwOHmAjyNzjygkC72vkHjIofPTg+jTm1Z0F58fq3ZnsCYPCiCZWOBDNA0SK5vsU/nRbh2q6yxzzxTkfnxl+1sRp/88KRlUbtPW0T3vBnnBLgM2EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788420276; c=relaxed/simple;
	bh=r8QhVg4LEPyho6UFXtV04Ge/fVZKoV/Xbxq+11f8TQs=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UfYgtLuRVaIQ2gwtiGPV14auVUmzXjxu3Xqb7bEi3Pbpssdj/JuM2mO1hesjSAuzCj/+10VyrA5F0bMYO/kBEADh+fVLYvmKMBNQlFXsfpOnZKiYqm7u9qDqisKXuXC+kFM0DEiEjhttfL5dX2hWYkOfGB4IujSF+k3ELQhLcRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NFI0Hdnx; arc=none smtp.client-ip=91.218.175.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NFI0Hdnx"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=r8QhVg4LEPyho6UFXtV04Ge/fVZKoV/Xbxq+11f8TQs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788420271; v=1; x=1789025071;
 b=NFI0HdnxiU9KfRcPY0j2l3F5vkGx+3y2MkW0wCQghAARcJ/NhXcKf68UVCDWBgvO9vlUJtJ1
 aktHsTFmDG7CnIdW3Gf32nC+RHsu3yqj+6MJJZvaGXPkuV0x0dKFrOPTxD7gKnMfZqI9SNE8ZTw
 ZfesdBTGfWz2hLbFfeQ9ihU0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9d9a0b8d2708cf8b;
	Thu, 03 Sep 2026 07:24:31 +0000
X-Mizu-Trace-ID: 9d9a0b8d2708cf8b
X-Migadu-Flow: FLOW_OUT
Message-ID: <8c816b23-d394-4389-94ab-7fec889b1300@linux.dev>
Date: Thu, 3 Sep 2026 15:24:26 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ziyang Men <ziyang.meme@gmail.com>,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v5] selftests/cgroup: add PSI pressure trigger and
 validation tests
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Suren Baghdasaryan <surenb@google.com>
References: <20260902040725.877155-1-cui.tao@linux.dev>
 <aphkAGKpg3dgFc6c@localhost.localdomain>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <aphkAGKpg3dgFc6c@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Michal, Suren,

在 2026/9/3 02:47, Michal Koutný 写道:
> Hello Tao.
> 
> On Wed, Sep 02, 2026 at 12:07:25PM +0800, Tao Cui <cui.tao@linux.dev> wrote:
>> +/* PSI triggers are written with a trailing NUL the kernel parser expects. */
>> +static ssize_t write_trigger(int fd, const char *trigger)
>> +{
>> +	return write(fd, trigger, strlen(trigger) + 1);
>> +}
> 
> Hyrum's law. It all works for me: NUL, \n or just write(2) the exact
> length of the string.
> For conventionality, I'd prefer the simple literals and plain strlen() +
> 0. (I reckon cg_write() cannot be used because of FD access.)
> 

Your Hyrum's law point made me look at the parser, and I'm glad it
did, because the behavior is more subtle than "all of them work".
psi_write() does

        buf[buf_size - 1] = '\0';

i.e. it overwrites the last byte of whatever was written. With a plain
strlen()-sized write that eats the last digit: "some 150000 2000000"
silently arms a 200000us window when privileged, and fails with EINVAL
for unprivileged users (200000 is not a multiple of the 2s minimum). I
reproduced both on 7.0.0-28 here. I suspect your runs succeeded
because a truncated window still makes a valid trigger for root, so
nothing looked off.

I went with your \n variant instead: the newline gets clobbered, the
payload stays intact, and it is the conventional procfile form. So the
reliance on the undocumented NUL is gone, even though not quite via
strlen()+0.

Two follow-ups this suggests, if there is interest (I'm not pushing
either within this series):

- psi.rst says nothing about the terminator while sysfs documents its
  (append, not clobber) behavior explicitly; a sentence in psi.rst
  would at least make the convention discoverable.
- kernfs and sysfs both append the NUL after the written data, so the
  user bytes survive. psi_write() could do the same with
  buf_size = min(nbytes, sizeof(buf) - 1) and buf[buf_size] = '\0'.
  Terminator-terminated writes keep their exact meaning, and a bare
  strlen() write would parse in full instead of losing its last digit.
  That would be the more principled fix, but it is a behavior change
  for unterminated writes, so it needs a call from the PSI maintainers.

>> +
>> +static int pressure_open(const char *resource)
>> +{
>> +	char path[PATH_MAX];
>> +	int fd;
>> +
>> +	snprintf(path, sizeof(path), "/proc/pressure/%s", resource);
>> +	fd = open(path, O_RDWR);
>> +	if (fd < 0)
>> +		ksft_perror(path);
> 
> This outputs:
> | # /proc/pressure/irq: No such file or directory (2)
> | #      SKIP      /proc/pressure/irq unavailable
> 
> I.e. similar message is printed twice.
> Since strace is a companion of cgroup selftests, I'd keep this helper
> silent.
> 

Agreed, the helper is silent now. The duplicate was my own doing: I
added the print in v5 on Suren's v4 request (it replaced a raw
fprintf) without noticing the SKIP message right below it already
carries the reason, so removing it satisfies both comments.

>> +	return fd;
>> +}
>> +
>> +FIXTURE(psi)
>> +{
>> +	char root[PATH_MAX];
>> +	char *cg;
>> +};
>> +
>> +FIXTURE_SETUP(psi)
>> +{
>> +	int psi_fd;
>> +
>> +	if (cg_find_unified_root(self->root, sizeof(self->root), NULL))
>> +		SKIP(return, "cgroup v2 isn't mounted");
>> +
>> +	/* PSI must be enabled (CONFIG_PSI=y, not disabled on the cmdline). */
>> +	psi_fd = open("/proc/pressure/memory", O_RDONLY);
>> +	if (psi_fd < 0)
>> +		SKIP(return, "PSI unavailable (CONFIG_PSI=n or psi=0)");
>> +	close(psi_fd);
>> +
>> +	self->cg = cg_name(self->root, "psi_trigger_test");
>> +	if (!self->cg)
>> +		SKIP(return, "failed to allocate cgroup name");
>> +	if (cg_create(self->cg))
>> +		SKIP(return, "failed to create cgroup: %s", strerror(errno));
> 
> Why are these two SKIPs (not failures)?
> 

You're right, they are not environment problems. They are ASSERTs in
FIXTURE_SETUP() now, so a run without privileges fails loudly instead
of vanishing into skips.

>> +TEST_F(psi, cgroup_trigger_fire)
>> +{
>> +	char *cpupress;
>> +	struct pollfd pfd = { .events = POLLPRI };
>> +	long ncpus;
>> +	int fd;
>> +	int i;
>> +
>> +	cpupress = cg_control(self->cg, "cpu.pressure");
>> +	ASSERT_NE(NULL, cpupress);
>> +	fd = open(cpupress, O_RDWR);
>> +	free(cpupress);
>> +	ASSERT_GE(fd, 0);
>> +	pfd.fd = fd;
>> +
>> +	/*
>> +	 * 1usec threshold over a 2s window: any CPU stall fires it. The 2s
>> +	 * window is the smallest unprivileged users are allowed to arm.
>> +	 */
>> +	ASSERT_GT(write_trigger(fd, "some 1 2000000"), 0);
> 
> The selftest rarely can be run as unprivileged user (even test cgroup
> creation needs privileges), so this comment is irrelevant. (But it's
> fine to test with that value.)
> 

Dropped.

> On the more abstract level -- I was playing with this and thinking about
> a value that'd test both sides, i.e. false triggers as well as false
> non-triggers. I'd find that to be the half of the window and the number
> of tasks should be then (3*ncpus + 1) / 2.
> Or perhaps test two thresholds, one tiny like you did and one maximum
> (whole window) with same amount tasks but expect trigger, no trigger
> respectively.
> 

I tried both of your variants before picking one. The half-window
threshold with (3*ncpus+1)/2 hogs fired reliably, and the two-threshold
variant also held up on the negative side: with the threshold equal to
the whole window, ncpus+1 hogs never fired it (measured cpu.pressure
"some" stays around 2-17% under that oversubscription, so the margin
is comfortable rather than borderline). I kept the existing tiny-
threshold test and added cgroup_trigger_no_fire for the whole-window
side, which matches your second variant and keeps the hog setup shared.

> 
>> +
>> +	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
>> +	if (ncpus == -1)
>> +		TH_LOG("sysconf(_SC_NPROCESSORS_ONLN): %s", strerror(errno));
>> +	ASSERT_NE(-1, ncpus);
> 
> Same as messages from pressure_open() above. Simply assert.
> 
>> +
>> +	/* ncpus+1 hogs guarantee CPU contention inside the cgroup. */
>> +	for (i = 0; i < ncpus + 1; i++)
>> +		ASSERT_GE(cg_run_nowait(self->cg, hog_cpu, NULL), 0);
>> +
>> +	ASSERT_EQ(1, poll(&pfd, 1, PSI_POLL_TIMEOUT_MS));
>> +	ASSERT_NE(0, pfd.revents & POLLPRI);
>> +	close(fd);
>> +}
>> +
>> +TEST_HARNESS_MAIN
> 
> All in all, this looks so much better than the initial version, well
> done. Just a few polishing touches.
> 

All 7 tests pass on a 2-CPU and a 16-CPU machine.

Thank you both, this series learned a lot from you: Suren walked me
through the harness conversion and the reporting details, and you kept
the semantics honest, which is what surfaced the parser behavior. The
test is in a much better shape than what I started with, and the
parser finding above came out of your push on both directions of the
trigger.

Thanks
Tao

> Michal

