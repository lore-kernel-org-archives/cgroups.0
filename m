From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH RFC 9/9] block, bfq: decrease
 'num_groups_with_pending_reqs' earlier
Date: Thu, 16 Dec 2021 17:34:06 +0100
Message-ID: <B5C2B1F6-4DF9-4657-AFF4-D53DD04A65DC@linaro.org>
References: <20211127101132.486806-1-yukuai3@huawei.com>
 <20211127101132.486806-10-yukuai3@huawei.com>
 <AA66019E-FD14-4821-B53D-0C56EEC38828@linaro.org>
 <4765e7f8-48b7-3bc6-5eb6-1dc0a569233d@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YIxQQ6KDBZhBgpCjwTDT7xZgLL24q7Pq/WYlBcp43Wc=;
        b=P4zJ4MdxI3Nrq2mTejPtTAUCz2UTy2xuQFXkgZ51A3KEZY3c8BbN2FMPLzvgbMKG/q
         2CS3yZFEyqHxMzPI6X1GpdoEf7/MOX2c3YmQETBCmfW78pISipn2xqcOZbdiJgvCNJiw
         3VJ2atCKDqhYMLBfQPRzc95ji4OpWuWcZG6iYnojd5q6N19g6zvgS20ZcXYBq+xz3uM+
         Ror14fJKf1hGgsQL8KDApaQr3lj8beuTP3xEei2gF56D1gL6W7lmSjr0NrbQP3GXVzpm
         FAY4tBJcjTbSjdm3thtN8R96q5Qt/7rsyyynLkRfFW7fF8ZlcPnfDkvN3Y1lE37hmhOW
         Zkzw==
In-Reply-To: <4765e7f8-48b7-3bc6-5eb6-1dc0a569233d@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com



> Il giorno 11 dic 2021, alle ore 03:10, yukuai (C) <yukuai3@huawei.com> =
ha scritto:
>=20
> =E5=9C=A8 2021/12/10 18:21, Paolo Valente =E5=86=99=E9=81=93:
>>> Il giorno 27 nov 2021, alle ore 11:11, Yu Kuai<yukuai3@huawei.com>  =
ha scritto:
>>>=20
>>> Currently 'num_groups_with_pending_reqs' won't be decreased when
>>> the group doesn't have any pending requests, while any child group
>>> have any pending requests. The decrement is delayed to when all the
>>> child groups doesn't have any pending requests.
>>>=20
>>> For example:
>>> 1) t1 issue sync io on root group, t2 and t3 issue sync io on the =
same
>>> child group. num_groups_with_pending_reqs is 2 now.
>>> 2) t1 stopped, num_groups_with_pending_reqs is still 2. io from t2 =
and
>>> t3 still can't be handled concurrently.
>>>=20
>>> Fix the problem by decreasing 'num_groups_with_pending_reqs'
>>> immediately upon the deactivation of last entity of the group.
>>>=20
>> I don't understand this patch clearly.
>> I understand your proposal not to count a group as with pending =
requests, in case no child process of the group has IO, but only its =
child groups have pending requests.
>> So, entities here are only queues for this patch?
>> If they are only queues, I think it is still incorrect to remove the =
group from the count of groups with pending IO when all its child queues =
are deactivated, because there may still be unfinished IO for those =
queues.
>=20
> Hi, Paolo
>=20
> bfq_weights_tree_remove() will be called when all requests are =
completed
> in bfq_queue, thus I recored how many queues have pending requests
> through weights tree insertion and removal.(Details in patch 7)
>=20
> Thus when calling bfq_weights_tree_remove() for bfqq, I can check if
> there are no queues have pending requests for parent bfqg:
>=20
> if (!bfqg->num_entities_with_pending_reqs && -> no queues with pending =
reqs
>    entity->in_groups_with_pending_reqs) {   -> the group is counted
>=20

Ok, I got confused because you use the term deactivation.  Yet you
seem to decrement the counter at the right time.  Maybe fix that term,
in commit messages and comments.

Thanks,
Paolo

> Thanks,
> Kuai
>> Am I missing something?
>> Thanks,
>> Paolo

