From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] mm/memcontrol: Add the drop_cache interface for cgroup v2
Date: Tue, 22 Sep 2020 16:06:31 +0800
Message-ID: <CALOAHbCvRA61NbamdKSxLoy4eNqR6G_1OA=zEjb7Mu0Yh9O0sg@mail.gmail.com>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz> <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz> <CALOAHbCDXwjN+WDSGVv+G3ho-YRRPjAAqMJBtyxeGHH6utb5ew@mail.gmail.com>
 <20200921113646.GJ12990@dhcp22.suse.cz> <CALOAHbCker64WEW9w4oq8=avA6oKf3-Jrn-vOOgkpqkV3g+CYA@mail.gmail.com>
 <20200922072733.GT12990@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dI2SOSDVGxObAVcXLG7drnzqQGI8RgnuHUnXIEvu+us=;
        b=ce1QZHfPYr5zB923i5Vse/ct0CsPz2mKEtK2BbKoGHWENzw/eroXjVr04Ewvb2hGJS
         QftNRfFEtfhs6OKUpC2ikzJAlZsa5r8xvteqqh4LEdNI+fgTY/I/WgLziY0QpPKVLEkb
         GG21E8+R4F7QBCrhWRnnz9XX/jPxaMKK3QjvEXC/4OyyQ0XvGH3tTppXeBz54NRX2Clk
         P5Cj3fSL5NObe+IXN+Xaj5LGNyn3qX5hrv5tR12V1FQ4ExbmniCg+wgzL9F+GGvyzcj1
         u9yPJ5iY6r126F19PpbOXJqj6zYd4X2giCbe9fUrSLDp/sXu3N7X8lCc5jGBkUojuD+w
         BG5g==
In-Reply-To: <20200922072733.GT12990@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: zangchunxin@bytedance.com, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Jonathan Corbet <corbet@lwn.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org

On Tue, Sep 22, 2020 at 3:27 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Tue 22-09-20 12:20:52, Yafang Shao wrote:
> > On Mon, Sep 21, 2020 at 7:36 PM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Mon 21-09-20 19:23:01, Yafang Shao wrote:
> > > > On Mon, Sep 21, 2020 at 7:05 PM Michal Hocko <mhocko@suse.com> wrote:
> > > > >
> > > > > On Mon 21-09-20 18:55:40, Yafang Shao wrote:
> > > > > > On Mon, Sep 21, 2020 at 4:12 PM Michal Hocko <mhocko@suse.com> wrote:
> > > > > > >
> > > > > > > On Mon 21-09-20 16:02:55, zangchunxin@bytedance.com wrote:
> > > > > > > > From: Chunxin Zang <zangchunxin@bytedance.com>
> > > > > > > >
> > > > > > > > In the cgroup v1, we have 'force_mepty' interface. This is very
> > > > > > > > useful for userspace to actively release memory. But the cgroup
> > > > > > > > v2 does not.
> > > > > > > >
> > > > > > > > This patch reuse cgroup v1's function, but have a new name for
> > > > > > > > the interface. Because I think 'drop_cache' may be is easier to
> > > > > > > > understand :)
> > > > > > >
> > > > > > > This should really explain a usecase. Global drop_caches is a terrible
> > > > > > > interface and it has caused many problems in the past. People have
> > > > > > > learned to use it as a remedy to any problem they might see and cause
> > > > > > > other problems without realizing that. This is the reason why we even
> > > > > > > log each attempt to drop caches.
> > > > > > >
> > > > > > > I would rather not repeat the same mistake on the memcg level unless
> > > > > > > there is a very strong reason for it.
> > > > > > >
> > > > > >
> > > > > > I think we'd better add these comments above the function
> > > > > > mem_cgroup_force_empty() to explain why we don't want to expose this
> > > > > > interface in cgroup2, otherwise people will continue to send this
> > > > > > proposal without any strong reason.
> > > > >
> > > > > I do not mind people sending this proposal.  "V1 used to have an
> > > > > interface, we need it in v2 as well" is not really viable without
> > > > > providing more reasoning on the specific usecase.
> > > > >
> > > > > _Any_ patch should have a proper justification. This is nothing really
> > > > > new to the process and I am wondering why this is coming as a surprise.
> > > > >
> > > >
> > > > Container users always want to drop cache in a specific container,
> > > > because they used to use drop_caches to fix memory pressure issues.
> > >
> > > This is exactly the kind of problems we have seen in the past. There
> > > should be zero reason to addre potential reclaim problems by dropping
> > > page cache on the floor. There is a huge cargo cult about this
> > > procedure and I have seen numerous reports when people complained about
> > > performance afterwards just to learn that the dropped page cache was one
> > > of the resons for that.
> > >
> > > > Although drop_caches can cause some unexpected issues, it could also
> > > > fix some issues.
> > >
> > > "Some issues" is way too general. We really want to learn about those
> > > issues and address them properly.
> > >
> >
> > One use case in our production environment is that some of our tasks
> > become very latency sensitive from 7am to 10am, so before these tasks
> > become active we will use drop_caches to drop page caches generated by
> > other tasks at night to avoid these tasks triggering direct reclaim.
> >
> > The best way to do it is to fix the latency in direct reclaim, but it
> > will take great effort.
>
> What is the latency triggered by the memory reclaim? It should be mostly
> a clean page cache right as drop_caches only drops clean pages. Or is
> this more about [id]cache? Do you have any profiles where is the time
> spent?
>

Yes, we have analyzed the issues in the direct reclaim, but that is
not the point.
The point is that each case may take us several days to analyze, while
the user can't wait, so they will use drop_caches to workaround it
until we find the solution.

> > while drop_caches give us an easier way to achieve the same goal.
>
> It papers over real problems and that is my earlier comment about.
>
> > IOW, drop_caches give the users an option to achieve their goal before
> > they find a better solution.
>
> You can achieve the same by a different configuration already. You can
> isolate your page cache hungry overnight (likely a backup) workload into
> its own memcg. You can either use an aggressive high limit during the
> run or simply reduce the high/max limit after the work is done.
>
> If you cannot isolate that easily then you can lower high limit
> temporarily before your peak workload.
>

Right, there're many better solutions if you have _enough_ time.
But as I described above, the user needs to fix it ASAP before you
find a better solution.

> Really throwing all the page cache away just to prepare for a peak
> workload sounds like a bad idea to me. You are potentially throwing
> data that you have to spend time to refault again.

If some tasks work at night but idle at day, while the others work at
day but idle at night, it is not bad to drop all caches when you
switch the workload.
It may be useless to drop these caches, but these caches are really
useless for the next workload.

-- 
Thanks
Yafang
