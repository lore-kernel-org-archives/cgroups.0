From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: Add generic cgroup subsystem permission
 checks
Date: Wed, 5 Oct 2016 12:09:09 -0700
Message-ID: <20161005190909.GA31873@dtor-ws>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <1475556090-6278-2-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CLHh3hnxFWV1iUftavLEAJuwvH2w9wbU+2/Pq03f/1g=;
        b=XuqqgclSYEjKTZiK7SwUvOrfi6X5U6DVwIkywy96iE3sT5A+QcylxRUzNa5NGyaoQB
         YDan3LHl79T8iCuaOLX66TDHrXKBvcTWMqzL3f1RTNrKBn3eeiPQPPf86QV+WM2/wZMy
         WjEqd/nLAI2RZ3PiMqS6yQwcDki7il27cX04CBF3vi5sA+aEXFxZKw9vUAusV4S2SsPv
         EhBFEPRJLmscFK3NigSDiLZY++lxfNZxqC2fxi3GsrlMXF4g/VyxZ2aOQBhYgcpj8kd4
         hVfF+tUkT2KcnIXZDZWhtyKoWPl7LEwUWMw8U21n3m4qdOFMcnDAXzemmiX/S5sJ8F9i
         5HoA==
Content-Disposition: inline
In-Reply-To: <1475556090-6278-2-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ricky Zhou <rickyz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

[ Some comments are form Ricky Zhou <rickyz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, some from
myself ]

On Mon, Oct 03, 2016 at 09:41:29PM -0700, John Stultz wrote:
> From: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> 
> Rather than using explicit euid == 0 checks when trying to move
> tasks into a cgroup, move permission checks into each specific
> cgroup subsystem. If a subsystem does not specify a 'allow_attach'
> handler, then we fall back to doing the checks the old way.
> 
> This patch adds a 'allow_attach' handler instead of reusing the
> 'can_attach' handler, since if the 'can_attach' handler was
> reused, a new cgroup that implements 'can_attach' but not the
> permission checks could end up with no permission checks at all.
> 
> This also includes folded down fixes from:
>   Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
>   Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
> Cc: Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Original-Author: San Mehat <san-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> [jstultz: Rewording of commit message, folded down fixes]
> Signed-off-by: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  Documentation/cgroup-v1/cgroups.txt |  9 +++++++++
>  include/linux/cgroup-defs.h         |  1 +
>  kernel/cgroup.c                     | 40 +++++++++++++++++++++++++++++++++++--
>  3 files changed, 48 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/cgroup-v1/cgroups.txt b/Documentation/cgroup-v1/cgroups.txt
> index 308e5ff..295f026 100644
> --- a/Documentation/cgroup-v1/cgroups.txt
> +++ b/Documentation/cgroup-v1/cgroups.txt
> @@ -578,6 +578,15 @@ is completely unused; @cgrp->parent is still valid. (Note - can also
>  be called for a newly-created cgroup if an error occurs after this
>  subsystem's create() method has been called for the new cgroup).
>  
> +int allow_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
> +(cgroup_mutex held by caller)
> +
> +Called prior to moving a task into a cgroup; if the subsystem
> +returns an error, this will abort the attach operation.  Used
> +to extend the permission checks - if all subsystems in a cgroup
> +return 0, the attach will be allowed to proceed, even if the
> +default permission check (root or same user) fails.
> +
>  int can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
>  (cgroup_mutex held by caller)
>  
> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> index 5b17de6..0f4548c 100644
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h
> @@ -441,6 +441,7 @@ struct cgroup_subsys {
>  	void (*css_free)(struct cgroup_subsys_state *css);
>  	void (*css_reset)(struct cgroup_subsys_state *css);
>  
> +	int (*allow_attach)(struct cgroup_taskset *tset);
>  	int (*can_attach)(struct cgroup_taskset *tset);
>  	void (*cancel_attach)(struct cgroup_taskset *tset);
>  	void (*attach)(struct cgroup_taskset *tset);
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index d6b729b..e6afe2d 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2833,6 +2833,25 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
>  	return ret;
>  }
>  
> +static int cgroup_allow_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
> +{
> +	struct cgroup_subsys_state *css;
> +	int i;
> +	int ret;
> +
> +	for_each_css(css, i, cgrp) {
> +		if (css->ss->allow_attach) {
> +			ret = css->ss->allow_attach(tset);
> +			if (ret)
> +				return ret;
> +		} else {
> +			return -EACCES;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int cgroup_procs_write_permission(struct task_struct *task,
>  					 struct cgroup *dst_cgrp,
>  					 struct kernfs_open_file *of)
> @@ -2847,8 +2866,25 @@ static int cgroup_procs_write_permission(struct task_struct *task,
>  	 */
>  	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
>  	    !uid_eq(cred->euid, tcred->uid) &&
> -	    !uid_eq(cred->euid, tcred->suid))
> -		ret = -EACCES;
> +	    !uid_eq(cred->euid, tcred->suid)) {
> +		/*
> +		 * if the default permission check fails, give each
> +		 * cgroup a chance to extend the permission check
> +		 */
> +		struct cgroup_taskset tset = {
> +			.src_csets = LIST_HEAD_INIT(tset.src_csets),
> +			.dst_csets = LIST_HEAD_INIT(tset.dst_csets),
> +			.csets = &tset.src_csets,
> +		};
> +		struct css_set *cset;
> +
> +		cset = task_css_set(task);

Do we need to take css_set_lock here? If not, why?

> +		list_add(&cset->mg_node, &tset.src_csets);
> +		ret = cgroup_allow_attach(dst_cgrp, &tset);
> +		list_del(&tset.src_csets);

This should be

		list_del_init(&cset->mg_node);

since you are deleting task's cset from the tset list, not other way
around. It only happen to work because there is exactly 1 member in
tset.src_csets and list_del done on it is exactly list_del_init on the
node, so you are not leaving with uncorrupted mg_node in task's cset.

> +		if (ret)
> +			ret = -EACCES;
> +	}
>  
>  	if (!ret && cgroup_on_dfl(dst_cgrp)) {
>  		struct super_block *sb = of->file->f_path.dentry->d_sb;

Isn't this, generally speaking, racy? We take current task's cset and
check if we have rights to move it over.  But we do not have any locking
between check and actual move, so can the cset change between these 2
operations?

And if cset can't really change and it is only 1 task, then why do we
bother with forming taskset at all? Can we make allow_attach take just
the target task argument?

Thanks.

-- 
Dmitry
