From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] memcg: replace cgroup_lock with memcg specific
 memcg_lock
Date: Tue, 4 Dec 2012 06:52:21 -0800
Message-ID: <20121204145221.GA3885@mtj.dyndns.org>
References: <1354282286-32278-1-git-send-email-glommer@parallels.com>
 <1354282286-32278-5-git-send-email-glommer@parallels.com>
 <20121203171532.GG17093@dhcp22.suse.cz>
 <50BDAD38.6030200@parallels.com>
 <20121204082316.GB31319@dhcp22.suse.cz>
 <50BDB4E3.4040107@parallels.com>
 <20121204084544.GC31319@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=EeGDp9PaaOEEy2hBOdOwiG7/t+3/Np9z6EGrTUGS63U=;
        b=qEbPdZTAAV3pqYncx6FdGXxGFS91m+WAmJY/Owpb44CyMhbh0gzM3uhnF1RYtG8vXi
         OK7QtPQoYLdmswjFMCkGlengzXylXxjI2wfm9XAzOW2kad8p7FbUnR9l6xV9bWi3Sh66
         EbS+g3ML8BxZBFmH4viKf1OixReWWT+SIYcnx6+rqDD07coGB32iaKF8YWWnS+ljqCpI
         UMhAUtHyI4TsLeBfPthv+TIefy9LJ/zPZNhlJVWNN28MaaHg5dSCoMFEgbNaaC+kbO6D
         OOwmJjBKGmVr3EgXV5dwEZOhKwcaoszl6wCkWTyS8lnUCMzDIYvYsP39dzRt9IyTwfFS
         XYng==
Content-Disposition: inline
In-Reply-To: <20121204084544.GC31319-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Michal, Glauber.

On Tue, Dec 04, 2012 at 09:45:44AM +0100, Michal Hocko wrote:
> Because such a helper might be useful in general? I didn't check if
> somebody does the same test elsewhere though.

The problem is that whether a cgroup has a child or not may differ
depending on the specific controller.  You can't tell whether
something exists or not at a given time without synchronization and
synchronization is per-controller.  IOW, if a controller cares about
when a cgroup comes online and goes offline, it should synchronize
those events in ->css_on/offline() and only consider cgroups marked
online as online.

> > If you really dislike doing a children count (I don't like as well, I
> > just don't dislike), maybe we can do something like:
> > 
> > i = 0;
> > for_each_mem_cgroup_tree(iter, memcg) {
> > 	if (i++ == 1)
> > 		return false;
> > }
> > return true;
> 
> I guess you meant:
> i = 0;
> for_each_mem_cgroup_tree(iter, memcg) {
> 	if (i++ == 1) {
> 		mem_cgroup_iter_break(iter);
> 		break;
> 	}
> }
> return i > 1;

Or sth like the following?

bool memcg_has_children(cgrp)
{
	lockdep_assert_held(memcg_lock);

	rcu_read_lock();
	cgroup_for_each_children(pos, cgrp) {
		if (memcg_is_online(pos)) {
			rcu_read_unlock();
			return true;
		}
	}
	rcu_read_unlock();
	return ret;
}

-- 
tejun
