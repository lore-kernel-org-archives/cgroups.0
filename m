From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH cgroup/for-4.3 1/3] cgroup: replace error handling in
 cgroup_init() with WARN_ON()s
Date: Mon, 10 Aug 2015 18:19:31 +0800
Message-ID: <55C87AB3.1040105@huawei.com>
References: <20150805172012.GO17598@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150805172012.GO17598@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On 2015/8/6 1:20, Tejun Heo wrote:
> The init sequence shouldn't fail short of bugs and even when it does
> it's better to continue with the rest of initialization and we were
> silently ignoring /proc/cgroups creation failure.
>
> Drop the explicit error handling and wrap sysfs_create_mount_point(),
> register_filesystem() and proc_create() with WARN_ON()s.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

acked
