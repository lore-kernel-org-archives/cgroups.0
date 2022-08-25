From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFD RESEND] cgroup: Persistent memory usage tracking
Date: Thu, 25 Aug 2022 07:59:42 -1000
Message-ID: <Ywe4jlSvu5rC44+1@slm.duckdns.org>
References: <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
 <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org>
 <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
 <YwNold0GMOappUxc@slm.duckdns.org>
 <CAHS8izNvEpX3Lv7eFn-vu=4ZT96Djk2dU-VU+zOueZaZZbnWNw@mail.gmail.com>
 <YwPy9hervVxfuuYE@cmpxchg.org>
 <YwRDFe+K837tKGED@P9FQF9L96D>
 <YwRF+df9P2TPu7Zw@slm.duckdns.org>
 <CAHS8izMFMtM5ry12iEo72nwkynDpgycETn6QoXLGj=O6b8z1jg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=Oidv9VqQ5BZvp2nfE+LkznopgBMVvrufzEclz2gYRyo=;
        b=Bj5Iv6LvIYj0/8CnpMN6CDJnlruw5qIUhOj9Sta6KqtxRxUVavkcpyn9tcVP2uBZa3
         4v/gRXwe1SSJikUYjoM908yOqA7T0hS1Wj62M/MB83e+u64jPjC7Ig1YejWc4TfhPTuz
         FX2WkffIAkDHnfEJ21KSkPh4ME9fQyubJ6Y5jTsOmiVahmE09XOeG6NQH9xHMMnhhOTz
         xybdhkL/6qnCoT4lWcS9WH2Q1uxJ5TQvTTEUNuU0JwaJECQCXpwCcVW2zWdVTSMy+ZLV
         uQW7SdkBNItNHAvYtKkyW0UDXQ3jxq7uWyx2nrFfqNFB2ZKPe2Q6cxM+WWuFGPHqfD9A
         n7rA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAHS8izMFMtM5ry12iEo72nwkynDpgycETn6QoXLGj=O6b8z1jg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Yafang Shao <laoar.shao@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, john fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, jolsa@kernel.org, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Zefan Li <lizefan.x@bytedance.com>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>

Hello,

On Wed, Aug 24, 2022 at 12:02:04PM -0700, Mina Almasry wrote:
> > If we can express all the resource contraints and structures in the cgroup
> > side and configured by the management agent, the application can simply e.g.
> > madvise whatever memory region or flag bpf maps as "these are persistent"
> > and the rest can be handled by the system. If the agent set up the
> > environment for that, it gets accounted accordingly; otherwise, it'd behave
> > as if those tagging didn't exist. Asking the application to set up all its
> > resources in separate steps, that might require significant restructuring
> > and knowledge of how the hierarchy is setup in many cases.
> 
> I don't know if this level of granularity is needed with a madvise()
> or such. The kernel knows whether resources are persistent due to the
> nature of the resource. For example a shared tmpfs file is a resource
> that is persistent and not cleaned up after the process using it dies,
> but private memory is. madvise(PERSISTENT) on private memory would not
> make sense, and I don't think madvise(NOT_PERSISTENT) on tmpfs-backed
> memory region would make sense. Also, this requires adding madvise()
> hints in userspace code to leverage this.

I haven't thought hard about what the hinting interface should be like. The
default assumptions would be that page cache belongs to the persistent
domain and anon belongs to the instance (mm folks, please correct me if I'm
off the rails here), but I can imagine situations where that doesn't
necessarily hold - like temp files which get unlinked on instance shutdown.

In terms of hint granularity, more coarse grained (e.g. file, mount
whatever) seems to make sense but again I haven't thought too hard on it.
That said, as long as the default behavior is reasonable, I think adding
some hinting calls in the application is acceptable. It doesn't require any
structrual changes and the additions would be for its own benefit of more
accurate accounting and control. That makes sense to me.

One unfortunate effect this will have is that we'll be actively putting
resources into intermediate cgroups. This already happens today but if we
support persistent domains, it's gonna be a lot more prevalent and we'll
need to update e.g. iocost to support IOs coming out of intermediate
cgroups. This kinda sucks because we don't even have knobs to control self
vs. children distributions. Oh well...

Thanks.

-- 
tejun
