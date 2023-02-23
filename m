From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm/memcontrol: add memory.peak in cgroup root
Date: Thu, 23 Feb 2023 14:00:06 -0800
Message-ID: <Y/fh5sQEcM9hPt4Z@P9FQF9L96D.corp.robot.car>
References: <AM5PR0202MB25167BFBBE892630A2EE3B7DE1AB9@AM5PR0202MB2516.eurprd02.prod.outlook.com>
 <Y/eizTVo8LM70flh@P9FQF9L96D.corp.robot.car>
 <AM5PR0202MB2516BD45CFBC033F9EA3B0A4E1AB9@AM5PR0202MB2516.eurprd02.prod.outlook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677189611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d26wBxNftgvIEigvlBues+H50f7ZSE9Q9ePe8CXNvAs=;
        b=hy1GOCctAm2u9Q/WJ7L7i8MHDrWDIM/OZ/LaaCUIlYO4NsaGcXONCLopBdR4rwr7VnKtOG
        kEU4fg/XS5dDhRvUcB3YGSEgEtiJmdnDYBkH7Kt/hwVXa+rSdfjo4GDKrlOZWuLKOz6aw2
        R1thl8eJaTOT74Ik2v5yhyn4k7IbbkY=
Content-Disposition: inline
In-Reply-To: <AM5PR0202MB2516BD45CFBC033F9EA3B0A4E1AB9@AM5PR0202MB2516.eurprd02.prod.outlook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Chae <Matthew.Chae@axis.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, kernel <kernel@axis.com>, Christopher Wong <Christopher.Wong@axis.com>, Muchun Song <muchun.song@linux.dev>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Feb 23, 2023 at 07:00:57PM +0000, Matthew Chae wrote:
> Hi Roman,
> 
> I'd like to get the peak memory usage recorded overall time, rather than at a certain time.
> Plus, I expect that the systematical way might have better performance compared to userspace sampling.

I'm not necessarily saying to do this in userspace, you can try add a new system-wide counter
(new /proc/vmstat entry). Obviously, it might be easier to do this in userspace.
My point is to do it on system level rather than cgroup level and record a bottom of free
memory rather than the peak of used memory.

> If I understand correctly, recording the bottom of available free memory might not be helpful for this.
> Am I missing something?

Why?
