From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Date: Fri, 3 May 2013 12:14:18 -0700
Message-ID: <20130503191418.GC22860@mtj.dyndns.org>
References: <20130502182933.GN19814@mtj.dyndns.org>
 <20130502184514.GI30020@redhat.com>
 <20130502184953.GP19814@mtj.dyndns.org>
 <20130502190732.GK30020@redhat.com>
 <CAOS58YOk7G=dBG1v5Ed2z3biMMyKkkutp30vH5XC72z0_Z85cw@mail.gmail.com>
 <20130502193139.GL30020@redhat.com>
 <20130502231307.GT19814@mtj.dyndns.org>
 <20130503175652.GB6062@redhat.com>
 <20130503185751.GA22860@mtj.dyndns.org>
 <20130503190823.GC6062@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=08BmKuyY6X6DRLH9D4/tXejMcUIVsUgw893Zj0YX6SA=;
        b=mj9PFMGsf+/OpNk4TDoFggrzM11Iann+zXL7uc/ba3oiuUnzVl/l/zpCmLW9IVBM+t
         3M2GLA6bhcelZS1mSbXMiE/QNAWLuEOwpa6r7va2s/lon54kxktm0G9HGRtf9qjvEjnX
         PguCk0eJUEayhVkLaaBOP1X/1b2Z6S68D+jv1kbDljkTWZuTFebspwTrBlRefKT8hTQy
         Dp1uCUeLyrG9XKsEKRbjjWhFroP7cCRz+GwSotfKVzU21x1KhVsG9PzCcxtCrxgONyud
         XqqIheSNJ4DnQvFYJwa5EdtAqwldcaaJwSxNd+gfKjX5JU0Ofql0UdDOXMXs5FFjiROA
         gt2A==
Content-Disposition: inline
In-Reply-To: <20130503190823.GC6062-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 03, 2013 at 03:08:23PM -0400, Vivek Goyal wrote:
> 		T1	T2	T3	T4	T5	T6	T7
> parent:			b1	b2	b3		b4 	b5
> child: 		b1	b2	b3		b4	b5	
> 
> 
> So continuity breaks down because application is waiting for previous
> IO to finish. This forces expiry of existing time slices and new time
> slice start both in child and parent and penalty keep on increasing.

It's a problem even in flat mode as the "child" above can easily be
just a process which is throttling itself and it won't be able to get
the configured bandwidth due to the scheduling bubbles introduced
whenever new slice is started.  Shouldn't be too difficult to get rid
of, right?

Thanks.

-- 
tejun
