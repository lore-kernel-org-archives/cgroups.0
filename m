From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: add a validation check to cgroup_add_cftyps()
Date: Tue, 18 Feb 2014 18:20:56 -0500
Message-ID: <20140218232056.GL31892@mtj.dyndns.org>
References: <530176EE.6030605@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DznWveeJcJj5y7khhkeiy8Y7fJV+W+/G7QqdXwc7nc8=;
        b=AH9Iwp9qXqjw5U6Ke86B39G3RqcUOnJTBUisQfww7cnKOMhG/JykjNz5gkwYiWIkKm
         WiIRUwQOdlv/7bV2jWd5+g0Cyxc8M+GStMIkiP2vsbSzu/EgGdSE/Bsz2Zc+JFLIA9c+
         xhGUP0A5y7nXdOelbqyCGedTJGx+eBXF8VTMDRTC9vWM8eO7Talwqh3t2X1nIiGdeDe9
         q4lzBn+JgA5qhuX8vzIY3ljXL00sGolo8x/wTOMYpvquyVimy1ecvub7q0FlzNuw0yq+
         nZ32+in2akmkm7ZFDGo38ZjGVCXjiAyNy3YFrfLD2ZY0sjo3YwzDGU5kve0j7//T4ZxS
         B0DQ==
Content-Disposition: inline
In-Reply-To: <530176EE.6030605@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Mon, Feb 17, 2014 at 10:41:50AM +0800, Li Zefan wrote:
> Fengguang reported this bug:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000003c
> IP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1
> ...
> Call Trace:
>   [<cc9d1129>] ? kmem_cache_alloc_trace+0x33f/0x3b7
>   [<cc90c6fc>] cgroup_add_cftypes+0x8f/0xca
>   [<cd78b646>] cgroup_init+0x6a/0x26a
>   [<cd764d7d>] start_kernel+0x4d7/0x57a
>   [<cd7642ef>] i386_start_kernel+0x92/0x96
> 
> This happens in a corner case. If CGROUP_SCHED=y but CFS_BANDWIDTH=n &&
> FAIR_GROUP_SCHED=n && RT_GROUP_SCHED=n, we have:
> 
> cpu_files[] = {
> 	{ }	/* terminate */
> }
> 
> When we pass cpu_files to cgroup_apply_cftypes(), as cpu_files[0].ss
> is NULL, we'll access NULL pointer.
> 
> The bug was introduced by commit de00ffa56ea3132c6013fc8f07133b8a1014cf53
> ("cgroup: make cgroup_subsys->base_cftypes use cgroup_add_cftypes()").
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.15.  Thanks.

-- 
tejun
