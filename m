From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH RFC 0/9] support concurrent sync io for bfq on a specail
 occasion
Date: Fri, 10 Dec 2021 11:23:39 +0100
Message-ID: <F9F1D3F7-2C76-4301-944B-0BD1A2A5FE83@linaro.org>
References: <20211127101132.486806-1-yukuai3@huawei.com>
 <D3FF0820-6A51-46A1-A363-8FFA8CCD2851@linaro.org>
 <809b90cc-20ba-c4fd-8c29-b9e3123c1cef@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RhcNME8TKvIC091+E24ipgQ5jFFJHEZIioS3/i94A5g=;
        b=kEqCxBLp0pqz7dfAy1XCRSof85ZGCTYONFa/fsiyuXgzpTTPNVCktFtmb8KnJZbgGS
         ZKKlecZz0D9P2mux41wenBzPhLv+o64L3zqNieN7xdWyZEwyaQo1JRkx8p6Snuwc9MJ5
         M1t2m6BKGwRHC58CgBxQlptDEuQ/+W/7VNvKE0lWSnfdvLAFiqUy/mQgWbN491oCTt89
         b/0YzB8vygER+4TFEg8xNftOYJhRcU+LzJ5riekqX0e78UNWQprxxi9gpIEO093rljWZ
         cNtWusFHtgeRhL5BeS+YtzGPMSU1UUcYHV/lJY86zJ8j/gbkje7WBAH967OX2gZ2naTm
         9aKg==
In-Reply-To: <809b90cc-20ba-c4fd-8c29-b9e3123c1cef@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-kernel@vger.kernel.org, yi.zhang@huawei.com



> Il giorno 10 dic 2021, alle ore 10:50, yukuai (C) <yukuai3@huawei.com> =
ha scritto:
>=20
> =E5=9C=A8 2021/12/10 17:20, Paolo Valente =E5=86=99=E9=81=93:
>>> Il giorno 27 nov 2021, alle ore 11:11, Yu Kuai <yukuai3@huawei.com> =
ha scritto:
>>>=20
>>> Bfq can't handle sync io concurrently as long as the io are not =
issued
>>> from root group currently.
>>>=20
>>> Previous patch set:
>>> =
https://lore.kernel.org/lkml/20211014014556.3597008-2-yukuai3@huawei.com/t=
/
>>>=20
>>> During implemting the method mentioned by the above patch set, I =
found
>>> more problems that will block implemting concurrent sync io. The
>>> modifications of this patch set are as follows:
>>>=20
>>> 1) count root group into 'num_groups_with_pending_reqs';
>>> 2) don't idle if 'num_groups_with_pending_reqs' is 1;
>>> 3) If the group doesn't have pending requests while it's child =
groups
>>> have pending requests, don't count the group.
>> Why don't yo count the parent group? It seems to me that we should =
count it.
> Hi, Paolo
>=20
> For example, we only issue io in child group c2(root->c1->c2),
> 'num_groups_with_pending_reqs' will end up greater than 1, thus it's
> impossible to handle sync io concurrently. Thus I don't count root and
> c1, only count c2.

Right!

Please explain this clearly in comments.


>>> 4) Once the group doesn't have pending requests, decrease
>>> 'num_groups_with_pending_reqs' immediately. Don't delay to when all
>>> it's child groups don't have pending requests.
>>>=20
>> I guess this action is related to 3).
> Yes, if c1, c2 are both active, and then c1 don't have any pending =
reqs,
> I want to decrease num_groups_with_pending_reqs to 1 immediately.

I'll check this point directly on the patch that does this decrement,
because something is not clear to me.

Thanks,
Paolo

>  So
> that sync io on c2 can be handled concurrently.
>=20


> Thanks,
> Kuai
>=20
>> Thanks,
>> Paolo
>>> Noted that I just tested basic functionality of this patchset, and I
>>> think it's better to see if anyone have suggestions or better
>>> solutions.
>>>=20
>>> Yu Kuai (9):
>>>  block, bfq: add new apis to iterate bfq entities
>>>  block, bfq: apply news apis where root group is not expected
>>>  block, bfq: handle the case when for_each_entity() access root =
group
>>>  block, bfq: count root group into 'num_groups_with_pending_reqs'
>>>  block, bfq: do not idle if only one cgroup is activated
>>>  block, bfq: only count group that the bfq_queue belongs to
>>>  block, bfq: record how many queues have pending requests in =
bfq_group
>>>  block, bfq: move forward __bfq_weights_tree_remove()
>>>  block, bfq: decrease 'num_groups_with_pending_reqs' earlier
>>>=20
>>> block/bfq-cgroup.c  |  3 +-
>>> block/bfq-iosched.c | 92 =
+++++++++++++++++++++++----------------------
>>> block/bfq-iosched.h | 41 +++++++++++++-------
>>> block/bfq-wf2q.c    | 44 +++++++++++++++-------
>>> 4 files changed, 106 insertions(+), 74 deletions(-)
>>>=20
>>> --=20
>>> 2.31.1
>>>=20
>> .

