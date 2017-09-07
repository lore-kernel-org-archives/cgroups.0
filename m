From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: memcontrol: use per-cpu stocks for socket memory
 uncharging
Date: Thu, 7 Sep 2017 19:47:45 +0100
Message-ID: <20170907184745.GA20598@castle.DHCP.thefacebook.com>
References: <20170829100150.4580-1-guro@fb.com>
 <20170829192621.GA5447@cmpxchg.org>
 <20170830105524.GA2852@castle.dhcp.TheFacebook.com>
 <CALvZod5zP=LL=LhD0WX-zX4mPbn7F_obQmpCrrin9YuBQHJLow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=cJp+96N6H9WJSX08xzZ2jkahUNh+byZC6vvDElfeTTE=;
 b=QnI4meTIfyc54GILEKy7s0GWbacHuECn8CrdPf+KhY2DRItRlvSi8EhCS4SNA4bHcinB
 QOUs6ZCc3WGfuxYf8wM4ywX6L6rq9WDuohabVYcHZs1fu4RBpsIfcn6bYJO2deGZynY8
 qrCMXIT+ZwO0ZhOmLTaSzu8jB0giMlxPkeo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cJp+96N6H9WJSX08xzZ2jkahUNh+byZC6vvDElfeTTE=;
 b=TeRJ/AeXqRZVPQakTJAU8fsKhGG+74js4cZNIjMn+cunhnszcv2LXMcNxedR169LOMdzbDUbCS7YHMppCDmN6rlO8+G4zl9j9cJY9MgxOBf2ikxE3KKxx8tTAOy61wYxre0yMIXLBNIi7lnzORXXtfW2pi+yLTX+xmNC6nIvzcY=
Content-Disposition: inline
In-Reply-To: <CALvZod5zP=LL=LhD0WX-zX4mPbn7F_obQmpCrrin9YuBQHJLow@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, kernel-team@fb.com, LKML <linux-kernel@vger.kernel.org>

On Thu, Sep 07, 2017 at 11:44:12AM -0700, Shakeel Butt wrote:
> >> As far as other types of pages go: page cache and anon are already
> >> batched pretty well, but I think kmem might benefit from this
> >> too. Have you considered using the stock in memcg_kmem_uncharge()?
> >
> > Good idea!
> > I'll try to find an appropriate testcase and check if it really
> > brings any benefits. If so, I'll master a patch.
> >
> 
> Hi Roman, did you get the chance to try this on memcg_kmem_uncharge()?

Hi Shakeel!

Not yet, I'll try to it asap.
Do you have an example when it's costly?

Thanks!
