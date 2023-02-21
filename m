From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: Sv: [PATCH] mm/memcontrol: add memory.peak in cgroup root
Date: Tue, 21 Feb 2023 17:16:55 +0100
Message-ID: <Y/TudzUxEDwn6MHX@dhcp22.suse.cz>
References: <20230221143421.10385-1-matthew.chae@axis.com>
 <Y/TeKkhQtV7Bck8P@dhcp22.suse.cz>
 <DB4PR02MB93344BAA949FA7E25E298C90FEA59@DB4PR02MB9334.eurprd02.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676996216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VIg5pY0sBhoDHUCkynozPJyyyBzhn0SD+XqJCl/DX2E=;
        b=ur51GYTE2PM2xTY09JS0cAxfrrMgcksi2E8L5UaVsGStsT6bwlH326WLSm6l65zQtfEdqw
        Z4arZMuoF0l5KIbPLj1yCjM6zsKeo1KHpZgW4KMeov7zRMniNkkJ4UQHM1oXVcjpqRGzbA
        UBvQod4cxxgaQzlYpt3NWSL7267moYU=
Content-Disposition: inline
In-Reply-To: <DB4PR02MB93344BAA949FA7E25E298C90FEA59-7YaF7f4iyy4XcPQCjnbtU2rxpoXoJLNtvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christopher Wong <Christopher.Wong-VrBV9hrLPhE@public.gmane.org>
Cc: Matthew Chae <Matthew.Chae-VrBV9hrLPhE@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel <kernel-VrBV9hrLPhE@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue 21-02-23 16:13:14, Christopher Wong wrote:
> Hi Michal,
> 
> Thanks for the quick response! I think we are just trying to
> get the same value that was available for us in cgroup v1
> memory.max_usage_in_bytes. I guess this value also is incomplete for
> representing the system memory usage.

Correct.

> Is it due the incompleteness that the memory.peak has been left out in
> the root of cgroup v2?

I think so but I do not remember 100%. You might want to look into email
archives.
-- 
Michal Hocko
SUSE Labs
