From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Make cpuset_fork() handle
 CLONE_INTO_CGROUP properly
Date: Thu, 6 Apr 2023 11:45:53 +0200
Message-ID: <20230406-vernommen-kurieren-e75f4ee6ea96@brauner>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680774359;
        bh=CNnljoUNyOiCQnpEpUjEBMYYwt8hw2OqgmnQ53lJJC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NO4KxgWW4fGaPj/jgCTdne5zTkmD5p5XSq8odegv2hTDIN/+Gx/hpw686wJ2vJzt7
         dThSxxFMxxBYdfBZ93TM3nfZyuEoi3I0NZHSLTo6SaqR8RxxjSJ4+xVUb6R4n8Qbon
         GLYOO6EQQpJr6x7794UnkMjbDvkz/flUyRCXjk6FHck+y0PL1EgOy4HFQFTDEMqmkl
         iKmrWRC6JsPXFyJN4tb8IekF1NjUDg+0qKMJNTSoVk8mV0MZVYn6KqvBxgROg6j8VO
         TAbrbZJQUyQi3wL8C99KaZlaVKV0Xy106X4QSyidFU0RfdMaTf3HEUuxxV4cgcD6KT
         hE6QQEdsCIS7w==
Content-Disposition: inline
In-Reply-To: <20230331145045.2251683-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Fri, Mar 31, 2023 at 10:50:43AM -0400, Waiman Long wrote:
> By default, the clone(2) syscall spawn a child process into the same
> cgroup as its parent. With the use of the CLONE_INTO_CGROUP flag
> introduced by commit ef2c41cf38a7 ("clone3: allow spawning processes
> into cgroups"), the child will be spawned into a different cgroup which
> is somewhat similar to writing the child's tid into "cgroup.threads".
> 
> The current cpuset_fork() method does not properly handle the
> CLONE_INTO_CGROUP case where the cpuset of the child may be different
> from that of its parent.  Update the cpuset_fork() method to treat the
> CLONE_INTO_CGROUP case similar to cpuset_attach().
> 
> Since the newly cloned task has not been running yet, its actual
> memory usage isn't known. So it is not necessary to make change to mm
> in cpuset_fork().
> 
> Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---

Just two nits. I think this needs a Cc stable and it would be nice if
you could give Giuseppe a "Reported-by".
