From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next v2 2/5] block, bfq: add fake weight_counter for
 weight-raised queue
Date: Mon, 25 Apr 2022 21:34:16 +0800
Message-ID: <a27b8c79-867f-9253-84db-1d39c964b3ed@huawei.com>
References: <20220416093753.3054696-1-yukuai3@huawei.com>
 <20220416093753.3054696-3-yukuai3@huawei.com>
 <20220425094856.qgkhba2klguduxot@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220425094856.qgkhba2klguduxot@quack3.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack@suse.cz>
Cc: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2022/04/25 17:48, Jan Kara =D0=B4=B5=C0:
> On Sat 16-04-22 17:37:50, Yu Kuai wrote:
>> Weight-raised queue is not inserted to weights_tree, which makes it
>> impossible to track how many queues have pending requests through
>> weights_tree insertion and removel. This patch add fake weight_counter
>> for weight-raised queue to do that.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>=20
> This is a bit hacky. I was looking into a better place where to hook to
> count entities in a bfq_group with requests and I think bfq_add_bfqq_busy=
()
> and bfq_del_bfqq_busy() are ideal for this. It also makes better sense
> conceptually than hooking into weights tree handling.
>=20
Hi,

bfq_del_bfqq_busy() will be called when all the reqs in the bfqq are
dispatched, however there might still some reqs are't completed yet.

Here what we want to track is how many bfqqs have pending reqs,
specifically if the bfqq have reqs are't complted.

Thus I think bfq_del_bfqq_busy() is not the right place to do that.

Thanks,
Kuai
> Other than this the rest of the series looks fine to me.
>=20
> 								Honza
