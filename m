From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/4] cgroup bpf auto-detachment
Date: Fri, 24 May 2019 19:57:17 -0700
Message-ID: <CAADnVQK7uukL5=S=96BrU7YOyxidA4Pnm3rPRoGy45bJU=_8tA@mail.gmail.com>
References: <20190524235156.4076591-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=riyApgsTYeHf2zY9V/AMEGkb7h3Dl4SpcWBAI87ws7o=;
        b=Cr2EYgUjkeLHCtvqjSOGW9oFUeSPO02ig9NkKOBRRNy0fICJ7Ng/0FaVg2RY/yn8+m
         fz1gqwEe5Nghmb5/L0O5hssEIMkWS1e+FyPTKJK9O30frk2ZuXUF4A7Sv0KDahcfE8zk
         YtliVApzcXpsSSdDiNfKn6Sw5q+kJFunCzZVbDdOtbLiZwofrEhlj/bp58LcT/3UnmF0
         2/ydota/TCeN+DqRA829wZP16pG24a5l/A9vt+NrcUhcK1FAB9OpXT6DXYRCXKa5H0+K
         2rBqm9geg/dPXJDCyYojiykzXs+Q4uq2kfpSoHY55opQgPFJZNGpg74TUPicJdisQ2Ei
         eBvA==
In-Reply-To: <20190524235156.4076591-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Kernel Team <kernel-team@fb.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Yonghong Song <yhs@fb.com>, LKML <linux-kernel@vger.kernel.org>

On Fri, May 24, 2019 at 4:52 PM Roman Gushchin <guro@fb.com> wrote:
>
> This patchset implements a cgroup bpf auto-detachment functionality:
> bpf programs are detached as soon as possible after removal of the
> cgroup, without waiting for the release of all associated resources.
>
> Patches 2 and 3 are required to implement a corresponding kselftest
> in patch 4.
>
> v4:
>   1) release cgroup bpf data using a workqueue
>   2) add test_cgroup_attach to .gitignore

There is a conflict in tools/testing/selftests/bpf/Makefile
Please rebase
