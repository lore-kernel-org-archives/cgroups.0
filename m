From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/9] cgroup/cpuset: Fix a partition bug with hotplug
Date: Mon, 26 Jul 2021 12:59:54 -1000
Message-ID: <YP8+ajTnvrha+0O6@mtj.duckdns.org>
References: <20210720141834.10624-1-longman@redhat.com>
 <20210720141834.10624-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IgP1YWplDp3/09cvQQ0d2eAW1JPxMRhx9Jd4cef5V3E=;
        b=eQAl1RXPI6I/QPb5dmHK3sSJfrW/33/Xd+Kq+ZHhRC+jWg/KgNZOApZ/JQhK/b4tcM
         f1qBS4uW84HHhnxyahQnwsnOk6TeV1HVmF0yO6oZ898KgpEahR5N+sdrg+X1+VfFCl0K
         qwC+oGx/hc4Ck8IVbvOMLHUMwUeIXgYaFT+Oj+zLZblC7w0Y6qY1rgcMgZq4uzSLRKTW
         +awoE5DdCCWXlu137dLx92EfC9UDM3iU0vEUXbRGBxKjwCmO1pt/lsISLS2SSKvf5sYx
         0I3neM8nIcFOXM3f1BOqwuSINJnC+K0ue18tjWWsOWYzDdX7vRJXkfsSFZ4ZrwcVQgCb
         1iwQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210720141834.10624-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Tue, Jul 20, 2021 at 10:18:27AM -0400, Waiman Long wrote:
> In cpuset_hotplug_workfn(), the detection of whether the cpu list
> has been changed is done by comparing the effective cpus of the top
> cpuset with the cpu_active_mask. However, in the rare case that just
> all the CPUs in the subparts_cpus are offlined, the detection fails
> and the partition states are not updated correctly. Fix it by forcing
> the cpus_updated flag to true in this particular case.
> 
> Fixes: 4b842da276a8 ("cpuset: Make CPU hotplug work with partition")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.15 w/ a minor update to the comment (I dropped
"just" before "all". It read weird to me.)

Thanks.

-- 
tejun
