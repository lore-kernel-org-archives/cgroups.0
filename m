From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] don't attach a task to a dead cgroup
Date: Thu, 19 Apr 2012 15:53:22 -0700
Message-ID: <20120419225322.GC10553@google.com>
References: <1334875758-20939-1-git-send-email-glommer@parallels.com>
 <1334875758-20939-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=BCTcxuk8bDCv/Z1CGj3h90i6KBQ9GVuRX5QzFm6mBPE=;
        b=vaLS8SNJH/2X6e7NvJPA6bnfqbyXMBzHo+2OL2jvts6m6/mJtiSvppjur+OyaagcBS
         HOv2u3rKRQy0sG3LM1Om0BotOW6ePwXqvKjx0UXqwYg97qAJscgccBw1jvcNV8Nd+h8n
         QZ2tUlZ4f6TlGdq+BJg9Aj1sOD+KVnTUGeDvPC7pUsTwlbgCIz7mr79xlw4p8Bybpv7X
         wxqmHUW3Hij/L/PvvmtJeCjYU7TY9c4xhQ8atQZJlNibzK9e7WyrlINXnU6hnZyRKxmY
         QDhUEToS3hRammyriOeuGTfUKjaWkQ+Oxn25cNw3qglEtavSvnkUnIamBaWcP6s8V90H
         Zm0w==
Content-Disposition: inline
In-Reply-To: <1334875758-20939-2-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Thu, Apr 19, 2012 at 07:49:16PM -0300, Glauber Costa wrote:
> Not all external callers of cgroup_attach_task() test to
> see if the cgroup is still live - the internal callers at
> cgroup.c does.
> 
> With this test in cgroup_attach_task, we can assure that
> no tasks are ever moved to a cgroup that is past its
> destruction point and was already marked as dead.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CC: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>  kernel/cgroup.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index b61b938..932c318 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1927,6 +1927,9 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>  	struct cgroup_taskset tset = { };
>  	struct css_set *newcg;
>  
> +	if (cgroup_is_removed(cgrp))
> +		return -ENODEV;
> +

Isn't the test in cgroup_lock_live_group() enough?

-- 
tejun
