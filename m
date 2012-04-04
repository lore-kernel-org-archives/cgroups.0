From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] writeback and cgroup
Date: Wed, 4 Apr 2012 16:02:37 -0700
Message-ID: <20120404230237.GA2173@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404145134.GC12676@redhat.com>
 <20120404184909.GB29686@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404203239.GM12676@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jvHbC89Hi1qTkOK+5NsePnGwJAAr/+4RRIDSNJ/TzSQ=;
        b=wuYPM1hjPhKz22EtmWUSxhQxG4EcTNKCsYJfAcfS4bF4xyXJMdUug7lIb18XBZfVMQ
         qYI5KT1amNTFARLG9iuF2r/gs3B0m4jG+kf21sOsr5BXuCvy/GIxlLlrePPa86NaPEXZ
         w6K6dl6Qc8Syx0uM7FyPrbhsxMXCL2VT42bK2n6NAiMnN9wG0FbWnOXZ30YI0uoatmN5
         GDSwbCh89dJdSpipNwwQkEMJ5jYG4yulr8C8IcDn1CempZzraLQ/NlKNed9knSph2iTi
         WuYw4UmnUiZV3H9yS3A+k11DacoWBur3j19JNm/sGw5T9lDqV5uu/I5yT/lY9bUEJOOO
         wJ+w==
Content-Disposition: inline
In-Reply-To: <20120404203239.GM12676-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, sjayaraman-IBi9RG/b67k@public.gmane.org, andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org, jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lsf-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, Vivek.

On Wed, Apr 04, 2012 at 04:32:39PM -0400, Vivek Goyal wrote:
> > Let's say we have iops/bps limitation applied on top of proportional IO
> > distribution
> 
> We already do that. First IO is subjected to throttling limit and only 
> then it is passed to the elevator to do the proportional IO. So throttling
> is already stacked on top of proportional IO. The only question is 
> should it be pushed to even higher layers or not.

Yeah, I know we already can do that.  I was trying to give an example
of non-trivial IO limit configuration.

> So split model is definitely confusing. Anyway, block layer will not
> apply the limits again as flusher IO will go in root cgroup which 
> generally goes to root which is unthrottled generally. Or flusher
> could mark the bios with a flag saying "do not throttle" bios again as
> these have been throttled already. So throttling again is probably not
> an issue. 
> 
> In summary, agreed that split is confusing and it fills a gap existing
> today.

It's not only confusing.  It's broken.  So, what you're saying is that
there's no provision to orchestrate between buffered writes and other
types of IOs.  So, it would essentially work as if there are two
separate controls controlling each of two heavily interacting parts
with no designed provision between them.  What the....

-- 
tejun
