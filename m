From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Mon, 13 Apr 2015 10:24:39 -0400
Message-ID: <20150413142439.GA2596@htj.duckdns.org>
References: <1428799917-15141-1-git-send-email-cyphar@cyphar.com>
 <1428799917-15141-4-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jyYdSJgfi7OS4fyEf2lsogxklPvJ3bZpN/ocnIFJDss=;
        b=V7GsLLkiqcosCZtWlOXEBSdTgguYZyClijHwmZAxUt4w7fB7kF9K/0keLdmAKBiNUs
         DDTlYANI5fks/dqdYk51J/oMQc4nGAJy6M7/RkY6DM3yx+ZyaOL8lpMA6XJQZHJhw5CC
         BvOLjjD5BThA+rM4fsJWc/68ZM9wNobp359XVkIgvCzpRuEHIfGrpcDGXy4a6RQKeywh
         AHuX1impbLOcAr54OgRhknnaS9AO7HyGHIaR5rcwLWfL5xf2SzEmzfGQxfgmC4hKUfuO
         o+htZUptetELgpRVk4KkY+en8W6uaDdBnjN3MNZ/VRMPZaoguCL3ZDAclQAgjcAMiiri
         gU4g==
Content-Disposition: inline
In-Reply-To: <1428799917-15141-4-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Apr 12, 2015 at 10:51:56AM +1000, Aleksa Sarai wrote:
> +/* list of all tags for subsystems */
> +enum cgroup_subsys_tag {
> +#define TAG_ID(_t) CGROUP_ ## _t
> +#define SUBSYS(_x) UNUSED_IDENT(_x),
> +#define TAG(_t) TAG_ID(_t), \
> +	UNUSED_IDENT(_t) = TAG_ID(_t) - 2,
> +#define _COUNT(_t, _i) _i, \
> +	CGROUP_ ## _t ## _COUNT = (TAG_ID(_t ## _END) - TAG_ID(_t ## _START)) + 1, \
> +	UNUSED_IDENT(_t) = _i - 1,
> +#define COUNT(_t) _COUNT(_t, UNUSED_IDENT(_t))
> +#include <linux/cgroup_subsys.h>
> +#undef COUNT
> +#undef TAG
> +#undef SUBSYS
> +#undef TAG_ID
> +};

Ummm... is this really necessary?  Can't we do something like the
following?

#define SUBSYS_TAG(tag)						\
	__##tag,						\
	tag = __##tag - 2,

-- 
tejun
