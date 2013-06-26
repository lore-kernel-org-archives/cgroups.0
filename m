From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.11] cgroup: grab cgroup_mutex in
 drop_parsed_module_refcounts()
Date: Wed, 26 Jun 2013 10:50:08 -0700
Message-ID: <20130626175008.GF4405@mtj.dyndns.org>
References: <51C9D17B.5090208@oracle.com>
 <20130626010454.GD30407@mtj.dyndns.org>
 <20130626010521.GE30407@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=D3R9qt858knNkrcbLlsDzUgKIGn6JenjN7+EjGO3YkU=;
        b=BqK/DX8PMNJysMwFjXp+WqEzZOOdAHEvIllVJEnH0RdIMIgnHGPmSIpgII0xbeYdec
         xVRJjiVXjXK9r/Ept3NlOfpzz7fRSZxsGNQM9dbth/yaAzA08V+GD8IVPSwykRQs4/9+
         etzo7YVZYJzqN6W5MTC9d70q4LTrEIvn2WYUutH+0/K6eKRRjEZFjUee6qrkDpOQ1KBJ
         FhfnUYk37uutPR+SKY3bSuJZyFqs+t4WoPCORSk7wonMvJYhExDccdKwj0ivWaglh9xT
         CM0jFEt7YGTknrSM4Y7QIEUHGSh8p+o0h81KVWc5+ufCJ9lXBONtS42OP1g7QnJcnL1+
         bgdw==
Content-Disposition: inline
In-Reply-To: <20130626010521.GE30407-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trinity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 25, 2013 at 06:05:21PM -0700, Tejun Heo wrote:
> This isn't strictly necessary as all subsystems specified in
> @subsys_mask are guaranteed to be pinned; however, it does spuriously
> trigger lockdep warning.  Let's grab cgroup_mutex around it.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied both patches to cgroup/for-3.11.

Thanks.

-- 
tejun
