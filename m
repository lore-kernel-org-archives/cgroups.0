From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [RFC PATCH 0/3] cgroup: fsio throttle controller
Date: Fri, 18 Jan 2019 18:07:45 +0100
Message-ID: <F576C256-A032-4E62-99EA-F60162B6E069@linaro.org>
References: <20190118103127.325-1-righi.andrea@gmail.com>
 <20190118163530.w5wpzpjkcnkektsp@macbook-pro-91.dhcp.thefacebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=gyQDSAb68RQOHEAGcpAMGbpY6osDtgIRCykF1IhHNwM=;
        b=HU9kyzdLG8Vdjse4wbAw07vOaJh5Si9/j3EQ7hPP6b7u4jYzJlRmo3MCmEQcCJvE0L
         7yJxYZkvpWXG2dLi2D6UO67yRGR6drNNVltyvlQ7rKp9J18InsoWD/DMPREGkJ9fgPIT
         hnLAokuARJ1ILwmuwuX6PHhtfXT9avcdZKzNs=
In-Reply-To: <20190118163530.w5wpzpjkcnkektsp@macbook-pro-91.dhcp.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrea Righi <righi.andrea@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



> Il giorno 18 gen 2019, alle ore 17:35, Josef Bacik =
<josef@toxicpanda.com> ha scritto:
>=20
> On Fri, Jan 18, 2019 at 11:31:24AM +0100, Andrea Righi wrote:
>> This is a redesign of my old cgroup-io-throttle controller:
>> https://lwn.net/Articles/330531/
>>=20
>> I'm resuming this old patch to point out a problem that I think is =
still
>> not solved completely.
>>=20
>> =3D Problem =3D
>>=20
>> The io.max controller works really well at limiting synchronous I/O
>> (READs), but a lot of I/O requests are initiated outside the context =
of
>> the process that is ultimately responsible for its creation (e.g.,
>> WRITEs).
>>=20
>> Throttling at the block layer in some cases is too late and we may =
end
>> up slowing down processes that are not responsible for the I/O that
>> is being processed at that level.
>=20
> How so?  The writeback threads are per-cgroup and have the cgroup =
stuff set
> properly.  So if you dirty a bunch of pages, they are associated with =
your
> cgroup, and then writeback happens and it's done in the writeback =
thread
> associated with your cgroup and then that is throttled.  Then you are =
throttled
> at balance_dirty_pages() because the writeout is taking longer.
>=20

IIUC, Andrea described this problem: certain processes in a certain =
group dirty a
lot of pages, causing write back to start.  Then some other blameless
process in the same group experiences very high latency, in spite of
the fact that it has to do little I/O.

Does your blk_cgroup_congested() stuff solves this issue?

Or simply I didn't get what Andrea meant at all :)

Thanks,
Paolo

> I introduced the blk_cgroup_congested() stuff for paths that it's not =
easy to
> clearly tie IO to the thing generating the IO, such as readahead and =
such.  If
> you are running into this case that may be something worth using.  =
Course it
> only works for io.latency now but there's no reason you can't add =
support to it
> for io.max or whatever.
>=20
>>=20
>> =3D Proposed solution =3D
>>=20
>> The main idea of this controller is to split I/O measurement and I/O
>> throttling: I/O is measured at the block layer for READS, at page =
cache
>> (dirty pages) for WRITEs, and processes are limited while they're
>> generating I/O at the VFS level, based on the measured I/O.
>>=20
>=20
> This is what blk_cgroup_congested() is meant to accomplish, I would =
suggest
> looking into that route and simply changing the existing io controller =
you are
> using to take advantage of that so it will actually throttle things.  =
Then just
> sprinkle it around the areas where we indirectly generate IO.  Thanks,
>=20
> Josef

