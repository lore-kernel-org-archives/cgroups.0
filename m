From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 1/4] memcg: introduce per-memcg reclaim interface
Date: Mon, 11 Apr 2022 09:20:30 +0200
Message-ID: <YlPWvuK5pG/CapKv@dhcp22.suse.cz>
References: <20220408045743.1432968-1-yosryahmed@google.com>
 <20220408045743.1432968-2-yosryahmed@google.com>
 <YlA754XNFAmWQcm6@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <YlBCeadBqbeVvALK@dhcp22.suse.cz>
 <YlBM/HlPyPUZew5N@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649661635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EKQ22xGnCAfhZWYXu0EvGb4wthBpsfoBSJ1Jf+KqZ/U=;
        b=ZyojcBVo92JmwvoAqRyuWeNWhRdm2bTVzL3tgs8ML4g9f+5OapIHmsoh8iSO3TZbUFORDW
        l7lVqpJ+JmozjlZtoMfJjR4SyYzHmgOUP3TOxtkw2i10q7qGLIWBSnvnX/BajoavEbPNJp
        v/KvnynxlBntXBl4aDgMwxDLnE8Fnlg=
Content-Disposition: inline
In-Reply-To: <YlBM/HlPyPUZew5N@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, l

On Fri 08-04-22 10:55:56, Dan Schatzberg wrote:
> On Fri, Apr 08, 2022 at 04:11:05PM +0200, Michal Hocko wrote:
> > Regarding "max" as a possible input. I am not really sure to be honest.
> > I can imagine that it could be legit to simply reclaim all the charges
> > (e.g. before removing the memcg) which should be achieveable by
> > reclaiming the reported consumption. Or what exactly should be the
> > semantic?
> 
> Yeah, it just allows you to avoid reading memory.current to just
> reclaim everything if you can specify "max"

The same could be achieved by requesting a really high number (-1Ul)

> - you're still protected
> by nretries to eventually bail out.

The number of retries is an implementation detail and nobody should
really rely on that. Bail out on signal can be still used so yeah
getting a large input or whatever alias of that should be just fine.

> Mostly, though I just feel like
> supporting "max" makes memory.reclaim semetric with a lot of the
> cgroup memory control files which tend to support "max".

max is used for limits now and this doesn't have a semantic of one.
But I have to say I do not really feel strongly about this.

-- 
Michal Hocko
SUSE Labs
