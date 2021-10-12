From: Quanyang Wang <quanyang.wang@windriver.com>
Subject: Re: [PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Tue, 12 Oct 2021 14:22:13 +0800
Message-ID: <6d76de0b-9de7-adbe-834b-c49ed991559d@windriver.com>
References: <20211007121603.1484881-1-quanyang.wang@windriver.com>
 <20211011162128.GC61605@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=y9SYHQEGPJEHcZD/n698B/66roamsmBxCIlLSiqPXps=;
 b=RDFXCm2pW+n3LCDWG4yA3X+fq8fsShv1SMl5S99K0jNGKRSDVRi0KNEh4KoOwryW+Yvt
 s0c/wB7YJ/J1pGio5GjUg+xbGiHqJxycnFGVfG6JQJqzospjpI+ffi17aH6Jvs64THvg
 /e7+1p2jTJx2Mdyc0XZiCFTLh6sgNjaSFUZQf+EaaLEhcZbdrLruFZ8yWSADeahl9eyQ
 ReDd1xShiLK6QF39Wyx/G5mLVPlK9f5T9ViW+hOLSp+OlixVn3e3I/KyDJYIi+9QRgX/
 V6NNAqI0C+b5ImGfBmm3Lkoh7sXJU/j3KUTtrubHjLVTtnwBjwR+rG2/GC/rk7l7aF7a 6A== 
In-Reply-To: <20211011162128.GC61605@blackbody.suse.cz>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

Hi Michal & Roman,

Thank you for your review.

On 10/12/21 12:21 AM, Michal Koutn=C3=BD wrote:
> Hello.
>=20
> On Thu, Oct 07, 2021 at 08:16:03PM +0800, quanyang.wang@windriver.com wro=
te:
>> This is because that root_cgrp->bpf.refcnt.data is allocated by the
>> function percpu_ref_init in cgroup_bpf_inherit which is called by
>> cgroup_setup_root when mounting, but not freed along with root_cgrp
>> when umounting.
>=20
> Good catch!
>=20
>> Adding cgroup_bpf_offline which calls percpu_ref_kill to
>> cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in umount path.
>=20
> That is sensible.
>=20
>> Fixes: 2b0d3d3e4fcfb ("percpu_ref: reduce memory footprint of percpu_ref=
 in fast path")
>=20
> Why this Fixes:? Is the leak absent before the percpu_ref refactoring?
Before this commit, percpu_ref is embedded in cgroup, it can be freed=20
along with cgroup, so there is no memory leak. Since this commit, it=20
causes the memory leak.
Should I change it to "Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime=20
of cgroup_bpf from cgroup itself")"?
> I guess the embedded data are free'd together with cgroup. Makes me
> wonder why struct cgroup_bpf has a separate percpu_ref counter from
> struct cgroup...
>=20
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -2147,8 +2147,10 @@ static void cgroup_kill_sb(struct super_block *sb)
>>   	 * And don't kill the default root.
>>   	 */
>>   	if (list_empty(&root->cgrp.self.children) && root !=3D &cgrp_dfl_root=
 &&
>> -	    !percpu_ref_is_dying(&root->cgrp.self.refcnt))
>> +			!percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
>> +		cgroup_bpf_offline(&root->cgrp);
>=20
> (You made some unnecessary whitespace here breaking indention :-)
Thanks for pointing it out. I will send a V2 to fix this.

Thanks,
Quanyang
>=20
>>   		percpu_ref_kill(&root->cgrp.self.refcnt);
>> +	}
>>   	cgroup_put(&root->cgrp);
>>   	kernfs_kill_sb(sb);
>>   }
