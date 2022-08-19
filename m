From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for bpf map
Date: Fri, 19 Aug 2022 08:59:20 +0800
Message-ID: <CALOAHbDt9NUv9qK_J1_9CU0tmW9kiJ+nig_0NfzGJgJmrSk2fw@mail.gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com> <Yv67MRQLPreR9GU5@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=XmfAUBn1gArqpjhXlxsozSzKVKhtwcuq/x+I+Cb3JzY=;
        b=Qo3NPm1+YvEv8c/eNWWuQFae5XughAMFYdkSqiR35cDKbnL8eJWtPd0Qvb5yLNCtMC
         0yZnB5M4GAGOEqeZ6Y3z5l6Xnr5D2ly83lWAX3lQmYV+Cd7UO/2krUBvtRMrdjf/GWZM
         KIt5Zfdjv1m1Br4cZlsYbCTFbYv/lOmKgYjnqyqKQGqW8bjmYPopiDWCj0L9VoQXlo0E
         8bzWAqhogkYmdRNYJDWi05oP9XPaZWRT8LUFfgst0CIC3mIRU6GJKnueDWqUioS5Efub
         xXxg6xCAZ+pX8K/X2jQ7JHrX50aTo7L9D23bKrhlSF3HnWi8sZ92KFjfYELFZBqadizo
         VkbQ==
In-Reply-To: <Yv67MRQLPreR9GU5@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, john fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, jolsa@kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, lizefan.x@bytedance.com, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On Fri, Aug 19, 2022 at 6:20 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Thu, Aug 18, 2022 at 02:31:06PM +0000, Yafang Shao wrote:
> > After switching to memcg-based bpf memory accounting to limit the bpf
> > memory, some unexpected issues jumped out at us.
> > 1. The memory usage is not consistent between the first generation and
> > new generations.
> > 2. After the first generation is destroyed, the bpf memory can't be
> > limited if the bpf maps are not preallocated, because they will be
> > reparented.
> >
> > This patchset tries to resolve these issues by introducing an
> > independent memcg to limit the bpf memory.
>
> memcg folks would have better informed opinions but from generic cgroup pov
> I don't think this is a good direction to take. This isn't a problem limited
> to bpf progs and it doesn't make whole lot of sense to solve this for bpf.
>

This change is bpf specific. It doesn't refactor a whole lot of things.

> We have the exact same problem for any resources which span multiple
> instances of a service including page cache, tmpfs instances and any other
> thing which can persist longer than procss life time. My current opinion is
> that this is best solved by introducing an extra cgroup layer to represent
> the persistent entity and put the per-instance cgroup under it.
>

It is not practical on k8s.
Because, before the persistent entity, the cgroup dir is stateless.
After, it is stateful.
Pls, don't continue keeping blind eyes on k8s.

> It does require reorganizing how things are organized from userspace POV but
> the end result is really desirable. We get entities accurately representing
> what needs to be tracked and control over the granularity of accounting and
> control (e.g. folks who don't care about telling apart the current
> instance's usage can simply not enable controllers at the persistent entity
> level).
>

Pls.s also think about why k8s refuse to use cgroup2.

> We surely can discuss other approaches but my current intuition is that it'd
> be really difficult to come up with a better solution than layering to
> introduce persistent service entities.
>
> So, please consider the approach nacked for the time being.
>

It doesn't make sense to nack it.
I will explain to you by replying to your other email.

-- 
Regards
Yafang
