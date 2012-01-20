From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: make sure memcg margin is 0 when over limit
Date: Fri, 20 Jan 2012 09:08:10 -0800
Message-ID: <20120120170810.GB3086@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1327071436-20763-1-git-send-email-glommer@parallels.com>
 <1327071436-20763-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gxVushK/drmp+UgWwJgVLSazeeR+z8wO6J4iQjkESbY=;
        b=JotPEn6mvyL8JwKZhLAEDNCVPcC7PzH5oXULZKTyJc7Zjv4Ot9mbwcRCs6W3/WBENK
         BkAs1VnUsWqect+swqg33aN71Bkr3z7flLROOFeXbSLBhTiu8DMV+8gL1bil9wG4dq9u
         i5RLR4GpTTqMnT3jbIMdOM89O+2KW+LR4Rm8E=
Content-Disposition: inline
In-Reply-To: <1327071436-20763-3-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

On Fri, Jan 20, 2012 at 06:57:15PM +0400, Glauber Costa wrote:
> For the memcg sock code, we'll need to register allocations
> that are temporarily over limit. Let's make sure that margin
> is 0 in this case.
> 
> I am keeping this as a separate patch, so that if any weirdness
> interaction appears in the future, we can now exactly what caused
> it.
> 
> Suggested by Johannes Weiner 
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CC: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
