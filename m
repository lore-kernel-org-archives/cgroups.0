From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Fri, 19 Aug 2022 06:29:22 -1000
Message-ID: <Yv+6YjaGAv52yvq9@slm.duckdns.org>
References: <1660908562-17409-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=UMwZBhpqxvMN4MWwkHckLMAVG27kfXbnwXOCeD112cI=;
        b=GCXQ0jrSKwhxTdDFaLB9Yx0otU4yPi1wlSwQtWbV+ZH7O/f4QKRxXJTQenmXQDThwK
         qOzg+oLhbwQWO+mboLEBXF4mWTEdBiQjEth/eUYaDnlQHfA4oxAr+S6jlTmbfb+B4RBm
         MMfkAsBxGk04ZGAWr3GQUVXWvZbwjGhcIkk32qwPQbVMESPB1oNgBnV1oBsktWK3btWP
         aZfzgsVl5keC0Xcy0DfJxAfbrQmNzJY/SpNIPEomjheSRkuln3FTfweWPPzG9+7R/+Lb
         WKZy3Hkc9y4q+EWRBO2VhDaNdmmQHnhx4NU8x8D18sXITF2WqzIyVgyGGkWRVjT1lcmI
         bzfw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1660908562-17409-1-git-send-email-zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Fri, Aug 19, 2022 at 07:29:22PM +0800, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> 
> It is observed in android system where per-app cgroup is demanded by freezer
> subsys and part of groups require memory control. The hierarchy could be simplized
> as bellowing where memory charged on group B abserved while we only want have
> group E's memory be controlled and B's descendants compete freely for memory.
> This should be the consequences of unified hierarchy.
> Under this scenario, less efficient memory reclaim is observed when comparing
> with no memory control. It is believed that multi LRU scanning introduces some
> of the overhead. Furthermore, page thrashing is also heavier than global LRU
> which could be the consequences of partial failure of WORKINGSET mechanism as
> LRU is too short to protect the active pages.
> 
> A(subtree_control = memory) - B(subtree_control = NULL) - C()
> 							\ D()
> 			    - E(subtree_control = memory) - F()
> 							  \ G()
> 
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

Just in case it wasn't clear.

Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
