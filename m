From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 0/2] block, bfq: make bfq disable iocost and present a
 double interface
Date: Fri, 22 Nov 2019 16:42:10 +0100
Message-ID: <14200A37-0721-4444-B8A7-BE03CEDE84FB@linaro.org>
References: <20191001193316.3330-1-paolo.valente@linaro.org>
 <19BC0425-559E-433A-ACAD-B12FA02E20E4@linaro.org>
 <94E51269-62DC-427A-A81C-3851ABC818BC@linaro.org>
 <DE7EFCFA-D8A6-48EB-AE46-0C7D813A2095@linaro.org>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=AhkChjhhkTkmXD5KEPPeHkdoCCiZF1hLVImO/Bt3nAc=;
        b=aSwzsfgF+FrDcZPZkK7Kc12bjuxIIjPk+vg8NZ6HA6HDVyJkkIbok9MxpDrJGNLwR5
         BahHSFXCDpo3nCLRNmZU+UDaVbshPM3bdDiGZCtSZKjY8nngLHp+cZ2WWcIIndO2PVW4
         k9RL30RQbE0gRT4+6uPwLBiXse9LqXvuNTqaBZglspWwX/YKjS81CgJUtnBLW9jRUKZV
         YGZDZhuvcp76mcUk6inUco9vhLAtOF/lyiDybRQOWXDnuSwG1G2OLAUnzM3ZwJKDl5N4
         LpM8KmKM1EVVh8rA2UUgzTEhb10YykYols92/j6szA9n/osKzVvo5VTsg8Ng69jzhUoL
         Cc+g==
In-Reply-To: <DE7EFCFA-D8A6-48EB-AE46-0C7D813A2095@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

Jens,
5.5 has arrived too, and this version should do what you asked.  Can
you please consider this series?

Thanks,
Paolo

> Il giorno 4 nov 2019, alle ore 07:55, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>=20
> Hi Jens,
> no issue has been raised in more than a month, and this version was
> requested by Tejun and is backed by you. So can it be queued for 5.5?
>=20
> Thanks,
> Paolo
>=20
>> Il giorno 23 ott 2019, alle ore 07:44, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>>=20
>> ping
>>=20
>>> Il giorno 9 ott 2019, alle ore 16:25, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>>>=20
>>> Jens, Tejun,
>>> can we proceed with this double-interface solution?
>>>=20
>>> Thanks,
>>> Paolo
>>>=20
>>>> Il giorno 1 ott 2019, alle ore 21:33, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>>>>=20
>>>> Hi Jens,
>>>>=20
>>>> the first patch in this series is Tejun's patch for making BFQ =
disable
>>>> io.cost. The second patch makes BFQ present both the bfq-prefixes
>>>> parameters and non-prefixed parameters, as suggested by Tejun [1].
>>>>=20
>>>> In the first patch I've tried to use macros not to repeat code
>>>> twice. checkpatch complains that these macros should be enclosed in
>>>> parentheses. I don't see how to do it. I'm willing to switch to any
>>>> better solution.
>>>>=20
>>>> Thanks,
>>>> Paolo
>>>>=20
>>>> [1] https://lkml.org/lkml/2019/9/18/736
>>>>=20
>>>> Paolo Valente (1):
>>>> block, bfq: present a double cgroups interface
>>>>=20
>>>> Tejun Heo (1):
>>>> blkcg: Make bfq disable iocost when enabled
>>>>=20
>>>> Documentation/admin-guide/cgroup-v2.rst |   8 +-
>>>> Documentation/block/bfq-iosched.rst     |  40 ++--
>>>> block/bfq-cgroup.c                      | 260 =
++++++++++++------------
>>>> block/bfq-iosched.c                     |  32 +++
>>>> block/blk-iocost.c                      |   5 +-
>>>> include/linux/blk-cgroup.h              |   5 +
>>>> kernel/cgroup/cgroup.c                  |   2 +
>>>> 7 files changed, 201 insertions(+), 151 deletions(-)
>>>>=20
>>>> --
>>>> 2.20.1
>>>=20
>>=20
>=20

