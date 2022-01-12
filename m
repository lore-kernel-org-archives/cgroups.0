From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 4/7] cgroup/cpuset: Add a new isolated cpus.partition
 type
Date: Wed, 12 Jan 2022 11:23:39 -1000
Message-ID: <Yd9G27Jhn6XpCArg@slm.duckdns.org>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-5-longman@redhat.com>
 <Yd7x3P+wGCVfYtza@hirez.programming.kicks-ass.net>
 <0cf37ac0-69c7-2da4-22a6-58e78dc35cef@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=joW7LRyJxGU+ls3GDExQALSF8Ajn8PPvcP34cp5s5X8=;
        b=AdyXG9XI9slk2xLabffbB7kjFOKzRJMJTMAGCvwXu48pDzBggUTt0o3eO/hAcVCXtd
         p/Y1IgkWZ2FRoLx6EkgKcAAk7LFaeTGnNLq8TipYkngOeSOLrsPxoPCx5cMUMGakQxBw
         GqeQnKVGrpzeNrzEuSOuzgzCdxT4ncFxjS8BaZl9wb4MJyXnWcR0YqeSiXbxkwlnTSHB
         fVgDmk2Os6dZor4FJaLs/UpXlZof3KgvtyBNwa+d/2tftO5OJmz5mzAOnDE5obSm2vbU
         Nv/GbGdmatRVy2iXezqSL8kahPc5KR3T56uHfwJUro8mi4x+i9fsKPzczZTkYipP9ovc
         waMA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0cf37ac0-69c7-2da4-22a6-58e78dc35cef-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Wed, Jan 12, 2022 at 10:40:01AM -0500, Waiman Long wrote:
> Yes, that is a possible workaround. However, it makes cgroup management much
> harder especially in the cgroup v2 environment where multiple controllers
> are likely to be enabled in the same cgroup.

In most cases, cgroup2 shouldn't be a problem here given that controllers
can be enabled selectively and this 1-cpu cgroups will most likely be
leaves. But yeah, not super convenient.

Thanks.

-- 
tejun
