From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 03/11] memcg: change defines to an enum
Date: Mon, 25 Jun 2012 21:11:55 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206252110470.26640@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=UrWx3zrGtcUkTCI3mVK5kCeuPVd50yN1gWtWlhquiwU=;
        b=fwExA6lr44ecJy5gXYqGSG5bmzVxnO5Y2Blmjct2MCCMjAKzvWYlYE6/SSQnsSzWtx
         xuwbxjGnI0y3+7rQppbTfglo2gfEteUEoDjdR04nc3qJfVoGMC/iQtIJHBHcAyYDOT5Y
         60CdZuL0kHyG84X7tfkIGDJgx0ZvfSY25LuQzt26CV7yjuRjod330/skN7FXEiNvF0gi
         Z4UGeQIymKCB2rERFP0hVDQR0XmgQOARDhJKp52RSYZ34fsirIYjLADMs4iooEy5Db6B
         2FBVUsMlde1xotFMy0EJos+3N8sqnLBYmxOjvpUAccgSnMo8P+XnHKZSsicabokXrybK
         mgrQ==
In-Reply-To: <1340633728-12785-4-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>

On Mon, 25 Jun 2012, Glauber Costa wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8e601e8..9352d40 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -387,9 +387,12 @@ enum charge_type {
>  };
>  
>  /* for encoding cft->private value on file */
> -#define _MEM			(0)
> -#define _MEMSWAP		(1)
> -#define _OOM_TYPE		(2)
> +enum res_type {
> +	_MEM,
> +	_MEMSWAP,
> +	_OOM_TYPE,
> +};
> +
>  #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
>  #define MEMFILE_TYPE(val)	((val) >> 16 & 0xffff)
>  #define MEMFILE_ATTR(val)	((val) & 0xffff)

Shouldn't everything that does MEMFILE_TYPE() now be using type 
enum res_type rather than int?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
