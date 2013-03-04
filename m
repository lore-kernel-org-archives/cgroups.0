From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: avoid accessing modular cgroup subsys
 structure without locking
Date: Mon, 4 Mar 2013 10:04:30 -0800
Message-ID: <20130304180430.GE30413@htj.dyndns.org>
References: <5130535F.7060201@huawei.com>
 <5130537C.5010608@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=3poXDC76bkyROHyRjfb5SOqoDs7coatx5JXWZmHlRVQ=;
        b=cy2EXvJuf2pcnz6wTmRqISHxRCBcTuUBYh+5RX6XK4vreaPwh1bmw8J+eUOG1Vnc20
         +cxNI1mc8WohGVkSPofAf0MSrZF+lFWotaiLuikgMQ+sZeeEARLws8Xy0lV2350Mn58m
         NjAKbuoHu6btcS8+gZwW2bxhTTjsy96MzvCbv12l0MV9g8Nw2PA5SPPTnOUayCWsT4mo
         e/XeQsgeL9ZGXeffGlmUqJKxrs7iDv555HfDepk1TbLNgxuXcEA4gLJ4KP+9+D54U5r0
         YP2aF9k4GmBqICZtpcP3yh34c1DK0O3TOeNji/PQyWtT8VHvbFUU0mCXfdRj7nFvSMq2
         AZ9Q==
Content-Disposition: inline
In-Reply-To: <5130537C.5010608-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Fri, Mar 01, 2013 at 03:06:36PM +0800, Li Zefan wrote:
>  /* Define the enumeration of all builtin cgroup subsystems */
>  #define SUBSYS(_x) _x ## _subsys_id,
> -#define IS_SUBSYS_ENABLED(option) IS_ENABLED(option)
>  enum cgroup_subsys_id {
> +#define IS_SUBSYS_ENABLED(option) IS_BUILTIN(option)
>  #include <linux/cgroup_subsys.h>
> +#undef IS_SUBSYS_ENABLED
> +	CGROUP_BUILTIN_SUBSYS_COUNT,
> +
> +	__CGROUP_SUBSYS_TEMP_PLACEHOLDER = CGROUP_BUILTIN_SUBSYS_COUNT - 1,
> +
> +#define IS_SUBSYS_ENABLED(option) IS_MODULE(option)
> +#include <linux/cgroup_subsys.h>
> +#undef IS_SUBSYS_ENABLED
>  	CGROUP_SUBSYS_COUNT,
>  };
> -#undef IS_SUBSYS_ENABLED
>  #undef SUBSYS

Arghh.... can we at least have a comment explaining what we're doing
here?  It's ugly and confusing.

> @@ -5019,13 +5019,17 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
>  	tsk->cgroups = &init_css_set;
>  
>  	if (run_callbacks && need_forkexit_callback) {
> -		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> +		/*
> +		 * fork/exit callbacks are supported only for builtin
> +		 * subsystems, and the builtin section of the subsys
> +		 * array is immutable, so we don't need to lock the
> +		 * subsys array here. On the other hand, modular section
> +		 * of the array can be freed at module unload, so we
> +		 * can't touch that.
> +		 */
> +		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {

Probably enough to say "for/exit callback are supported only for
builtin subsys, see cgroup_for() for details"?

Thanks.

-- 
tejun
