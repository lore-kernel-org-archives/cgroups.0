From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [RFC PATCH 0/3] cgroup: fsio throttle controller
Date: Fri, 18 Jan 2019 12:04:17 +0100
Message-ID: <E5872191-EE96-442E-B668-DD148157E665@linaro.org>
References: <20190118103127.325-1-righi.andrea@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=REsuoknvb/3a2B+SDLFUMAUKbWrBKWE0r2peyl8vGtg=;
        b=Q8ilU4VaiYC5KjBHvv91+MzS+PG8Axat78nK4i7W+o5D98gCncPk87LRZh2li+zcQU
         0IpLWpQ6zgDg5i2HMnZ5jGVUuRGvb+2+9i0nJInd/4NkOlb86PcL9UFjK/3Uj92aAIUT
         dz4MbIlDrwI2vjcLH6e4cKZ636/X6uTk4fpvA=
In-Reply-To: <20190118103127.325-1-righi.andrea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Josef Bacik <josef@toxicpanda.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



> Il giorno 18 gen 2019, alle ore 11:31, Andrea Righi =
<righi.andrea@gmail.com> ha scritto:
>=20
> This is a redesign of my old cgroup-io-throttle controller:
> https://lwn.net/Articles/330531/
>=20
> I'm resuming this old patch to point out a problem that I think is =
still
> not solved completely.
>=20
> =3D Problem =3D
>=20
> The io.max controller works really well at limiting synchronous I/O
> (READs), but a lot of I/O requests are initiated outside the context =
of
> the process that is ultimately responsible for its creation (e.g.,
> WRITEs).
>=20
> Throttling at the block layer in some cases is too late and we may end
> up slowing down processes that are not responsible for the I/O that
> is being processed at that level.
>=20
> =3D Proposed solution =3D
>=20
> The main idea of this controller is to split I/O measurement and I/O
> throttling: I/O is measured at the block layer for READS, at page =
cache
> (dirty pages) for WRITEs, and processes are limited while they're
> generating I/O at the VFS level, based on the measured I/O.
>=20

Hi Andrea,
what the about the case where two processes are dirtying the same
pages?  Which will be charged?

Thanks,
Paolo

> =3D Example =3D
>=20
> Here's a trivial example: create 2 cgroups, set an io.max limit of
> 10MB/s, run a write-intensive workload on both and after a while, from =
a
> root cgroup, run "sync".
>=20
> # cat /proc/self/cgroup
> 0::/cg1
> # fio --rw=3Dwrite --bs=3D1M --size=3D32M --numjobs=3D16 --name=3Dseeker=
 --time_based --runtime=3D30
>=20
> # cat /proc/self/cgroup
> 0::/cg2
> # fio --rw=3Dwrite --bs=3D1M --size=3D32M --numjobs=3D16 --name=3Dseeker=
 --time_based --runtime=3D30
>=20
> - io.max controller:
>=20
> # echo "259:0 rbps=3D10485760 wbps=3D10485760" > =
/sys/fs/cgroup/unified/cg1/io.max
> # echo "259:0 rbps=3D10485760 wbps=3D10485760" > =
/sys/fs/cgroup/unified/cg2/io.max
>=20
> # cat /proc/self/cgroup
> 0::/
> # time sync
>=20
> real	0m51,241s
> user	0m0,000s
> sys	0m0,113s
>=20
> Ideally "sync" should complete almost immediately, because the root
> cgroup is unlimited and it's not doing any I/O at all, but instead =
it's
> blocked for more than 50 sec with io.max, because the writeback is
> throttled to satisfy the io.max limits.
>=20
> - fsio controller:
>=20
> # echo "259:0 10 10" > /sys/fs/cgroup/unified/cg1/fsio.max_mbs
> # echo "259:0 10 10" > /sys/fs/cgroup/unified/cg2/fsio.max_mbs
>=20
> [you can find details about the syntax in the documentation patch]
>=20
> # cat /proc/self/cgroup
> 0::/
> # time sync
>=20
> real	0m0,146s
> user	0m0,003s
> sys	0m0,001s
>=20
> =3D Questions =3D
>=20
> Q: Do we need another controller?
> A: Probably no, I think it would be better to integrate this policy =
(or
>   something similar) in the current blkio controller, this is just to
>   highlight the problem and get some ideas on how to address it.
>=20
> Q: What about proportional limits / latency?
> A: It should be trivial to add latency-based limits if we integrate =
this in the
>   current I/O controller. About proportional limits (weights), they're
>   strictly related to I/O scheduling and since this controller doesn't =
touch
>   I/O dispatching policies it's not trivial to implement proportional =
limits
>   (bandwidth limiting is definitely more straightforward).
>=20
> Q: Applying delays at the VFS layer doesn't prevent I/O spikes during
>   writeback, right?
> A: Correct, the tradeoff here is to tolerate I/O bursts during =
writeback to
>   avoid priority inversion problems in the system.
>=20
> Andrea Righi (3):
>  fsio-throttle: documentation
>  fsio-throttle: controller infrastructure
>  fsio-throttle: instrumentation
>=20
> Documentation/cgroup-v1/fsio-throttle.txt | 142 +++++++++
> block/blk-core.c                          |  10 +
> include/linux/cgroup_subsys.h             |   4 +
> include/linux/fsio-throttle.h             |  43 +++
> include/linux/writeback.h                 |   7 +-
> init/Kconfig                              |  11 +
> kernel/cgroup/Makefile                    |   1 +
> kernel/cgroup/fsio-throttle.c             | 501 =
++++++++++++++++++++++++++++++
> mm/filemap.c                              |  20 +-
> mm/page-writeback.c                       |  14 +-
> 10 files changed, 749 insertions(+), 4 deletions(-)
>=20

