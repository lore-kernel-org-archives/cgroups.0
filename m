From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Thu, 30 Mar 2023 10:14:59 +0200
Message-ID: <ZCVFA78lDj2/Uy0C@dhcp22.suse.cz>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-5-yosryahmed@google.com>
 <ZCQfZJFufkJ10o01@dhcp22.suse.cz>
 <CAJD7tkb-UpKm2QbjYzB=B=oGk6Hyj9cbUviZUPC+7VsvBecH7g@mail.gmail.com>
 <20230329192059.2nlme5ubshzdbpg6@google.com>
 <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz>
 <CAJD7tka0CmRvcvB0k8DZuid1vC9OK_mFriHHbXNTUkVE7OjaTA@mail.gmail.com>
 <ZCU+8lSi+e4WgT3F@dhcp22.suse.cz>
 <CAJD7tkaKd9Bcb2-e83Q-kzF7G+crr1U+7uqUPBARXWq-LpyKvw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680164100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L+5wWM9KaM83E2/8g4jR2hxUBs15iqyGGbyguGgqv6E=;
        b=Zkm382DuV3cURAzt/IiQ9KAhrZxaXTxTdveLwdBMtYHpoE8u1K6ciaYaQMSNkGJ/omClUo
        iIcdekBvIAUYIuqAzCDRW3IXFkKXanegH0ZMMprE+/Z1xVDp1l90YBKnyajEOetGF/rKfL
        5FdD/y8rIiefom+dXeppIrIHiFQKcfg=
Content-Disposition: inline
In-Reply-To: <CAJD7tkaKd9Bcb2-e83Q-kzF7G+crr1U+7uqUPBARXWq-LpyKvw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu 30-03-23 01:06:26, Yosry Ahmed wrote:
[...]
> If we achieve that, do you think it makes sense to add
> WARN_ON_ONCE(irqs_disabled()) instead to prevent future users from
> flushing while disabling irqs or in irq context?

WARN_ON (similar to BUG_ON) will not prevent anybody from doing bad
things. We already have means to shout about sleepable code being
invoked from an atomic context and there is no reason to duplicate that.
As I've said earlier WARN_ON might panic the system in some
configurations (and yes they are used also in production systems - do
not ask me why...). So please be careful about that and use that only
when something really bad (yet recoverable) is going on.

-- 
Michal Hocko
SUSE Labs
