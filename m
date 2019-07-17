From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH v10 6/9] kselftests: cgroup: add freezer controller self-tests
Date: Wed, 17 Jul 2019 14:26:49 +0530
Message-ID: <CA+G9fYt+UmakwaZAM4gR-B+V8kZUJVNh8gFBcXa4zU2j0Cz0ZQ@mail.gmail.com>
References: <20190405174708.1010-1-guro@fb.com> <20190405174708.1010-7-guro@fb.com>
 <CA+G9fYvz6MA0N8GgwY5QNdWBAw+XT9QcmwnABsSpjLnwz_jLzA@mail.gmail.com> <20190717004904.GA32357@castle.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5jVJYwVPqhI92ePrVwuK/g+oP5mpkNXJhduBRrTnzOo=;
        b=hc6r1e69nhIl69WPP0wsHJjCJ0EIaTLGofpXpOOCuwEBWVM2DslumLrlHBCVRPlXOb
         vtpofLq3bWMezI1jFYPQSlVS0XUVXadYW1mcxJJ5hzyT0MTd+x3PpzFNVy3N1IxT0mBM
         zCVb5nyOsBRFPJnDRXtMVc95qbpz21UCgaHQBRVnZjF87bPjqx3yZHbISO4sBn7ubXjb
         qa7ZJwAAPRVKsL+9pm4ezR+ltfBh3ZdLMYqJFyBAUnv1FDYODKsz9I1vzYgHx5jMZToN
         VCYnF5+0nRvQ69Xkihe/2ovzECrI4sGWEORpaknO3Y4aTs7qO9TZ198lz6V70XEcqWDr
         bOOw==
In-Reply-To: <20190717004904.GA32357@castle.dhcp.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Shuah Khan <shuah@kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>

Hi Roman,

> The interaction between ptrace and freezer is complicated
> (as ptrace in general),so there are known cases when spurious
> cgroup transitions (frozen <-> non frozen <-> frozen ) can happen.

When test ran for 8 times it got failed 5 times.
I have noticed intermittent failure on x86_64, arm64 hikey device and
qemu_arm64.

>
> Does it create any difficulties? If so, I'll send a diff to ignore
> the result of this test for now.

No difficulties. I will mark this test case as known failure.

> > > This patch implements 9 tests for the freezer controller for
> > > cgroup v2:
> > ...
> > > 6) ptrace test: the test checks that it's possible to attach to
> > > a process in a frozen cgroup, get some information and detach, and
> > > the cgroup will remain frozen.
> >
> > selftests cgroup test_freezer failed because of the sys entry path not found.
>
> Can you, please, elaborate on this?

I see this failure output on screen and sharing log here.

Please find full test log here,
https://lkft.validation.linaro.org/scheduler/job/825346#L673

- Naresh
