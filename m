From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [patch v11 0/6] support concurrent sync io for bfq on a specail
 occasion
Date: Tue, 1 Nov 2022 19:32:45 +0800
Message-ID: <b2099166-5386-d60b-0b31-e5cd40ef97da@huaweicloud.com>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220916071942.214222-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Yu Kuai <yukuai1@huaweicloud.com>, tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, Jens

=D4=DA 2022/09/16 15:19, Yu Kuai =D0=B4=B5=C0:
> From: Yu Kuai <yukuai3@huawei.com>
>
>=20
> Currently, bfq can't handle sync io concurrently as long as they
> are not issued from root group. This is because
> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
> bfq_asymmetric_scenario().
>=20
> The way that bfqg is counted into 'num_groups_with_pending_reqs':
>=20
> Before this patchset:
>   1) root group will never be counted.
>   2) Count if bfqg or it's child bfqgs have pending requests.
>   3) Don't count if bfqg and it's child bfqgs complete all the requests.
>=20
> After this patchset:
>   1) root group is counted.
>   2) Count if bfqg has pending requests.
>   3) Don't count if bfqg complete all the requests.
>=20
> With the above changes, concurrent sync io can be supported if only
> one group is activated.

Can you apply this patchset?

Thanks,
Kuai

