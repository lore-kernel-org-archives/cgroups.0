From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Date: Thu, 25 Oct 2012 10:42:20 -0700
Message-ID: <20121025174220.GJ11442@htj.dyndns.org>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-5-git-send-email-mhocko@suse.cz>
 <20121018224148.GR13370@google.com>
 <20121019133244.GE799@dhcp22.suse.cz>
 <20121019202405.GR13370@google.com>
 <20121022103021.GA6367@dhcp22.suse.cz>
 <20121024192535.GG12182@atj.dyndns.org>
 <20121025143756.GI11105@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4avZoNj2AydfQBjJ2YevFNb7ek2IBuZdTTHImXgQteA=;
        b=YnqIT9ltBETWVo5v8t/nviqo4oKQDMam+v46z2tvWPK4Bws+bpUGhMGAa6xPEpmrud
         M0RSQbpnQAQFrCaxrYsMyw+X9ed1AyozUKvwWke6guQBSeZZy2Wj9a6teytTxqB3+qNb
         lO0b3bA0bEplWifKssolXX0HuSjPnTl/pn2rg5OzrTAt4GVroxlSSRGqOxLNISS/A6gp
         t2UA6t4kmr8H6ag1Ijt79NjWSlKPCUKMrquOVoNrHc78hWHuWXABRUhxjotw+fHLgfr5
         oYws0K/6cWxoY5QIgQ6nguj5eJFkVoL3UzgiYlzIU9eLDRWviiZ+kYcyVXN7gTybovsD
         UjIA==
Content-Disposition: inline
In-Reply-To: <20121025143756.GI11105-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hey, Michal.

On Thu, Oct 25, 2012 at 04:37:56PM +0200, Michal Hocko wrote:
> I am not sure I understand you here. So are you suggesting
> s/BUG_ON/WARN_ON_ONCE/ in this patch?

Oh, no, I meant that we can do upto patch 3 of this series and then
follow up with proper cgroup core update and then stack further
memcg cleanups on top.

> > Let's create a cgroup branch and build things there.  I don't think
> > cgroup changes are gonna be a single patch and expect to see at least
> > some bug fixes afterwards and don't wanna keep them floating separate
> > from other cgroup changes.  
> 
> > mm being based on top of -next, that should work, right?
> 
> Well, a tree based on -next is, ehm, impractical. I can create a bug on
> top of my -mm git branch (where I merge your cgroup common changes) for
> development and then when we are ready we can send it as a series and
> push it via Andrew. Would that work for you?
> Or we can push the core part via Andrew, wait for the merge and work on
> the follow up cleanups later?
> It is not like the follow up part is really urgent, isn't it? I would
> just like the memcg part settled first because this can potentially
> conflict with other memcg work.

Argh... can we pretty *please* just do a plain git branch?  I don't
care where it is but I want to be able to pull it into cgroup core and
yes I do wanna make this happen in this devel cycle.  We've been
sitting on it far too long waiting for memcg.

Thanks.

-- 
tejun
