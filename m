Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE9638E126
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 09:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786353806; cv=none; b=CyB2/SG8XF1+9xMokgIRA5ZNzS8qI2BRjdoDYDFKOfQRfSi943VzitCDpquD1N08fmptXr5I6pVAF3iT4s4ZC2vMcy/Humn9hdNfN0oZPjWgoHbF9n4z3Djxbjuz6zSGb57octxGJv6kOgE/othSKZcUK+6Rr/hm6bRi1ZYO4G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786353806; c=relaxed/simple;
	bh=6JozLynXfbtk8MfqIw+r6O8oaMH3/b+R5rLRcwfirMY=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NfLgXIO+ThFNoAH/r4fUjKBp9lgE5Vhfk2bwyo4iarMvu/FDxGaNOLooK+sbCH48WjFNuBx94qnifLHik/60QjARxh0zdBlmeOSQX+Q6f+jKNm/8LnAqpfExgGg2c6NVZL2xajkfOBcRVYdLYfbYiKtTtWQION5vkPJTDN0lQAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jkZDhuIE; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jkZDhuIE"
Message-ID: <3be22b35-e256-48e9-8992-8b047e0ff5e6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786353791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lV4C0VmtRF+IYs2aKzucAqYcuMqaArySurhAE75oWR8=;
	b=jkZDhuIE20QCf6P0ybVC1JBs3Yda3cx79OXRuT26vGW1TDLD9iu1b8PCvoYA11GJxNVeAP
	lFhfXm2wI4iK83sRio06lgPeJjieiYlCbgcsF1otwZkDm2puZayrXrk2BNdvMOe4r+1DbA
	Adn3pCrqcIFoSMROX5nAT3N/PXc0dF8=
Date: Mon, 10 Aug 2026 17:22:58 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ziyang Men <ziyang.meme@gmail.com>, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] selftests/cgroup: add PSI pressure trigger and
 validation tests
To: Suren Baghdasaryan <surenb@google.com>
References: <20260728083742.2359320-1-cui.tao@linux.dev>
 <CAJuCfpHyX5BP88Fk1dOY3F=vk-Me3D-8vF=Dv_Uh17TnaphBhw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <CAJuCfpHyX5BP88Fk1dOY3F=vk-Me3D-8vF=Dv_Uh17TnaphBhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


Hi Suren,

Thanks for the review.

Yeah, you called the "AI glitch" correctly. This is only my second
selftests patch and I ran it through an AI assistant for "polishing"
before sending -- that's where the (void)root, the errno = 0 lines, and
the (int)ARRAY_SIZE cast came from. None of it belongs here and I
should've caught it before sending.

