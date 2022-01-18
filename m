From: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/3] block, bfq: minor cleanup and fix
Date: Tue, 18 Jan 2022 18:53:01 +0100
Message-ID: <4E86637B-382D-4A6E-8E5C-F788589FD395@linaro.org>
References: <20211231032354.793092-1-yukuai3@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=M7FBzDoAriv8xQwZLoTeD6TT/AZBvb4RBjfiUlayd0k=;
        b=s9eeoFqeWryDhzZWuDTcq1vMbgdJuw61xJU6xmMrmmjzk2833fTJhClgBKm/9Buvzr
         /CJRd9eeYG1vrSUWpvusfrFg3CIQZ9w2oS6ZErGCfNXDXvMFXvZIufkgGhDve3v2ci5t
         z1IPHvF4sIXYz0uPjj/8Rq7qgyRJ4mTjJ43gn7dx+GDYDh46kSASXq/5jPJHWku4OUiK
         s7ajzbmCQG98b1myDBKC/2AN5kDUXloC7E8nrUUgPnEciKZZpt0GGYFn8BENphBjCkXQ
         BDQnGiM04AsymRvjsm3PIAOdm67ECL77HleUijs3FE6bHBj8IWLOBqKDEt8OY0I0PGV2
         gRDg==
In-Reply-To: <20211231032354.793092-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



> Il giorno 31 dic 2021, alle ore 04:23, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> ha =
scritto:
>=20
> Chagnes in v2:
> - add comment in patch 2
> - remove patch 4, since the problem do not exist.
>=20
> Yu Kuai (3):
>  block, bfq: cleanup bfq_bfqq_to_bfqg()
>  block, bfq: avoid moving bfqq to it's parent bfqg
>  block, bfq: don't move oom_bfqq
>=20

All
Acked-by: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks,
Paolo


> block/bfq-cgroup.c  | 16 +++++++++++++++-
> block/bfq-iosched.c |  4 ++--
> block/bfq-iosched.h |  1 -
> block/bfq-wf2q.c    | 15 ---------------
> 4 files changed, 17 insertions(+), 19 deletions(-)
>=20
> --=20
> 2.31.1
>=20

