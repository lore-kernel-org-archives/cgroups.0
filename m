From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-5.8] cgroup: add cpu.stat file to root cgroup
Date: Tue, 26 May 2020 16:15:54 -0400
Message-ID: <20200526201554.GH83516@mtj.thefacebook.com>
References: <20200526200800.3969430-1-boris@bur.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OIlePaEo2DB2lWCSsF6hOGAO/zJmXGR+8z88QbPZwuA=;
        b=vGsBr5wQpHw68zyoZJvgzHNbkgx9psh74mtNJxqpEOgwrQpmej8EZzHAX4XhlgkBAw
         LMMIEgnCRPb4utbn/CnS0mmTr+9tLCJAcYDlmkThNex0SAFcxXvxSps/IwKCuihbUAKw
         /YcMZCmkST4MESr2kDzOSDrPgMTVh1fkmousvPmqj4Hy3X3bCPQ3tan68m6KlRjj6Vfw
         lyXF9bpOir119aygoHP9wIQ4fbD1LqHyTM0finKJh1dqqGmjdDn+ChV2eLSCqAIhqsiL
         PW+Vqyz2HPxXk9Fl5HlmTArOGH2iJoMyRZoYlGJgHisGrNuaCiLCovFib5xYjl8eju23
         E5Vw==
Content-Disposition: inline
In-Reply-To: <20200526200800.3969430-1-boris-UrQYPotlwNs@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Tue, May 26, 2020 at 01:08:00PM -0700, Boris Burkov wrote:
> Currently, the root cgroup does not have a cpu.stat file. Add one which
> is consistent with /proc/stat to capture global cpu statistics that
> might not fall under cgroup accounting.
> 
> We haven't done this in the past because the data are already presented
> in /proc/stat and we didn't want to add overhead from collecting root
> cgroup stats when cgroups are configured, but no cgroups have been
> created.
> 
> By keeping the data consistent with /proc/stat, I think we avoid the
> first problem, while improving the usability of cgroups stats.
> We avoid the second problem by computing the contents of cpu.stat from
> existing data collected for /proc/stat anyway.
> 
> Signed-off-by: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

If there are any objections, please holler. I'll wait a few days and
route it through the cgroup tree.

Thanks.

-- 
tejun
