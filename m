From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next] block, bfq: cleanup 'bfqg->online'
Date: Thu, 2 Feb 2023 09:16:52 +0800
Message-ID: <76f00d0a-b8d9-ab04-329c-3ba33d12d884@huaweicloud.com>
References: <20230201120609.4151432-1-yukuai1@huaweicloud.com>
 <20230201131037.6frw2kpc54k4sx7a@quack3>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230201131037.6frw2kpc54k4sx7a@quack3>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack@suse.cz>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, paolo.valente@linaro.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, Jan!

=D4=DA 2023/02/01 21:10, Jan Kara =D0=B4=B5=C0:
> On Wed 01-02-23 20:06:09, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> After commit dfd6200a0954 ("blk-cgroup: support to track if policy is
>> online"), there is no need to do this again in bfq.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>=20
> So I agree this is nice to do but it isn't so simple. BFQ relies on the
> fact that 'online' is cleared under bfqd->lock so we cannot associate bio
> in bfq_bio_bfqg() with a bfqg that has already its bfq_pd_offline()
> function run.
>=20
> Maybe if you set 'online' to false before calling ->pd_offline() things
> would work fine for BFQ.

Yes, you're right. Thanks for the explanation.

Kuai

