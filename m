From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.8-fixes] cgroup: fix invalid controller
 enable rejections with cgroup namespace
Date: Fri, 23 Sep 2016 23:19:51 -0500
Message-ID: <20160924041951.GB18242@mail.hallyn.com>
References: <20160923210003.GF31387@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160923210003.GF31387-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Evgeny Vereshchagin <evvers-k+OT61UuxXo@public.gmane.org>

On Fri, Sep 23, 2016 at 05:00:03PM -0400, Tejun Heo wrote:
> >From 9157056da8f8c4a6305f15619e269f164b63a6de Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Fri, 23 Sep 2016 16:55:49 -0400
> 
> On the v2 hierarchy, "cgroup.subtree_control" rejects controller
> enables if the cgroup has processes in it.  The enforcement of this
> logic assumes that the cgroup wouldn't have any css_sets associated
> with it if there are no tasks in the cgroup, which is no longer true
> since a79a908fd2b0 ("cgroup: introduce cgroup namespaces").
> 
> When a cgroup namespace is created, it pins the css_set of the
> creating task to use it as the root css_set of the namespace.  This
> extra reference stays as long as the namespace is around and makes
> "cgroup.subtree_control" think that the namespace root cgroup is not
> empty even when it is and thus reject controller enables.
> 
> Fix it by making cgroup_subtree_control() walk and test emptiness of
> each css_set instead of testing whether the list_head is empty.
> 
> While at it, update the comment of cgroup_task_count() to indicate
> that the returned value may be higher than the number of tasks, which
> has always been true due to temporary references and doesn't break
> anything.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Evgeny Vereshchagin <evvers-k+OT61UuxXo@public.gmane.org>
> Cc: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Acked-by: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

thanks!

-serge

> Cc: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.6+
> Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
> Link: https://github.com/systemd/systemd/pull/3589#issuecomment-249089541
> ---
> Hello,
> 
> I applied this patch to cgroup/for-4.8-fixes as I wanted it to get
> exposure ASAP as it's pretty late in the devel cycle.  If I messed up
> something, please let me know.
> 
> Thanks.
> 
>  kernel/cgroup.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index d1c51b7..0d4ee1e 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3446,9 +3446,28 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
>  	 * Except for the root, subtree_control must be zero for a cgroup
>  	 * with tasks so that child cgroups don't compete against tasks.
>  	 */
> -	if (enable && cgroup_parent(cgrp) && !list_empty(&cgrp->cset_links)) {
> -		ret = -EBUSY;
> -		goto out_unlock;
> +	if (enable && cgroup_parent(cgrp)) {
> +		struct cgrp_cset_link *link;
> +
> +		/*
> +		 * Because namespaces pin csets too, @cgrp->cset_links
> +		 * might not be empty even when @cgrp is empty.  Walk and
> +		 * verify each cset.
> +		 */
> +		spin_lock_irq(&css_set_lock);
> +
> +		ret = 0;
> +		list_for_each_entry(link, &cgrp->cset_links, cset_link) {
> +			if (css_set_populated(link->cset)) {
> +				ret = -EBUSY;
> +				break;
> +			}
> +		}
> +
> +		spin_unlock_irq(&css_set_lock);
> +
> +		if (ret)
> +			goto out_unlock;
>  	}
>  
>  	/* save and update control masks and prepare csses */
> @@ -3899,7 +3918,9 @@ void cgroup_file_notify(struct cgroup_file *cfile)
>   * cgroup_task_count - count the number of tasks in a cgroup.
>   * @cgrp: the cgroup in question
>   *
> - * Return the number of tasks in the cgroup.
> + * Return the number of tasks in the cgroup.  The returned number can be
> + * higher than the actual number of tasks due to css_set references from
> + * namespace roots and temporary usages.
>   */
>  static int cgroup_task_count(const struct cgroup *cgrp)
>  {
> -- 
> 2.7.4
