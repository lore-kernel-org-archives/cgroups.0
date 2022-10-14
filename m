From: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] perf stat: Support old kernels for bperf cgroup
 counting
Date: Fri, 14 Oct 2022 10:30:52 -0300
Message-ID: <Y0lkjJLfZNXQNYxR@kernel.org>
References: <Y0Sx2KWX4gPlLytq@slm.duckdns.org>
 <20221011052808.282394-1-namhyung@kernel.org>
 <Y0Wfl88objrECjSo@slm.duckdns.org>
 <Y0ljzN920sWalEHR@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665754255;
        bh=mINcMLnVsgheBTTRF+mKEseQpUsGdZeG1g0fkhbY1s8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F5k0CxXma58+OUFwamCyShctCfhZ4boPFlcTKXUDVo4dAsKnwDpkQJDIftCIIEgOw
         SUYYg38JNhtp85t0DPyanIjStUgYbL9bPCykHcwPItgz04Uj68xFIHpd8omJTGvd6R
         8dIBeSS9Du1WD4R8RpxsSs7pbRhh4Qw42iZsqRIFGq8CJkhpPpsmeA61h60IGsb4wZ
         HS6W++YWokOJ6lty9mMD5VbBuaX+IYVtn/VjkLfaQvpYsmNqIcDCgIREgAwiGM68l6
         YPiwN/0brn4bBo7l2WtuYSNF3tdtoGSv4oJe4yZU3bZCdOgLwRe/qAaMA86wiiaLo/
         z+VMAbtM9OfQQ==
Content-Disposition: inline
In-Reply-To: <Y0ljzN920sWalEHR-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Em Fri, Oct 14, 2022 at 10:27:40AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Oct 11, 2022 at 06:53:43AM -1000, Tejun Heo escreveu:
> > On Mon, Oct 10, 2022 at 10:28:08PM -0700, Namhyung Kim wrote:
> > > The recent change in the cgroup will break the backward compatiblity in
> > > the BPF program.  It should support both old and new kernels using BPF
> > > CO-RE technique.
> 
> > > Like the task_struct->__state handling in the offcpu analysis, we can
> > > check the field name in the cgroup struct.
>  
> > > Acked-by: Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Acked-by: Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>  
> > Applied to cgroup/for-6.1-fixes.
> 
> Hey, I noticed that the perf build is broken for the
> tools/perf/util/bpf_skel/bperf_cgroup.bpf.c skell, so I tried using b4
> on this Namhyung patch, it ended up getting a newer version, by Tejun,
> that mixes up kernel code and tooling, which, when I tried to apply
> upstream didn't work.
> 
> Please try not to mix up kernel and tools/ changes in the same patch to
> avoid these issues.
> 
> Also when changing tools/perf, please CC me.
> 
> I'm now back trying to apply v2 of this patch to see if it fixes my
> build.

Yeah, applying just Namhyung's v2 patch gets perf back building, I'll
keep it there while processing the other patches so that I can test them
all together.

- Arnaldo
