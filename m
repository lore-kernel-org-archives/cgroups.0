From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] sched/deadline: cpuset: Rework DEADLINE
 bandwidth restoration
Date: Wed, 15 Mar 2023 14:55:14 +0000
Message-ID: <20230315145514.vjoypwadprvpgwam@airbuntu>
References: <20230315121812.206079-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678892117;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZabwygkIwaPkH1+zXM510MIMS3ybA3ZKy/VPsc/fej0=;
        b=LAe0+2HZbcS22v6Go0o8VDxrhU6u6tvB0jA1ySBIMjzMmYM/fMnxdxTB+6VxbuBmRc
         DeeLT5EoBXj2arciyQbcEurkG+jaDk0+BehhoH1nHSbhVM+uFcmm/L8TPrWM9OWTVlO/
         swWGr7oIZVeLEr/jTYIfDZcFTJ5TkD6KE63FGTLFBzNHA/GxM9YEsfccsUtcPnzRg2pM
         bDVnDmrLPr7Ty6V8FY1xayPkFSu28eOa0XmF1c8K73QO/drOJn+Eyt8w/YO4uIWu045t
         FnGxxgjS8+/0xy9lDBxKPx7iR8PWFzV0X6VPFdk1SAx/xdDnPAIcvOiMbpKYoAkezhPF
         ESVw==
Content-Disposition: inline
In-Reply-To: <20230315121812.206079-1-juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AyHOaXKfS9Lw@public.gmane.org>

On 03/15/23 12:18, Juri Lelli wrote:
> Qais reported [1] that iterating over all tasks when rebuilding root
> domains for finding out which ones are DEADLINE and need their bandwidth
> correctly restored on such root domains can be a costly operation (10+
> ms delays on suspend-resume). He proposed we skip rebuilding root
> domains for certain operations, but that approach seemed arch specific
> and possibly prone to errors, as paths that ultimately trigger a rebuild
> might be quite convoluted (thanks Qais for spending time on this!).

Thanks a lot for this! And sorry I couldn't provide something better.

> 
> To fix the problem I instead would propose we
> 
>  1 - Bring back cpuset_mutex (so that we have write access to cpusets
>      from scheduler operations - and we also fix some problems
>      associated to percpu_cpuset_rwsem)
>  2 - Keep track of the number of DEADLINE tasks belonging to each cpuset
>  3 - Use this information to only perform the costly iteration if
>      DEADLINE tasks are actually present in the cpuset for which a
>      corresponding root domain is being rebuilt

nit:

Would you consider adding another patch to rename the functions?
rebuild_root_domains() and update_tasks_root_domain() are deadline accounting
specific functions and don't actually rebuild root domains.


Thanks!
