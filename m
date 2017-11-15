From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup/cpuset: remove circular dependency deadlock
Date: Wed, 15 Nov 2017 09:05:24 -0800
Message-ID: <20171115170524.GU983427@devbig577.frc2.facebook.com>
References: <45cdac2f-4462-e5b5-d724-8cca58e3932a@codeaurora.org>
 <1509347805-23491-1-git-send-email-prsood@codeaurora.org>
 <6f8b194f-05ec-05d4-3df6-e9eadc7f68bf@codeaurora.org>
 <20171115103742.xt7muaq2dfrs2cyd@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ta3Rx4hEuOe7xYzb5+/ff1Yj+GHSja3IAdnF2NTOi0s=;
        b=a/WHd6GZ+ro/CsEMbpr7LIq625LvKppBHTXdM6W8HZYpiSnfuGaBuJZqUOFOAelhWH
         NCU7Lk8q5ftOPbe31Vuc4YEY7rDff0Nk1EAuw8Nku/okFiAsD3sgbwZoNpLhwtR8MCQp
         j5OoIRNLROuuzYeeklc4MoN0aO2GssapJ9UOBq3o8dpKlyfQ5QVs5MmFGwKryXilHhJk
         xXk3M9HZtGHJMYwRrAq2rHhXMRpm6d35NICRhLDtmO2jdTWXqMIBhx2mb9jOSlSIzP2g
         OnCou0cw3UEZSFXssFxuhQDgPZTRBa7BnKDQJZ4p8vmo8j/Fk4chzf4XDZku4jqYEJAJ
         U/cA==
Content-Disposition: inline
In-Reply-To: <20171115103742.xt7muaq2dfrs2cyd-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 15, 2017 at 11:37:42AM +0100, Peter Zijlstra wrote:
> On Wed, Nov 15, 2017 at 03:56:26PM +0530, Prateek Sood wrote:
> > Any improvement/suggestion for this patch?
> 
> I would have done 2 patches, the first one solving the locking issue,
> the second removing the then redundant async rebuild stuff.
> 
> Other than that this looks OK I suppose, but I was expecting this to go
> through the cgroup tree, TJ?

Will pick them up after -rc1.

Thanks.

-- 
tejun
