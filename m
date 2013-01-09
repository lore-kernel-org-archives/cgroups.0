From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3.4 1/2] cgroup: Take css_set_lock when calling cgroup_css_sets_empty()
Date: Wed, 09 Jan 2013 13:37:38 +0100
Message-ID: <50ED6492.5070400@redhat.com>
References: <1357733486-1742-1-git-send-email-hdegoede@redhat.com> <1357733486-1742-2-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357733486-1742-2-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Self-nack, looks like I posted this series too soon. With a config which actually
has CGROUP controllers enabled this causes a panic, so looks like I need to do some
more work on this.

Feedback on this issue is still appreciated.

Regards,

Hans


On 01/09/2013 01:11 PM, Hans de Goede wrote:
> As indicated in the comment above cgroup_css_sets_empty the
> css_set_lock must be hold when calling it.
>
> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>   kernel/cgroup.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c908354..59e711a 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3980,7 +3980,10 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
>   	/* the vfs holds both inode->i_mutex already */
>   again:
>   	mutex_lock(&cgroup_mutex);
> -	if (!cgroup_css_sets_empty(cgrp)) {
> +	read_lock(&css_set_lock);
> +	ret = cgroup_css_sets_empty(cgrp);
> +	read_unlock(&css_set_lock);
> +	if (!ret) {
>   		mutex_unlock(&cgroup_mutex);
>   		return -EBUSY;
>   	}
>
