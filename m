From: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v3 0/6] multiple cleanup patches for bfq
Date: Mon, 30 May 2022 09:34:46 +0200
Message-ID: <5BC943C7-3AA4-4CED-9B11-15DA969DA852@linaro.org>
References: <20220528095958.270455-1-yukuai3@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=i2FIUxMX07dIItmCTvQjDvu7n64mA3I16Cf2RtZUc9E=;
        b=DLaTskUkWjAQizg06WRK4OQ5IjBDjAR1xNLKk6o5mJOCZgMi3CKiKiSgzNBJVktQOr
         FJw6QDr48a4i+waCCeI2SgKfgtvDUkMC6OleUzscAXa2/SUKfk7G0jbv8OlPIeef5Lx4
         G4uxf2YfIfNi7bdZJKJ5u+Dfe7MXdiUW3gDuWiO4zk8eRfYE9/++jJEd0m2x1a6+Vwmw
         A85OWPBHmk/+4r/z9k70SjrjLLFZxd7gX45N3onexytP1A0RLt/8WTO6S6uWsMkCv/ji
         jz0pRQE5tS9wJQfIrlFEmvUI36KgT8ggw+guxi8dCOiZwHazQYMb7FbPcEBrmInQzSxQ
         O2Gg==
In-Reply-To: <20220528095958.270455-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



> Il giorno 28 mag 2022, alle ore 11:59, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> ha =
scritto:
>=20
> Resend just in case v2 end up in spam (for Paolo).
>=20
> Changes in v2:
> - add missing blank line in patch 1.
> - remove patch 7,8, since they are wrong.
> - add reviewed-by tag
>=20
> There are no functional changes in this patchset, just some places
> that I think can be improved during code review.
>=20

Thank you for this cleanup!

Acked-by: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>

> Previous version:
> v1: =
https://lore.kernel.org/all/20220514090522.1669270-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
>=20
> Yu Kuai (6):
>  block, bfq: cleanup bfq_weights_tree add/remove apis
>  block, bfq: cleanup __bfq_weights_tree_remove()
>  block, bfq: factor out code to update 'active_entities'
>  block, bfq: don't declare 'bfqd' as type 'void *' in bfq_group
>  block, bfq: cleanup bfq_activate_requeue_entity()
>  block, bfq: remove dead code for updating 'rq_in_driver'
>=20
> block/bfq-cgroup.c  |  2 +-
> block/bfq-iosched.c | 38 +++----------------
> block/bfq-iosched.h | 11 ++----
> block/bfq-wf2q.c    | 91 ++++++++++++++++++++-------------------------
> 4 files changed, 51 insertions(+), 91 deletions(-)
>=20
> --=20
> 2.31.1
>=20

