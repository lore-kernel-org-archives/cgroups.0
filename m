From: "Singh, Balbir" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: switch to rstat fix
Date: Tue, 16 Mar 2021 11:52:22 +1100
Message-ID: <494a5169-7e18-804b-3975-3a6442aff601@gmail.com>
References: <20210315234100.64307-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xZoZuWb2tBzrGLpbmU0QlJ3nLJM79Q95ZotWRYdo/dU=;
        b=udPVwzShPfqLnJku3Fi+dpSMekaBCR/1LK2aWf1PcUDLZZrudJibDmi0qfrv/bqFQi
         2H93ctwVoCfgOr2SN8hWgsDeHQvcBvP8XiGlBtPsy1YjVOKrLNSDioU8RZp8zwqXc3A6
         oJI2UWvwmwVvKThzHVEDxhD1X5nOp/VOJj4PbXs+hR49oilZocWDgVy25YKK8EOHXYdm
         qYcsl+P22j8n75mkw0RH4x+LoJ8q9WWI19/8ttIpLAb5Tp5h50c6BXldIRsMApX7ghT4
         eTArYFObAgWoCrP6O+yFbQ/MxkIiKeK6kzPC9Og6q+TOirm7W6j9lHvVgDGzbYPmZY3q
         8c5Q==
In-Reply-To: <20210315234100.64307-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-GB
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On 16/3/21 10:41 am, Johannes Weiner wrote:
> Fix a sleep in atomic section problem: wb_writeback() takes a spinlock
> and calls wb_over_bg_thresh() -> mem_cgroup_wb_stats, but the regular
> rstat flushing function called from in there does lockbreaking and may
> sleep. Switch to the atomic variant, cgroup_rstat_irqsafe().
> 
> To be consistent with other memcg flush calls, but without adding
> another memcg wrapper, inline and drop memcg_flush_vmstats() instead.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---

The patch make sense, but it does break any notion of abstraction we had
about controllers have some independence in their strategy to maintain
their own counters and stats. It now couples writeback with rstat instead
of just memcg.

Acked-by: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
