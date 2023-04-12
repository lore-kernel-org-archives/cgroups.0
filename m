From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 0/5] cgroup/cpuset: Fix CLONE_INTO_CGROUP problem &
 other issues
Date: Wed, 12 Apr 2023 08:26:33 -1000
Message-ID: <ZDb32V9xcWOi2_CL@slm.duckdns.org>
References: <20230411133601.2969636-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681323996; x=1683915996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qe4SS5MwqgNNblasLyBUlGHPWf5yZ2STwXpKEpxvmgk=;
        b=D6xcB4D7MIBRR03l3RpjS/l27LEHg1viozYtwZQliZiaIVrC1xMrJpPnq8o1gzm14I
         JinmTIp358cI33pWMrORKQjFCOlJXwjAlLcNb5AnbynV6VZyjfLzDiWsLBViXVvEnLF4
         X9S/aXCudZ/20PGfQpYuRUbeRjP2nQ5kAcU5U2HcC/vzbH+MdXAWWMOwtDIsV6J6utNz
         JnD2Jd/YQmdasVSwJXw1J+yGtQcbhRmpXeOQLBQCzXWB1LM58DLi1p0FhFMlCEBCnlKi
         UM9H/rWDEcR6vfqsvyrKzg/07TW1DYjzNfX2+WXz47oV2qD6pQ3+mgdb1AQrsRpVHYOf
         bHXA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230411133601.2969636-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 11, 2023 at 09:35:56AM -0400, Waiman Long wrote:
>  v4:
>   - Add missing rcu_read_lock/unlock to cpuset_cancel_fork() in patch 3.
>   - Add patch 5 to reduce performance impact for the
>     non-CLONE_INTO_CGROUP case.
> 
>  v3:
>   - Update patches 2 & 3 to put task_cs() call under rcu_read_lock().
> 
>  v2:
>   - Drop v1 patch 3
>   - Add a new patch to fix an issue in cpuset_cancel_attach() and
>     another patch to add cpuset_can_fork() and cpuset_cacnel_fork()
>     methods.
> 
> The first patch in this series fixes a problem in
> cpuset_cancel_attach(). Patches 2 and 3 fixes the CLONE_INTO_CGROUP
> problem in cpuset. Patch 4 is a minor fix. The last patch is a
> performance optimization patch for the non-CLONE_INTO_CGROUP case.

Applied 1-4 to cgroup/for-6.3-fixes w/ stable cc'd. Given that the fixes are
a bit involved, the breakages have been there for quite a while and the
cpuset code has changed quite a bit, backporting might not be trivial tho.
Let's see how that goes.

Thanks.

-- 
tejun
