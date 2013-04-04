From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 5/7] cgroup: make sure parent won't be destroyed
 before its children
Date: Thu, 4 Apr 2013 06:53:53 -0700
Message-ID: <20130404133706.GA9425@htj.dyndns.org>
References: <515BF233.6070308@huawei.com>
 <515BF2A4.1070703@huawei.com>
 <20130404113750.GH29911@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=toGnHD9IUAb/IMSUybyTxoEvm9/PXxm4JDzsfnVe+ls=;
        b=c/zPBWWUA5ekOuhG7xDy2hb4ZYDzJ9Npbcm8157Qo2EBiF1/4guYDNPjUOFBDWOMA0
         Tx8J2CqQqKovO+ip8GIX+0OuQOWNOUhDkRwjSv3hpg5FIcpqYivi5nDgBkDpxp+P8/KB
         3sOqPygAYk6C6wKBso1edSgxKn6eaFEstroi80LMis+INMurgpZOtt2laBqkK5lrg9GQ
         Baaq/rxIfZA3B3Bh8Ze3CFsXou+5zkdZTiQ3TM9s81QXsYWbXE2U9CwmqBYk0+/fcQz8
         iPl3p6D3IhJj54It0jcccGNksni0Yt7wnq8CCQyMPwEHPlis9pkimi4laPweyvUNn1sj
         WUtg==
Content-Disposition: inline
In-Reply-To: <20130404113750.GH29911-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hey,

On Thu, Apr 04, 2013 at 01:37:50PM +0200, Michal Hocko wrote:
> On Wed 03-04-13 17:13:08, Li Zefan wrote:
> > Suppose we rmdir a cgroup and there're still css refs, this cgroup won't
> > be freed. Then we rmdir the parent cgroup, and the parent is freed due
> > to css ref draining to 0. Now it would be a disaster if the child cgroup
> > tries to access its parent.
> 
> Hmm, I am not sure what is the correct layer for this to handle - cgroup
> core or memcg. But we have enforced that in mem_cgroup_css_online where
> we take an additional reference to the memcg.
> 
> Handling it in the memcg code would have an advantage of limiting an
> additional reference only to use_hierarchy cases which is sufficient
> as we never touch the parent otherwise (parent_mem_cgroup).

But what harm does an additional reference do?  And given that there
are cgroup core interfaces which access ->parent, I think it'd be a
good idea that parent always exists while there are children.

Thanks.

-- 
tejun
