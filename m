From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Mon, 22 Aug 2022 08:09:01 -0700
Message-ID: <CALvZod5YGVSTvsg25P6goqyGEY21eVnahsXcs2BGsp6OXxLwsg@mail.gmail.com>
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-4-shakeelb@google.com>
 <YwNe3HBxzF+fWb2n@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=DL+gliCYJUBpfOq1j0gfe9XybjmiohhXfC5HxYReYKQ=;
        b=Wy9VrLR+iXIOs02vfJHYtL6p0NbydFm1yZdXSv/BbjuFOkMtSTPP5CovxJ8349YqKj
         G3MVhdA4OpFY8unEsaSt6zl96K01EATVtDmzrpuZf7ttwrRaJShdhZDkiI3ve+qZNaMO
         LaMlsEqTM0HnQfbQJ+Ybp1cnhMyLAgbc8INMpkq7KkujbvLbZ3V3a+NkCsxtQtac3dFk
         vdsSPaw69M8DRRGlUlj8oR/cctPuyyB4P3GQXi7AhcJrZf2VSCnqZnoHSJmlaPfCsIHj
         Joq2WkpjnyjHGnaNIuUdQt4Q0lg3lljWYfXsxd0kZCxPo/shZ5oEicOIck6uwGYGrqs4
         U2ZA==
In-Reply-To: <YwNe3HBxzF+fWb2n@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Feng Tang <feng.tang@intel.com>, Oliver Sang <oliver.sang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, Aug 22, 2022 at 3:47 AM Michal Hocko <mhocko@suse.com> wrote:
>
[...]
>
> > To evaluate the impact of this optimization, on a 72 CPUs machine, we
> > ran the following workload in a three level of cgroup hierarchy with top
> > level having min and low setup appropriately. More specifically
> > memory.min equal to size of netperf binary and memory.low double of
> > that.
>
> a similar feedback to the test case description as with other patches.

What more info should I add to the description? Why did I set up min
and low or something else?

> >
> >  $ netserver -6
> >  # 36 instances of netperf with following params
> >  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> >
> > Results (average throughput of netperf):
> > Without (6.0-rc1)       10482.7 Mbps
> > With patch              17064.7 Mbps (62.7% improvement)
> >
> > With the patch, the throughput improved by 62.7%.
> >
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Reported-by: kernel test robot <oliver.sang@intel.com>
>
> Anyway
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks
