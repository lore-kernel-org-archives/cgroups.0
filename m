From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v14 1/4] cgroup: fix uninitialised iterator in
 for_each_subsys_which
Date: Wed, 10 Jun 2015 13:49:36 +0900
Message-ID: <20150610044936.GI11955@mtj.duckdns.org>
References: <1433849530-22845-1-git-send-email-cyphar@cyphar.com>
 <1433849530-22845-2-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=72M9hWvq2tzCrvMutYNZBLPp/QQ/PkUg7qUwYTPyfQo=;
        b=sxHCF+AXL1qhIacBrYET0dbop+MT6U/EJWOH7caPGk4LIU5u4DBSOhrlYLS++50H2Y
         2PMCuxoOA3l/Ax5MJzfKKB/qcDErUk5/h4ySJ/vKwMFoeDnIBWD30fmJ4mSyg2SQQ6TL
         7B6nEBmdl+9RtqF/yIGoVFomGtG7dRmlrZI38AYFJ1ehmmsTNZEMCwY4F84UTO30ro2C
         GWjOISLh3GmaeBO/K/ekFyC1V8YWGom0yY3PHA5C4RyppKsX3EDnxCVLO6jG3bUm7eNQ
         02XJPXkYQpSbQ7sIWB/tsA1K6X3RWfUmpC4kp8CJ1IQzgcoKz6rfzM74Yr+KIH7FeJzy
         MzSg==
Content-Disposition: inline
In-Reply-To: <1433849530-22845-2-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 09, 2015 at 09:32:07PM +1000, Aleksa Sarai wrote:
> Fix the fact that @ssid is uninitialised in the case where
> CGROUP_SUBSYS_COUNT = 0 by setting ssid to 0.
> 
> Fixes: cb4a31675270 ("cgroup: use bitmask to filter for_each_subsys")
> Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.2.

Thanks.

-- 
tejun
