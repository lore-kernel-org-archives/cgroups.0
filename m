From: Tejun Heo <tj@kernel.org>
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Date: Tue, 17 Dec 2013 07:29:26 -0500
Message-ID: <20131217122926.GC29989@htj.dyndns.org>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
 <20131216163530.GH32509@htj.dyndns.org>
 <20131216171937.GG26797@dhcp22.suse.cz>
 <20131216172143.GJ32509@htj.dyndns.org>
 <alpine.LNX.2.00.1312161718001.2037@eggly.anvils>
 <52AFC163.5010507@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=j8N8S8iRxbrFFzzTjAD1HB4LZjtQnXPWsxNVommM8t0=;
        b=b6AyWR5QwdmdoPZgbWVshFcIiDf+zB9Pwt4MJ24S1sRS82Rs+u9KJYEW+/UUGpoLZj
         U1pm2gI97tSDLt7UMPum73Nza/rNIT6GfQwS8A2r33tTp35wCbF6aayo0dhuWy5LJMWk
         OmHDu5UGceUkNKBX9irkrTMzce+VLIwdV9YtkF3KKuYZZF11KMXFREvLTI58Oi2x2c3g
         7hezXMqUUR5cG1fN9t98FB/ZEYVvf+wqJPoZX4gRPKmJ5EcfIvZ2RKAt8W8kEA5s58lF
         wBsgHf6EU+Re3e5Lh0Tx8C1LGQhlkeaaxeRV95EVVm7inSrczDunjcPZ0gVYvCUZhjZP
         HeGQ==
Content-Disposition: inline
In-Reply-To: <52AFC163.5010507@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Li.

On Tue, Dec 17, 2013 at 11:13:39AM +0800, Li Zefan wrote:
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c36d906..769b5bb 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -868,6 +868,15 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
>  		struct cgroup *cgrp = dentry->d_fsdata;
>  
>  		BUG_ON(!(cgroup_is_dead(cgrp)));
> +
> +		/*
> +		 * We should remove the cgroup object from idr before its
> +		 * grace period starts, so we won't be looking up a cgroup
> +		 * while the cgroup is being freed.
> +		 */

Let's remove this comment and instead comment that this is to be made
per-css.  I mixed up the lifetime rules of the cgroup and css and
thought css_from_id() should fail once css is confirmed to be offline,
so the above comment.  It looks like we'll eventually have to move
cgrp->id to css->id (just simple per-ss idr) as the two objects'
lifetime rules will be completely separate.  Other than that, looks
good to me.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
