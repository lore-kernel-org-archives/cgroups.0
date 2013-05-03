From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Date: Fri, 3 May 2013 11:57:51 -0700
Message-ID: <20130503185751.GA22860@mtj.dyndns.org>
References: <20130502175701.GL19814@mtj.dyndns.org>
 <20130502181747.GH30020@redhat.com>
 <20130502182933.GN19814@mtj.dyndns.org>
 <20130502184514.GI30020@redhat.com>
 <20130502184953.GP19814@mtj.dyndns.org>
 <20130502190732.GK30020@redhat.com>
 <CAOS58YOk7G=dBG1v5Ed2z3biMMyKkkutp30vH5XC72z0_Z85cw@mail.gmail.com>
 <20130502193139.GL30020@redhat.com>
 <20130502231307.GT19814@mtj.dyndns.org>
 <20130503175652.GB6062@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=Qxx16XjBgGPuq2AzZg4dhnvPGeSX3ER8BMHMjSSSi0s=;
        b=yfOXRI1VghrnIhsNHXVsnhWkzYBCU4grscPUPN4nAxCHlD6VKll6XnrIqC6zC1c3JX
         ykf5jCmDM6c+TRo2jl2e1KyulO6jMd/ta2rRxbKAf5u8tbrZNPShnXF55f8whem+3yKu
         W1MIVoUQM2hQHzGE2hMWpuq7v6ZUqo4ivyTRETYRoatx/8Mv6IMBa6h7xsLPNcCzJyA3
         Z0TRGs2GHT2WGzBDbP67qhvBWXzjNG+eSTsgpVeBMg9BKeOqeaS/pHzWWxkldFO1bT/2
         9xLYkEVa2Gbj1L4Vn9wq+/+4LvMVbtetPBAflpRisLGjH03Ew1rMr9ES4JzERBASB/4a
         qaWQ==
Content-Disposition: inline
In-Reply-To: <20130503175652.GB6062-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 03, 2013 at 01:56:52PM -0400, Vivek Goyal wrote:
> > Yeah, I think that's what *should* be happening but not what I'm
> > seeing.  I'm seeing ~15% penalty.
> 
> What test are you running. I am running a simple dd with directIO and
> I am not seeing any penalty.

Combination of dd and a test program that I've been using for some
while which can generate concurrent direct random IOs.  Attaching the
source code for the latter.

> # set limit to 1000000 bytes/second both in parent and child cgroup
> # dd if=/dev/vdb of=/dev/null iflag=direct
> 
> I will capture blktrace and analyze it though to understand better
> what's happening.

Try using larger block size.  It looks like dispatch windows being
reset depending on timing is hurting the overall bandwidth.  It
becomes pronounced with larger IOs.

Thanks.

-- 
tejun
