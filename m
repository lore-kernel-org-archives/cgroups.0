From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: don't grab mutex in rcu callback
Date: Thu, 14 Feb 2013 08:48:30 -0800
Message-ID: <20130214164830.GI9057@htj.dyndns.org>
References: <1360860363-2879-1-git-send-email-jerry.snitselaar@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=ywdRRHO38ntUA12wt2/sff7U3HKfoKcX8sXhUkn//XI=;
        b=Xv6zgqAXSVe/PBwke6eV0cUgPqQRhD77HJE+nQCQ+2tMCRMUAkOMl6S0vKwCg7/T+X
         Iwt6+euQYCbwbjPjmzUTMvcRC0+qaKEmvZJOlgvyqoBT+WTv4mJ2Li52M2jabReeLLbM
         6gCB2GF3hbuL3pX697+muabg5vnfwTo+BwG/zmNltuYA/dVg13T+iQxcwTkg/mGMNmAh
         nKbe9fCnFcbb0u7jp1bsuOBFQ3XTiM170FyVZEg8kezOz7t2+ZM+gAUifLqqAnx2QSPh
         psHjtba6zK79dDBD0K6D5vNmsFTJmAoekrqvwlOdtLw82I7OM+OyTi07YNalT3XVI2zO
         7Etw==
Content-Disposition: inline
In-Reply-To: <1360860363-2879-1-git-send-email-jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

(cc'ing Andrew)

Andrew, can you please pick up this one?

 http://article.gmane.org/gmane.linux.kernel.cgroups/6158/raw

Thank you.

On Thu, Feb 14, 2013 at 09:46:03AM -0700, Jerry Snitselaar wrote:
> commit 103a197 "security/device_cgroup: lock assert fails in
> dev_exception_clean()" grabs devcgroup_mutex to fix assert failure,
> but mutex can't be grabbed in rcu callback. Since there shouldn't be
> any other references when css_free is called, mutex isn't needed for
> list cleanup in devcgroup_css_free().
> 
> Signed-off-by: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  security/device_cgroup.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index d794abc..1c69e38 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -159,6 +159,16 @@ static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
>  	}
>  }
>  
> +static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
> +{
> +	struct dev_exception_item *ex, *tmp;
> +
> +	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
> +		list_del_rcu(&ex->list);
> +		kfree_rcu(ex, rcu);
> +	}
> +}
> +
>  /**
>   * dev_exception_clean - frees all entries of the exception list
>   * @dev_cgroup: dev_cgroup with the exception list to be cleaned
> @@ -167,14 +177,9 @@ static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
>   */
>  static void dev_exception_clean(struct dev_cgroup *dev_cgroup)
>  {
> -	struct dev_exception_item *ex, *tmp;
> -
>  	lockdep_assert_held(&devcgroup_mutex);
>  
> -	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
> -		list_del_rcu(&ex->list);
> -		kfree_rcu(ex, rcu);
> -	}
> +	__dev_exception_clean(dev_cgroup);
>  }
>  
>  /*
> @@ -215,9 +220,7 @@ static void devcgroup_css_free(struct cgroup *cgroup)
>  	struct dev_cgroup *dev_cgroup;
>  
>  	dev_cgroup = cgroup_to_devcgroup(cgroup);
> -	mutex_lock(&devcgroup_mutex);
> -	dev_exception_clean(dev_cgroup);
> -	mutex_unlock(&devcgroup_mutex);
> +	__dev_exception_clean(dev_cgroup);
>  	kfree(dev_cgroup);
>  }
>  
> -- 
> 1.8.1.1.293.gfe73786
> 

-- 
tejun
