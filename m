From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 6/6] cgroup: update debug controller to print out thread
 mode information
Date: Mon, 17 Jul 2017 17:19:16 -0400
Message-ID: <f6025fbf-bd53-dcd7-a5f7-d7e7a97da788@redhat.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-7-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 4F2D380F90
In-Reply-To: <20170717020721.3612468-7-tj@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On 07/16/2017 10:07 PM, Tejun Heo wrote:
> From: Waiman Long <longman@redhat.com>
>
> Update debug controller so that it prints out debug info about thread
> mode.
>
>  1) The relationship between proc_cset and threaded_csets are displayed.
>  2) The status of being a thread root or threaded cgroup is displayed.
>
> This patch is extracted from Waiman's larger patch.
>
> Patch-originally-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/cgroup/cgroup-internal.h |  2 ++
>  kernel/cgroup/cgroup.c          |  4 +--
>  kernel/cgroup/debug.c           | 58 +++++++++++++++++++++++++++++++----------
>  3 files changed, 48 insertions(+), 16 deletions(-)
>
> diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
> index f10eb19..c167a40 100644
> --- a/kernel/cgroup/cgroup-internal.h
> +++ b/kernel/cgroup/cgroup-internal.h
> @@ -153,6 +153,8 @@ static inline void get_css_set(struct css_set *cset)
>  
>  bool cgroup_ssid_enabled(int ssid);
>  bool cgroup_on_dfl(const struct cgroup *cgrp);
> +bool cgroup_is_thread_root(struct cgroup *cgrp);
> +bool cgroup_is_threaded(struct cgroup *cgrp);
>  
>  struct cgroup_root *cgroup_root_from_kf(struct kernfs_root *kf_root);
>  struct cgroup *task_cgroup_from_root(struct task_struct *task,
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 7097ce4..2f34020 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -333,7 +333,7 @@ static bool cgroup_has_tasks(struct cgroup *cgrp)
>  	return cgrp->nr_populated_csets;
>  }
>  
> -static bool cgroup_is_threaded(struct cgroup *cgrp)
> +bool cgroup_is_threaded(struct cgroup *cgrp)
>  {
>  	return cgrp->dom_cgrp != cgrp;
>  }
> @@ -372,7 +372,7 @@ static bool cgroup_can_be_thread_root(struct cgroup *cgrp)
>  }
>  
>  /* is @cgrp root of a threaded subtree? */
> -static bool cgroup_is_thread_root(struct cgroup *cgrp)
> +bool cgroup_is_thread_root(struct cgroup *cgrp)
>  {
>  	/* thread root should be a domain */
>  	if (cgroup_is_threaded(cgrp))
> diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
> index dac46af..062904f 100644
> --- a/kernel/cgroup/debug.c
> +++ b/kernel/cgroup/debug.c
> @@ -114,27 +114,54 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
>  {
>  	struct cgroup_subsys_state *css = seq_css(seq);
>  	struct cgrp_cset_link *link;
> -	int dead_cnt = 0, extra_refs = 0;
> +	int dead_cnt = 0, extra_refs = 0, threaded_csets = 0;
>  
>  	spin_lock_irq(&css_set_lock);
> +
> +	if (cgroup_is_thread_root(css->cgroup))
> +		seq_puts(seq, "[thread root]\n");
> +	else if (cgroup_is_threaded(css->cgroup))
> +		seq_puts(seq, "[threaded]\n");

The cgroup status will not be needed anymore as you have introduced the
cgroup.type control file that returns the proper information.

Cheers,
Longman
