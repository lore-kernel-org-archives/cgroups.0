From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
Date: Mon, 25 Jun 2012 21:57:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206252157000.30072@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-12-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=XRlsY1awZJ+hmlL5CBtbNC7AL/gFOYBBtUJm3vTWpU0=;
        b=aCcwbFVXbWWj93vEC657BFLqXvZM3LM5kaRmVVhWcSwEiLpiolGoIdVr12kJofwX9/
         3EpP+OIqnmfovwtoVjIpsKEC20SETcOpFLiRBD2W5WIAhwGD1Du+8gl6UTBcVje2mSC5
         +w7mas+IfVtBIfsJ/YCV/9wwfKcpGiOt/Q16eVeDem5oHqP0u7GQpo4Y6Qkf6W5Mt3yZ
         Q+FWmM1NVNR2FaxGQzvYtzJfXh+TgPQq2Y4fdi6CC9TQWlozVxHJ/X4MsKcSI3Pgr3E9
         xW6EgKhiuns+6g19tv3sAzuyUfhWTh7zkwm2JVlGaKzeQsAIMmoEVnhQ1Feg4+kDNwop
         ZcTQ==
In-Reply-To: <1340633728-12785-12-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@redhat.com>

On Mon, 25 Jun 2012, Glauber Costa wrote:

> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> index ccc1899..914ec07 100644
> --- a/include/linux/thread_info.h
> +++ b/include/linux/thread_info.h
> @@ -61,6 +61,12 @@ extern long do_no_restart_syscall(struct restart_block *parm);
>  # define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK)
>  #endif
>  
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +# define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP | __GFP_KMEMCG)
> +#else
> +# define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP)
> +#endif
> +

This type of requirement is going to become nasty very quickly if nobody 
can use __GFP_KMEMCG without testing for CONFIG_CGROUP_MEM_RES_CTLR_KMEM.  
Perhaps define __GFP_KMEMCG to be 0x0 if it's not enabled, similar to how 
kmemcheck does?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
