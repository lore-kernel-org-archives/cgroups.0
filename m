From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Thu, 13 Feb 2020 10:52:49 -0500
Message-ID: <20200213155249.GI88887@mtj.thefacebook.com>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-4-hannes@cmpxchg.org>
 <20200130170020.GZ24244@dhcp22.suse.cz>
 <20200203215201.GD6380@cmpxchg.org>
 <20200211164753.GQ10636@dhcp22.suse.cz>
 <20200212170826.GC180867@cmpxchg.org>
 <20200213074049.GA31689@dhcp22.suse.cz>
 <20200213135348.GF88887@mtj.thefacebook.com>
 <20200213154731.GE31689@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EuJrg4ULs0tpagr31hXq1zdKPAdFI4MMOOagF1qJLOg=;
        b=PnjLF4bNA/eUyCHgQ/R8wWTcv3gOxU/nYK8t0Sd6AcOsphiCjIu2d4hWM4XNJrJafd
         XgexmQM//GYEUS2Q79iqv68UkFJZPtLjF1AZJdYosM2nOHeRG3BwnZoNAe+H15LDic0U
         mKRMYRni5DqhLpZ9U0Plvl11o3JecbI4ETKTy4aMgKU4sndLLwACtL53DzTrrbRX0WWy
         oNFNxYsLwhjxLBwrqYmDBR/4Y5K+F6KfdMe2Sr2t56jkIy16cydbw7Q6u8fhT2NUopRX
         YWcB76bAbCNyH5CJcWEJDAJhA8Ungl8ZJhh35Jp0l2R31W8u+aum4qdhDbnwFDwye59v
         vTrQ==
Content-Disposition: inline
In-Reply-To: <20200213154731.GE31689-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Thu, Feb 13, 2020 at 04:47:31PM +0100, Michal Hocko wrote:
> Well, I would tend to agree but I can see an existing cgroup hierarchy
> imposed by systemd and that is more about "logical" organization of
> processes based on their purpose than anything resembling resources.
> So what can we do about that to make it all work?

systemd right now isn't configuring any resource control by default,
so I'm not sure why it is relevant in this discussion. You gotta
change the layout to configure resource control no matter what and
it's pretty easy to do. systemd folks are planning to integrate higher
level resource control features, so my expectation is that the default
layout is gonna change as it develops.

Thanks.

-- 
tejun
