From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
Date: Fri, 10 Jun 2022 14:30:00 -0700
Message-ID: <CAJD7tkZqCrqx0UFHVXv3VMNNk8YJrJGtVVy_tP3GDTryh375PQ@mail.gmail.com>
References: <20220610194435.2268290-7-yosryahmed@google.com> <202206110544.D5cTU0WQ-lkp@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=95Jw5s5U+9h+RH3k4GM+5YUCgDK6/y0zF6sj5xk3tV0=;
        b=I+ONCW4N40xi6OHman8kT5DVagz+dhj6LV2/JU1uBHo+0lmkQbKluqGvs343u50BiS
         OyvUQ4SPAlJtyZOqfiIWw4B7wLi1gaxgumSP6uftAkDU76vru5Oo+77mrE0i9qhYJ1Dj
         jQA0YKZTzSfZtqzfixdeJuPJ/r4nZCV6ViCmqpISYzWBLUSyhDBw77FX6rMZFxmlfcNN
         Lfrl98LpKkvIFHqxznHvSNq8sQyfhl7nVGOQoP75TBvCmjitZYk8Jq7e+KBEHa28eMky
         OUKnIRVFISHidByYyg5+mBN3C+AoCqeHKMyfjs6CuC5cZoGFs4SZYnlM1X0zRNJc6cx0
         bsAQ==
In-Reply-To: <202206110544.D5cTU0WQ-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ne

On Fri, Jun 10, 2022 at 2:23 PM kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> Hi Yosry,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on bpf-next/master]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220611/202206110544.D5cTU0WQ-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
> compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/83f297e2b47dc41b511f071b9eadf38339387b41
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
>         git checkout 83f297e2b47dc41b511f071b9eadf38339387b41
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> All errors (new ones prefixed by >>):
>
>    kernel/cgroup/rstat.c:161:22: warning: no previous prototype for 'bpf_rstat_flush' [-Wmissing-prototypes]
>      161 | __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
>          |                      ^~~~~~~~~~~~~~~
> >> kernel/cgroup/rstat.c:509:10: error: 'const struct btf_kfunc_id_set' has no member named 'sleepable_set'; did you mean 'release_set'?
>      509 |         .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
>          |          ^~~~~~~~~~~~~
>          |          release_set
>    kernel/cgroup/rstat.c:509:27: warning: excess elements in struct initializer
>      509 |         .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
>          |                           ^
>    kernel/cgroup/rstat.c:509:27: note: (near initialization for 'bpf_rstat_kfunc_set')
>
>
> vim +509 kernel/cgroup/rstat.c
>
>    505
>    506  static const struct btf_kfunc_id_set bpf_rstat_kfunc_set = {
>    507          .owner          = THIS_MODULE,
>    508          .check_set      = &bpf_rstat_check_kfunc_ids,
>  > 509          .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
>    510  };
>    511
>
> --
> 0-DAY CI Kernel Test Service
> https://01.org/lkp

AFAICT these failures are because the patch series depends on a patch
in the mailing list [1] that is not in bpf-next, as explained by the
cover letter.

[1] https://lore.kernel.org/bpf/20220421140740.459558-5-benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
