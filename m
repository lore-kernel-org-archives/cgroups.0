From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v2 2/2] block: cancel all throttled bios in del_gendisk()
Date: Wed, 1 Dec 2021 17:26:17 +0800
Message-ID: <a30bfafa-82ed-0ac1-deac-afb83f29c805@huawei.com>
References: <20211130011730.2584339-1-yukuai3@huawei.com>
 <20211130011730.2584339-3-yukuai3@huawei.com>
 <YaZQqjjygHGFEdbx@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <YaZQqjjygHGFEdbx@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: hch@infradead.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2021/12/01 0:26, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Tue, Nov 30, 2021 at 09:17:30AM +0800, Yu Kuai wrote:
>> +void blk_throtl_cancel_bios(struct request_queue *q)
>> +{
>> +	struct throtl_data *td =3D q->td;
>> +	struct blkcg_gq *blkg;
>> +	struct cgroup_subsys_state *pos_css;
>> +	struct bio *bio;
>> +	int rw;
>> +
>> +	rcu_read_lock();
>=20
> So, all of the draining is being performed without holding the q lock, wh=
ich
> *might* be okay given that we're in the del_gendisk path but is likely ri=
sky
> - ie. there can still be timers or whatever racing against it.

I'll hold queue_lock to draining bios in next iteration,

Thanks,
Kuai
>=20
> Thanks.
>=20
