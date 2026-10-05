Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE3735E92F;
	Mon,  5 Oct 2026 07:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791186795; cv=none; b=M/Vn9j8vEtTPaAYutl7Uo7F7wWKwX2YO9KUB2gfovlQL0h6DCRBJxVOyQ17l8wSSArHxgpih7LNoAdDy360XsT6pjnH1dgwoBd4fgwhpDD5BzRR+qEtyuptAtSCA9BGilJVbzR4NXvkwF6xW7n/E7VF5cUbKehbapoGUfCdL648=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791186795; c=relaxed/simple;
	bh=PBXa2DuXdFqBZRICIabALpvUzRmhBpiMuPaWLmZTUGs=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=WzxOdAGTHAWM6xYZnoiIWysoS9mv+sipFIMWgt3rQm43yo4MkSRQMYDJ+aC0hdj9hM7lPQIYsPOBnvQ6cvkcHGo6MvVnBiYl5OCg5JwNQxjOAQO+y/jfoNj1DwQIcxt0SBAOzEUBdPwCeIX4wZ8dJilSaKSM+dPuuFtZ2u9Gjgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EEX+P8CP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EEX+P8CP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9521F000FF;
	Mon,  5 Oct 2026 07:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791186793;
	bh=p8pB98yXVn3emMjSSVc5iGuD87aD74hXLFXwrp1IR14=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=EEX+P8CPFeqWLSN59RzmGW3okJrWBjL6X4WZQ29o3f4Nq0tIqMaqJhXpenBYRESYX
	 yLr/6vNkyiB/QVgs5zLCeYF1lZ/eWykY2jayP+n3JLO0BDVzLklA2oN66POyCpJ0M8
	 ACoSS1yP91wzs2/kkXR6AGYVCW0G3/htMwHDa56r5fUmx5ZGlnI2TlDZval00GP2vd
	 evxYEkphbACrDVnO3o/U/I9epZ0n8riPwtBTcw9qOkk/kHJh8Lw7KxjINSemSfbp9e
	 jjBzb3UMLUYfwz81sU923vgWgmRmwclgx/rRb5kdSlzAN6+bKnYI9hvtvI9VL3OaWd
	 EQXmRq8LXJ6Mw==
Content-Type: multipart/mixed; boundary="===============0647874907332121866=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <3a4688cd7929354339fc61a5f4e8a0109e426a83097d9d9a2357ac6e3fe2c9ea@mail.kernel.org>
In-Reply-To: <20261005070625.8871-4-kmehltretter@gmail.com>
References: <20261005070625.8871-4-kmehltretter@gmail.com>
Subject: Re: [RFC PATCH v2 3/3] selftests/bpf: exercise task storage from hrtimer_start
From: bot+bpf-ci@kernel.org
To: kmehltretter@gmail.com,peterz@infradead.org,tglx@linutronix.de,bigeasy@linutronix.de,akpm@linux-foundation.org,vbabka@kernel.org,harry@kernel.org,ast@kernel.org
Cc: kmehltretter@gmail.com,mingo@redhat.com,will@kernel.org,boqun@kernel.org,longman@redhat.com,corbet@lwn.net,david@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,stevensd@google.com,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,shuah@kernel.org,ameryhung@gmail.com,swarajgaikwad1925@gmail.com,clrkwllms@kernel.org,rostedt@goodmis.org,linux-kernel@vger.kernel.org,linux-doc@vger.kernel.org,linux-mm@kvack.org,linux-rt-devel@lists.linux.dev,bpf@vger.kernel.org,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon,  5 Oct 2026 07:53:09 +0000 (UTC)

--===============0647874907332121866==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: exercise task storage from hrtimer_start

TL;DR: Test-organization question only: should the new hrtimer task-storage
selftest be a subtest of task_local_storage.c instead of a separate file? The
review finds the test logic correct and the standalone file defensible.

> diff --git a/tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c b/tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c
> new file mode 100644
> index 000000000000..216e66263bf6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <sys/timerfd.h>
> +#include <unistd.h>
> +
> +#include <test_progs.h>
> +#include "task_storage_hrtimer.skel.h"
> +
> +#define TRIGGER_COUNT 1000
> +
> +void test_task_storage_hrtimer(void)
> +{

A subsystem pattern flags this as potentially concerning: this adds a new
top-level test file for a narrow variant of behavior that an existing test
in the same directory already covers more generally.

prog_tests/task_local_storage.c already groups the general task-local
storage tests as subtests, including test_nodeadlock(), backed by
progs/task_storage_nodeadlock.c.  That subtest performs the same
bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE) followed by
bpf_task_storage_delete() sequence and counts failures, just from a
different hook (lsm.s/socket_post_create).

The only difference here is the attach point, tp_btf/hrtimer_start, which
reaches the task storage allocator under the hrtimer base raw lock on
PREEMPT_RT.

Should this be a new subtest of test_task_local_storage() instead of a
separate prog_tests/task_storage_hrtimer.c?

For balance, the standalone file may well be defensible.  It uses its own
skeleton, as the existing task_local_storage.c subtests also do, so folding
it in would mostly move the test function rather than share setup.  It also
exercises a path that no existing selftest reaches: none of the current
programs that use task storage attach to tracepoints emitted from inside the
hrtimer code, and the programs that do use hrtimer tracepoints
(timer_start_deadlock.c, test_vmlinux.c) do not use task storage.

The test logic itself looks correct: the tp_btf prototype matches
TP_PROTO(hrtimer, mode, was_armed), and timerfd_settime() with a non-zero
it_value emits one trace_hrtimer_start under cpu_base->lock, so the counter
assertions are consistent.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/37277547264
--===============0647874907332121866==--
