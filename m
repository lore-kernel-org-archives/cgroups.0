From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: add memory.peak in cgroup root
Date: Fri, 24 Feb 2023 16:02:33 +0100
Message-ID: <Y/jRibeqSlO1Z55I@dhcp22.suse.cz>
References: <AM5PR0202MB25167BFBBE892630A2EE3B7DE1AB9@AM5PR0202MB2516.eurprd02.prod.outlook.com>
 <Y/eizTVo8LM70flh@P9FQF9L96D.corp.robot.car>
 <AM5PR0202MB2516BD45CFBC033F9EA3B0A4E1AB9@AM5PR0202MB2516.eurprd02.prod.outlook.com>
 <Y/h0GlmeSQ735DxK@dhcp22.suse.cz>
 <df9cc4e1-befc-af10-c353-733bec54baf1@axis.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677250954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d8dUNJuoGh57MMmzf6vnneijK9db4lzSQ6GQgUgsF7U=;
        b=e0Z/9wOiQZhXeUoLx2DGZ2kkdRJLjS9c5vrTd6UXnvd476+j6OMnwKPIDdR8+uqppgl/5O
        EdRvXfTAZ3+4SjAAQkBtZYIuWi8h7axrtS+rXX7YqXHthFEssSxO+zInHdiG/mJB7JeexV
        4NOeApm8s4f4SgLYujPd9+YHf6EFwGI=
Content-Disposition: inline
In-Reply-To: <df9cc4e1-befc-af10-c353-733bec54baf1-VrBV9hrLPhE@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Chae <matthewc-VrBV9hrLPhE@public.gmane.org>
Cc: Matthew Chae <Matthew.Chae-VrBV9hrLPhE@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel <kernel-VrBV9hrLPhE@public.gmane.org>, Christopher Wong <Christopher.Wong-VrBV9hrLPhE@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri 24-02-23 15:18:49, Matthew Chae wrote:
> Hi Michal
> 
> Thank you for helping me gain full insight.
> It looks like there is no proper way to get the peak memory usage recorded
> without adding any overhead to the system and for all users. But I fully
> understand what you kindly explained. Basically, having low memory left
> doesn't mean a bad situation for the system, So checking the peak memory
> doesn't mean a lot and is not necessary.

You might find https://www.pdl.cmu.edu/ftp/NVM/tmo_asplos22.pdf
interesting and helpful
-- 
Michal Hocko
SUSE Labs
