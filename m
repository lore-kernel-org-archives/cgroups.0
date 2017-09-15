From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Properly init nr_tasks in cgroup_taskset
Date: Fri, 15 Sep 2017 08:47:44 -0700
Message-ID: <20170915154743.GF378890@devbig577.frc2.facebook.com>
References: <1505421913-29577-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9d8TW1/sgTvV0oHjnO2kbuXr5qWJi6et+Iuw1QpQLBI=;
        b=SpwZJG6+is9EKITBjp9R1pI+vIIJ7d1EYq6SAhvj8X2J9G1mAl1kI+MuyP4XHNp9iX
         f4sIN2s9U54z8IH23q4Q4t/+JOWF8qqIxKMod4iunEhVIdXHCizz7lCMI567t6Z3jG5r
         VJj6K1Ie2GYc3uO6X/m04P+D7ir9JWV2PFBEILAYpUgiL+UYjliNiRWCUYdSK3/AU4GF
         akbH5oqCUTlqssS0HQab+ii3LAY9BhPHPk14if3EUrQQzbZYREvpZsGTKqsEOCT2ZCIw
         iJUqRCL3lspqkV98kA1lASYLDWQBWJJ0sug5pjwUn4LZbl5me4erY+QZU9GfvnB2MYEU
         sFCw==
Content-Disposition: inline
In-Reply-To: <1505421913-29577-1-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Waiman.

On Thu, Sep 14, 2017 at 01:45:13PM -0700, Waiman Long wrote:
> Commit 610467270fb3 ("cgroup: don't call migration methods if there
> are no tasks to migrate") introduces a new field nr_tasks to the
> cgroup_taskset structure for keeping track of the number of tasks
> contained in the structure.  The initial value of this field, however,
> is not guaranteed to be 0 as all the cgroup_taskset structures are
> allocated from stack.  Therefore, we need to explicitly initilized
> it in the CGROUP_TASKSET_INIT() macro for the new code to behave
> correctly.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cgroup-internal.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
> index 5151ff2..6b4c04e 100644
> --- a/kernel/cgroup/cgroup-internal.h
> +++ b/kernel/cgroup/cgroup-internal.h
> @@ -76,6 +76,7 @@ struct cgroup_mgctx {
>  	.src_csets		= LIST_HEAD_INIT(tset.src_csets),		\
>  	.dst_csets		= LIST_HEAD_INIT(tset.dst_csets),		\
>  	.csets			= &tset.src_csets,				\
> +	.nr_tasks		= 0,						\

But it's an initialization macro, which means that the only way these
are used is as a part of whole struct initialization and the compiler
would always set the unspecified fields to zero.

Thanks.

-- 
tejun
