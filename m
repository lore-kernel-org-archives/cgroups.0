From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: Pre-allocate tree node on blkg_conf_prep
Date: Thu, 22 Oct 2020 15:42:50 -0400
Message-ID: <20201022194250.GC5691@mtj.thefacebook.com>
References: <20201022182945.1679730-1-krisman@collabora.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JPTA51Icev/OImAexJIn3nNqguo6sqoMkgdEXm6+riU=;
        b=ScjsSosei205+3tvbkhCmIv/Pw6ud3+VJDhNx32/wv6M8CKD6NodvDDSiJVsinb1dD
         LmfEc6+HwEjyVbkmZQO75VS5aATAbvqizZ2z2FiaHOj69KTOxgkLOm0IcjYAYaoX2pAp
         9KmXyM8i8AZjWyvT3s/V55IYQpdT4AuyyniWyJ3AmQ28VbimlAJbKsbRJax9hnntzmxJ
         uYpThRmVhanjTy2NPJUTZxIYwTQNeBi+USQfe1Zq3F3isczednx3a3fVZlRWYJSUZC8x
         2f0k/REUrWjEjgEPj6GHZ9ssbW+8B3TPZeVJKP+XahQNcZ9LrWItqNHjvVq1lEbPcJCP
         EEBA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20201022182945.1679730-1-krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org

On Thu, Oct 22, 2020 at 02:29:45PM -0400, Gabriel Krisman Bertazi wrote:
> @@ -657,6 +658,8 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
>  			goto fail;
>  		}
>  
> +		preloaded = !radix_tree_preload(GFP_KERNEL);

I think we can just fail the function if GFP_KERNEL preload fails.

Thanks.

-- 
tejun
