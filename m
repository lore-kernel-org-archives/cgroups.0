From: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/9] support concurrent sync io for bfq on a specail
 occasion
Date: Fri, 10 Dec 2021 10:20:29 +0100
Message-ID: <D3FF0820-6A51-46A1-A363-8FFA8CCD2851@linaro.org>
References: <20211127101132.486806-1-yukuai3@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SX+FfU5mZDxCoswRXg/krQoh/mf5XisDnoDBVGtWZvI=;
        b=fa2LOUoLxWv4XALz/wTI0VNk09ZivC+oOpTGEYFmFJQf65kvfkThGd8C0Tunk1nPCF
         zr+ehwd5gQ7hkPz7TvP32O9oNaZ+SWaichsnJbwlAjkrIZl3xbVi3hO/LIvr6BNuOQhx
         nA1e31nbAymHHtphxOYLlTzudumNyCS0SOyeG/x56jcrfxisLXkUiOJrnyh64fJ9L4lL
         5jzumWamcoK8rPC3Eerm1S0JuIyBmd9UbjhYBRBsEL5cEXN/AgzKnGbS3bvmF9qL46ZU
         Pb10cYUUzk+dKF+1vVfK3LRkPVbSs1/0A18UCloFMsfc3P4bczuLKEK32WPiNZq31EYw
         I3sg==
In-Reply-To: <20211127101132.486806-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



> Il giorno 27 nov 2021, alle ore 11:11, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> ha =
scritto:
>=20
> Bfq can't handle sync io concurrently as long as the io are not issued
> from root group currently.
>=20
> Previous patch set:
> =
https://lore.kernel.org/lkml/20211014014556.3597008-2-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/t=
/
>=20
> During implemting the method mentioned by the above patch set, I found
> more problems that will block implemting concurrent sync io. The
> modifications of this patch set are as follows:
>=20
> 1) count root group into 'num_groups_with_pending_reqs';
> 2) don't idle if 'num_groups_with_pending_reqs' is 1;
> 3) If the group doesn't have pending requests while it's child groups
> have pending requests, don't count the group.

Why don't yo count the parent group? It seems to me that we should count =
it.

> 4) Once the group doesn't have pending requests, decrease
> 'num_groups_with_pending_reqs' immediately. Don't delay to when all
> it's child groups don't have pending requests.
>=20

I guess this action is related to 3).

Thanks,
Paolo

> Noted that I just tested basic functionality of this patchset, and I
> think it's better to see if anyone have suggestions or better
> solutions.
>=20
> Yu Kuai (9):
>  block, bfq: add new apis to iterate bfq entities
>  block, bfq: apply news apis where root group is not expected
>  block, bfq: handle the case when for_each_entity() access root group
>  block, bfq: count root group into 'num_groups_with_pending_reqs'
>  block, bfq: do not idle if only one cgroup is activated
>  block, bfq: only count group that the bfq_queue belongs to
>  block, bfq: record how many queues have pending requests in bfq_group
>  block, bfq: move forward __bfq_weights_tree_remove()
>  block, bfq: decrease 'num_groups_with_pending_reqs' earlier
>=20
> block/bfq-cgroup.c  |  3 +-
> block/bfq-iosched.c | 92 +++++++++++++++++++++++----------------------
> block/bfq-iosched.h | 41 +++++++++++++-------
> block/bfq-wf2q.c    | 44 +++++++++++++++-------
> 4 files changed, 106 insertions(+), 74 deletions(-)
>=20
> --=20
> 2.31.1
>=20

