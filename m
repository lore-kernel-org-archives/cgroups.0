From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] mm/memcontrol: Add the drop_cache interface for cgroup v2
Date: Mon, 21 Sep 2020 19:23:01 +0800
Message-ID: <CALOAHbCDXwjN+WDSGVv+G3ho-YRRPjAAqMJBtyxeGHH6utb5ew@mail.gmail.com>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz> <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jylsjxure8iloHgTv6dK8e3IpVuFYGMIH7w1sVGlBAw=;
        b=nqLrdxvYUsrTTUgEz8hFcvRTwfimgRk7PIAWUsvqWfJXTlPGfflwm8mzXT8aa2KY2P
         68uE0ItUG43PEBQHvQz0n5LfzcY5Vinp3+0+N/mi9FzOG6wN7RalWfeVlXnWsudjvjLp
         azA/VpQMdPVNfv0XmXevqqOz8FpUze8tuIoBUenMuu9HhVDRlzMDoeTwUTGMvMguTp/z
         8XEmLlOEvu1vFSu26V/SA8TWV2zWBUcmtuQOOj/8mT/j0oWnquMpxzpvNWBy+D2FVLw5
         URhzLqfaOkxtFGFL0xgduy16DEHqIIA4K/3Dp3aKV72mKsmud58QrDiQCeOAcPvNt6ik
         /HCA==
In-Reply-To: <20200921110505.GH12990@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: zangchunxin@bytedance.com, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Jonathan Corbet <corbet@lwn.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org

On Mon, Sep 21, 2020 at 7:05 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Mon 21-09-20 18:55:40, Yafang Shao wrote:
> > On Mon, Sep 21, 2020 at 4:12 PM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Mon 21-09-20 16:02:55, zangchunxin@bytedance.com wrote:
> > > > From: Chunxin Zang <zangchunxin@bytedance.com>
> > > >
> > > > In the cgroup v1, we have 'force_mepty' interface. This is very
> > > > useful for userspace to actively release memory. But the cgroup
> > > > v2 does not.
> > > >
> > > > This patch reuse cgroup v1's function, but have a new name for
> > > > the interface. Because I think 'drop_cache' may be is easier to
> > > > understand :)
> > >
> > > This should really explain a usecase. Global drop_caches is a terrible
> > > interface and it has caused many problems in the past. People have
> > > learned to use it as a remedy to any problem they might see and cause
> > > other problems without realizing that. This is the reason why we even
> > > log each attempt to drop caches.
> > >
> > > I would rather not repeat the same mistake on the memcg level unless
> > > there is a very strong reason for it.
> > >
> >
> > I think we'd better add these comments above the function
> > mem_cgroup_force_empty() to explain why we don't want to expose this
> > interface in cgroup2, otherwise people will continue to send this
> > proposal without any strong reason.
>
> I do not mind people sending this proposal.  "V1 used to have an
> interface, we need it in v2 as well" is not really viable without
> providing more reasoning on the specific usecase.
>
> _Any_ patch should have a proper justification. This is nothing really
> new to the process and I am wondering why this is coming as a surprise.
>

Container users always want to drop cache in a specific container,
because they used to use drop_caches to fix memory pressure issues.
Although drop_caches can cause some unexpected issues, it could also
fix some issues. So container users want to use it in containers as
well.
If this feature is not implemented in cgroup, they will ask you why
but there is no explanation in the kernel.

Regarding the memory.high, it is not perfect as well, because you have
to set it to 0 to drop_caches, and the processes in the containers
have to reclaim pages as well because they reach the memory.high, but
memory.force_empty won't make other processes to reclaim.

That doesn't mean I agree to add this interface, while I really mean
that if we discard one feature we'd better explain why.

-- 
Thanks
Yafang
