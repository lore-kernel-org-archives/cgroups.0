From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 2/2] mm/cgroup: delay soft limit data allocation
Date: Thu, 23 Feb 2017 12:16:44 +1100
Message-ID: <20170223011644.GB8841@balbir.ozlabs.ibm.com>
References: <1487779091-31381-1-git-send-email-ldufour@linux.vnet.ibm.com>
 <1487779091-31381-3-git-send-email-ldufour@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jeHaptzFAk8CXlqvklTBZfe82l0V6P/dLv5LSjLWlwc=;
        b=dqFm15wGxbtXb8JTGkpcbXhPWmR+F1fUdk7n/bqLWw72DBWSIkQ0qEUp1kGDwUfJp/
         270axjxhIhpKsy+dJj6+m0Fobr7o/gKT9OibGRhgIFMrv2r/0yCqGAXzkc2jEcKDapLG
         uxNYKMbuYjCOLoLquvEyRx0nucm4hN/NpVEU6k3lfAY2s8bV6kEeqEmzCP9wHcyW7v7Y
         TD4DwgXJx8/bCqs73L8K/dQNq9Y6L+5TLDlvQUcGrgXn3eVoI7romc7o72lAMnSt9Fyq
         R8Qg6w5C/V705eAGx0/IV4M7o1bW8I+icZ5lQTK6ym+uT0jap+YtCsQy0ZrNHLQdLnsP
         B5bA==
Content-Disposition: inline
In-Reply-To: <1487779091-31381-3-git-send-email-ldufour@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, Feb 22, 2017 at 04:58:11PM +0100, Laurent Dufour wrote:
> Until a soft limit is set to a cgroup, the soft limit data are useless
> so delay this allocation when a limit is set.
> 
> Suggested-by: Michal Hocko <mhocko@kernel.org>
> Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
> ---
<snip>
> @@ -3000,6 +3035,8 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
>  		}
>  		break;
>  	case RES_SOFT_LIMIT:
> +		if (!soft_limit_initialized)
> +			soft_limit_initialize();

What happens if this fails? Do we disable this interface?
It's a good idea, but I wonder if we can deal with certain
memory cgroups not supporting soft limits due to memory
shortage at the time of using them.

>  		memcg->soft_limit = nr_pages;
>  		ret = 0;
>  		break;

Balbir Singh.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
