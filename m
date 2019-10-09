From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 0/2] block, bfq: make bfq disable iocost and present a
 double interface
Date: Wed, 9 Oct 2019 16:25:03 +0200
Message-ID: <19BC0425-559E-433A-ACAD-B12FA02E20E4@linaro.org>
References: <20191001193316.3330-1-paolo.valente@linaro.org>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=iRU49OEAt4LyCj336K2hOD9DnveAI21uNOjEn9qQOW4=;
        b=E9KCxy7r7W8VuG+gzVrXD0ZY3tqFeU411T36Nq5kTRByAlfDI/wbHpZh/g5kswfCoM
         vwLhWo9403t2VxWW4ttuhL8ENG78lJ8LR6XWeY18QVo6Qr4zH+d1uHFUyneYhxhEkfb7
         oMSONezKLBCpzFUmlkWHaWWec4Xj13yVUdpiV6FskZnBwdrKUX9kQ6LjaOcmqOJlWuZM
         xTGdMwq4xxVsIXN7Ozu0ww8Z3z+iLn4MhQuSH898YBtmx6CNggIToafYp08ywpTdf7PC
         9bohWInAa5ueiUydRrA7pzUepRWP7esXN28+KUc2MKi0VSEEnuKu5Jajoz2XAehkmJu/
         Sp6Q==
In-Reply-To: <20191001193316.3330-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, oleksandr@natalenko.name, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

Jens, Tejun,
can we proceed with this double-interface solution?

Thanks,
Paolo

> Il giorno 1 ott 2019, alle ore 21:33, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>=20
> Hi Jens,
>=20
> the first patch in this series is Tejun's patch for making BFQ disable
> io.cost. The second patch makes BFQ present both the bfq-prefixes
> parameters and non-prefixed parameters, as suggested by Tejun [1].
>=20
> In the first patch I've tried to use macros not to repeat code
> twice. checkpatch complains that these macros should be enclosed in
> parentheses. I don't see how to do it. I'm willing to switch to any
> better solution.
>=20
> Thanks,
> Paolo
>=20
> [1] https://lkml.org/lkml/2019/9/18/736
>=20
> Paolo Valente (1):
>  block, bfq: present a double cgroups interface
>=20
> Tejun Heo (1):
>  blkcg: Make bfq disable iocost when enabled
>=20
> Documentation/admin-guide/cgroup-v2.rst |   8 +-
> Documentation/block/bfq-iosched.rst     |  40 ++--
> block/bfq-cgroup.c                      | 260 ++++++++++++------------
> block/bfq-iosched.c                     |  32 +++
> block/blk-iocost.c                      |   5 +-
> include/linux/blk-cgroup.h              |   5 +
> kernel/cgroup/cgroup.c                  |   2 +
> 7 files changed, 201 insertions(+), 151 deletions(-)
>=20
> --
> 2.20.1

