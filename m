From: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/3] block, bfq: avoid moving bfqq to it's parent bfqg
Date: Tue, 8 Feb 2022 17:07:49 +0100
Message-ID: <36E597B3-AC41-48CC-BF3D-C35FAA7CCDD6@linaro.org>
References: <20220129015924.3958918-1-yukuai3@huawei.com>
 <20220129015924.3958918-3-yukuai3@huawei.com>
 <c85b10ce-fb41-9e0a-772a-63c226227207@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=pxjwicyhltOLuF32btZSo9eR1Q86Q6QmMx6SaA/q3DI=;
        b=OB5f9v0kZYyeHeXgReydEaPOiq979JGQ7lVGZlZ6oerO1iBCCY1iWxu20iUkDgyoNe
         c1t/aUQ01QC+znccPD/jcIC+wwAm6hnUmmiy2z7kDF3cLJUMMmMFFRmeet/e3nBKQyEt
         Xk/CRe2LQ/RZ49l0q1BZsmQYAq4gFiek0EEZ+Z1ABV2rNhdhkyA1+kns7YAk3M7b+Lk8
         RLcZE0Sb0VvlEU2SZHdq0wbgunrryPSxZFiTgUDpR/sQS4gmOfV+oPD8RzV7YCzjALNT
         VMwocI/yT5E0Q0Vus3FHvHbYZ/1eK/o29ut25C0BmXinqyLPrMuZIx3hvWhJCDKkhxn2
         MAmQ==
In-Reply-To: <c85b10ce-fb41-9e0a-772a-63c226227207-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



> Il giorno 8 feb 2022, alle ore 04:53, yukuai (C) <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> =
ha scritto:
>=20
> =E5=9C=A8 2022/01/29 9:59, Yu Kuai =E5=86=99=E9=81=93:
>> Moving bfqq to it's parent bfqg is pointless.
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  block/bfq-cgroup.c | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> Hi, Paolo
>=20
> I make a clerical error in last version of this patch:
>=20
> bfq_group should be bfqq_group
>=20
> Can you please take a look of this patch? I do compile and
> test the patch this time...
>=20

Haven't I acked this patch series already?

Thanks,
Paolo

> Thanks,
> Kuai

