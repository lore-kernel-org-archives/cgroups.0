From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Date: Fri, 9 Mar 2012 08:53:13 -0800
Message-ID: <20120309165313.GA24890@google.com>
References: <4F587199.6050404@cn.fujitsu.com>
 <20120308182622.GC25508@google.com>
 <4F59A27D.9080705@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qQSyEJ7z5Oyp2wfggnh02+nm3a4VVsdYcLSqbNnhMy8=;
        b=C8L7pHOOXt72X0/W3kGpJHWfaNvK+020fVwpFCF15VcM0JFUkRjKqJrkna1lTt9IWr
         7fjm8InS3LBXHWIJhBSQK19t21ic4O09QJN+07HDfid+VuvASz3cP5B4WCSRpk7eu/vm
         SZ4g5U70ipL+YZj0BLL4mqI3NrhWNmSwxC2l46LiLIPFO+C6s6VIAcG3xsRhXcJiH6q5
         3/K79v+VYqpMQSyoyyxkBP/rNkCm+SENQXP+WVO3HG5co/e/uxN2RI8blCaPlSN4zh0f
         aq8irXgTQ1ZJ4arK9smfXFBjPB8PVToj17BwtEIZz6LCwo7he3uknwzxdmysjhlMsb2N
         /IUA==
Content-Disposition: inline
In-Reply-To: <4F59A27D.9080705-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?57yqIOWLsA==?= <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Li.

On Fri, Mar 09, 2012 at 02:26:05PM +0800, Li Zefan wrote:
> The problem is, forks can happen at any time, so there's no way to prevent
> forks from happening while iterating tasks in a cgroup, so controllers
> have to deal with it. In fact freezer is somewhat aware of this issue,
> that's why it provides the ->fork callback, but there's race.
> 
> This patch is not too bad (needs a bit modification). cgroup core will detect
> (via seqcount) if something's happened to a cgroup and the tasks in it, and
> then cgroup will notify controllers to check if newly-forked tasks should
> be adjusted accordingly, so they will have consistent status with other tasks
> in the same cgroup.

But why can't we just do what every sane subsystem would do - link
first and then invoke notification callback?  I mean, we're now
essentially trying to do the following.

1. Take some action.
2. Trigger notification.
3. Link the result of the action to list.

So, of course, if someone tries to traverse the "results", there's a
race window between #2 and #3.  Your fix seems to change the traverser
to,

1. Traverse the list.
2. If something happened inbetween, take another look.

But, the right thing to do would be changing the fork path to

1. Take some action.
2. Link the result of the action to list.
3. Trigger notification.

If I'm missing something, please don't feel shy to hammer it into me
as I'm feeling very lost at the moment.

Thanks.

-- 
tejun
