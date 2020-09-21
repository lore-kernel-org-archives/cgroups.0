From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] mm/memcontrol: Add the drop_cache interface for cgroup v2
Date: Mon, 21 Sep 2020 13:05:05 +0200
Message-ID: <20200921110505.GH12990@dhcp22.suse.cz>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz>
 <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600686306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JbHgBz0aomN5pIFfxuOnm8ox/XRaHVRuL/a8R/t+W4A=;
        b=eL+FH/xVmyP8IdigcZ5a4u7kHJf6RwmLhlfQwsnfcss6tnGPYKb5I4tNsxdX5ShApxJwD4
        PoNov/l7i+HWrjj4fhL8wEUmOToZ/ce5LA7BF7H9V+YAwudUts6p0uOo6Hor6UobHAXM0I
        BZqmvLSBzfoozCfUeXbV/WJmM/GA+7M=
Content-Disposition: inline
In-Reply-To: <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: zangchunxin@bytedance.com, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Jonathan Corbet <corbet@lwn.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org

On Mon 21-09-20 18:55:40, Yafang Shao wrote:
> On Mon, Sep 21, 2020 at 4:12 PM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Mon 21-09-20 16:02:55, zangchunxin@bytedance.com wrote:
> > > From: Chunxin Zang <zangchunxin@bytedance.com>
> > >
> > > In the cgroup v1, we have 'force_mepty' interface. This is very
> > > useful for userspace to actively release memory. But the cgroup
> > > v2 does not.
> > >
> > > This patch reuse cgroup v1's function, but have a new name for
> > > the interface. Because I think 'drop_cache' may be is easier to
> > > understand :)
> >
> > This should really explain a usecase. Global drop_caches is a terrible
> > interface and it has caused many problems in the past. People have
> > learned to use it as a remedy to any problem they might see and cause
> > other problems without realizing that. This is the reason why we even
> > log each attempt to drop caches.
> >
> > I would rather not repeat the same mistake on the memcg level unless
> > there is a very strong reason for it.
> >
> 
> I think we'd better add these comments above the function
> mem_cgroup_force_empty() to explain why we don't want to expose this
> interface in cgroup2, otherwise people will continue to send this
> proposal without any strong reason.

I do not mind people sending this proposal.  "V1 used to have an
interface, we need it in v2 as well" is not really viable without
providing more reasoning on the specific usecase.

_Any_ patch should have a proper justification. This is nothing really
new to the process and I am wondering why this is coming as a surprise.

-- 
Michal Hocko
SUSE Labs
