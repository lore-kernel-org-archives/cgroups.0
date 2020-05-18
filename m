From: Markus Elfring <Markus.Elfring-S0/GAf8tV78@public.gmane.org>
Subject: Re: [PATCH v2] blkcg: Fix memory leak in blkg_conf_prep()
Date: Mon, 18 May 2020 16:06:58 +0200
Message-ID: <48c1964b-a939-b33f-2c47-90ac7069317a@web.de>
References: <1589805366-328489-1-git-send-email-wubo40@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1589810819;
        bh=bKxwgZuQN7kNtLLFjAQSHsWwwY7I6KjCkB1Igwn9wj0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Fj9vHeB8O8VYoiABiQF3yqDmXHsAgo3nUYhVRdMHEqgQSUIePk0Nqvefl1kI65/L1
         NjapP+KPtI5hSvLOFEgtqU7Rnn2LgGekg9fU3IcMHRzvQz5KUpgwFOLqz8KUnrRUdV
         Nl633NSPfr+FncGDiyu8v9nQcHgjs7a22I1sSqmo=
In-Reply-To: <1589805366-328489-1-git-send-email-wubo40-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Content-Language: en-GB
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1254"
To: Wu Bo <wubo40-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feilong Lin <linfeilong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhiqiang Liu <liuzhiqiang26-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

> If a call of the function blkg_lookup_check() failed,

Thanks that you would like to integrate something from my suggestion.


> we should be release the previously allocated block group

I find that an other wording would be preferred over =E2=80=9Cwe should=E2=
=80=9D.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?id=3Db9bbe6ed63b2b9f2c9ee5cbd0f=
2c946a2723f4ce#n151


> before jumping to the lable 'fail_unlock' in the implementation of

Please avoid another typo here.


> the function blkg_conf_prep().
>
> Suggested-by: Markus Elfring <Markus.Elfring-S0/GAf8tV78@public.gmane.org>

I find this tag questionable because the bug fix was presented before.
https://lore.kernel.org/linux-block/4c670a6c-98c3-2b14-7438-09199506d92f@w=
eb.de/
https://lkml.org/lkml/2020/5/15/779


> ---
> V2: omit the source code quotation from
>     the change description

* I recommend to improve also the patch subject accordingly.

* Would you like to move the name from the previous tag into
  this information?


> ---
>  block/blk-cgroup.c | 1 +

I suggest to omit the triple dashes before this diffstat.

Regards,
Markus
