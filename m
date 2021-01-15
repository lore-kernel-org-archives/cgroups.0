From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Thu, 14 Jan 2021 22:17:18 -0500
Message-ID: <YAEJPs4DJIgAXWul@mtj.duckdns.org>
References: <20201218061755.121205-1-chenzhou10@huawei.com>
 <YABDWvI2PWQpnv59@blackbook>
 <d4ba14b0-ee06-b793-a840-2c2ff369d890@huawei.com>
 <YAB3Wuu+hFpN698N@blackbook>
 <7804658e-7644-8edb-5ca8-0c97389c8c62@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5ZQN0t+SyirEWcCnAtJWFZVAj9QfKHKmBdxx1H8XwTE=;
        b=odr0pw6Tc4JOSEerz1bsmasAi60PTA3HexpYK4sUs3CMn4UPSHFwTCje4xad/XxtEo
         CL84jc8pHGUYe8mImzQQI3TrdZy6n/CgU1UHZSBLdxA5xctlwgyV+D4xOimaT3M6uWyT
         yiC+nw82au74Mn/hxt1Q73E4iXvgTMSWKcum2qqT00gXo5gMUSwrJNfOUBzDgWGhaVZr
         A+HnmBgxn9RcuYCDgGweJehTinfBAxFcUQLNNsL5QESd//9e+7jh3Jq2A0LopjvMf4re
         P6TlcVR0r52q1udIrdYpghFbEKwq+iNPduY4Xrr4tZCXtYcK1zOszrey0pwB48dKpeTq
         MTmg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <7804658e-7644-8edb-5ca8-0c97389c8c62@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chenzhou <chenzhou10@huawei.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 15, 2021 at 09:55:43AM +0800, chenzhou wrote:
> Yeah, this will select all enabled controllers, but which doesn't the behavior we want.
> I think the case should return error with information "Disabled controller xx" rather than
> attaching all the other enabled controllers.
> 
> For example, boot with cgroup_no_v1=cpu, and then mount with
> "mount -t cgroup -o cpu cpu /sys/fs/cgroup/cpu", then all enabled controllers will
> be attached expect cpu.

Okay, that explanation actually makes sense. Can you please update the
description to include what's broken and how it's being fixed? It really
isn't clear what the patch is trying to achieve from the current
description.

Thanks.

-- 
tejun
