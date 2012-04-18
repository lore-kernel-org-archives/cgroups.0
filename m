From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFD] Merge task counter into memcg
Date: Wed, 18 Apr 2012 08:54:33 +0200
Message-ID: <20120418065430.GB25568@somewhere>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <20120412010745.GE1787@cmpxchg.org>
 <20120412145507.GC11455@somewhere.redhat.com>
 <4F87042A.2000902@parallels.com>
 <20120412165922.GA12484@somewhere.redhat.com>
 <20120417151753.GB32402@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=8SEmTvb2UMSSbO8cBHIyI1KPpOICPXLriYlR/On9O0U=;
        b=AMZEZcDkVftx8/14a6/RHUak5P/fxOE9n0Wpi8rLcq3cM2kkgETaNQT8Z0RsqIEP0R
         lctIeNZbaapNPs0ezU9l1PKlrLOvisQEB3G7qdSkHcNBElrNwK5+xQ4DGzBsuphhOfMo
         JgjOhkuaXZnzcVNtaU32W4nHPzh66F0bl/kiXu7+tZfVGwRp284bR8LijhZjnnZidLmv
         XAZ0dOk4tTkpaA+f4esEF54kkuaAzTND1LSuHQqQUgrqWv07JKCg2eD3/+c1uAtmfJDr
         LAzoGhwSTagD7ithMuFSd4M6hvM1YVFHDfpNMO6/NB3lWhR2nYu4ZMEeCkE9J1tVFT8l
         Uvkw==
Content-Disposition: inline
In-Reply-To: <20120417151753.GB32402-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Daniel Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

On Tue, Apr 17, 2012 at 08:17:53AM -0700, Tejun Heo wrote:
> Hello, Frederic.
> 
> On Thu, Apr 12, 2012 at 06:59:27PM +0200, Frederic Weisbecker wrote:
> > I want:
> > 
> > a) to prevent the forkbomb from going far enough to DDOS the machine
> > b) to be able to kill that forkbomb once detected, in one go without race
> > against concurrent forks.
> > 
> > I think a) can work just fine with kernel stack limiting. I also need
> > to be notified about the fact we reached the limit. And b) should
> > be feasible with the help of the cgroup freezer. 
> 
> kmem allocation fail after reaching the limit which in turn should
> fail task creation.  Isn't that the same effect as the task_counter as
> implemented?

That's it.

> 
> > > Is there anything for which you need to know exactly the number of
> > > processes?
> > 
> > No that's really about prevent/kill forkbomb as far as I'm concerned.
> 
> Hmm... so, accounting overhead aside, if the only purpose is
> preventing the whole machine being brought down by a fork bomb, kmem
> limiting is enough, right?

I think so yeah.
