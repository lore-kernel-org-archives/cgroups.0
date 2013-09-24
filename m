From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
Date: Mon, 23 Sep 2013 21:46:12 -0400
Message-ID: <20130924014612.GC3482@htj.dyndns.org>
References: <524001F8.6070205@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6THy7vEnAm4QRfHybQIWm3IJND5Mqgm/ce/EhU581qg=;
        b=EdHJd/0gIexU0ivWV/dmyA9fjffV5GwZNkGhXbKXQ5/m6lWiW+NpJkloGrwqmylXF5
         gSp/AGN0Jr22tc8wN+YJ73PCM3Do/5X7rEqTKZvpRA9/gNcueZYX32j37KDW5Z5CYz10
         XQHVQbFjsMuHisn10aENMISf0BQg41MYqEZudpdLAj0yeHpaKNKyVd0akfXTVCg5mHl9
         FDfcXlgJivPhLw7Fs3qKjgo1IOKJpZ0MOmKv1HLJTyH1sDQUCc2ycECY870BJ9q88pOH
         GRRNXJN53ka7txiA93v3jaTigDzSWzJl4KejSWk5lzmuQfiJADiqfNq385L/1vT18+aO
         7IMQ==
Content-Disposition: inline
In-Reply-To: <524001F8.6070205@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

On Mon, Sep 23, 2013 at 04:55:20PM +0800, Li Zefan wrote:
> Hi Andrew,
> 
> The whole patchset has been acked and reviewed by Michal and Tejun.
> Could you merge it into mm tree?
> 
> ===========
> 
> This patchset converts memcg to use cgroup->id, and then we remove cgroup
> css_id.

Applied to cgroup/for-3.13.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
