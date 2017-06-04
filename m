From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v2] memcg: refactor mem_cgroup_resize_limit()
Date: Sun, 4 Jun 2017 23:09:42 +0300
Message-ID: <20170604200942.GA23523@esperanza>
References: <20170601230212.30578-1-yuzhao@google.com>
 <20170604200437.17815-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JPkw3H1VFHThTObyYueonhOnkNacfQQs/V4CDJjpfE4=;
        b=UPnUSj6WmwpNTyXIxjwl3kn3Z315yl3eOsmmJ7Ie4GC3m+qvTOLpCkqBUBowTZ6RnO
         DFG5NM+/KGfQQ0IYXoCVk5/mu08UA/NyiSRdpkNMgaERs1uyTDmN4QB6zkSdOC5SnITt
         /ECe4hAiUNtq9St9aIv7wjIX+hOTDXlZp4/b7O6zem0fEk8JcVEjvE7VV2mOgM23bOzk
         1wwBATleysCw8fcNab9nRLFMgOENGDo5vAZjpwSnMugUBoLW57HSICuS/yCBQqoQl4XN
         OPzGES76BENoyMIEah3Y5WAOWgDZP4xxYkNHm0TFGV+3PTs2sb4Mpn44XgpknCGIfNUa
         UEjg==
Content-Disposition: inline
In-Reply-To: <20170604200437.17815-1-yuzhao@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, n.borisov.lkml@gmail.com

On Sun, Jun 04, 2017 at 01:04:37PM -0700, Yu Zhao wrote:
> @@ -2498,22 +2449,24 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  		}
>  
>  		mutex_lock(&memcg_limit_mutex);
> -		if (limit < memcg->memory.limit) {
> +		inverted = memsw ? limit < memcg->memory.limit :
> +				   limit > memcg->memsw.limit;
> +		if (inverted)
>  			mutex_unlock(&memcg_limit_mutex);
>  			ret = -EINVAL;
>  			break;
>  		}

For some reason, I liked this patch more without this extra variable :-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
