From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: add memory.peak in cgroup root
Date: Thu, 23 Feb 2023 09:30:53 -0800
Message-ID: <Y/eizTVo8LM70flh@P9FQF9L96D.corp.robot.car>
References: <AM5PR0202MB25167BFBBE892630A2EE3B7DE1AB9@AM5PR0202MB2516.eurprd02.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677173458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1WZIJ8pUmzgqf8s+eBJbOZDw0S7cY6i0ZgBo0K3FG/Q=;
        b=pioTvFJu7T1+T4/dTxeZZqfGM2/TWjnxl4BbSskW/8iJMEnf3xGmnYpO2bJERJoSDtrpit
        0eku3xR9czaZIWNvA8YRjTXPDh9dCUtqB9XDSEDs0pibvBl25q+K8xrv85ULglmXpU5SYL
        spx63rP8+9iIRtqUhMP6lWjWqydHSU0=
Content-Disposition: inline
In-Reply-To: <AM5PR0202MB25167BFBBE892630A2EE3B7DE1AB9-y8SMVMhlxwlZMxuguPlqCOmQVOPts17knBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Chae <Matthew.Chae-VrBV9hrLPhE@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel <kernel-VrBV9hrLPhE@public.gmane.org>, Christopher Wong <Christopher.Wong-VrBV9hrLPhE@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Feb 23, 2023 at 04:22:33PM +0000, Matthew Chae wrote:
> Hi Michal,
> 
> First off, thank you for sharing your opinion.
> I'd like to monitor the peak memory usage recorded of overall system or at least cgroup accounted memory through memory.peak.
> But it looks like this is not relevant to what I wanted.
> It might be good to have some proper way for checking the system's peak memory usage recorded.

I guess you might want to do the opposite: instead of tracking the peak usage,
you can record the bottom of available free memory.

Thanks!
