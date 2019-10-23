From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 0/2] block, bfq: make bfq disable iocost and present a
 double interface
Date: Wed, 23 Oct 2019 07:44:47 +0200
Message-ID: <94E51269-62DC-427A-A81C-3851ABC818BC@linaro.org>
References: <20191001193316.3330-1-paolo.valente@linaro.org>
 <19BC0425-559E-433A-ACAD-B12FA02E20E4@linaro.org>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Yxvk4JK0S6fOQxsokBnmhH3TcJSOZWVYOtlV6nQoCzM=;
        b=IFQbUvYUvIHygSN9UBfOAvTiOyAzVBISTOa5oYkQV7XmGLlGYuvqaeduwqDjZf7K/e
         SQDZFmJeyHwpYRriWd5Nw2SSe3qrPJifJuCW0PwujfTLdYgFxe+mBVIu5EjjpfFDas4b
         ZFsJhWPjdQVgMj7ILlz3158WwsfWdOr4KiDokAQqJZsGMG+qn5d1YC6Ub6GHPn6fRbcR
         VjLGYvNaCMSA/huILsbMGgR/4rntEmKbyAOGT9zdGIt4ElfUIX9yDoehNxnQ1B8zRBjK
         D3+k9tktvAsX7k0YeKEdQ8+l3k2AFN/jC7+bAXc2YX9R2y8OKdKEqb0CDJ4jAEipvBZ0
         d9Yg==
In-Reply-To: <19BC0425-559E-433A-ACAD-B12FA02E20E4@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, oleksandr@natalenko.name, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

ping

> Il giorno 9 ott 2019, alle ore 16:25, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>=20
> Jens, Tejun,
> can we proceed with this double-interface solution?
>=20
> Thanks,
> Paolo
>=20
>> Il giorno 1 ott 2019, alle ore 21:33, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>>=20
>> Hi Jens,
>>=20
>> the first patch in this series is Tejun's patch for making BFQ =
disable
>> io.cost. The second patch makes BFQ present both the bfq-prefixes
>> parameters and non-prefixed parameters, as suggested by Tejun [1].
>>=20
>> In the first patch I've tried to use macros not to repeat code
>> twice. checkpatch complains that these macros should be enclosed in
>> parentheses. I don't see how to do it. I'm willing to switch to any
>> better solution.
>>=20
>> Thanks,
>> Paolo
>>=20
>> [1] https://lkml.org/lkml/2019/9/18/736
>>=20
>> Paolo Valente (1):
>> block, bfq: present a double cgroups interface
>>=20
>> Tejun Heo (1):
>> blkcg: Make bfq disable iocost when enabled
>>=20
>> Documentation/admin-guide/cgroup-v2.rst |   8 +-
>> Documentation/block/bfq-iosched.rst     |  40 ++--
>> block/bfq-cgroup.c                      | 260 =
++++++++++++------------
>> block/bfq-iosched.c                     |  32 +++
>> block/blk-iocost.c                      |   5 +-
>> include/linux/blk-cgroup.h              |   5 +
>> kernel/cgroup/cgroup.c                  |   2 +
>> 7 files changed, 201 insertions(+), 151 deletions(-)
>>=20
>> --
>> 2.20.1
>=20

