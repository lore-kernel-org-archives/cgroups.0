From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Mon, 8 Jul 2013 10:00:47 -0700
Message-ID: <20130708170047.GA18600@mtj.dyndns.org>
References: <20130708100046.14417.12932.stgit@zurg>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=cYOoyNE+Iqb0QPIigGmN7eTyLKVnPU5YV3lwgrYbKSw=;
        b=rDxMfYCiY8CVZd6uw1+ff3Hy90LUoYYfOqUIf4X9OIPjMDyJV4rfpocu+VrWk3YgKk
         iOfxsmZDgv8haRPJre3vK+o4KkqDBQeAAWHOvmorIBvzv1M4R8WnzOegogCm4Nb8QLUj
         YJtwsmXI0yYb7kKgIH8QgaQdKDomtZ8TW8QuUBW6m3tnGF/JTmd58sDxfFxEmGZJFZkw
         t9JYe7kH8aviSSJ+FBNmLajhT+yUImm65Qs3lvy8DXItDAAGvm8zX97S0GHuafogM1fU
         cT7owYNPdrM0loWxzBLOz8vllAfYu5uzrUt+GGIR5kknEFVWtsKGE5oZZRfDCfuwcHYv
         lpoQ==
Content-Disposition: inline
In-Reply-To: <20130708100046.14417.12932.stgit@zurg>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

(cc'ing Vivek and Jens)

Hello,

On Mon, Jul 08, 2013 at 02:01:39PM +0400, Konstantin Khlebnikov wrote:
> This is proof of concept, just basic functionality for IO controller.
> This cgroup will control filesystem usage on vfs layer, it's main goal is
> bandwidth control. It's supposed to be much more lightweight than memcg/blkio.

While blkcg is pretty heavy handed right now, there's no inherent
reason for it to be that way.  The right thing to do would be updating
blkcg to be light-weight rather than adding yet another controller.
Also, all controllers should support full hierarchy.

> Unlike to blkio this method works for all of filesystems, not just disk-backed.
> Also it's able to handle writeback, because each inode has context which can be
> used in writeback thread to account io operations.

Again, a problem to be fixed in the stack rather than patching up from
up above.  The right thing to do is to propagate pressure through bdi
properly and let whatever is backing the bdi generate appropriate
amount of pressure, be that disk or network.

> This is early prototype, I have some plans about extra functionality because
> this accounting itself is mostly useless, but it can be used as basis for more
> usefull features.

I'm afraid it'd have very low chance of making upstream.  If this area
of work is interesting / important, please look into improving blkcg
rather than working around it.

Thanks.

-- 
tejun
