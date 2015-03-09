From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Sun, 8 Mar 2015 23:06:36 -0400
Message-ID: <20150309030636.GC13283@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-2-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VPyn2E7j58tJ0pmdtQBgU9/IOUAVCECEfglOIWwHl+w=;
        b=YkFpg8dn5QAnS2rShir3rKeDmnCXrYA4mT6qaGlRkfJ462bDZn77rLh3vmsuA0kUvq
         gqqOAq393szn8cB3A1A1FBOb23zdnPA6YpW8Yz3bp/UG179smTCXcewXfFMnmt3jSgSV
         ZfcW4c7UftyQOsqQKZAJZZWtDzivkTDUB5VpGYWUclvJRBk17Gs975vuCkIuoHWYWyja
         GX9lbwxCgTM6WRQ7DBfnr1C0CXMHCH1C/TBxFuEmIwKl0q7TFlwYYtLb/gInY97hHR5x
         N9wn7xsaxBYlh+DSyM79OgGbDI0+cogvAX4O6/9H6xagEo/B/VsXv3U/kYeZ17nu2XhU
         9k7A==
Content-Disposition: inline
In-Reply-To: <1425010639-16492-2-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Feb 27, 2015 at 03:17:18PM +1100, Aleksa Sarai wrote:
...
> In order for can_fork to deal with a task that has an accurate css_set,
> move the css_set updating to cgroup_fork (where it belongs).

Hmmm?  So, now the task is visible on cgroup side before the point of
no return?  What happens if fork fails afterwards?  Also, why is this
non-trivial change happening in tandem in this patch?

> @@ -946,6 +950,11 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
>  static inline int cgroup_init_early(void) { return 0; }
>  static inline int cgroup_init(void) { return 0; }
>  static inline void cgroup_fork(struct task_struct *p) {}
> +static inline int cgroup_can_fork(struct task_struct *p)
> +{
> +	return 0;
> +}

Please follow the surrounding style.

> @@ -4928,7 +4928,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
>  	 * init_css_set is in the subsystem's root cgroup. */
>  	init_css_set.subsys[ss->id] = css;
>  
> -	need_forkexit_callback |= ss->fork || ss->exit;
> +	need_forkexit_callback |= ss->can_fork || ss->cancel_fork || ss->fork || ss->exit;

Your patch isn't the culprit but this is silly given that this flag is
set pretty much whenever cgroups are enabled.  Per-callback subsys
mask would make far more sense.

Thanks.

-- 
tejun
