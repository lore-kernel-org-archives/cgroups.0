From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v3 2/3] block, bfq: avoid moving bfqq to it's parent bfqg
Date: Tue, 8 Feb 2022 11:53:42 +0800
Message-ID: <c85b10ce-fb41-9e0a-772a-63c226227207@huawei.com>
References: <20220129015924.3958918-1-yukuai3@huawei.com>
 <20220129015924.3958918-3-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220129015924.3958918-3-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: paolo.valente@linaro.org, jack@suse.cz, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2022/01/29 9:59, Yu Kuai =D0=B4=B5=C0:
> Moving bfqq to it's parent bfqg is pointless.
>=20
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   block/bfq-cgroup.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)

Hi, Paolo

I make a clerical error in last version of this patch:

bfq_group should be bfqq_group

Can you please take a look of this patch? I do compile and
test the patch this time...

Thanks,
Kuai
