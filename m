From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [RFC PATCH 0/3] cgroup: fsio throttle controller
Date: Fri, 18 Jan 2019 12:11:49 +0100
Message-ID: <08B91C51-C104-483A-AF15-74C40B5DAACC@linaro.org>
References: <20190118103127.325-1-righi.andrea@gmail.com>
 <E5872191-EE96-442E-B668-DD148157E665@linaro.org>
 <20190118111008.GA25335@xps-13>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=MU+d557iFzoQgxyJuKKMNzCTccSSo+Om4Ij1sV8T/lo=;
        b=dCmgurZPh5iqDD2hXGFZMNquWsSEISHeZyctshkwd5Zzi+uFGxtzYCsxe+XMG+/9G6
         pacYyZof6dbtjiSGlVIAu8vCUeIGv3maD8KvqzFFEg4W9VEkzvaLyAuR13XcJNeLlz62
         xwZCJW+4Bhtt12NL7nxK5tYD1pXQd/R0wmNn8=
In-Reply-To: <20190118111008.GA25335@xps-13>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Josef Bacik <josef@toxicpanda.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



> Il giorno 18 gen 2019, alle ore 12:10, Andrea Righi =
<righi.andrea@gmail.com> ha scritto:
>=20
> On Fri, Jan 18, 2019 at 12:04:17PM +0100, Paolo Valente wrote:
>>=20
>>=20
>>> Il giorno 18 gen 2019, alle ore 11:31, Andrea Righi =
<righi.andrea@gmail.com> ha scritto:
>>>=20
>>> This is a redesign of my old cgroup-io-throttle controller:
>>> https://lwn.net/Articles/330531/
>>>=20
>>> I'm resuming this old patch to point out a problem that I think is =
still
>>> not solved completely.
>>>=20
>>> =3D Problem =3D
>>>=20
>>> The io.max controller works really well at limiting synchronous I/O
>>> (READs), but a lot of I/O requests are initiated outside the context =
of
>>> the process that is ultimately responsible for its creation (e.g.,
>>> WRITEs).
>>>=20
>>> Throttling at the block layer in some cases is too late and we may =
end
>>> up slowing down processes that are not responsible for the I/O that
>>> is being processed at that level.
>>>=20
>>> =3D Proposed solution =3D
>>>=20
>>> The main idea of this controller is to split I/O measurement and I/O
>>> throttling: I/O is measured at the block layer for READS, at page =
cache
>>> (dirty pages) for WRITEs, and processes are limited while they're
>>> generating I/O at the VFS level, based on the measured I/O.
>>>=20
>>=20
>> Hi Andrea,
>> what the about the case where two processes are dirtying the same
>> pages?  Which will be charged?
>>=20
>> Thanks,
>> Paolo
>=20
> Hi Paolo,
>=20
> in this case only the first one will be charged for the I/O activity
> (the one that changes a page from clean to dirty). This is probably =
not
> totally fair in some cases, but I think it's a good compromise,

Absolutely, I just wanted to better understand this point.

> at the
> end rewriting the same page over and over while it's already dirty
> doesn't actually generate I/O activity, until the page is flushed back
> to disk.
>=20

Right.

Thanks,
Paolo

> Obviously I'm open to other better ideas and suggestions.
>=20
> Thanks!
> -Andrea

