From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] cgroup: use percpu refcnt for cgroup_subsys_states
Date: Mon, 17 Jun 2013 10:16:51 -0700
Message-ID: <20130617171651.GE32663@mtj.dyndns.org>
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
 <1371096298-24402-12-git-send-email-tj@kernel.org>
 <20130614132026.GD10084@dhcp22.suse.cz>
 <20130614223125.GD6593@mtj.dyndns.org>
 <20130615053522.GA7017@htj.dyndns.org>
 <20130617132744.GB5018@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=o442r442E35YtG4Q6nMFp8acbjQTv+lKpVAgxmZiviM=;
        b=zQtiOYHbXUJDG8osg72cJL+JGrID24k+D41Ww7CMUZxgWcNF2Tm32iC9LrxIdjDaOJ
         Sf7n7ezI0hCNhXuQqiPeSfUaSTcZhdin+OzpLA9CMbbOqOGbVyz5rPRc47Msn3MZBT8c
         ArD7a/zMjEgcn2FFAcJ3ig9V1bk4Dy8csSw8/ahY4jKMVlggKIyouVqEBF9V/MZXNxh7
         GLATbKhuQiHEub4tHekk+KREiNcCih7j//oCYRwlrdLrYtTWOZl7ua3pQueibsY5i9j6
         cr/DBf2YPtafJY4vda6HA87bfopMDt2R/leB1Q+IabNMfb9HUDaEi2nQioh34fDS2io5
         4n/w==
Content-Disposition: inline
In-Reply-To: <20130617132744.GB5018-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Alasdair G. Kergon" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello, Michal.

On Mon, Jun 17, 2013 at 03:27:44PM +0200, Michal Hocko wrote:
> Thanks for your results! Yes the boost can be really high. I will try to
> measure some memcg workloads as soon as I have some spare cycles. I do
> not expect a big win but I also do not think this would regress.

With the just committed RCU-sched conversion, the slowdown even on
single CPU configuration w/ CONFIG_PREEMPT should be in the range of a
few percent points in the worst cases and will mostly be in the noise
in any realistic scenarios.  So, yeah, looks pretty good to me. :)

Thanks.

-- 
tejun
