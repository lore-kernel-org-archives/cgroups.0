From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Thu, 31 Aug 2023 09:40:03 -0700
Message-ID: <CAJD7tkbo28Mc9ydPnqL_gKmi-QZGORE-FVcZcQnsLVTCA1UBzA@mail.gmail.com>
References: <20230830175335.1536008-5-yosryahmed@google.com> <202308311025.538QuXBV-lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693500043; x=1694104843; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drcv5mKJ9RhO4L7vLkvVuevPSBYeBJBAmcU4Oua4F00=;
        b=yTA644q6Seh2/5aVPQn7DTe+hvJiKfe7COTZEj1glHSCcL7fDKUK/1sywwKG5n8iER
         c4jKh5yEDHpRWaHqY8tLVG/EaKE13MuC1zzhih6R08Gl3r11V6dmrcPiVlPJ6+1hdLxr
         MNj+XFgUQRpFcNJBHOJS3VVexBB0SlFXPaIq0rDfY5ot3dGgaazyxPwdJKTso9TOV0qL
         C2RJzRP2Nkc2zBrwxQKX6VJstxV/lUoRx2JbIue0do+mgbBYv//842aKyqUQHTU5v1pZ
         DEMVfaBX/tx/xlIDLq/Nb+X/9NajYL7H3DmtV2sPrev7+uWLU0tcbTYRa65363Zz6saF
         uTKg==
In-Reply-To: <202308311025.538QuXBV-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, llvm-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, oe-kbuild-all-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 30, 2023 at 8:08=E2=80=AFPM kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> w=
rote:
>
> Hi Yosry,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on akpm-mm/mm-everything]
> [also build test WARNING on linus/master next-20230830]
> [cannot apply to v6.5]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Yosry-Ahmed/mm-mem=
cg-properly-name-and-document-unified-stats-flushing/20230831-015518
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-ev=
erything
> patch link:    https://lore.kernel.org/r/20230830175335.1536008-5-yosryah=
med%40google.com
> patch subject: [PATCH v3 4/4] mm: memcg: use non-unified stats flushing f=
or userspace reads
> config: i386-randconfig-r013-20230831 (https://download.01.org/0day-ci/ar=
chive/20230831/202308311025.538QuXBV-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
> compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git =
ae42196bc493ffe877a7e3dff8be32035dea4d07)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20230831/202308311025.538QuXBV-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202308311025.538QuXBV-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
> >> mm/memcontrol.c:667:6: warning: no previous prototype for function 'me=
m_cgroup_user_flush_stats' [-Wmissing-prototypes]
>    void mem_cgroup_user_flush_stats(struct mem_cgroup *memcg)
>         ^
>    mm/memcontrol.c:667:1: note: declare 'static' if the function is not i=
ntended to be used outside of this translation unit
>    void mem_cgroup_user_flush_stats(struct mem_cgroup *memcg)
>    ^
>    static
>    1 warning generated.

Ah silly mistake on my end. Will send v4 after making
mem_cgroup_user_flush_stats() static.

>
>
> vim +/mem_cgroup_user_flush_stats +667 mm/memcontrol.c
>
>    658
>    659  /*
>    660   * mem_cgroup_user_flush_stats - do a stats flush for a user read
>    661   * @memcg: memory cgroup to flush
>    662   *
>    663   * Flush the subtree of @memcg. A mutex is used for userspace rea=
ders to gate
>    664   * the global rstat spinlock. This protects in-kernel flushers fr=
om userspace
>    665   * readers hogging the lock.
>    666   */
>  > 667  void mem_cgroup_user_flush_stats(struct mem_cgroup *memcg)
>    668  {
>    669          mutex_lock(&stats_user_flush_mutex);
>    670          do_stats_flush(memcg);
>    671          mutex_unlock(&stats_user_flush_mutex);
>    672  }
>    673
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
