From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/5] cgroup: record ancestor IDs and reimplement
 cgroup_is_descendant() using it
Date: Tue, 17 Nov 2015 18:03:35 -0500
Message-ID: <20151117230335.GK22864@mtj.duckdns.org>
References: <1447789240-29394-1-git-send-email-tj@kernel.org>
 <1447789240-29394-2-git-send-email-tj@kernel.org>
 <alpine.LSU.2.20.1511172353350.13966@nerf40.vanv.qr>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=55zpRWxA/rO7G/5x+JDS/fuJ4tYzaE+UQufL1L7Y+Ec=;
        b=C0wQox8n0hjq7t1gKVoqse640D+wVN/Ou94T2oN172ooaNOx9BjY8bk/UohcXFlKfN
         faAz8pUQb7VvRh74XiYwoUJfkaqXaftroTjRYD59jjn4SKO38UUU99en45e7jDzOTg1d
         8SlqSi+c47bbBY8B4sh4q3gfWmJpjptkC3I4S1cFyJC9H8QJfrG70wTCydplS5UoLUcs
         JYuZ8d1Q220dJNje4QQqo/DFSuFlJFb5aycC1FMN8tSe3R3znkCv528kZlOnyLD4llRL
         UuR1oc3FnrkgkcQ5tXYOKcb9ULU4B6GoRuYSOt1HYAwcv5NYnb9E6CmEwMUYVFRLdH6l
         dExg==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1511172353350.13966@nerf40.vanv.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Engelhardt <jengelh@inai.de>
Cc: davem@davemloft.net, pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu, lizefan@huawei.com, hannes@cmpxchg.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, daniel@iogearbox.net, daniel.wagner@bmw-carit.de, nhorman@tuxdriver.com

On Tue, Nov 17, 2015 at 11:54:54PM +0100, Jan Engelhardt wrote:
> 
> On Tuesday 2015-11-17 20:40, Tejun Heo wrote:
> >+static inline bool cgroup_is_descendant(struct cgroup *cgrp,
> >+					struct cgroup *ancestor)
> 
> (const struct group *cgrp, const struct group *ancestor)

I'm not sure about using const on complex data structures.  It often
ends up causing more mess than being helpful.  It's never consistent
and often can't be - e.g. you throw in an iteration macro and then
realize that there need to be two separate variants of iteration
macros for consts and !consts after propagating const through the call
chains and then end up doing forced casts.

Thanks.

-- 
tejun
