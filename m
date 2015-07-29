From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 02/10] cgroup: introduce cgroup_subsys->legacy_name
Date: Wed, 29 Jul 2015 09:18:20 +0800
Message-ID: <55B829DC.3010107@huawei.com>
References: <1437763434-28699-1-git-send-email-tj@kernel.org> <1437763434-28699-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437763434-28699-3-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org, avanzini.arianna@gmail.com, kernel-team@fb.com, hannes@cmpxchg.org, cgroups@vger.kernel.org

On 2015/7/25 2:43, Tejun Heo wrote:
> This allows cgroup subsystems to use a different name on the unified
> hierarchy.  cgroup_subsys->name is used on the unified hierarchy,
> ->legacy_name elsewhere.  If ->legacy_name is not explicitly set, it's
> automatically set to ->name and the userland visible behavior remains
> unchanged.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: cgroups@vger.kernel.org

Acked