在 2026/8/9 11:44, Suren Baghdasaryan 写道:
> On Tue, Jul 28, 2026 at 1:38 AM Tao Cui <cui.tao@linux.dev> wrote:
>>
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> The cgroup selftests have no PSI coverage. Add test_psi.c: trigger
>> smoke tests (one per fd, IRQ full-only), cgroup.pressure toggle, and a
>> CPU-pressure trigger test using over-subscription. Skips when PSI is
>> disabled or a resource is absent.
>>
>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>> ---
>> Changes since v1 (Michal Koutny, sashiko review):
>> - Trim errno checks to smoke level; loosen toggle range checks.
>> - Switch trigger test from memory to CPU pressure (deterministic, no SKIP).
>> - churn_memory() removed -- sysconf/shared-helper point is moot.
>> - Runner stays out of the cgroup; hogs reaped via cg_killall().
>> - Add PSI/IRQ skip-guards, zero-init buffers, .gitignore entry.
>> ---
>>  tools/testing/selftests/cgroup/.gitignore |   1 +
>>  tools/testing/selftests/cgroup/Makefile   |   2 +
>>  tools/testing/selftests/cgroup/config     |   1 +
>>  tools/testing/selftests/cgroup/test_psi.c | 280 ++++++++++++++++++++++
>>  4 files changed, 284 insertions(+)
>>  create mode 100644 tools/testing/selftests/cgroup/test_psi.c
>>
>> diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
>> index 952e4448bf07..ce2b907c57ea 100644
>> --- a/tools/testing/selftests/cgroup/.gitignore
>> +++ b/tools/testing/selftests/cgroup/.gitignore
>> @@ -8,5 +8,6 @@ test_kill
>>  test_kmem
>>  test_memcontrol
>>  test_pids
>> +test_psi
>>  test_zswap
>>  wait_inotify
>> diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
>> index e01584c2189a..a8c69e37332a 100644
>> --- a/tools/testing/selftests/cgroup/Makefile
>> +++ b/tools/testing/selftests/cgroup/Makefile
>> @@ -16,6 +16,7 @@ TEST_GEN_PROGS += test_kill
>>  TEST_GEN_PROGS += test_kmem
>>  TEST_GEN_PROGS += test_memcontrol
>>  TEST_GEN_PROGS += test_pids
>> +TEST_GEN_PROGS += test_psi
>>  TEST_GEN_PROGS += test_zswap
>>
>>  LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
>> @@ -32,4 +33,5 @@ $(OUTPUT)/test_kill: $(LIBCGROUP_O)
>>  $(OUTPUT)/test_kmem: $(LIBCGROUP_O)
>>  $(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
>>  $(OUTPUT)/test_pids: $(LIBCGROUP_O)
>> +$(OUTPUT)/test_psi: $(LIBCGROUP_O)
>>  $(OUTPUT)/test_zswap: $(LIBCGROUP_O)
>> diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
>> index 39f979690dd3..8a3ef479e83d 100644
>> --- a/tools/testing/selftests/cgroup/config
>> +++ b/tools/testing/selftests/cgroup/config
>> @@ -4,3 +4,4 @@ CONFIG_CGROUP_FREEZER=y
>>  CONFIG_CGROUP_SCHED=y
>>  CONFIG_MEMCG=y
>>  CONFIG_PAGE_COUNTER=y
>> +CONFIG_PSI=y
>> diff --git a/tools/testing/selftests/cgroup/test_psi.c b/tools/testing/selftests/cgroup/test_psi.c
>> new file mode 100644
>> index 000000000000..51dc35e26013
>> --- /dev/null
>> +++ b/tools/testing/selftests/cgroup/test_psi.c
>> @@ -0,0 +1,280 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#define _GNU_SOURCE
>> +#include <errno.h>
>> +#include <fcntl.h>
>> +#include <poll.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <sys/wait.h>
>> +#include <unistd.h>
>> +#include <linux/limits.h>
>> +
>> +#include "kselftest.h"
>> +#include "cgroup_util.h"
>> +
>> +/* How long to wait for the CPU-pressure trigger before giving up. */
>> +#define PSI_POLL_TIMEOUT_MS    5000
>> +
>> +static int pressure_open(const char *resource)
>> +{
>> +       char path[PATH_MAX];
>> +
>> +       snprintf(path, sizeof(path), "/proc/pressure/%s", resource);
>> +       return open(path, O_RDWR);
>> +}
>> +
>> +/* Write a trigger descriptor, including the trailing NUL the parser expects. */
>> +static ssize_t write_trigger(int fd, const char *trigger)
>> +{
>> +       return write(fd, trigger, strlen(trigger) + 1);
>> +}
>> +
>> +/* Trigger smoke test: second on same fd -> EBUSY; IRQ rejects "some". */
> 
> Please write more descriptive comments for your tests. I have to guess
> what you mean by this.
> 
Yeah, those are too cryptic. I'll spell out what each case is actually
exercising instead of just the expected result.
>> +static int test_proc_triggers(const char *root)
> 
> Why do you pass root here if you are not using it? AI glitch?
> 
Dropping the param entirely. The proc-trigger cases don't need a cgroup,
so they shouldn't take one (this also ties into the split below).
>> +{
>> +       static const char *const resources[] = { "io", "memory", "cpu" };
>> +       int ret = KSFT_FAIL;
>> +       int fd = -1;
>> +       int i;
>> +
>> +       (void)root;
>> +
>> +       for (i = 0; i < (int)ARRAY_SIZE(resources); i++) {
>> +               fd = pressure_open(resources[i]);
>> +               if (fd < 0) {
>> +                       ksft_print_msg("open /proc/pressure/%s: %s\n",
>> +                                      resources[i], strerror(errno));
> 
> You could move these ksft_print_msg() into pressure_open() and make
> that function a bit more useful while making the code here simpler.
> 
Will do, folding the error printing in there.
>> +                       goto cleanup;
>> +               }
>> +
>> +               errno = 0;
> 
> Why are you resetting the errno? If the next syscall fails, it will
> reset the errno and if it succeeds, you won't be using errno anyway.
> I'm confused.
> 
No good reason -- removing. I'll only read errno right after a failed
call.
>> +               if (write_trigger(fd, "some 150000 2000000") <= 0) {
>> +                       ksft_print_msg("%s: 'some' trigger rejected: %s\n",
>> +                                      resources[i], strerror(errno));
>> +                       goto cleanup;
>> +               }
>> +               /* A second trigger on the same fd must fail with EBUSY. */
>> +               errno = 0;
>> +               if (write_trigger(fd, "full 150000 2000000") != -1 || errno != EBUSY) {
>> +                       ksft_print_msg("%s: second trigger expected EBUSY, got %s\n",
>> +                                      resources[i], strerror(errno));
>> +                       goto cleanup;
>> +               }
>> +
>> +               close(fd);
>> +               fd = -1;
> 
> When you jump to cleanup label you always need to close the fd. You
> could simplify the flow if you remove all these "fd = -1;" and change
> the end of the function to be:
> 
>         return KSFT_PASS
> cleanup:
>         close(fd);
>         return ret;
> }
> 
Right, that's just noise. Single close(fd) in cleanup.
>> +       }
>> +
>> +       /* IRQ is full-only, and only exists with CONFIG_IRQ_TIME_ACCOUNTING. */
> 
> It would be better if you split this test into separate tests for
> "io", "memory", "cpu" and "irq" and if "irq" is not available you can
> return KSFT_SKIP for that test only. This way when a test fails the
> user will know exactly what failed.
> 
Agreed, splitting them. irq will KSFT_SKIP when /proc/pressure/irq
isn't there.
>> +       fd = pressure_open("irq");
>> +       if (fd >= 0) {
>> +               errno = 0;
>> +               if (write_trigger(fd, "some 150000 1000000") != -1) {
>> +                       ksft_print_msg("irq 'some': expected failure, got %s\n",
>> +                                      strerror(errno));
>> +                       goto cleanup;
>> +               }
>> +               close(fd);
>> +               fd = -1;
>> +       }
>> +
>> +       ret = KSFT_PASS;
>> +cleanup:
>> +       if (fd >= 0)
>> +               close(fd);
>> +       return ret;
>> +}
>> +
>> +/* cgroup.pressure 0/1 hides/shows the *.pressure files and round-trips. */
> 
> The above comment needs to be expanded to explain what you are
> testing. It does not read as a proper English sentence.
> 
Rewriting it as an actual sentence.
>> +static int test_cgroup_pressure_toggle(const char *root)
>> +{
>> +       char buf[BUF_SIZE] = { 0 };
>> +       char *cg = NULL;
>> +       int ret = KSFT_FAIL;
>> +
>> +       cg = cg_name(root, "psi_toggle_test");
>> +       if (!cg)
>> +               goto cleanup;
>> +       if (cg_create(cg))
>> +               goto cleanup;
> 
> Jumping to "cleanup" above results in a call to cg_destroy() while
> cg_create() failed. It will try to rmdir() a directory which we never
> created.
> 
that's a real bug. Adding a "created" flag so we don't tear
down a cgroup that was never set up.
>> +
>> +       if (cg_write(cg, "cgroup.pressure", "0")) {
>> +               ksft_print_msg("failed to disable cgroup.pressure\n");
> 
> Reporting strerror() in these failure logs would be useful.
> 
Adding it to the cg_write/cg_read paths.
>> +               goto cleanup;
>> +       }
>> +       if (cg_read(cg, "cgroup.pressure", buf, sizeof(buf)) < 0 || atoi(buf) != 0) {
> 
> atoi() will return 0 even on error, so if you want to really check the
> value is 0 use a more robust method like strtol() or simply do a
> string comparison.
> 
Right, atoi is wrong here. String compare instead.
>> +               ksft_print_msg("cgroup.pressure=0 readback: '%s'\n", buf);
>> +               goto cleanup;
>> +       }
>> +       if (cg_read(cg, "memory.pressure", buf, sizeof(buf)) >= 0) {
>> +               ksft_print_msg("memory.pressure visible while disabled\n");
>> +               goto cleanup;
>> +       }
>> +
>> +       if (cg_write(cg, "cgroup.pressure", "1")) {
>> +               ksft_print_msg("failed to re-enable cgroup.pressure\n");
>> +               goto cleanup;
>> +       }
>> +       if (cg_read(cg, "cgroup.pressure", buf, sizeof(buf)) < 0 || atoi(buf) != 1) {
>> +               ksft_print_msg("cgroup.pressure=1 readback: '%s'\n", buf);
>> +               goto cleanup;
>> +       }
>> +       if (cg_read(cg, "memory.pressure", buf, sizeof(buf)) < 0) {
>> +               ksft_print_msg("memory.pressure unreadable while enabled\n");
>> +               goto cleanup;
>> +       }
>> +
>> +       ret = KSFT_PASS;
>> +cleanup:
>> +       if (cg)
>> +               cg_destroy(cg);
>> +       free(cg);
> 
> free(NULL) works but would be cleaner to do this instead:
> 
>       if (cg) {
>               cg_destroy(cg);
>               free(cg);
>       }
> 
ok, collapsing those.
>> +       return ret;
>> +}
>> +
>> +/* Induce deterministic CPU pressure (more hogs than CPUs). */
>> +static int test_cgroup_trigger_fire(const char *root)
>> +{
>> +       char *cg = NULL, *cpupress = NULL;
>> +       int fd = -1, ret = KSFT_FAIL;
>> +       struct pollfd pfd;
>> +       long ncpus, i;
>> +       pid_t pid;
>> +
>> +       cg = cg_name(root, "psi_trigger_test");
>> +       if (!cg)
>> +               goto cleanup;
>> +       if (cg_create(cg))
>> +               goto cleanup;
> 
> Same issue with this jump. You will be calling cg_killall(cg) and
> cg_destroy(cg) even though cg_create() did not succeed.
Same created-flag fix.
> 
>> +
>> +       cpupress = cg_control(cg, "cpu.pressure");
>> +       if (!cpupress)
>> +               goto cleanup;
>> +       fd = open(cpupress, O_RDWR);
>> +       if (fd < 0) {
>> +               ksft_print_msg("open cpu.pressure: %s\n", strerror(errno));
>> +               goto cleanup;
>> +       }
>> +
>> +       /* 1us threshold in a 1s window: any cpu stall fires it. */
>> +       errno = 0;
>> +       if (write_trigger(fd, "some 1 1000000") <= 0) {
>> +               ksft_print_msg("arming trigger failed: %s\n", strerror(errno));
>> +               goto cleanup;
>> +       }
>> +
>> +       ncpus = sysconf(_SC_NPROCESSORS_ONLN);
>> +       if (ncpus <= 0)
> 
> Why is this not treated as a test failure?
> 
Yeah, making sysconf() <= 0 a KSFT_FAIL.
>> +               ncpus = 1;
>> +
>> +       pid = fork();
>> +       if (pid < 0) {
>> +               ksft_print_msg("fork: %s\n", strerror(errno));
>> +               goto cleanup;
>> +       }
>> +       if (pid == 0) {
>> +               /* Enter the cgroup, then over-subscribe it with CPU hogs. */
>> +               if (cg_enter_current(cg))
>> +                       _exit(KSFT_FAIL);
>> +               for (i = 0; i < ncpus; i++) {
>> +                       if (fork() == 0) {
>> +                               for (;;)
>> +                                       asm volatile("" ::: "memory");
>> +                               _exit(0);
>> +                       }
>> +               }
>> +               for (;;)
>> +                       asm volatile("" ::: "memory");  /* child is also a hog */
>> +               _exit(0);
>> +       }
>> +
>> +       pfd.fd = fd;
>> +       pfd.events = POLLPRI;
>> +       switch (poll(&pfd, 1, PSI_POLL_TIMEOUT_MS)) {
>> +       case -1:
>> +               ksft_print_msg("poll: %s\n", strerror(errno));
>> +               break;
>> +       case 0:
>> +               ksft_print_msg("no trigger event; could not induce cpu pressure\n");
>> +               ret = KSFT_SKIP;
>> +               break;
>> +       default:
>> +               if (pfd.revents & POLLPRI)
>> +                       ret = KSFT_PASS;
>> +               else
>> +                       ksft_print_msg("poll returned 0x%x\n", pfd.revents);
>> +               break;
>> +       }
>> +
>> +       /* Stop the hogs (bounded, so waitpid can't hang) and reap the child. */
>> +       cg_killall(cg);
>> +       waitpid(pid, NULL, 0);
>> +
>> +cleanup:
>> +       if (fd >= 0)
>> +               close(fd);
>> +       if (cg) {
>> +               cg_killall(cg);
>> +               cg_destroy(cg);
>> +       }
>> +       free(cpupress);
>> +       free(cg);
>> +       return ret;
>> +}
>> +
>> +#define TEST(x) { #x, x }
>> +
>> +struct psi_test {
>> +       const char *name;
>> +       int (*fn)(const char *root);
>> +};
>> +
>> +static struct psi_test tests[] = {
>> +       TEST(test_proc_triggers),
>> +       TEST(test_cgroup_pressure_toggle),
>> +       TEST(test_cgroup_trigger_fire),
> 
> Instead of setting up these tests manually you could use
> TEST_HARNESS_MAIN, TEST_F and other helpers from kselftest_harness.h.
> 
I just went with the manual style to match the rest of the directory --
test_memcontrol.c, test_core.c, test_cpu.c, etc. all use ksft_set_plan()
and none use kselftest_harness.h. Happy to switch to the harness if
you'd prefer.

I'll fold all of this into v3.

Thanks,
Tao
>> +};
>> +
>> +int main(int argc, char **argv)
>> +{
>> +       char root[PATH_MAX];
>> +       int mempress_fd;
>> +       int i;
>> +
>> +       (void)argc;
>> +
>> +       ksft_print_header();
>> +       ksft_set_plan(ARRAY_SIZE(tests));
>> +
>> +       if (cg_find_unified_root(root, sizeof(root), NULL))
>> +               ksft_exit_skip("cgroup v2 isn't mounted\n");
>> +
>> +       /* PSI must be enabled (CONFIG_PSI=y, not default-disabled). */
>> +       mempress_fd = open("/proc/pressure/memory", O_RDONLY);
>> +       if (mempress_fd < 0)
>> +               ksft_exit_skip("PSI unavailable (CONFIG_PSI=n or psi=0)\n");
>> +       close(mempress_fd);
>> +
>> +       if (cg_read_strstr(root, "cgroup.controllers", "memory"))
>> +               ksft_exit_skip("memory controller isn't available\n");
>> +       if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
>> +               if (cg_write(root, "cgroup.subtree_control", "+memory"))
>> +                       ksft_exit_skip("failed to enable memory controller\n");
>> +
>> +       for (i = 0; i < (int)ARRAY_SIZE(tests); i++) {
>> +               switch (tests[i].fn(root)) {
>> +               case KSFT_PASS:
>> +                       ksft_test_result_pass("%s\n", tests[i].name);
>> +                       break;
>> +               case KSFT_SKIP:
>> +                       ksft_test_result_skip("%s\n", tests[i].name);
>> +                       break;
>> +               default:
>> +                       ksft_test_result_fail("%s\n", tests[i].name);
>> +                       break;
>> +               }
>> +       }
>> +
>> +       ksft_finished();
>> +}
>> --
>> 2.43.0
>>

