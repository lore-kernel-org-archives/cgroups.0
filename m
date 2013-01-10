From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3.4 1/2] cgroup: Take css_set_lock when calling cgroup_css_sets_empty()
Date: Thu, 10 Jan 2013 10:43:09 +0800
Message-ID: <50EE2ABD.5070404@huawei.com>
References: <1357743822-21707-1-git-send-email-hdegoede@redhat.com> <1357743822-21707-2-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357743822-21707-2-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/1/9 23:03, Hans de Goede wrote:
> As indicated in the comment above cgroup_css_sets_empty the
> css_set_lock must be hold when calling it.
> 
> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c908354..59e711a 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3980,7 +3980,10 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
>  	/* the vfs holds both inode->i_mutex already */
>  again:
>  	mutex_lock(&cgroup_mutex);
> -	if (!cgroup_css_sets_empty(cgrp)) {
> +	read_lock(&css_set_lock);
> +	ret = cgroup_css_sets_empty(cgrp);

This function doesn't exist in 3.4.xx kernel! It was introduced by an
out-of-tree patch, and that patch introduced these two bugs (maybe more).

> +	read_unlock(&css_set_lock);
> +	if (!ret) {
>  		mutex_unlock(&cgroup_mutex);
>  		return -EBUSY;
>  	}
> 
