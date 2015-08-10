From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH cgroup/for-4.3 3/3] cgroup: replace __DEVEL__sane_behavior
 with cgroup2 fs type
Date: Mon, 10 Aug 2015 18:19:50 +0800
Message-ID: <55C87AC6.3090705@huawei.com>
References: <20150805172012.GO17598@mtj.duckdns.org>
 <20150805172043.GP17598@mtj.duckdns.org>
 <20150805172108.GQ17598@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150805172108.GQ17598@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On 2015/8/6 1:21, Tejun Heo wrote:
> With major controllers - cpu, memory and io - shaping up for the
> unified hierarchy, cgroup2 is about ready to be, gradually, released
> into the wild.  Replace __DEVEL__sane_behavior flag which was used to
> select the unified hierarchy with a separate filesystem type "cgroup2"
> so that unified hierarchy can be mounted as follows.
>
>    mount -t cgroup2 none $MOUNT_POINT
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

acked
