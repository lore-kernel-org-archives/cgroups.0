From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 14/14] cgroup: implement css_tryget()
Date: Sun, 11 May 2014 00:54:59 -0400
Message-ID: <20140511045459.GA25009@cmpxchg.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-15-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=NSn88F6vUo+uMYiFoy2uXJH/UJqJnG80rO6l5JwOJ7I=;
	b=dSgTFiqc9FbnOM05SSafdditJCpppl+bAXXLGp49xhK16CiTHil/b1hYq+2QX7B815F67B6ePOXJHRPm/7Dbi+YIleg3bZZHRNLlqZ64Sn4KuQXYaYJ8tPzweKkY64IHqC4ApXg3ppsA+zrCAFGSZ809CnoRMzSEb6X5yrbd7hE=;
Content-Disposition: inline
In-Reply-To: <1399671091-23867-15-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 09, 2014 at 05:31:31PM -0400, Tejun Heo wrote:
> Implement css_tryget() which tries to grab a cgroup_subsys_state's
> reference as long as it already hasn't reached zero.  Combined with
> the recent css iterator changes to include offline && !released csses
> during traversal, this can be used to access csses regardless of its
> online state.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  include/linux/cgroup.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index c8eb66e..6dd3867 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -111,6 +111,22 @@ static inline void css_get(struct cgroup_subsys_state *css)
>  }
>  
>  /**
> + * css_tryget - try to obtain a reference on the specified css
> + * @css: target css
> + *
> + * Obtain a reference on @css unless it already has reached zero and is
> + * being released.  This function doesn't care whether @css is on or
> + * offline.  The caller naturally needs to ensure that @css is accessible
> + * but doesn't have to be holding a reference on it - IOW, RCU protected
> + * access is good enough for this function.  Returns %true if a reference
> + * count was successfully obtained; %false otherwise.
> + */
> +static inline bool css_tryget(struct cgroup_subsys_state *css)
> +{
> +	return percpu_ref_tryget(&css->refcnt);
> +}

percpu_ref_tryget() fails once killed (transitioned from per-cpu to
atomic mode), but exactly this happens during offlining and so this
would actually be equivalent to css_tryget_online(), no?
