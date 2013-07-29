From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/8] cgroup: convert cgroup_ida to cgroup_idr
Date: Mon, 29 Jul 2013 14:28:35 -0400
Message-ID: <20130729182835.GD26076@mtj.dyndns.org>
References: <51F614B2.6010503@huawei.com>
 <51F614C4.7060602@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=niQtGH7TJKA2CqS4FI09pvROmyz/d/z3f4wVpWp/gQE=;
        b=AvWNg3bSY9nt3gVTukAcbfp3YNrzsrBq11Hjav5TDeAL5xQ1j9/u7O+1fg3UPIFjTg
         dhoVBsfuaAmc7uL9Pcoale0YluFs8j2KQRIwfiJLLDYk2Up2DuL/NUTikoZRDaquGp5H
         1u7pztOX3lrOUQqNu7LLX79VAu/7FTW8DD9apnSosJLtsNgzgK2h7G0CTgHs+cZJaEGu
         DjnC+NYUHAoSWSCTtvOfjIxz5Md6ZkZ7v8gX3tCz+i+8lVy70a+RIMSLs0XBbfN+EoIc
         2Vqno/MiaLK1AZXIB2c214aOT+0QR/zE/OKMmUKxDfGOGEIChQ9myMcPTrnTwkUZhRzG
         JUww==
Content-Disposition: inline
In-Reply-To: <51F614C4.7060602-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello,

On Mon, Jul 29, 2013 at 03:07:48PM +0800, Li Zefan wrote:
> @@ -4590,6 +4599,9 @@ static void cgroup_offline_fn(struct work_struct *work)
>  	/* delete this cgroup from parent->children */
>  	list_del_rcu(&cgrp->sibling);
>  
> +	if (cgrp->id)
> +		idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
> +

Yeap, if we're gonna allow lookups, removal should happen here but can
we please add short comment explaining why that is?  Also, do we want
to clear cgrp->id?

Thanks.

-- 
tejun
