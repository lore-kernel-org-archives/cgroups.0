From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch -v4 4/8] memcg: enhance memcg iterator to support
 predicates
Date: Mon, 3 Jun 2013 18:07:37 -0700
Message-ID: <20130604010737.GF29989@mtj.dyndns.org>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
 <1370254735-13012-5-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XWeGKsnKUBWaBNKHUm+t8/Un86VlwxXrc4V8xDYWi+c=;
        b=hAXqe2CugV68aMWYGLvE6Mfc9mRkEbkT9n/S3G6b1/zvR9j60NFo5GPt5zo9FTPqn2
         Yt+7faDykeA1mQeP6ipVk4/6BIrAHMJSvrfQMlAaYMddpe9vgg++u8nqVuz+HINZrBcM
         nmDoyHDb2SAhYL4f8saOiJNZc8C0I/ZjseLESmuMtoszez0g9XmIwlscJ/TjJy3tA4H1
         G8FkdyiQmsxuzAV+sIWPCi7h9ubYwcgYD6zRBDyHRtTthtiSApLdxZULdFs2s9r5OVoZ
         ANQrLshx1qmgAybqs8ElVfuionCHWQ/NJRmf+lJh2nBWY9ueIYEpuhGwx+r2qSPlzj6H
         aYvQ==
Content-Disposition: inline
In-Reply-To: <1370254735-13012-5-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Jun 03, 2013 at 12:18:51PM +0200, Michal Hocko wrote:
> The caller of the iterator might know that some nodes or even subtrees
> should be skipped but there is no way to tell iterators about that so
> the only choice left is to let iterators to visit each node and do the
> selection outside of the iterating code. This, however, doesn't scale
> well with hierarchies with many groups where only few groups are
> interesting.
> 
> This patch adds mem_cgroup_iter_cond variant of the iterator with a
> callback which gets called for every visited node. There are three
> possible ways how the callback can influence the walk. Either the node
> is visited, it is skipped but the tree walk continues down the tree or
> the whole subtree of the current group is skipped.
> 
> TODO is it correct to reclaim + cond together? What if the cache simply
> skips interesting nodes which another predicate would find interesting?

I don't know.  Maybe it's just taste but it looks pretty ugly to me.
Why does everything have to be folded into the iteration function?
The iteration only depends on the current position.  Can't you factor
out skipping part outside the function rather than rolling into this
monstery thing with predicate callback?  Just test the condition
outside and call a function to skip whatever is necessary?

Also, cgroup_rightmost_descendant() can be pretty expensive depending
on how your tree looks like.  It travels to the rightmost child at
each level until it can't.  In extreme cases, you can travel the whole
subtree.  This usually isn't a problem for its usecases but yours may
be different, I'm not sure.

Thanks.

-- 
tejun
