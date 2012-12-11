From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: performance drop after using blkcg
Date: Tue, 11 Dec 2012 08:01:37 -0800
Message-ID: <20121211160137.GJ7084@htj.dyndns.org>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
 <20121211142518.GA5580@redhat.com>
 <20121211142742.GE7084@htj.dyndns.org>
 <20121211144336.GB5580@redhat.com>
 <20121211144718.GF7084@htj.dyndns.org>
 <20121211150234.GC5580@redhat.com>
 <20121211151412.GG7084@htj.dyndns.org>
 <20121211153725.GD5580@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QhDUHEqea0+pg0jkXS548G4asrpZsEQQnk1di/w69fI=;
        b=qwRDksF+/xbEvhiAGs+gW9ll9xzxKbhOn59hWYm+UYNzYhoXER+Ecpp4KVOi3OWbZ/
         zDGMaom0M0Moww5GGygEbP5bTmj4Cl5Yh2M/oGsDrF94YM3jBr15guDUxGG9a1EicARs
         TE02Il1pqvqfdQai2TPNEXWnpQLJcczDvhpP8DW4UbqpVMRjd7mKdD4YskI5HCjJcmqO
         P0fVgtFXxwMvHJI1nyLc5VUQ4K9vuQ3RwAoK7xj40J03X+MtCP7ARhYRDvqvar7fpupu
         BRnDbgQJJJiCVY0eK5VIT6/XVwfwQxuHdI4Z3gNlLqtf5vYvFkpUGzYHqtM4xfneBC6F
         YOZw==
Content-Disposition: inline
In-Reply-To: <20121211153725.GD5580-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zhao Shuai <zhaoshuai-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, Vivek.

On Tue, Dec 11, 2012 at 10:37:25AM -0500, Vivek Goyal wrote:
> I have experimented with schemes like that but did not see any very
> promising resutls. Assume device supports queue depth of 128, and there
> is one dependent reader and one writer. If reader goes away and comes
> back and preempts low priority writer, in that small time window writer
> has dispatched enough requests to introduce read delays. So preemption
> helps only so much. I am curious to know how iops based scheduler solve
> these issues.  
> 
> Only way to provide effective isolation seemed to be idling and the
> moment we idle we kill the performance. It does not matter whether we
> are scheduling time or iops.

If the completion latency of IOs fluctuates heavily depend on queue
depth, queue depth would need to be throttled so that lower priority
queue can't overwhelm the device queue while prospect higher priority
accessors exist.  Another aspect is that devices are getting a lot
more consistent in terms of latency.

While idling would also solve isolation issue with unordered deep
device queue, it really is a solution for a rotational device with
large seek penalty as the time lost while idling can often/somtimes
made up by the save from lower seeks.  For non-rot devices with deep
queue, the right thing to do would be controlling queue depth or
propagate priority to the device queue (from what I hear, people are
working on it. dunno how well it would turn out tho).

> >  cfq is way too heavy and
> > ill-suited for high speed non-rot devices which are becoming more and
> > more consistent in terms of iops they can handle.
> > 
> > I think we need something better suited for the maturing non-rot
> > devices.  They're becoming very different from what cfq was built for
> > and we really shouldn't be maintaining several rb trees which need
> > full synchronization for each IO.  We're doing way too much and it
> > just isn't scalable.
> 
> I am fine with doing things differently in a different scheduler. But 
> what I am aruging here is that atleast with CFQ we should be able to
> experiment and figure out what works.  In CFQ all the code is there and
> if this iops based scheduling has merit, one should be able to quickly
> experiment and demonstrate how would one do things differently.
> 
> To me I have not been able to understand yet that what is iops based
> scheduling doing differently. Will we idle there or not. If we idle
> we again have performance problems.

When the device can do tens of thousands ios per sec, I don't think it
makes much sense to idle the device.  You just lose too much.

> So doing things out of CFQ is fine. I am only after understanding the
> technical idea which will solve the problem of provinding isolation
> as well as fairness without losing throughput. And I have not been
> able to get a hang of it yet.

I think it already has some aspect of it.  It has the half-iops mode
for a reason, right?  It just is very inefficient and way more complex
than it needs to be.

Thanks.

-- 
tejun
