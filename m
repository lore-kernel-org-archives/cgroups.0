From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] cgroup TODOs
Date: Fri, 14 Sep 2012 10:53:16 -0700
Message-ID: <20120914175316.GE17747@google.com>
References: <20120913205827.GO7677@google.com>
 <1347621302.7172.22.camel@twins>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ePcUTSZtfxYqWNaAn71LL1u/nfd5g5ImfMLFAYAGgIA=;
        b=vMbKN5z+U5zQWbh34CWvY9E1twCDyiNAUrRKdb6S59U/DY8AxPq23EdLXyU8TF5M4B
         pqPbOCeSqO8d9pYlTwPiyvEUq1BnVALh/DradFKy7atxMk4aI5G7IMHp4OfgzK3J/Y9A
         pv272dsqG3UoiEDcMO9X+vLctW6zgiiGW+lGWlXsMGCz9ky8JV3DsazuOM9Gnp575Z95
         d89OjLcVEnQvG38qQqaWASwKxXGHjnfMzXF9/4UF8Spapqp2jOVSti4cJdObPsePu67K
         gEbqk1m0rApLQg6UQo65VYSJ2r4CWtwcLhJ9sDXCPHm6PCoooKFkw4+tKgYxx1aSdn49
         NYoQ==
Content-Disposition: inline
In-Reply-To: <1347621302.7172.22.camel@twins>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Hello, Peter.

On Fri, Sep 14, 2012 at 01:15:02PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-13 at 13:58 -0700, Tejun Heo wrote:
> >   The cpu ones handle nesting correctly - parent's accounting includes
> >   children's, parent's configuration affects children's unless
> >   explicitly overridden, and children's limits nest inside parent's. 
> 
> The implementation has some issues with fixed point math limitations on
> deep hierarchies/large cpu count, but yes.
> 
> Doing soft-float/bignum just isn't going to be popular I guess ;-)

As things currently stand, I think the cpu stuff is high enough bar to
aim for.  That said, I do have some problems with how it handles tasks
vs. groups.  Will talk about in another reply.

> People also don't seem to understand that each extra cgroup carries a
> cost and that nested cgroups are more expensive still, even if the
> intermediate levels are mostly empty (libvirt is a good example of how
> not to do things).
> 
> Anyway, I guess what I'm saying is that we need to work on the awareness
> of cost associated with all this cgroup nonsense, people seem to think
> its all good and free -- or not think at all, which, while depressing,
> seem the more likely option.

The decision may not have been conscious but it seems that we settled
on the direction where cgroup does more hierarchy-wise rather than
leaving non-scalable operations to each use case - e.g. filesystem
trees are very scalable but for that they give up a lot of tree-aware
things like knowing the size of a given subtree.

For what cgroup does, I think the naturally chosen direction is the
right one.  Its functionality inherently requires more involvement
with the tree structure and we of course should try to document the
implications clearly and make things scale better where we can
(e.g. stat propagation has no reason to happen on every update).

Thanks.

-- 
tejun
