From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 1/3] nitpick: make simple functions inline
Date: Sun, 11 Dec 2011 21:44:54 +0100
Message-ID: <4EE51646.3030900@parallels.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-3-git-send-email-glommer@parallels.com> <4EE4FCBB.9050600@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EE4FCBB.9050600-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On 12/11/2011 07:55 PM, KOSAKI Motohiro wrote:
>> -static int notify_on_release(const struct cgroup *cgrp)
>> +static inline int notify_on_release(const struct cgroup *cgrp)
>>    {
>>    	return test_bit(CGRP_NOTIFY_ON_RELEASE,&cgrp->flags);
>>    }
>>
>> -static int clone_children(const struct cgroup *cgrp)
>> +static inline int clone_children(const struct cgroup *cgrp)
>>    {
>>    	return test_bit(CGRP_CLONE_CHILDREN,&cgrp->flags);
>>    }
> 
> Can you please tell us which compiler failed automatic inlining?
> I suspect gcc is enough sane and we don't need this patch.

Of course we don't need, that's the very definition of a "nitpick".
This patch is directed towards the reader, not the compiler. Maintainers
are free to take it or not, although I believe being explicit is better.

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
