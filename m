From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] cgroup: Do not take css_set_lock in
 cgroup_show_path
Date: Tue, 2 May 2023 15:56:01 -0400
Message-ID: <9e149289-c1c0-3297-145d-ad3a890056ac@redhat.com>
References: <20230502133847.14570-1-mkoutny@suse.com>
 <20230502133847.14570-4-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683057367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iMs73NusrIc3WnWcdl7Fx0I1f6axuQqjUOBlJwm9l/c=;
        b=HHjTDNPbnDC4AFvS43aRgTee73bw2RWLhk5yANez+r0RAFMrlgRTFoTgDZamwISd5C3Cwc
        W0sZt2kjd8k7B3A1NHwWpbvoGiq+17dmvmc+309m/pHP0JFa24Ee+MvW3aoKIJ2/u0j1JV
        Z/qfvOxQgZwFKOhjmEUSzPAz0jvhG7E=
Content-Language: en-US
In-Reply-To: <20230502133847.14570-4-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Jiri Wiesner <jwiesner-l3A5Bk7waGM@public.gmane.org>

On 5/2/23 09:38, Michal Koutný wrote:
> /proc/$pid/mountinfo may accumulate lots of entries (causing frequent
> re-reads of whole file) or lots cgroupfs entries alone.
> The cgroupfs entries rendered with cgroup_show_path() may increase/be
> subject of css_set_lock contention causing further slowdown -- not only
> mountinfo rendering but any other css_set_lock user.
>
> We leverage the fact that mountinfo reading happens with namespace_sem
> taken and hierarchy roots thus cannot be freed concurrently.
>
> There are three relevant nodes for each cgroupfs entry:
>
>          R ... cgroup hierarchy root
>          M ... mount root
>          C ... reader's cgroup NS root
>
> mountinfo is supposed to show path from C to M.
>
> Current's css_set (and linked root cgroups) are stable under
> namespace_sem, therefore current_cgns_cgroup_from_root() doesn't need
> css_set_lock.
>
> When the path is assembled in kernfs_path_from_node(), we know that:
> - C kernfs_node is (transitively) pinned via current->nsproxy,
> - M kernfs_node is pinned thanks to namespace_sem,
> - path C to M is pinned via child->parent references (this holds also
>    when C and M are in distinct subtrees).
>
> Streamline mountinfo rendering a bit by relieving css_set_lock and add
> careful notes about that.
>
> Signed-off-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
> ---
>   kernel/cgroup/cgroup.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 32d693a797b9..e2ec6f0028be 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -1407,12 +1407,18 @@ static inline struct cgroup *__cset_cgroup_from_root(struct css_set *cset,
>   	struct cgroup *res_cgroup = NULL;
>   
>   	if (cset == &init_css_set) {
> +		/* callers must ensure root stability */
>   		res_cgroup = &root->cgrp;
>   	} else if (root == &cgrp_dfl_root) {
>   		res_cgroup = cset->dfl_cgrp;
>   	} else {
>   		struct cgrp_cset_link *link;
> -		lockdep_assert_held(&css_set_lock);
> +		/* cset's cgroups are pinned unless they are root cgroups that
> +		 * were unmounted.  We look at links to !cgrp_dfl_root
> +		 * cgroup_root, either lock ensures the list is not mutated
> +		 */
> +		lockdep_assert(lockdep_is_held(&css_set_lock) ||
> +			       lockdep_is_held_type(&namespace_sem, -1));
Again lockdep_is_held(&namespace_sem) is good enough.

>   
>   		list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
>   			struct cgroup *c = link->cgrp;
> @@ -1438,8 +1444,6 @@ current_cgns_cgroup_from_root(struct cgroup_root *root)
>   	struct cgroup *res = NULL;
>   	struct css_set *cset;
>   
> -	lockdep_assert_held(&css_set_lock);
> -
>   	/* namespace_sem ensures `root` stability on unmount */
>   	lockdep_assert(lockdep_is_held_type(&namespace_sem, -1));
>   
> @@ -1905,10 +1909,8 @@ int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
>   	if (!buf)
>   		return -ENOMEM;
>   
> -	spin_lock_irq(&css_set_lock);
>   	ns_cgroup = current_cgns_cgroup_from_root(kf_cgroot);
>   	len = kernfs_path_from_node(kf_node, ns_cgroup->kn, buf, PATH_MAX);
> -	spin_unlock_irq(&css_set_lock);
>   
>   	if (len >= PATH_MAX)
>   		len = -ERANGE;
Cheers,
Longman

