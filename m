From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cpuset: fix race between hotplug work and later CPU
 offline
Date: Fri, 13 Nov 2020 05:26:03 -0500
Message-ID: <20201113102603.GG7496@mtj.duckdns.org>
References: <20201112171711.639541-1-daniel.m.jordan@oracle.com>
 <20201113081622.GA2628@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OzkmFiHGwyD+I15mtrva81uZcY7HDY5tWPQl2Uj50ck=;
        b=K+WAle8GcXxw4uPqUL3iF+4TrsgI5rq+lL7lrFVr6yVcAlbePlqv6f7qb6i2dM+FZd
         E2icUWNakB9SOYmNfM1R+nHqLV1UtP44bsReRVk6nMLaJ6J6MKUufQTVm2FwRgdt2owu
         DNYQDYbTsw1gNPvKRsJz4vR0tp4YkgQ6rluw2pGXjvw2YCe8JLueyLsIggXiKKIZVmN/
         L/qay4mlQ8jTALH9QIdPLCT8R+Sb1Q7IvwdXl4e2FcnGEuw2sSqG3jYi8w4OXUox/NKJ
         HVMNJur/eLs9eK1bOP+D98m0WL8/WcxWxbm+3VAu4mihjfEehI3AFTfZ9t+E2iaw5vAI
         J8NQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20201113081622.GA2628-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Nov 13, 2020 at 09:16:22AM +0100, Peter Zijlstra wrote:
> Works for me. TJ, do I take this or do you want it in the cgroup tree?
> 
> In that case:
> 
> Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Please take it through the sched tree, and FWIW

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thank you.

-- 
tejun
