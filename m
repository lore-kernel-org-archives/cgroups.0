From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH v10 6/9] kselftests: cgroup: add freezer controller self-tests
Date: Tue, 16 Jul 2019 20:18:39 +0530
Message-ID: <CA+G9fYvz6MA0N8GgwY5QNdWBAw+XT9QcmwnABsSpjLnwz_jLzA@mail.gmail.com>
References: <20190405174708.1010-1-guro@fb.com> <20190405174708.1010-7-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YrNz8Q0qPVQBIoGob+UcRjTxZM1rMVhgoGUsAEtnBd8=;
        b=nRiNC+kUdj8lsYEzkcic81q9xM1RzrwfOcHBr5/kNF0xZPu/wF9Vuhh3dG+c5MjMsB
         Lcd+uU1Eyy9SGkEH1qTwGyP5MmWQw80swJjOgDqnNzvvPSbELxtkfVNzxvC1rzKPff4T
         nlkrn59+VV4ygIjhgauMHTsYBOdeAARNubjpDOia/L0U+3Q449nuF7uWDDAAdvL1dmFd
         wJkmpbOwdAES6uGqXCQbVrzRu18SfRx3imvYjibztYVB/oUecv5Q1nVe3IgQqHZsjfPC
         c+pHZCA00FHgqIAk0IDcmvCtqYbkEEM0TRO78bDpZYR17llbBNgvigXKjGMP63jnccZl
         Rtog==
In-Reply-To: <20190405174708.1010-7-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>, kernel-team@fb.com, cgroups@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>, Shuah Khan <shuah@kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, lkft-triage@lists.linaro.org

Hi Roman,

Just want to share information here on what we notice on running this test case,

On Fri, 5 Apr 2019 at 23:17, Roman Gushchin <guroan@gmail.com> wrote:
>
> This patch implements 9 tests for the freezer controller for
> cgroup v2:
...
> 6) ptrace test: the test checks that it's possible to attach to
> a process in a frozen cgroup, get some information and detach, and
> the cgroup will remain frozen.

selftests cgroup test_freezer failed because of the sys entry path not found.
 Cgroup /sys/fs/cgroup/unified/cg_test_ptrace isn't frozen
/sys/fs/cgroup/unified/cg_test_ptrace: isn't_frozen #
# not ok 6 test_cgfreezer_ptrace

This test case fails intermittently.

Test output:
-------------
# selftests cgroup test_freezer
cgroup: test_freezer_ #
# Cgroup /sys/fs/cgroup/unified/cg_test_ptrace isn't frozen
/sys/fs/cgroup/unified/cg_test_ptrace: isn't_frozen #
# ok 1 test_cgfreezer_simple
1: test_cgfreezer_simple_ #
# ok 2 test_cgfreezer_tree
2: test_cgfreezer_tree_ #
# ok 3 test_cgfreezer_forkbomb
3: test_cgfreezer_forkbomb_ #
# ok 4 test_cgfreezer_rmdir
4: test_cgfreezer_rmdir_ #
# ok 5 test_cgfreezer_migrate
5: test_cgfreezer_migrate_ #
# not ok 6 test_cgfreezer_ptrace
ok: 6_test_cgfreezer_ptrace #
# ok 7 test_cgfreezer_stopped
7: test_cgfreezer_stopped_ #
# ok 8 test_cgfreezer_ptraced
8: test_cgfreezer_ptraced_ #
# ok 9 test_cgfreezer_vfork
9: test_cgfreezer_vfork_ #
[FAIL] 3 selftests cgroup test_freezer
selftests: cgroup_test_freezer [FAIL]

Test results link,
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kselftest/cgroup_test_freezer?page=1

- Naresh
