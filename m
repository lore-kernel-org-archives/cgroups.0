From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH] mm, memcg: expose swapcache stat for memcg v1
Date: Tue, 26 Sep 2023 01:22:47 -0700
Message-ID: <CAJD7tkYY7je3x-MRhayyrC0xCFvKZO8CuiEnQHanF5_ErZ2n6Q@mail.gmail.com>
References: <20230902100728.3850149-1-liushixin2@huawei.com> <ZRKIdTE+4cm0KDCI@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695716606; x=1696321406; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j9tTw5sUAPOrchYqA3E5owwjKmHdzzHpZh+gEC9Bxy8=;
        b=sIrkm5fnHq62gxdiLho0PUJxuyqiaaJhNCpRLVeRdyS3virxw6FMkSakOFNGstwHnS
         IJPKspbKgEjUgDLxLHFXVYyiFL/JD7ZE2yYvv7Ibl8wXqFn5uhZBsESOhUXc4ABULXRk
         1PFIQIPxPFZjjiWMloZICYiMEyArrl5WDO1WMb3G5tNUe3Eogh0p4bDqNqvIaarsa8Sb
         tKf/UajuXwcYyjlO4N7Tm85kjCfeOJ/WDXs1+LWOD7a+p0IngBsXa0b0JX7jbS0qoHjA
         OQw9rcWdDar/GyM9lN9X4vssT3B20Psu6yLOKtbZ9eS8g980fenMlTfo40+Ckbb3hC14
         msrQ==
In-Reply-To: <ZRKIdTE+4cm0KDCI@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch@infradead.org>
Cc: Liu Shixin <liushixin2@huawei.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Kefeng Wang <wangkefeng.wang@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Tue, Sep 26, 2023 at 12:30=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Sat, Sep 02, 2023 at 06:07:28PM +0800, Liu Shixin wrote:
> > Since commit b6038942480e ("mm: memcg: add swapcache stat for memcg v2"=
)
> > adds swapcache stat for the cgroup v2, it seems there is no reason to
> > hide it in memcg v1. Conversely, with swapcached it is more accurate to
> > evaluate the available memory for memcg.
>
> Why are we adding new features to the long deprecated cgroup v1?
>

Technically this is not a new feature, we are just exposing a stat
that the kernel is already tracking (for both cgroup v1 and v2).

The reason I suggested to expose this for cgroup v1 is because a
recent series [1] started using this stat in the kernel to make some
reclaim decisions, for both cgroup v1 and v2. Exposing the stat in v1
will make sure no one assumes the stat is only useful for v2 and break
the tracking for v1 (which might cause some reclaim regressions then).

[1]https://lore.kernel.org/lkml/20230915083417.3190512-1-liushixin2@huawei.=
com/
