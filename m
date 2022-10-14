From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH v2] perf stat: Support old kernels for bperf cgroup
 counting
Date: Fri, 14 Oct 2022 10:27:40 -0300
Message-ID: <Y0ljzN920sWalEHR@kernel.org>
References: <Y0Sx2KWX4gPlLytq@slm.duckdns.org>
 <20221011052808.282394-1-namhyung@kernel.org>
 <Y0Wfl88objrECjSo@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665754063;
        bh=Mer19hBhh2VO610s7L+5FvRU6lA4fQAb3tmDtTWR/JQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QSMyBkrDW0HP2yY/TqJk38iFPqW3PhdhSf8o4Ma1vvCup/yA3qpniqx3AoaGRow6f
         PFBot3CSD3KUgKSSltJrF0UJU9pDn1yZ0icuzKeKSjtXsqoPnRocW36KDXEvuYeZcq
         F/rcnbjXCNa3TB3QeOoGH8kbKp1tCjIW3ySbEJ/lkDW3OV0xYbB1AOIBY6evPI8Q0k
         1DKnN5nqTOL1ymnU6f91TW+u80krsokFzeZy7KDxIeWPFK5K7OOOmks9c/apQqcMKu
         b6DfBCG1ZTcyn4GZKM3SQVQq/paEGjX3hpP3hiWW4vGwvxBbU8ZaAsN6g/V1BWGtYS
         mTTupBSRKzoGA==
Content-Disposition: inline
In-Reply-To: <Y0Wfl88objrECjSo@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org, Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>

Em Tue, Oct 11, 2022 at 06:53:43AM -1000, Tejun Heo escreveu:
> On Mon, Oct 10, 2022 at 10:28:08PM -0700, Namhyung Kim wrote:
> > The recent change in the cgroup will break the backward compatiblity in
> > the BPF program.  It should support both old and new kernels using BPF
> > CO-RE technique.

> > Like the task_struct->__state handling in the offcpu analysis, we can
> > check the field name in the cgroup struct.
 
> > Acked-by: Jiri Olsa <jolsa@kernel.org>
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
 
> Applied to cgroup/for-6.1-fixes.

Hey, I noticed that the perf build is broken for the
tools/perf/util/bpf_skel/bperf_cgroup.bpf.c skell, so I tried using b4
on this Namhyung patch, it ended up getting a newer version, by Tejun,
that mixes up kernel code and tooling, which, when I tried to apply
upstream didn't work.

Please try not to mix up kernel and tools/ changes in the same patch to
avoid these issues.

Also when changing tools/perf, please CC me.

I'm now back trying to apply v2 of this patch to see if it fixes my
build.

Thanks,

- Arnaldo
