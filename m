From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix lockdep warning for event_control
Date: Wed, 28 Nov 2012 13:07:19 -0800
Message-ID: <20121128210719.GB24683@htj.dyndns.org>
References: <1354133742-22175-1-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5G8zYHyNsW67jEkVhkm1AkIAtz4f06Ql3AjfyvY5Exo=;
        b=RxX71TfTuaCIKGleKBecjlBqJ08RiPryzwiBeifdIaCKGKFcYicQSWI21EyTo9I3HF
         Fen6w044fg7awTXWLW9E4cEoVAuNgmIWqO9GY1e/2m/8iSVzhSj2cY1y8zmbST+kiy/t
         X5TG4SOP2HIDtrGq4eiYqovPgeuqgpH3tF7SOSLe67fsJaIYm33eyX1uqfXUTtlI9JQ+
         J8ajARHLkxQqcrCad4V5/IPo5aW7vbRVnTmJZPsrmzcg9E4IBjUDeNYKkyIMAri2sKkO
         JTDt4peEza1H6ovwalL6j/7m1tohGWZBuW9aqstpkOCEzOthHb8F6tgorM2rSfWJsI2n
         pXFA==
Content-Disposition: inline
In-Reply-To: <1354133742-22175-1-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Greg.

On Wed, Nov 28, 2012 at 12:15:42PM -0800, Greg Thelen wrote:
> @@ -4276,6 +4276,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
>  	DEFINE_WAIT(wait);
>  	struct cgroup_event *event, *tmp;
>  	struct cgroup_subsys *ss;
> +	struct list_head tmp_list;

LIST_HEAD(tmp_list);

>  
>  	lockdep_assert_held(&d->d_inode->i_mutex);
>  	lockdep_assert_held(&cgroup_mutex);
> @@ -4330,16 +4331,20 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
>  	/*
>  	 * Unregister events and notify userspace.
>  	 * Notify userspace about cgroup removing only after rmdir of cgroup
> -	 * directory to avoid race between userspace and kernelspace
> +	 * directory to avoid race between userspace and kernelspace. Use
> +	 * a temporary list to avoid a deadlock with cgroup_event_wake(). Since
> +	 * cgroup_event_wake() is called with the wait queue head locked,
> +	 * remove_wait_queue() cannot be called while holding event_list_lock.
>  	 */
>  	spin_lock(&cgrp->event_list_lock);
> -	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
> +	list_replace_init(&cgrp->event_list, &tmp_list);

list_splice_init();

would be more conventional, I think.

> +	spin_unlock(&cgrp->event_list_lock);
> +	list_for_each_entry_safe(event, tmp, &tmp_list, list) {
>  		list_del(&event->list);

Maybe convert this to list_del_init() while at it?

>  		remove_wait_queue(event->wqh, &event->wait);
>  		eventfd_signal(event->eventfd, 1);
>  		schedule_work(&event->remove);
>  	}
> -	spin_unlock(&cgrp->event_list_lock);

Thanks.

-- 
tejun
