From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] memcg: Add swappiness to cgroup2
Date: Tue, 31 Dec 2019 15:16:21 -0800
Message-ID: <20191231151621.8f1565ef8736233dbf60bca7@linux-foundation.org>
References: <1577252208-32419-1-git-send-email-teawater@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577834182;
        bh=T1TP9OS5NPYDy/yeJXg2yUzaWY4igVKAIiTXgalOvCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H8M60uzpbqD2/72X0HwITZluZ6clbGOPd0ijAz1VhVr5Z3LM/3znM7GQRZUzyjNBR
         xvZ7i5CxutBqkLsKTIoT323gNM9oT82/jm2X97XHDvrHW2KzDaxjgLPiE3uwaTW9W9
         rk/vwiiwutPleNfxOzsVVXKrv0aHHhiWL2fqqikU=
In-Reply-To: <1577252208-32419-1-git-send-email-teawater@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hui Zhu <teawater@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Hui Zhu <teawaterz@linux.alibaba.com>

On Wed, 25 Dec 2019 13:36:48 +0800 Hui Zhu <teawater@gmail.com> wrote:

> Even if cgroup2 has swap.max, swappiness is still a very useful config.
> This commit add swappiness to cgroup2.
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7143,6 +7143,11 @@ static struct cftype swap_files[] = {
>  		.file_offset = offsetof(struct mem_cgroup, swap_events_file),
>  		.seq_show = swap_events_show,
>  	},
> +	{
> +		.name = "swappiness",
> +		.read_u64 = mem_cgroup_swappiness_read,
> +		.write_u64 = mem_cgroup_swappiness_write,
> +	},
>  	{ }	/* terminate */
>  };

There should be a Documentation/ update with this?




