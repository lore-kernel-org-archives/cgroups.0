From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup/cpuset: introduce cpuset.mems.migration
Date: Tue, 27 Apr 2021 10:43:31 -0400
Message-ID: <YIgjE6CgU4nDsJiR@slm.duckdns.org>
References: <20210426065946.40491-1-wuyun.abel@bytedance.com>
 <20210426065946.40491-3-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LjEjIzfJA5KpJv/2vrQIbqJyINd5uBvKHBOwXFK4cmg=;
        b=UfjKZXQgIFJ/QoFLh4LdDInp1ZFrKTBWFrDnfd9PYx50iwg7P4068CGLxLxyqvB6HR
         E5zPZ+36iFhlDwhZWQ5hljKXDXdRrzQq9kHdktL3oQ77hML0nySMN3kUELGojr2B/ZyR
         Y2lLPGmylOXLTwPt79TlAhSGPBfCzeuGWj59Hfvs35GWmeyspiP1g04ozHoQVsh/oNqW
         RPmwxkbA2Hfyckn9PULtvNVHNcvotFHbUisOfJAKV4k5tdoUtKUMKS+8Ai8VZu1yzrQX
         DQAgxK1PgW37F/ZH9XO8H4K8ZygoSh8DnVwmIo0PHtd015RSc99y5kqLcvFdk0D3mcAH
         YKWg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210426065946.40491-3-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Apr 26, 2021 at 02:59:45PM +0800, Abel Wu wrote:
> When a NUMA node is assigned to numa-service, the workload
> on that node needs to be moved away fast and complete. The
> main aspects we cared about on the eviction are as follows:
>=20
> a) it should complete soon enough so that numa-services
>    won=E2=80=99t wait too long to hurt user experience
> b) the workloads to be evicted could have massive usage on
>    memory, and migrating such amount of memory may lead to
>    a sudden severe performance drop lasting tens of seconds
>    that some certain workloads may not afford
> c) the impact of the eviction should be limited within the
>    source and destination nodes
> d) cgroup interface is preferred
>=20
> So we come to a thought that:
>=20
> 1) fire up numa-services without waiting for memory migration
> 2) memory migration can be done asynchronously by using spare
>    memory bandwidth
>=20
> AutoNUMA seems to be a solution, but its scope is global which
> violates c&d. And cpuset.memory_migrate performs in a synchronous

I don't think d) in itself is a valid requirement. How does it violate c)?

> fashion which breaks a&b. So a mixture of them, the new cgroup2
> interface cpuset.mems.migration, is introduced.
>=20
> The new cpuset.mems.migration supports three modes:
>=20
>  - "none" mode, meaning migration disabled
>  - "sync" mode, which is exactly the same as the cgroup v1
>    interface cpuset.memory_migrate
>  - "lazy" mode, when walking through all the pages, unlike
>    cpuset.memory_migrate, it only sets pages to protnone,
>    and numa faults triggered by later touch will handle the
>    movement.

cpuset is already involved in NUMA allocation but it always felt like
something bolted on - it's weird to have cpu to NUMA node settings at global
level and then to have possibly conflicting direct NUMA configuration via
cpuset. My preference would be putting as much configuration as possible on
the mm / autonuma side and let cpuset's node confinements further restrict
their operations rather than cpuset having its own set of policy
configurations.

Johannes, what are your thoughts?

Thanks.

--=20
tejun
