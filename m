From: Alistair Popple <apopple@nvidia.com>
Subject: Re: [RFC PATCH 01/19] mm: Introduce vm_account
Date: Mon, 30 Jan 2023 22:36:43 +1100
Message-ID: <87h6w8z1qr.fsf@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
 <Y8/r91PGGiY5JJvE@nvidia.com>
Mime-Version: 1.0
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAEhd6lFjlqhsDdSkhLZD2XuXICiUrmsfT/om6jGR28=;
 b=NhcaMtDdSc7GvoNYC6GXRJW8dIm46N744ndgUWEZuurJdki0rxPvhs6nqT46KdJbDWUU4Y2QhBroK1B3HtGCSvnWFxLlUhCz/6AsJhbVAQYPzZ4u9wzD2m+wruAEb9o7SmBMKZftAelHaq7xi1nIQCD1jn8ZDsItLppDLNryI+c4WV61kuu87Eq/VicY52JQrgZXmzvrit/xgfO33PdK9yPoDZlFoCoWv2WWlezMj4a4k/LNTxjw9u5/YQwQDbsMDao84SqOY1qVsl/GoRlz94oTGGYyheDS8dKOKDtwtYb0amgJKikfB2+tv3PiIdIihdOKw7Q2lo/N2AaiAYtXkw==
In-reply-to: <Y8/r91PGGiY5JJvE@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, linuxppc-dev@lists.ozlabs.org, linux-fpga@vger.kernel.org, linux-rdma@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, netdev@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org, rds-devel@oss.oracle.com, linux-kselftest@vger.kernel.org


Jason Gunthorpe <jgg@nvidia.com> writes:

> On Tue, Jan 24, 2023 at 04:42:30PM +1100, Alistair Popple wrote:
>> +/**
>> + * enum vm_account_flags - Determine how pinned/locked memory is accounted.
>> + * @VM_ACCOUNT_TASK: Account pinned memory to mm->pinned_vm.
>> + * @VM_ACCOUNT_BYPASS: Don't enforce rlimit on any charges.
>> + * @VM_ACCOUNT_USER: Accounnt locked memory to user->locked_vm.
>> + *
>> + * Determines which statistic pinned/locked memory is accounted
>> + * against. All limits will be enforced against RLIMIT_MEMLOCK and the
>> + * pins cgroup if CONFIG_CGROUP_PINS is enabled.
>> + *
>> + * New drivers should use VM_ACCOUNT_TASK. VM_ACCOUNT_USER is used by
>> + * pre-existing drivers to maintain existing accounting against
>> + * user->locked_mm rather than mm->pinned_mm.
>
> I thought the guidance was the opposite of this, it is the newer
> places in the kernel that are using VM_ACCOUNT_USER?

I'd just assumed mm->pinned_vm was preferred because that's what most
drivers use. user->locked_mm does seem more sensible though as at least
it's possible to meaningfully enforce some overall limit. Will switch
the flags/comment around to suggest new users use VM_ACCOUNT_USER.

> I haven't got to the rest of the patches yet, but isn't there also a
> mm->pinned_vm vs mm->locked_vm variation in the current drivers as
> well?
>
>> +void vm_account_init_current(struct vm_account *vm_account)
>> +{
>> +	vm_account_init(vm_account, current, NULL, VM_ACCOUNT_TASK);
>> +}
>> +EXPORT_SYMBOL_GPL(vm_account_init_current);
>
> This can probably just be a static inline
>
> You might consider putting all this in some new vm_account.h - given
> how rarely it is used? Compile times and all

Works for me.

> Jason

