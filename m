From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 5/5] cgroup/cpuset: Optimize out unneeded
 cpuset_can_fork/cpuset_cancel_fork calls
Date: Wed, 12 Apr 2023 08:27:39 -1000
Message-ID: <ZDb4G2jgQFK8h8Ys@slm.duckdns.org>
References: <20230411133601.2969636-1-longman@redhat.com>
 <20230411133601.2969636-6-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681324061; x=1683916061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Tb4IA2hxKxJJ3RN6D1gKaTZIjLOtDf6PRFb4BO0b70=;
        b=RLhJz9AWjqHov+WhKyEDR+6h+R9ZRGrwVpCnrwr7mS4AYOaQcP/3wLlt/e+w1kHoF2
         g066b9b7dcTfzUBN38Ui3VHndJTO8xge2sl4J5IdBiQD1w1UDZkjT3UURa8dJtHboKQl
         nLMOa35cMN2chosn1wyWPBSipx59lQmh7nwS1vXxLDXlBXwGRFxdeylsnT9hcmZVOSah
         TsCgbzGvQKJwJlCXa3Cw70+r5JaZVtW/GCI58dRr2MFToEM4X8XASJUIcCZwEiece+RH
         USzHP1SUDJNUOObjoWFSJFCoriH4KORWDSHtO//wi5/SP/YuoDSHhyczQ0D6fKHEOYRb
         p+3g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230411133601.2969636-6-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 11, 2023 at 09:36:01AM -0400, Waiman Long wrote:
> The newly introduced cpuset_can_fork() and cpuset_cancel_fork() calls
> are only needed when the CLONE_INTO_CGROUP flag is set which is not
> likely. Adding an extra cpuset_can_fork() call does introduce a bit
> of performance overhead in the fork/clone fastpath. To reduce this
> performance overhead, introduce a new clone_into_cgroup_can_fork flag
> into the cgroup_subsys structure. This flag, when set, will call the
> can_fork and cancel_fork methods only if the CLONE_INTO_CGROUP flag
> is set.
> 
> The cpuset code is now modified to set this flag. The same cpuset
> checking code in cpuset_can_fork() and cpuset_cancel_fork() will have
> to stay as the cgroups can be different, but the cpusets may still be
> the same. So the same check must be present in both cpuset_fork() and
> cpuset_can_fork() to make sure that attach_in_progress is correctly set.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Waiman, I'm not necessarily against this optimization but can we at least
have some performance numbers to show that this is actually meaningful?
Given how heavy our fork path is, I'm not too sure this would show up in any
meaningful way.

Thanks.

-- 
tejun
