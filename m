From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 3/4] block/rq_qos: use a global mutex to protect
 rq_qos apis
Date: Mon, 9 Jan 2023 14:37:45 +0800
Message-ID: <5633d865-8a8a-ef34-82e6-a2eacf943253@huaweicloud.com>
References: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
 <20230104085354.2343590-4-yukuai1@huaweicloud.com>
 <Y7XyIzGptuqO8EAt@slm.duckdns.org> <Y7YZnM/nqb0gxOei@slm.duckdns.org>
 <df2f7a60-467f-08ce-2a3e-1dc7853424aa@huaweicloud.com>
 <Y7cYKdOwSlfHtj7t@slm.duckdns.org>
 <ef55a0f1-d3c2-3979-963e-2fa10ba3c2ff@huaweicloud.com>
 <Y7hnH9GT6D469Vuu@slm.duckdns.org>
 <31e57528-39a5-84ed-8ea0-5c61bab00541@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <31e57528-39a5-84ed-8ea0-5c61bab00541-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/01/09 9:38, Yu Kuai =D0=B4=B5=C0:
>> So, it's not sysfs_lock but sysfs file deletion. When a kernfs, which=20
>> backs
>> sysfs, file is removed, it disables future operations and drains all
>> inflight ones before returning, so you remove the interface files before
>> cleaning up the object that it interacts with, you don't have to worry=20
>> about
>> racing against file operations as none can be in flight at that point.
>=20

I understand this know, kernfs_fop_write_iter() will grab
kernfs_node->active, and kobject_del() will wait for active to be
dropped in kernfs_drain().

>> Sorry that I've been asking you to go round and round but block device
>> add/remove paths have always been really tricky and we wanna avoid adding
>> more complications if at all possible. Can you see why the device is=20
>> being
>> destroyed before the queue attr is removed?
>=20

Sorry that I actually tested with patch 4 applied, and this is a bug
introduced by patch 4, my apologies. It set rqos to ERR_PTR() in
rq_qos_exit, and follow up rq_qos_issue() just check if rqos is NULL.

I'll wait for your patchset to be apllied, and then send a new version.
Just one thing to confirm, do you think it's better to use a global
mutex rather than a disk level mutex? I'm not sure because this will
cause different cgroup configurations from different disk can't
concurrent.

Thanks,
Kuai

