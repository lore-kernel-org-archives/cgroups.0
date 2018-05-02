From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] mm: introduce memory.min
Date: Wed, 2 May 2018 09:38:32 -0400
Message-ID: <20180502133832.GA18204@cmpxchg.org>
References: <20180423123610.27988-1-guro@fb.com>
 <20180424123002.utwbm54mu46q6aqs@esperanza>
 <20180424135409.GA28080@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MQb+rLXer5NC629RGQaLtl3AJPMltgdaOmcYi9Z0Qz8=; b=va/27gNsD8aCyniJXZj9IdTPTc
        5XSM0rKqONVdzkURGbOSYSZnSoBYsy7zJuw7Lh7r7Oeun50AttK/LXi3S1ud50qV05xG/B++oH/Tf
        vvdJ79ljsjLjmiM2Wwk/opkxZNGfjOEXITGyxlGobldCCYy494f4vNufSmDNJMaVVXf4=;
Content-Disposition: inline
In-Reply-To: <20180424135409.GA28080@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>

On Tue, Apr 24, 2018 at 02:54:15PM +0100, Roman Gushchin wrote:
> From: Roman Gushchin <guro@fb.com>
> Date: Tue, 24 Apr 2018 14:44:14 +0100
> Subject: [PATCH] mm: ignore memory.min of abandoned memory cgroups
> 
> If a cgroup has no associated tasks, invoking the OOM killer
> won't help release any memory, so respecting the memory.min
> can lead to an infinite OOM loop or system stall.
> 
> Let's ignore memory.min of unpopulated cgroups.

Good point, this makes sense.

> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> @@ -2549,8 +2549,11 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>  				/*
>  				 * Hard protection.
>  				 * If there is no reclaimable memory, OOM.
> +				 * Abandoned cgroups are loosing protection,

                                                         losing
