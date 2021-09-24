From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] mem_cgroup: optimize the atomic count of
 wb_completion
Date: Fri, 24 Sep 2021 16:01:51 +0200
Message-ID: <YU3aT7i2vBNxewam@dhcp22.suse.cz>
References: <1632465983-30525-1-git-send-email-brookxu.cn@gmail.com>
 <YU2boTZhfbo0h/Xi@dhcp22.suse.cz>
 <03145735-7764-4cd4-e15b-60402f4b447e@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632492114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dmtnQno5WAWYAwYyFrab1anhvWM53F0z0kxqT7Xw1k8=;
        b=nRbMdbYvkFc6B1k0PP9awPeMPmfeeTv3mNv/96g99J9pGTDnAplSR8wAChc7G9xWP98BoD
        gCteNo/1Cqk0O16O2ECCm4MqbJoI9lTh3LJINeTuulQtUUK0k+fNPQIAcU5EIOz6TGODVL
        LwxJX5IWJ/ZTtg+XuAvIrWloxnzE3jg=
Content-Disposition: inline
In-Reply-To: <03145735-7764-4cd4-e15b-60402f4b447e-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 24-09-21 21:02:52, brookxu wrote:
> Thanks for your time.
> 
> Michal Hocko wrote on 2021/9/24 17:34:
> > On Fri 24-09-21 14:46:22, brookxu wrote:
> >> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> >>
> >> In order to track inflight foreign writeback, we init
> >> wb_completion.cnt to 1. For normal writeback, this cause
> >> wb_wait_for_completion() to perform meaningless atomic
> >> operations. Since foreign writebacks rarely occur in most
> >> scenarios, we can init wb_completion.cnt to 0 and set
> >> frn.done.cnt to 1. In this way we can avoid unnecessary
> >> atomic operations.
> > 
> > Does this lead to any measurable differences?
> 
> I created multiple cgroups that performed IO on multiple disks, 
> then flushed the cache with sync command, and no measurable
> differences have been observed so far.

OK, so why do we want to optimize this code?
-- 
Michal Hocko
SUSE Labs
