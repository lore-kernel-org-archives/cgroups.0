From: Chris Down <chris@chrisdown.name>
Subject: Re: [RFC] memcg: Add swappiness to cgroup2
Date: Wed, 25 Dec 2019 14:05:46 +0000
Message-ID: <20191225140546.GA311630@chrisdown.name>
References: <1577252208-32419-1-git-send-email-teawater@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PaDmMxkiRy/WmC12erbAUHsnmEtdYs1r3ps1zkcgWAw=;
        b=dj9kUX7cO9CfQ0vYnu5g3KXmO6JhCagGhOV4IqNaW87UuclAEzzGxEeHbcInmbtxqV
         OTO0VWnbb+87Kf8YZB5UqxkkEHoCB1F/RLgqzLcQJiMEBmz9yznlTFDsFGo9tW626Hnj
         O3+BJexc5zq7YN4nzlzC/8FHKHufQKUeyGKzU=
Content-Disposition: inline
In-Reply-To: <1577252208-32419-1-git-send-email-teawater@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Hui Zhu <teawater@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Hui Zhu <teawaterz@linux.alibaba.com>

Hi Hui,

Hui Zhu writes:
>Even if cgroup2 has swap.max, swappiness is still a very useful config.
>This commit add swappiness to cgroup2.

When submitting patches like this, it's important to explain *why* you want it 
and what evidence there is. For example, how should one use this to compose a 
reasonable system? Why aren't existing protection controls sufficient for your 
use case? Where's the data?

Also, why would swappiness be something cgroup-specific instead of 
hardware-specific, when desired swappiness is really largely about the hardware 
you have in your system?

I struggle to think of situations where per-cgroup swappiness would be useful, 
since it's really not a workload-specific setting.

Thanks,

Chris

>Signed-off-by: Hui Zhu <teawaterz@linux.alibaba.com>
>---
> mm/memcontrol.c | 5 +++++
> 1 file changed, 5 insertions(+)
>
>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>index c5b5f74..e966396 100644
>--- a/mm/memcontrol.c
>+++ b/mm/memcontrol.c
>@@ -7143,6 +7143,11 @@ static struct cftype swap_files[] = {
> 		.file_offset = offsetof(struct mem_cgroup, swap_events_file),
> 		.seq_show = swap_events_show,
> 	},
>+	{
>+		.name = "swappiness",
>+		.read_u64 = mem_cgroup_swappiness_read,
>+		.write_u64 = mem_cgroup_swappiness_write,
>+	},
> 	{ }	/* terminate */
> };
>
>-- 
>2.7.4
>
>
