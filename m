From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v4 1/4] memcg: introduce per-memcg reclaim interface
Date: Sat, 23 Apr 2022 14:44:20 -0700
Message-ID: <CAJD7tkaAKPLCrZmZc0FDHj3s40rbZ5gp5gGpQEtiRvsE6vdWPg@mail.gmail.com>
References: <20220421234426.3494842-1-yosryahmed@google.com>
 <20220421234426.3494842-2-yosryahmed@google.com> <20220423133035.b6iz6vzhzlym3m4w@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yx8y7goVHBTlGvdtFFuNwwMCsekJcpP9yvzgyjH/bp8=;
        b=qUkkGk/bpw8J14YdHOTb4OZuCmi63QvteZvtb9Aamaxo0h8F/x9cxEHz27DzgjZcfU
         lO2ufp6jXpfprhMFOAKOY0UomKf+5C5Xba3QJ9Lf4mg0l10Kw819Itq5Awrey6+53cOg
         vVA2sH9g5lqyk8SDJcuqUYgRvr+O2I7vjscVtPkcSJ79na68KphWwZX4Zw31RRzsMgD7
         y6Ij35PmRo1cbbPNwwgB/xc3XBmk7Tqx6kzpyXUyoRCj61jI4z4UfkEhCCrywL3K5adi
         c6eVmKQZxrrOxtFX4Rt9FfNl5dyK0cMSNPoPJHPpsL/X1CTkqgnoWbDbiWbbx0VP5xpa
         NR0A==
In-Reply-To: <20220423133035.b6iz6vzhzlym3m4w@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kern>

On Sat, Apr 23, 2022 at 6:30 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Thu, Apr 21, 2022 at 11:44:23PM +0000, Yosry Ahmed wrote:
> > From: Shakeel Butt <shakeelb@google.com>
> [...]
> >
> > [yosryahmed@google.com: refreshed to current master, updated commit
> > message based on recent discussions and use cases]
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>
> You should add "Co-developed-by" tag for yourself here.
>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > Acked-by: Wei Xu <weixugc@google.com>
> > Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> > ---
> >
> [...]
> > +static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
> > +                           size_t nbytes, loff_t off)
> > +{
> > +     struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> > +     unsigned int nr_retries = MAX_RECLAIM_RETRIES;
> > +     unsigned long nr_to_reclaim, nr_reclaimed = 0;
> > +     int err;
> > +
> > +     buf = strstrip(buf);
> > +     err = page_counter_memparse(buf, "", &nr_to_reclaim);
> > +     if (err)
> > +             return err;
> > +
> > +     while (nr_reclaimed < nr_to_reclaim) {
> > +             unsigned long reclaimed;
> > +
> > +             if (signal_pending(current))
> > +                     return -EINTR;
> > +
> > +             /* This is the final attempt, drain percpu lru caches in the
>
> Fix the comment format. "/*" should be on its own line.
>
> > +              * hope of introducing more evictable pages for
> > +              * try_to_free_mem_cgroup_pages().
> > +              */
>
> No need to send a new version if Andrew can fix these in the mm tree.

I will be sending v5 anyway to address your review comments on the
last patch. I will fix these as well. Thanks!
