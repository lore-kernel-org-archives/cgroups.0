From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Wed, 11 Mar 2015 07:46:46 -0400
Message-ID: <20150311114646.GC25944@htj.duckdns.org>
References: <1425010639-16492-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-2-git-send-email-cyphar@cyphar.com>
 <20150309030636.GC13283@htj.duckdns.org>
 <CAOviyaip7Faz98YWzGoTaXGYVb72sfD+ZL4Xa89reU9+=43jFA@mail.gmail.com>
 <20150309065902.GP13283@htj.duckdns.org>
 <CAOviyaj3mf66ho15WrD8qB=ECxKWYTAkWodxWaFVMWeZG4d0FQ@mail.gmail.com>
 <20150310124701.GB28730@htj.duckdns.org>
 <CAOviyai7yJrbGb+uYpK35tw7R-KM0jWQ-BmhpyTqnRFJsVYdUA@mail.gmail.com>
 <20150310151728.GD28730@htj.duckdns.org>
 <CAOviyajuq5QgwmByVzF34RVyRs+fad=82i2pJH12y1kB5X6bWg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6CV4CygAx8YPAS1LGXtQzS3wCMSCkCRlH3mc758fFR8=;
        b=Sa54hggZflfUa/Sv3E0wLwOLCCAWPNayvqvQkGLg/MDf2AESe43gpAILxnfS3gzIa7
         UKMFvP4SLrerGqrgUs4U55Iu2fIuP4etoYPiQuxqkEVFhAotFoeyR2CvLED895+obSWL
         0eMzd7d9eOwvzKBuTXhWO4UxV4eABsAfX8GIYtVKeuMuuxpu3RzQ6iPx07NKgokf6QI+
         yMy8jVTd+wXMiOGqZGhE0L2mDagJmmt/4ScnfRLGyoV3KGhE1JNFFPW2X9JgbC2n3x/m
         /PBVukuGVJ7zeRSBu56LaL3lPDh8iUv6VCrzSzvq55BpBnEGuW0YMGj9KjqubnUITci6
         N+9Q==
Content-Disposition: inline
In-Reply-To: <CAOviyajuq5QgwmByVzF34RVyRs+fad=82i2pJH12y1kB5X6bWg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Wed, Mar 11, 2015 at 04:16:30PM +1100, Aleksa Sarai wrote:
> We know that the task will have its css_set set to task_css_set(current), and
> we could just use that in cgroup_can_fork(). The only question is, can
> task_css_set(current) change between cgroup_can_fork() and cgroup_post_fork()?

Yes, that's what I've been writing in the previous messages.  It can change.

> If it can change between the two calls, then we're in trouble -- there'd be no
> reliable way of checking that the future css_set allows for the fork without
> going through the registration of the css_set *proper* in cgroup_post_fork()
> unless we hold css_set_rwsem for the entirety of the can_fork() to post_fork()
> segment (which I can't imagine is a good idea).

Please re-read my previous messages.

Thanks.

-- 
tejun
