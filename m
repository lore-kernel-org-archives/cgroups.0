From: Quanyang Wang <quanyang.wang@windriver.com>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Wed, 20 Oct 2021 13:22:06 +0800
Message-ID: <7a21a20d-eb12-e491-4e69-4e043b3b6d8d@windriver.com>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590> <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590> <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
 <YW78AohHqgqM9Cuw@blackbook> <YW98RTBdzqin+9Ko@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=M3zj3HR38ju4gp1SZHrNW/BA6M77hV0CkGIcQsrcsK0=;
 b=crGWu1huM+TIIna967vieg/UKP8sGSVESCR3YhUBXa3FYNlpHcQkTohcggmHzoMgisrt
 BDo9k5kHMlnrMdT237+b69G9trrewnowx5GbJDefq1qPOoPVBXenf0WgQBslSJOq004m
 xbVJtUPvNg8ISxYEQcTVt6Oty2WivXABfu/7c6eEFkQMRMJxMkIxA9t6zgsoyRcZoHAB
 RgtE/txvhI3kRZVTetucI2FH6DDF5y5Js81cTcc0x7kzPkVDyuvbEuCj7Q3IHogRi7pD
 t+qUWTJEdngwGnedgTr4z4e64aQkq8713KbmmrUvd+OrFciUV0MLUTyXnkDc6nky9M0d RQ== 
In-Reply-To: <YW98RTBdzqin+9Ko@T590>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Ming Lei <ming.lei@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

Hi Ming,

On 10/20/21 10:17 AM, Ming Lei wrote:
> On Tue, Oct 19, 2021 at 07:10:26PM +0200, Michal Koutn=C3=BD wrote:
>> Hi.
>>
>> On Tue, Oct 19, 2021 at 06:41:14PM +0800, Quanyang Wang <quanyang.wang@w=
indriver.com> wrote:
>>> So I add 2 "Fixes tags" here to indicate that 2 commits introduce two
>>> different issues.
>>
>> AFAIU, both the changes are needed to cause the leak, a single patch
>> alone won't cause the issue. Is that correct? (Perhaps not as I realize,
>> see below.)
>>
>> But on second thought, the problem is the missing percpu_ref_exit() in
>> the (root) cgroup release path and percpu counter would allocate the
>> percpu_count_ptr anyway, so 4bfc0bb2c60e is only making the leak more
>> visible. Is this correct?
>>
>> I agree the commit 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of
>> percpu_ref in fast path") alone did nothing wrong.
>=20
> If only precpu_ref data is leaked, it is fine to add "Fixes: 2b0d3d3e4fcf=
",
> I thought cgroup_bpf_release() needs to release more for root cgroup, but
> looks not true.
For now, I can only observe that precpu_ref data is leaked when running=20
ltp testsuite.
Thanks,
Quanyang
>=20
>=20
> Thanks,
> Ming
>=20
