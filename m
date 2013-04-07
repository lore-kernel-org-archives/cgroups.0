From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC][PATCH 0/7] memcg: make memcg's life cycle the same as
 cgroup
Date: Sun, 7 Apr 2013 21:51:12 +0200
Message-ID: <20130407195112.GA12678@dhcp22.suse.cz>
References: <515BF233.6070308@huawei.com>
 <516131D7.8030004@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=WEu9oyFQM34DzjKS7nE0q9qjXmrQRUfybN8THO8IaZk=;
        b=JlvvLXunSvmNEi6Q/XXmkkyZiHjPpvFL2KBoNrHg01WQSxNEZbuH0rxBaLu5CZkn/r
         OBgUne71DOMcCVLBkiqPc52uy25zE8XmfWqo+XDRMO0chcn9JUMOlgaqGq/aONEl/je6
         +HrwEdN7g8YZFDFpN4MPmZV/3x5IhxXi6k2EhYuHfFQwrwgffCB/FculTRGFwDctcJ9K
         A2LusnBFnA5bXvQcpXaGCGhfBcoB1PxDdY4a/jVGC8/BKUGY9lAj2bITOh1MoW0ircd1
         tcuQ7U/cWrJbX+35pHtqOs0X4prhB+RPl3vIayrt1cpoSbapjc7hoxTkEhchkNbQRKf5
         PiZQ==
Content-Disposition: inline
In-Reply-To: <516131D7.8030004@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

On Sun 07-04-13 16:44:07, Li Zefan wrote:
> Hi,
> 
> I'm rebasing this patchset against latest linux-next, and it conflicts with
> "[PATCH v2] memcg: debugging facility to access dangling memcgs." slightly.
> 
> That is a debugging patch and will never be pushed into mainline, so should I
> still base this patchset on that debugging patch?

Could you split CONFIG_MEMCG_DEBUG_ASYNC_DESTROY changes into a separate
patch so that Andrew could put it on top of the mentioned patch?

> Also that patch needs update (and can be simplified) after this patchset:
> - move memcg_dangling_add() to mem_cgroup_css_offline()
> - remove memcg->memcg_name, and use cgroup_path() in mem_cgroup_dangling_read()?

Every improvement is welcome.

Thanks
-- 
Michal Hocko
SUSE Labs
