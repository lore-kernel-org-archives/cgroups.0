From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 0/1] block, bfq: remove bfq prefix from cgroups filenames
Date: Mon, 16 Sep 2019 16:56:06 +0200
Message-ID: <80C56C11-DA21-4036-9006-2F459ACE9A8C@linaro.org>
References: <20190909073117.20625-1-paolo.valente@linaro.org>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=gBWC3snefCabDrXZ1x4w/4vScF2L6+ltsxd1AOElg+8=;
        b=OjrwaYz2AQwT5OelSHDlmDJTq6d0W9vtp6R/Mf+Rxp3t1feUrbsXjI3gOk5kiQBo/F
         efj1fQ7n39FshL6tti/+V7aMUF2f3svbaUUu5cj8lO3QiMcrEurtxCpsGvugrG50YT+A
         Vkakk7cd9B2ISXHfmQrfSP1J7zemHWVgL0HteBJA/zQYrq8/07FlLfJ2JXCqFSlpZipo
         88Qf1QCBSnjzOpgUndKfw8fL5YW1M69Dpl2EvndiWoLC249vJBdEF2svILgs/I/WMmwI
         YyeYDzcEQUIOLOQEWyXgcLDiA1Ief9EiZZElT/V4q94l6RwEJ5GA2bWqnVfi1XDzhM48
         d8iw==
In-Reply-To: <20190909073117.20625-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, oleksandr@natalenko.name, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

News of this change?  Can we have it (or the solution with the
symlinks if you prefer it) for 5.4?

Thanks,
Paolo

> Il giorno 9 set 2019, alle ore 09:31, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>=20
> Hi Jens,
> now that BFQ's weight interface has been fixed [1], can we proceed
> with this change?
>=20
> In addition to acking this solution, in [2] Tejun already suggested a
> reduced version of the present patch. In Tejun's version, only
> bfq.weight is changed. But I guess that legacy code may use also some
> of the other bfq parameters in cgroups, without the bfq prefix. Apart
> from that, any version is ok for me, provided that it solves the
> current confusing situation for userspace [3].
>=20
> Thanks,
> Paolo
>=20
> [1] https://lkml.org/lkml/2019/8/27/1716
> [2] =
https://www.mail-archive.com/linux-block@vger.kernel.org/msg35823.html
> [3] https://github.com/systemd/systemd/issues/7057
>=20
> Angelo Ruocco (1):
>  block, bfq: delete "bfq" prefix from cgroup filenames
>=20
> block/bfq-cgroup.c | 46 +++++++++++++++++++++++-----------------------
> 1 file changed, 23 insertions(+), 23 deletions(-)
>=20
> --
> 2.20.1

