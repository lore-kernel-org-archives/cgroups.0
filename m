From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 00/10] cgroup/cpuset: cpu partition code fixes &
 enhancements
Date: Sun, 4 Sep 2022 10:48:38 -1000
Message-ID: <YxUPJqrsWvZoXXhZ@slm.duckdns.org>
References: <20220901205745.323326-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=l3XlvtUxRBxEdbMEdKHUlRAxmIFOa1PhP6QcRf9whvo=;
        b=CTdZcGNlqVJCtE/o2YQJgHj2u1letdzly71G8AwP+23usqZVUHLIE4Oz3/6KDs4S/k
         xDVHrwKau2bdDO3p+4GJEE4K7QECOh3FVRneojsgcLqQYwzUA5pvl4Yvan5dpVZbzmnj
         zEwEP/xpz/w8QJ1Xp4WhhURNX3I5WhNWJivedm5ORPCrVqUmrPIKRy1zFldhV5dNTRoq
         V23Zef6lxQSydwiS4VjveXx6w3ImkA3qsLIQevMCoDrtHryqAG0gDcf7EhpcC4gyjlsD
         XzkCRIGAwLFS1oyrxeott3phfyF91tvQ/Ujs2x48XZwLbJcl0iw4nXvv9FP/95crcZo6
         nckw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220901205745.323326-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Thu, Sep 01, 2022 at 04:57:35PM -0400, Waiman Long wrote:
> v12:
>  - Change patch 1 to enable update_tasks_cpumask() for top_cpuset except
>    for percpu kthreads.
>  - Add 2 more patches to make exclusivity rule violations invalidate the
>    partition and its siblings instead of failing the change to make it
>    consistent with other cpuset changes.
>  - Update documentation and test script accordingly.

Applied to cgroup/for-6.1 with the doc tables fixed.

Thanks a lot for sticking with it. This looks great.

-- 
tejun
