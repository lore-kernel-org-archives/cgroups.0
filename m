From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2 0/4] Introduce group balancer
Date: Tue, 8 Mar 2022 07:13:33 -1000
Message-ID: <YieOvaqJeEW2lta/@slm.duckdns.org>
References: <20220308092629.40431-1-dtcccc@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uo3YhUMbdaePnU6cb6jJ/A2E7AHW+1jZYWhnJKd7Sk8=;
        b=P4W2XgegdlmpihJbSspGRSZg95TKVpuUFPXs2xm3bmYsLkzpnCFD8V8AYKzsxGW0cP
         S/IhhZBfcKVEKOCNK9ws2cYY5BQWpxdtRmP8AKvfjdKBGiZ71RZpuiWmvd1aWOL9/Lae
         A2NMN5Mb9mVCnq9PoDhT5+9VSSLzlFatI1X/QSlVO4CBeCM8a/K+z02OsYDIcw9OxUfa
         8/vSQ00ge8dPW0NM/TF2EuUNOqDKggkq4SbDQ21FnDAPSEe750WzGf8E7Jq+zVGDu1GX
         YDw+Lwg3Pwxx+/hNBD7B0irfd+nWC/JyJJJAI5YuDEQZOZSTLHXcJyz+RInJzu7RlRAI
         IBAA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220308092629.40431-1-dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michael Wang <yun.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Cruz Zhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Masahiro Yamada <masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nathan Chancellor <nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <ar>

Hello,

On Tue, Mar 08, 2022 at 05:26:25PM +0800, Tianchen Ding wrote:
> Modern platform are growing fast on CPU numbers. To achieve better
> utility of CPU resource, multiple apps are starting to sharing the CPUs.
> 
> What we need is a way to ease confliction in share mode,
> make groups as exclusive as possible, to gain both performance
> and resource efficiency.
> 
> The main idea of group balancer is to fulfill this requirement
> by balancing groups of tasks among groups of CPUs, consider this
> as a dynamic demi-exclusive mode. Task trigger work to settle it's
> group into a proper partition (minimum predicted load), then try
> migrate itself into it. To gradually settle groups into the most
> exclusively partition.
> 
> GB can be seen as an optimize policy based on load balance,
> it obeys the main idea of load balance and makes adjustment
> based on that.
> 
> Our test on ARM64 platform with 128 CPUs shows that,
> throughput of sysbench memory is improved about 25%,
> and redis-benchmark is improved up to about 10%.

The motivation makes sense to me but I'm not sure this is the right way to
architecture it. We already have the framework to do all these - the sched
domains and the load balancer. Architecturally, what the suggested patchset
is doing is building a separate load balancer on top of cpuset after using
cpuset to disable the existing load balancer, which is rather obviously
convoluted.

* AFAICS, none of what the suggested code does is all that complicated or
  needs a lot of input from userspace. it should be possible to parametrize
  the existing load balancer to behave better.

* If, for some reason, you need more customizable behavior in terms of cpu
  allocation, which is what cpuset is for, maybe it'd be better to build the
  load balancer in userspace. That'd fit way better with how cgroup is used
  in general and with threaded cgroups, it should fit nicely with everything
  else.

Thanks.

-- 
tejun
