From: Chris Down <chris@chrisdown.name>
Subject: Re: [External] Re: [PATCH] mm/memcontrol: Add the drop_cache
 interface for cgroup v2
Date: Tue, 22 Sep 2020 10:51:36 +0100
Message-ID: <20200922095136.GA9682@chrisdown.name>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz>
 <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz>
 <CAKRVAeN5U6S78jF1n8nCs5ioAdqvVn5f6GGTAnA93g_J0daOLw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=vLhN/ucVLfE69Dl/WKI0HEpcS5fMQFDATogS8fruK+Y=;
        b=kWC+smJjtT0c9St6jcuRKFe+iC/3MNGMO2hzLmI4h3ukWa//TYGeZk5SPv1bkUzYpe
         Piq5Gfchg23WCZ9wQAwQMGNwS3SbNdcaDAC2Az/+yjW8h+MjYeKt2dW1g/mome8M5EMI
         iHbdhnfc6dBx+c0BNKdqAlSk0ap/1jplkFecY=
Content-Disposition: inline
In-Reply-To: <CAKRVAeN5U6S78jF1n8nCs5ioAdqvVn5f6GGTAnA93g_J0daOLw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Chunxin Zang <zangchunxin@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>, Yafang Shao <laoar.shao@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Jonathan Corbet <corbet@lwn.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org

Chunxin Zang writes:
>My usecase is that there are two types of services in one server. They
>have difference
>priorities. Type_A has the highest priority, we need to ensure it's
>schedule latency、I/O
>latency、memory enough. Type_B has the lowest priority, we expect it
>will not affect
>Type_A when executed.
>So Type_A could use memory without any limit. Type_B could use memory
>only when the
>memory is absolutely sufficient. But we cannot estimate how much
>memory Type_B should
>use. Because everything is dynamic. So we can't set Type_B's memory.high.
>
>So we want to release the memory of Type_B when global memory is
>insufficient in order
>to ensure the quality of service of Type_A . In the past, we used the
>'force_empty' interface
>of cgroup v1.

This sounds like a perfect use case for memory.low on Type_A, and it's pretty 
much exactly what we invented it for. What's the problem with that?
