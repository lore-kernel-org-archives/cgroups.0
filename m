From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for
 bpf map
Date: Wed, 7 Sep 2022 15:28:53 -0700
Message-ID: <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
 <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662589753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I1yxj38W9LLCjnCLzWIfLwcTDKqLav/lxTozk1c1g/I=;
        b=cnV9/bLAglNubg1YwGbWHhR5c6MxCQUpK8c/LmjtAgg0I61ifYF43G6tihLY8hrcN7hlHT
        khUhhtSDN0Xlgt6WlQAC0Xlj76xzCuUMt1VcEnCtvQRk0/rc8BXjMAMggDJ+qRupn5BGOg
        +CPlIh3epn0VqimtvaJOVDxfjWsnmVU=
Content-Disposition: inline
In-Reply-To: <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, shakeelb@google.com, songmuchun@bytedance.com, akpm@linux-foundation.org, lizefan.x@bytedance.com, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org

On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> ...
> > This patchset tries to resolve the above two issues by introducing a
> > selectable memcg to limit the bpf memory. Currently we only allow to
> > select its ancestor to avoid breaking the memcg hierarchy further. 
> > Possible use cases of the selectable memcg as follows,
> 
> As discussed in the following thread, there are clear downsides to an
> interface which requires the users to specify the cgroups directly.
> 
>  https://lkml.kernel.org/r/YwNold0GMOappUxc@slm.duckdns.org
> 
> So, I don't really think this is an interface we wanna go for. I was hoping
> to hear more from memcg folks in the above thread. Maybe ping them in that
> thread and continue there?

As I said previously, I don't like it, because it's an attempt to solve a non
bpf-specific problem in a bpf-specific way.

Yes, memory cgroups are not great for accounting of shared resources, it's well
known. This patchset looks like an attempt to "fix" it specifically for bpf maps
in a particular cgroup setup. Honestly, I don't think it's worth the added
complexity. Especially because a similar behaviour can be achieved simple
by placing the task which creates the map into the desired cgroup.
Beatiful? Not. Neither is the proposed solution.

Thanks!
