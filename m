From: Chris Down <chris@chrisdown.name>
Subject: Re: [External] Re: [PATCH] mm/memcontrol: Add the drop_cache
 interface for cgroup v2
Date: Tue, 22 Sep 2020 13:43:44 +0100
Message-ID: <20200922124344.GA34296@chrisdown.name>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz>
 <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz>
 <CAKRVAeN5U6S78jF1n8nCs5ioAdqvVn5f6GGTAnA93g_J0daOLw@mail.gmail.com>
 <20200922095136.GA9682@chrisdown.name>
 <CAKRVAePisoOg8QBz11gPqzEoUdwPiJ-9Z9MyFE2LHzR-r+PseQ@mail.gmail.com>
 <20200922104252.GB9682@chrisdown.name>
 <CAKRVAeOjST1vJsSXMgj91=tMf1MQTeNp_dz34z=DwL7Weh0bmg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EZVYPQDM745h290MwDvoCECH4RGR18nCNuRmCWFdNCw=;
        b=u3lMp8TydI2QP6QNm/pAfrLJ7GK81BNOYZKPoUBMxHXf4Zv6JaWyqYjI6FQPcXhjzp
         1zO/CvtrgtTa4Fi3WVskIRg9vs7l9p0r8mVyusxvjIvYBobSb98S1lsxHtK9IV8Sz0n5
         D5Vu7pA2LMs/XlZnl0jLCRk7QR2nUmaVMGDC8=
Content-Disposition: inline
In-Reply-To: <CAKRVAeOjST1vJsSXMgj91=tMf1MQTeNp_dz34z=DwL7Weh0bmg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Chunxin Zang <zangchunxin@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>, Yafang Shao <laoar.shao@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Jonathan Corbet <corbet@lwn.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org

Chunxin Zang writes:
>Please forgive me for not being able to understand why setting
>memory.low for Type_A can solve the problem.
>In my scene, Type_A is the most important, so I will set 100G to memory.low.
>But 'memory.low' only takes effect passively when the kernel is
>reclaiming memory. It means that reclaim Type_B's memory only when
>Type_A  in alloc memory slow path. This will affect Type_A's
>performance.
>We want to reclaim Type_B's memory in advance when A is expected to be busy.

That's what kswapd reclaim is for, so this distinction is meaningless without 
measurements :-)
