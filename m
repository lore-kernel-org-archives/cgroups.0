From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4-fixes 2/3] cgroup: fix handling of
 multi-destination migration from subtree_control enabling
Date: Tue, 1 Dec 2015 11:44:58 -0500
Message-ID: <20151201164458.GC12922@mtj.duckdns.org>
References: <20151123195541.GA19072@mtj.duckdns.org>
 <56543C76.2050008@bmw-carit.de>
 <20151124144418.GB17033@mtj.duckdns.org>
 <56547B22.2020802@bmw-carit.de>
 <20151124145945.GF17033@mtj.duckdns.org>
 <20151130224205.GA9039@mtj.duckdns.org>
 <20151130224431.GB9039@mtj.duckdns.org>
 <565D45FF.1030804@bmw-carit.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ROCnOijNdD3VFovG2DFRFw3K7JRgdkWODp95voAD+yw=;
        b=ykJ4EIofk0Q9gShUKnLF7iGByEZs+k0+uN+W/Hv5j7sYWH4LVYiTHDMDDIUFsgTMVd
         L9VprWz451W0zKJzB5VZlMMI0azcLaE+ijEncG4GbvkWBHZyZJmekb4SSm2ZbB0PaggN
         zXX2OrWQUemJKKuf9QFZfl2NCQbJSwZgVRpzMudGAd/lWxDP8H9FC0848q9nOPht4FyG
         LUnu9fN3et/RtOG9hgCQCjkcAIIA86L5gi+WK3YB/jdDCoMqgw9cCqrn6icixkWd14Rq
         paHIPxSjlysBcRWd8qDP7U03qv0Kq9BoyzeIIYMJn/aEn6A1dh1BSlTbuysg7qIuiN+z
         xcuw==
Content-Disposition: inline
In-Reply-To: <565D45FF.1030804-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

Hello, Daniel.

On Tue, Dec 01, 2015 at 08:02:23AM +0100, Daniel Wagner wrote:
> I was not able to verify if these two patches are fixing it. I don't see
> the call trace on mainline only when using cgroup/review-xt_cgroup2
> review branch.
> 
> So I ported it to review-xt_croup2 with only a small merge conflict for
> in netclassid_cgroup.c. No fun though, I still see it.

It also needs the previous ref fix patch and Oleg's race fix too.  Can
you please test the following branch?

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-pids-fixes

> Is there a patch missing? The subject indicates there should be 3 patches.

That's just me messing up patch title.  Sorry.

Thanks.

-- 
tejun
