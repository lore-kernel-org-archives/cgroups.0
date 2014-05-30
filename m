From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC RESEND 00/14] New version of the BFQ I/O Scheduler
Date: Fri, 30 May 2014 12:16:50 -0400
Message-ID: <20140530161650.GH24871@htj.dyndns.org>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
 <20140530153228.GE16605@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=aBPH1WeKmKxcwvMvtuzUxpeb03bqHECTMPICwS7pjAw=;
        b=tYXOQTQSCeSwiigvPm6TtsGoy1CorcpXfgJRgDKTqXK/ggzlkKmvJiHrg/Ok7dauwt
         9J4vc4d7Q3uujClUWsOYAEoCtmCvbCN7IFgcvYGqb5ROGF26NxJBmKxCU0dow7ZHyTOO
         rswnCW1UWGyYUiB8JfP31268iTdy6e8jBNHAXtpB3H2zTiOvxPAzCLbgE960HzgkFHpT
         2Q43619dfoI+TWP/9x20qpGDWLeW9APajNGmaOq0rbI8EtiVxoIQzQdKNFn+zIDOfB7h
         W+Hi6YrYjp7WukFlYlJBOk/YYYMtzhtPmnu/1njDjZ/7d1ftUC+9mMRor/iOpZKTejsC
         Dhiw==
Content-Disposition: inline
In-Reply-To: <20140530153228.GE16605-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: paolo <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paolo Valente <posta_paolo-whZMOeQn8C0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Vivek.

On Fri, May 30, 2014 at 11:32:28AM -0400, Vivek Goyal wrote:
> I don't think most of the people care about strong fairness guarantee.
> As an algorithm round robin is not bad for ensuring fairness. CFQ had
> started with that but then it stopped focussing on fairness and rather
> focussed on trying to address various real issues.

Oh, I widely disagree.  Have you looked at the test results in the
paper?  Unless the results are completely bogus, which it probably
isn't, this is awesome.  This is a *lot* more clearly characterized
algorithm which shows significantly better behavior especially in use
cases where scheduling matters.  I mean, it even reaches higher
throughput while achieving lower latency.  Why wouldn't we want it?

> And CFQ's problems don't arise from not having a good fairness algorithm.
> So I don't think this should be the reason for taking a new scheduler.

In comparison, cfq's fairness behavior is a lot worse but even
ignoring thing, one of the major problems of cfq is that the behavior
is hardly characterized.  It's really difficult to anticipate what
it'd do and understand why, which makes it very difficult to maintain
and improve.  Even just for the latter point, it'd be worthwhile to
adopt bfq.

> I think instead of numbers, what would help is a short description
> that what's the fundamental problem with CFQ which BFQ does not
> have and how did you solve that issue.

The papers are pretty clear and not too long.  Have you read them?

> One issue you seemed to mention is that write is a problem. CFQ 
> suppresses buffered writes very actively in an attempt to improve
> read latencies. How did you make it even better with BFQ.
> 
> Last time I had looked at BFQ, it looked pretty similar to CFQ except
> that core round robin algorithm had been replaced by a more fair
> algo and more things done like less preemption etc.
> 
> But personally I don't think using a more accurate fairness algorithm
> is the problem to begin with most of the time.
> 
> So I fail to understand that why do we need BFQ.

I violently disagree.  This is awesome.

Thanks.

-- 
tejun
