From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 06/12] cgroup, memcg: move cgroup_event implementation
 to memcg
Date: Fri, 30 Aug 2013 06:52:10 -0400
Message-ID: <20130830105210.GA30910@htj.dyndns.org>
References: <1376582550-12548-1-git-send-email-tj@kernel.org>
 <1376582550-12548-7-git-send-email-tj@kernel.org>
 <20130829181911.GA8517@mtj.dyndns.org>
 <20130830104755.GC28658@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mFf3NTHwbMnE08LIahMO8czaHtUIFw1IzijZtHfr7WI=;
        b=ZMpWiqMcr1ExEluR++l6CSncDvr76F8MdtD3vKNBTELepuY6fBS3hgT/8DdV2eNAwh
         bek58S6Zze84Amjjg1rKoFHqHfttpMh6hwTuiQaAuzHb6I5t06gaBJEHGduEzbo7KeeD
         caXQE36WMhv+eAYD6qRfZEuexOzd84APVCACvH5lufNZ6vacSJG7yHLBaxJ9WxLUAxqa
         j5SZfHm8P+PKbPPHs4v5N3d3cPua76ih/6tkQGELesyxhtXyiaC6ifynKuuILT1o/rt6
         CDpE0UbB/OHW80f8iyod61rrQBCimWzCfIjd4YGQ3h32/3K2fwmZiQFuKxTaZsdfu5JJ
         9LIQ==
Content-Disposition: inline
In-Reply-To: <20130830104755.GC28658-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Michal.

On Fri, Aug 30, 2013 at 12:47:55PM +0200, Michal Hocko wrote:
> > Updated as requested.  If there's still somthing missing, please let
> > me know.  In case you're okay with the change, how do you wanna route
> > it?  01-05 are already in cgroup/for-3.12 and the rest can either be
> > applie to cgroup/for-3.12, which will likely to require some, mostly
> > trivial, adjustments to memcg patches in -mm, or these all can be
> > routed through -mm.  Any preference?
> 
> I do not care much but as Andrew wasn't CCed and this comes quite late he
> might be reluctant to take it now and push in the next merge window. So
> if you hurry with this then route it via your tree.

Hmmm... yeah, it's quite late and I think it'd be better to do it in
the next cycle so that we can avoid disturbing memcg patches (again).
If you ack the changes, I'll queue them in a separate branch after
v3.11 is released so that memcg tree can be based on top of it.  Would
that work?

Thanks.

-- 
tejun
