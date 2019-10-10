From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Potential NULL pointer deference in mm/memcontrol.c
Date: Thu, 10 Oct 2019 09:19:37 +0200
Message-ID: <20191010071937.GA18412@dhcp22.suse.cz>
References: <CABvMjLRgShsBiod+GVcqirmKeFLN_KfxdDDwGo22YK0wULepwA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABvMjLRgShsBiod+GVcqirmKeFLN_KfxdDDwGo22YK0wULepwA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yizhuo Zhai <yzhai003@ucr.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>, Chengyu Song <csong@cs.ucr.edu>

On Wed 09-10-19 21:56:04, Yizhuo Zhai wrote:
> Hi All:
> mm/memcontrol.c:
> The function mem_cgroup_from_css() could return NULL, but some callers

This is the case only when the memory cgroup controller is disabled
which is a boot time option.

> in this file
> checks the return value but directly dereference it, which seems
> potentially unsafe.
> Such callers include mem_cgroup_hierarchy_read(),
> mem_cgroup_hierarchy_write(), mem_cgroup_read_u64(),
> mem_cgroup_reset(), etc.

And none of those should be ever called under that condition AFAICS.

Thanks!
-- 
Michal Hocko
SUSE Labs
