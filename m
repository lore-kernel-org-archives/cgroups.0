From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] memcg: replace cgroup_lock with memcg specific
 memcg_lock
Date: Tue, 4 Dec 2012 07:22:25 -0800
Message-ID: <20121204152225.GC3885@mtj.dyndns.org>
References: <1354282286-32278-1-git-send-email-glommer@parallels.com>
 <1354282286-32278-5-git-send-email-glommer@parallels.com>
 <20121203171532.GG17093@dhcp22.suse.cz>
 <50BDAD38.6030200@parallels.com>
 <20121204082316.GB31319@dhcp22.suse.cz>
 <50BDB4E3.4040107@parallels.com>
 <20121204084544.GC31319@dhcp22.suse.cz>
 <20121204145221.GA3885@mtj.dyndns.org>
 <20121204151420.GL31319@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=CddHstoUMkW2NSojMCH5MvCFXXr0+c4K7AU0fIikiew=;
        b=AfTuxdIbX1xHQSWSOhFo8e6194BjWa6Vbz1kFYm5uMkLt4iLYXoxgDyBs+Bjo1yUBm
         pGtUDrFuqd3tqdALeOiSKp6r/M3dC2NgxlO3mUfdMcOUjZU81ZOXQ+Eb7r+pHdecXxwj
         0OZibvEZdYnPtdkaYNHWYrtBinvtRF7XaRRquMEHKfAj/iHga7qflYUeM6HHtNHzWVS5
         1Kkoa6p2BVT7dvSvsLQE3OGkdPZUGaeR7vxAOQb9yyy0BRrip/1n33e0/Q5Nffy5HsVW
         A1oGWmY6KWjYFiQZVcVnqCEzCv51iB3DvFXZwbGg0CdRF4cIvf0cdVWMv87m5GHX/YOY
         LxRg==
Content-Disposition: inline
In-Reply-To: <20121204151420.GL31319-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Michal.

On Tue, Dec 04, 2012 at 04:14:20PM +0100, Michal Hocko wrote:
> OK, I read this as "generic helper doesn't make much sense". Then I
> would just ask. Does cgroup core really care whether we do
> list_empty test? Is this something that we have to care about in memcg
> and should fix? If yes then just try to do it as simple as possible.

The thing is, what does the test mean when it doesn't have proper
synchronization?  list_empty(&cgroup->children) doesn't really have a
precise meaning if you're not synchronized.  There could be cases
where such correct-most-of-the-time results are okay but depending on
stuff like that is a sure-fire way to subtle bugs.

So, my recommendation would be to bite the bullet and implement
properly synchronized on/offline state and teach the memcg iterator
about it so that memcg can definitively tell what's online and what's
not while holding memcg_mutex, and use such knowledge consistently.

Thanks.

-- 
tejun
