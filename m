From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: get a ref to source csses when migrating
Date: Mon, 24 Aug 2015 14:45:07 -0400
Message-ID: <20150824184507.GB28944@mtj.duckdns.org>
References: <CAOviyag1ZOgjtNWmnpfMm=fDgkhDn9UGKoJXy6HLWQMGb-tQAg@mail.gmail.com>
 <1440335432-4202-1-git-send-email-cyphar@cyphar.com>
 <1440335432-4202-2-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=maYhBwVtJ1diNCKoH52W3lxt7CiREQKiw4MW2sqY6ao=;
        b=JZ+TrK0Lt4n1aa5ma8ted0xqdJNDyHeVq0nAR1bCFccC7W1l7Xdg8k5UB26rxshPva
         vWS4Fd+HNnPII6G7lF/FEcp7IMEwiNnlddVsostm5mxE9wsPbMJZkZJt/Tjgf2Fe6gdp
         VWtUbP6vJFggFgRbIar/229811Hm5PIxaDQD67Wj+RusAZwSbRGVpQ/CuJfmNYSCGDG5
         yRkx1Y9xd1542u/bDSm90NJzxDUYBa0O+JXscmQFpwvzIazGe/PlioBUKDNIFfBowgLE
         aKokGdJRcuKSq48PA6UWOvdq8sGuuCoBP8ylPhQPwu5t8t1bD0z3q3BOyhO2VvCWLNR0
         wPSQ==
Content-Disposition: inline
In-Reply-To: <1440335432-4202-2-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Aug 23, 2015 at 11:10:31PM +1000, Aleksa Sarai wrote:
> Grab a ref to each source css being migrated from, otherwise it's
> possible for the refcount to reach zero between ->can_attach() and
> ->cancel_attach(). This means that operations on the task's old css
> (such as container_of(...)) become unsafe, as we may be operating on a
> different css.
> 
> Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 4ec1b7ee5de8..6cbfbe36284d 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2305,6 +2305,17 @@ static int cgroup_migrate(struct cgroup *cgrp, struct task_struct *leader,
>  	if (list_empty(&tset.src_csets))
>  		return 0;
>  
> +	/*
> +	 * Fetch a ref of each css, so that the old task's css doesn't get reaped
> +	 * between ->can_attach() and ->cancel_attach().
> +	 */
> +	down_read(&css_set_rwsem);
> +	list_for_each_entry(cset, &tset.src_csets, mg_node) {
> +		for_each_e_css(css, i, cgrp)
> +			css_get(cset->subsys[i]);
> +	}
> +	up_read(&css_set_rwsem);

Have you verified that the scenario you're describing can actually
happen?  AFAICS, cgroup_migrate_add_src() already does the pinning.

Thanks.

-- 
tejun
