From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] devcg: Store local settings for each device cgroup
Date: Fri, 16 Aug 2013 11:47:57 -0400
Message-ID: <20130816154757.GG2505@htj.dyndns.org>
References: <1376580854-30929-1-git-send-email-aris@redhat.com>
 <20130815195941.GA10977@mtj.dyndns.org>
 <20130815204804.GO7878@redhat.com>
 <20130815210937.GB10977@mtj.dyndns.org>
 <20130816152025.GC7878@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=u6MNgMA4GfmEyYOoTz3E0T6CaBCTeddIIkDntJ0apok=;
        b=P4FqACQ4TyjU65lhKv+WFwS7gDpReHZ3I9IpElSrmq5NmN+BhgxzvbJpJhy9MNi9zS
         0JN2BeuR3uREjpbVUuAP3k2J6DAVJEAGbZlPIgEyqAqPBsnbYxuUxE8HwXiULl6ccvaT
         eU6hlmq2+VDb6R+moKahJiGuddJkYWrjgDiKdy7k00fm/izLZm2J8x/VOeRHR2QHRcVu
         +zS6D0t9NckhIY48bx5g3RywXjjYB4lNAAb+/ZgjJICvIZV1OGUDDO/g5x06tzFM9hyz
         hLztZF2Q8sQF/ECXOVhe3zWTdXddjgfwUagBK/YNJDuKsb958p4azyL80HGoW+oozTnG
         dJZg==
Content-Disposition: inline
In-Reply-To: <20130816152025.GC7878-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>

Hello, Aristeu.

On Fri, Aug 16, 2013 at 11:20:26AM -0400, Aristeu Rozanski wrote:
> > e.g. if a cgroup will be allowed to be moved to another position in
> > the hierarchy, the cgroup shouldn't change its configuration across
> > such migration, right?  If so, we'd be allowing creating a cgroup
> > outside the hierarchy with any configuration moving it under another
> > while disallowing creating it under there and creating the same
> > configuration, which would be an outright buggy behavior.
> 
> Hm, then I think I got the requirements wrong. On my understanding you
> cannot have a cgroup with more access than its parent. And the reason
> for that is at that time the idea of having a container able to control
> its own hierarchy was valid.

Oh yes, sure, a descendant shouldn't have access to devices which
aren't allowed by its ancestors but that doesn't mean it can't have a
rule to allow such access.  It just wouldn't make any difference at
that point.  If the ancestors later change the configuration such that
the device is allowed, the cgroup will have access to that
automatically.  Rules configured and rules being applied need to be
distinguished and the latter doesn't need to affect the former.

> The way it is right now, when moved, a cgroup would have its active
> rules re-checked for permission and it'd be made an attempt to apply
> local rules if the new parent allows it.

Yeah, that's the correct behavior, if I'm not misunderstanding you,
but to be consistent we also need to allow creating rules which allow
devices which aren't allowed by ancestors.  It won't be applicable at
rule creation but may later become effective later on.

Thanks a lot for working on this!

-- 
tejun
