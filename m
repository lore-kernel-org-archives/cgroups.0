From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Thu, 26 Mar 2020 15:20:35 -0400
Message-ID: <20200326192035.GO162390@mtj.duckdns.org>
References: <20200326191623.129285-1-joel@joelfernandes.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BshxP40VVzwMKYJQVOlxQ7cvaL9xzYOkqdrLAsauMpo=;
        b=c20H/cNu1p8GBlF+mPsYbUh0rXL1H1AWe/ycm2VlcgEK65RBZQUQlnCR/ZCQQsD1K1
         +Eew8NDPAtsfuRrpiipXtIJx7olzpXEAHnH8S2hPh8lobGAMro4Qdjqd/LMLw/Ote73l
         SwhEfIIRGs6JQOEYNVnK3CsC7lNZ2gM/RM9o3qDLuATA7GcnGnxS5L5kopZxYXw1HJt6
         8gC5IhTabVdSWE6IGVSn9jzjguGE1t62zXlN3zPGs1TY2gMDyiLuiWT9/GYedbHZGDqB
         TZCSr3w0/jJpxXKukQ9LUz5TucI9EYGjvlrwGWAvs5teC779vvVK8kCKIoj4u2JHd9tY
         sUAA==
Content-Disposition: inline
In-Reply-To: <20200326191623.129285-1-joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Joel Fernandes (Google)" <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vpillai-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Guenter Roeck <groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kerr <kerrnel-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Mar 26, 2020 at 03:16:23PM -0400, Joel Fernandes (Google) wrote:
> This deliberately changes the behavior of the per-cpuset
> cpus file to not be effected by hotplug. When a cpu is offlined,
> it will be removed from the cpuset/cpus file. When a cpu is onlined,
> if the cpuset originally requested that that cpu was part of the cpuset,
> that cpu will be restored to the cpuset. The cpus files still
> have to be hierachical, but the ranges no longer have to be out of
> the currently online cpus, just the physically present cpus.

This is already the behavior on cgroup2 and I don't think we want to
introduce this big a behavior change to cgroup1 cpuset at this point.

Thanks.

-- 
tejun
