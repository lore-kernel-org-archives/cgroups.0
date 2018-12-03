From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 4/7] cgroup: cgroup v2 freezer
Date: Mon, 3 Dec 2018 16:35:41 +0100
Message-ID: <20181203153540.GF31795@redhat.com>
References: <20181130234745.6756-1-guro@fb.com>
 <20181130234745.6756-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181130234745.6756-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

On 11/30, Roman Gushchin wrote:
>
>  void recalc_sigpending(void)
>  {
>  	if (!recalc_sigpending_tsk(current) && !freezing(current) &&
> -	    !klp_patch_pending(current))
> +	    !klp_patch_pending(current) && !cgroup_task_frozen(current))

I must have missed something... but shouldn't it check JOBCTL_TRAP_FREEZE
rather than ->frozen?

Oleg.

