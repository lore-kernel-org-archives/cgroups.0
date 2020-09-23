From: Chunxin Zang <zangchunxin@bytedance.com>
Subject: Re: [External] Re: [PATCH] mm/memcontrol: Add the drop_cache
 interface for cgroup v2
Date: Wed, 23 Sep 2020 10:35:29 +0800
Message-ID: <CAKRVAeNCAVN4qOc57AU_-2dJ8sOT7p6JSO578aD0Seveuv0Rog@mail.gmail.com>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz> <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz> <CAKRVAeN5U6S78jF1n8nCs5ioAdqvVn5f6GGTAnA93g_J0daOLw@mail.gmail.com>
 <20200922095136.GA9682@chrisdown.name> <CAKRVAePisoOg8QBz11gPqzEoUdwPiJ-9Z9MyFE2LHzR-r+PseQ@mail.gmail.com>
 <20200922104252.GB9682@chrisdown.name> <CAKRVAeOjST1vJsSXMgj91=tMf1MQTeNp_dz34z=DwL7Weh0bmg@mail.gmail.com>
 <20200922124344.GA34296@chrisdown.name>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HNLILPO9KGBr2EiE7fPnteeqqVFqeTm0/utbd5V0UfM=;
        b=gpENJad7aIY/S5kBL5o8YVttNP6P373hhEXKz6ErBwsU/D+zf22imm1nkW4ERBaSHD
         zpAbAVk6UoSZYDLYJDZkFGLPhDVWGMO30j0pUcW7h49Tryqf3NzJu4RZcL1iD02GoqA6
         MG4REMrV1LplGXzEGHcMfLHjAQZ1DpNK4aAMFIQctSZ6kzBGbm0dg2ZTVSIvvckdxqRX
         A8p1DU39WBmIgc/L4nnjM4X9tMLRq8LvlGdaeOQbqxSz6Ff+SemO4COh6UTnhUpLf6VS
         txktKu+z0qVosUhE2kp0VE8x0/fTRFl8/cXeYa/Z0ziyNv7xI9D9QFTcZQvRCBscssRC
         /Uug==
In-Reply-To: <20200922124344.GA34296@chrisdown.name>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Michal Hocko <mhocko@suse.com>, Yafang Shao <laoar.shao@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Jonathan Corbet <corbet@lwn.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org

On Tue, Sep 22, 2020 at 8:43 PM Chris Down <chris@chrisdown.name> wrote:
>
> Chunxin Zang writes:
> >Please forgive me for not being able to understand why setting
> >memory.low for Type_A can solve the problem.
> >In my scene, Type_A is the most important, so I will set 100G to memory.low.
> >But 'memory.low' only takes effect passively when the kernel is
> >reclaiming memory. It means that reclaim Type_B's memory only when
> >Type_A  in alloc memory slow path. This will affect Type_A's
> >performance.
> >We want to reclaim Type_B's memory in advance when A is expected to be busy.
>
> That's what kswapd reclaim is for, so this distinction is meaningless without
> measurements :-)

Thanks for these suggestions, I will give it a try.

Best wishes
Chunxin
