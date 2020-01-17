From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 0/3] cgroup: Iterate tasks that did not finish do_exit()
Date: Fri, 17 Jan 2020 09:30:15 -0800
Message-ID: <CAJuCfpHkOz1LmygyxC9VxXux8_TFmEGr-BsAs-EadKt=AkZyiQ@mail.gmail.com>
References: <20200116043612.52782-1-surenb@google.com> <20200117151533.12381-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s/Igl7jec5R8DMF3nyQFihy0XoNH7LpzgEc781wHBbE=;
        b=IfI2V2VjiHDEyMxVeB6DJUwZfuJaVSwdWaVbiW2tG1VzG5iMe4Fmndr3Dh8Y5KaF7g
         SbVP5Ca373H4SpjZNwlaPj0ajlmO5/0RXj4cboBUBjlynN2ihp0sj5+LxlF9hYR3Gs5D
         5Qv2rZh4Yzvc8lS4UP3Ac5LRe5cw1v+Y0yJdR8pwwdPPusdbhjfrDBsi13y8DYwoaakI
         cuAz6BXfPrsKPA1w9FiWbzNzE9zzgpb3Rr4pw20A0bJZFGooUMKUtslJ3QXvxVnMh650
         IIszWgCEmch4wXJw0b3IsDeqswH27TUpZ2/KnyYvteCdFYD5butLob8faQQd6VS5iI6D
         fZyA==
In-Reply-To: <20200117151533.12381-1-mkoutny@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups mailinglist <cgroups@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, alex.shi@linux.alibaba.com, Roman Gushchin <guro@fb.com>, kernel-team <kernel-team@android.com>, JeiFeng Lee <linger.lee@mediatek.com>, linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org, linux-mediatek@lists.infradead.org, matthias.bgg@gmail.com, shuah@kernel.org, Tom Cherry <tomcherry@google.com>

Hi Michal,

On Fri, Jan 17, 2020 at 7:15 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote=
:
>
> Hi,
> I was looking into the issue and came up with an alternative solution tha=
t
> changes task iteration to be consistent with cgroup_is_populated() check =
and
> moving the responsibility to check PF_EXITING on the consumers of iterato=
r API.

Yeah, that was my first thought which basically reverts a part of
c03cd7738a83. When I first brought up this issue in the other email
thread, Tejun's comment was "the right thing to do is allowing
destruction of cgroups w/ only
dead processes in it". I assumed, maybe incorrectly, that the desire
here is not to include dying processes into cgroup.procs but to allow
cgroups with dying processes to be deleted.

To be clear, either way is fine with me since both ways solve the
issue and this way the code is definitely simpler. I'll rerun the
tests with your patches just to confirm the issue is gone.
Thanks!

> I haven't check your approach thoroughly, however, it appears to me it
> complicates (already non-trivial) cgroup destruction path. I ran your sel=
ftest
> on the iterators approach and it proved working.
>
>
> Michal Koutn=C3=BD (2):
>   cgroup: Unify css_set task lists
>   cgroup: Iterate tasks that did not finish do_exit()
>
> Suren Baghdasaryan (1):
>   kselftest/cgroup: add cgroup destruction test
>
>  include/linux/cgroup-defs.h                |  15 ++-
>  include/linux/cgroup.h                     |   4 +-
>  kernel/cgroup/cgroup.c                     |  86 ++++++++--------
>  kernel/cgroup/debug.c                      |  16 ++-
>  tools/testing/selftests/cgroup/test_core.c | 113 +++++++++++++++++++++
>  5 files changed, 176 insertions(+), 58 deletions(-)
>
> --
> 2.24.1
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kernel-team+unsubscribe@android.com.
>
