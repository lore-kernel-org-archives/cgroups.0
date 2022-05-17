From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next] block: fix io hung of setting throttle limit
 frequently
Date: Tue, 17 May 2022 14:16:01 +0800
Message-ID: <8abf8186-c5c3-47c1-7acd-9116f127fd03@huawei.com>
References: <20220516014429.33723-1-zhangwensheng5@huawei.com>
 <YoKmCOAzwzw3Lz7g@slm.duckdns.org>
 <ca251645-8d52-7a93-6ac2-579d97922a9e@huawei.com>
 <YoMiJIUehq1UyzgQ@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <YoMiJIUehq1UyzgQ@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zhang Wensheng <zhangwensheng5@huawei.com>, "ming.lei@redhat.com >> Ming Lei" <ming.lei@redhat.com>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

=D4=DA 2022/05/17 12:18, Tejun Heo =D0=B4=B5=C0:
> On Tue, May 17, 2022 at 11:12:28AM +0800, yukuai (C) wrote:
>> Ming added a condition in tg_with_in_bps_limit():
>> -       if (bps_limit =3D=3D U64_MAX) {
>> +       /* no need to throttle if this bio's bytes have been accounted */
>> +       if (bps_limit =3D=3D U64_MAX || bio_flagged(bio, BIO_THROTTLED))=
 {
>>
>> Which will let the first throttled bio to be issued immediately once
>> the config if updated.
>>
>> Do you think this behaviour is OK? If so, we can do the same for
>> tg_with_in_iops_limit.
>=20
> So, the current behavior is that if the user is being silly, it will get
> slower and slower. The new behavior would be that if the user is being
> silly, it can issue IOs faster and faster, which creates a perverse
> incentive to be silly.
Yes,

I just found that Ming's patch introduce a new problem:

If multiple bios are throttled, then they will be issued one by one with
corresponding time. However, after Ming's patch, all throttled bios will
be issued immediately once the waiting time of first bio is reached. And
such behaviour is definitely a problem...

>=20
> Probably the right thing to do is probably something like translating the
> existing budget in light of the new configuration so that config change
> neither gives or takes away the budget which has already accumulated. That
> said, are you guys seeing this becoming an issue in practice?

Agreed, the solution sounds reasonable. And this problem is found during
test, which issue a large io and in the meantime updating config with
random value.

Thanks,
Kuai
>=20
> Thanks.
>=20
