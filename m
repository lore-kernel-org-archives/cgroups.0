From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: memcg creates an unkillable task in 3.2-rc2
Date: Mon, 29 Jul 2013 12:10:26 -0400
Message-ID: <20130729161026.GD22605@mtj.dyndns.org>
References: <20130723174711.GE21100@mtj.dyndns.org>
 <8761vui4cr.fsf@xmission.com>
 <20130729075939.GA4678@dhcp22.suse.cz>
 <87ehahg312.fsf@xmission.com>
 <20130729095109.GB4678@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=j3Yg4Xp0MA3YTvRhwMOHxJSrhOJLUk6uWIjzd2Ey8UI=;
        b=ed0BeS6cNBBircmITx6BJQNOHhZCmW07wnx3Wznwpt510ghGPXLg9G3A/fPQFLSPQ/
         YaR9O1tYxC2+zbBC7F+1YHaixcE2iFwEsGmbFxWHcwFbGW6YO3AulgUf4e0gT4FrrLj9
         JMoQdBROGVDTkAvFDYOlS+gmIAPOnri+L5igPaVDSwi6Oi8wWRiTdwCq7f2SI+vn4laM
         0Q9mK/DZA8fH1RFaegmVcd7Y2jjHcKTgrUtHYMKX4J++4aZnT5EVybwzHP04RcjoXXqQ
         jlAPTVbCgvOuaOGrvDmNpNr2z9WObbnE9A4JN54Awvy6ufH1OOAtiXonH6xRbwyJnvX9
         GS+g==
Content-Disposition: inline
In-Reply-To: <20130729095109.GB4678-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

On Mon, Jul 29, 2013 at 11:51:09AM +0200, Michal Hocko wrote:
> Isn't this a bug in freezer then? I am not familiar with the freezer
> much but memcg oom handling seems correct to me. The task is sleeping
> KILLABLE and fatal_signal_pending in mem_cgroup_handle_oom will tell us
> to bypass the charge and let the taks go away.

Is the problem a frozen task not being killed even when SIGKILL is
received?  If so, it is a known problem and a side-effect of
cgroup_freezer (ab)using and making the existing power management
freezer visible to userland without really thinking about the
implications.  :(

So, yeah, if you use cgroup_freezer now, the tasks will get stuck in
states which aren't well defined when visible from userland and will
just stay there until unfrozen no matter what.  Yet another reason
I'll be screaming like a banshee at anyone who says that cgroup is
built to delegate subtree access rights to !root users.

It's on the to-do list but a very long term one.  Right now, if you
combine userland OOM handling with freezer and whatnot, it'd be pretty
easy to get into trouble.

Thanks.

-- 
tejun
