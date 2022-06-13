From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v11 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Sun, 12 Jun 2022 17:12:51 -1000
Message-ID: <YqarMyNo9oHxhZFh@slm.duckdns.org>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-8-longman@redhat.com>
 <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
 <404171dc-0da3-21f2-5003-9718f875e967@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q0gGWcWV/COJT901q1rc8QzcrP5DaNECZkTvshE+F+Q=;
        b=KyQJjJ5e7Nsc4ypOYCGc1PPbWbAidU7McvnzqEwhmXBSKGt+XA+UKo4C0rStxYLtJ6
         rzzT7/GhMYx3yzArDjKvdHv48bl1IH5UTHIo6z8v3HO0+YiK0Ouxtqo8iVvuBkoJpNUj
         Xw49TN+kG5PMWL7Zmdq/LcnxdEME5yBFZzB5+q2WmWf9oibGDOHANnGUF0XVZr1TDpAT
         OGPBKSva3rbfUUvwOG56eu3S0Eal0dSMaPyP8UCn0t556oli2wM6QdU6PfNuhaRUeetW
         PDazGjTXbMEwdTPjrNC1IfAHzRwTtJU7evS9DKVtupE8v9qPoM++WUb2O4s5v7QxmPal
         tDcw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <404171dc-0da3-21f2-5003-9718f875e967-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

Hello,

On Sun, Jun 12, 2022 at 11:02:38PM -0400, Waiman Long wrote:
> That is the behavior enforced by setting the CPU_EXCLUSIVE bit in cgroup v1.
> I haven't explicitly change it to make it different in cgroup v2. The major
> reason is that I don't want change to one cpuset to affect a sibling
> partition as it may make the code more complicate to validate if a partition
> is valid.

If at all possible, I'd really like to avoid situations where a parent can't
withdraw resources due to something that a descendant does.

Thanks.

-- 
tejun
