From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.12] cgroup: make cgroup_event specific
 to memcg
Date: Fri, 22 Nov 2013 18:39:47 -0500
Message-ID: <20131122233947.GH8981@mtj.dyndns.org>
References: <1376582550-12548-1-git-send-email-tj@kernel.org>
 <20131110044811.GA25112@mtj.dyndns.org>
 <20131111141010.GB14497@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=S4thyFNOIE8yZKOXpO24vZBePHTQAFSv9Zl5u9BW5X8=;
        b=Kw76h8g6Gn/RW6s0V6tDx4IPjLhJr4jeXJkNUtqrtcLnR6CdTiq956Jr3KzoDopHXY
         /lkVkG2ZKERsTID11942hTxKPeRD5Swxf8kgwqM79/gSUwS8UlHa0GzoxCT5TGi0RmWm
         p4NOFZmkzsKY+xOvNggSl2S5RqIjRz3HlfjwU+PYxRETfqyteDRKo6HkFS7AscNmDfhz
         gq0+glZVmTM26WVH87qLwWcHBTrZGb7hejOCr6QwWZkQ2Q+Sqx0NzPOTUWfgGJy77rF6
         s9lg/YOLY2IgLJ6RzJVFzPkpAt6ibdz9uCyWX5+0BG6nT9SCHqxHZ/+ANQ8RtcPDoi4m
         9OCA==
Content-Disposition: inline
In-Reply-To: <20131111141010.GB14497-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Nov 11, 2013 at 03:10:10PM +0100, Michal Hocko wrote:
> On Sun 10-11-13 13:48:11, Tejun Heo wrote:
> > Hey, guys.
> > 
> > I'll route this series through the cgroup tree with the acks added
> > once v3.13-rc1 drops.
> 
> Do you have it a local branch which I can merge into mm git tree?

Applied to cgroup/memcg_event which is based on top of v3.12 and then
pulled into cgroup/for-3.14.  Both branches are stable.  Please feel
free to use any.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git memcg_event
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.14

Thanks.

-- 
tejun
