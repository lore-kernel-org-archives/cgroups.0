From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH] cgroup: Return if dst_cgrp equals to src_cgrp
Date: Thu, 26 May 2022 00:51:46 +0200
Message-ID: <Yo6zAi+Y/uXLYUI7@blackbook>
References: <1653066120-21262-1-git-send-email-shisiyuan@xiaomi.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653519112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QP07LDyVTEoT20uTedwg+UGDjLkX645oy3+oI/k9KRs=;
        b=Un5rEjXdkXJRg/7BDQ4WUW/5PsCCqQ5kj5pJaQp7Co5y558JEvVWkwTggBiPxw9IsU/Jgz
        VkB5iahLfTOZjyEDs8pggBJHpKHHjfSOlosX/O9wN7Tobvg5sArOIb3hJ9uVgCoKf2SLP6
        rx7GDfcaa0DgZ9PwdWMgZNWZGf5fT90=
Content-Disposition: inline
In-Reply-To: <1653066120-21262-1-git-send-email-shisiyuan@xiaomi.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: shisiyuan19870131@gmail.com
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello.

On Sat, May 21, 2022 at 01:02:00AM +0800, shisiyuan <shisiyuan19870131@gmail.com> wrote:
> In function cgroup_migrate_add_src(), if dst_cgrp
> equals to src_cgroup which the tasks link, dont
> go on migrating tasks to another css_set.

Do you have an example which operations lead to this situation?

> This can save the cost of unnecessary migration.

How much are the savings visible?

(Note, I suspect the shortcut on `src_cgrp == dst_cgrp` might not be
always correct when called from cgroup_update_dfl_csses() but not 100%
sure now.)

Thanks,
Michal
