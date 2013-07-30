From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 1/8] cgroup: convert cgroup_ida to cgroup_idr
Date: Tue, 30 Jul 2013 10:21:59 -0400
Message-ID: <20130730142159.GI12016@htj.dyndns.org>
References: <51F614B2.6010503@huawei.com>
 <51F614C4.7060602@huawei.com>
 <20130729182835.GD26076@mtj.dyndns.org>
 <51F7127B.1070107@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=k0izRFF4MieyDgzjIlzeKhqYtQ3Ao9NXzdXpaDY1TBk=;
        b=ODE5SJBPMA/ImL7qBEvPiZGmVnjbqiFohREj0d53hWYT7SGFalry8Aox7nDEaO4jcw
         YAoNiV0/cbrPpwwsnbypDZeABWmmquJ+BAUCpOm2WuMyGHo+1LHqqrkhibS3p1ntf5SG
         2fps0usRQ2cTVswiRRuHELzXV7iUbYVsoqS7Q3vlXmWhkOqaaHkWNFrdpgKkUYBEzZOH
         0z2lOILqXykqJusYqYCXlEidaNM3kg/PM/zA7T2na3XYWuq2H7FprfghUwMTCsGdw0DM
         ZCme4MBuiCA8tunQ0gzyfgbJfPvUAYf2FrKJtzOH+Hg16f3RcZ14E+IJs78NM8TMqM+K
         oVkw==
Content-Disposition: inline
In-Reply-To: <51F7127B.1070107@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Tue, Jul 30, 2013 at 09:10:19AM +0800, Li Zefan wrote:
> Set cgrp->id to 0? No, 0 is a valid id. The if is here because at first

I don't know.  -1 then?

> I called idr_alloc() very late in cgroup_create(), so cgroup_offline_fn()
> can be called while cgrp->id hasn't been initialized. Now I can remove
> this check.

I'm just a bit apprehensive as IDs will be recycled very fast and
controllers would keep accessing the css and cgroup after offline
until all refs are drained, so it'd be nice if there's some mechanism
to prevent / detect stale ID usages.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
