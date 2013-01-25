From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/6] sched: split out css_online/css_offline from tg
 creation/destruction
Date: Fri, 25 Jan 2013 08:47:49 +0100
Message-ID: <20130125074749.GA20868@gmail.com>
References: <5100D4FE.9080205@huawei.com>
 <5100D518.8000103@huawei.com>
 <20130124100134.GC26351@gmail.com>
 <20130124194205.GS2373@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=i1ZygScGiSFg8RAzDUvfyiH6YJtJqif4GwJpXDhyPAE=;
        b=FQuPr4JZhKw89ewK1mu2RsLFfWus5j2hhMXNKWroCSLJmQaIns9gYGfivtMLVfi/pY
         AvCm5OZL6Hd6p1qvsAHGPVbVXyodqeerJsaY9m9AibzlT4qiYb679eedN+Rz4n6AsLJF
         h579THHtkCkFSisQ6IvkvTLlr/g0XxbV1vI75OwHmhtP69WAFMzRT6ZeFxEmZTsx9nEG
         2UuB3nkgJ2e2dshBBGoUvK/cMRlTkhDet4gSAlKDjd+BbfCr2NvKjZcxmh2LapZUqmm2
         3Grmsh12zpcEYBrotg+XMt+VqjlcWSq/5nHEPtHWbS1ab50lDyJMT2DSuewW0Ze93BHA
         8B5A==
Content-Disposition: inline
In-Reply-To: <20130124194205.GS2373-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


* Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Thu, Jan 24, 2013 at 11:01:34AM +0100, Ingo Molnar wrote:
> > Acked-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Ingo, if you don't objecdt, I'll take these through cgroup/for-3.9
> branch with other cgroup changes.  Pleaes holler if you object.

That's fine with me, it should not interact with anything 
pending in (or planned for) the scheduler tree for this cycle.

Thanks,

	Ingo
