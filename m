From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Fri, 31 Mar 2023 13:02:10 +0200
Message-ID: <ZCa9sixp3GJcjf8Y@dhcp22.suse.cz>
References: <CAJD7tkb-UpKm2QbjYzB=B=oGk6Hyj9cbUviZUPC+7VsvBecH7g@mail.gmail.com>
 <20230329192059.2nlme5ubshzdbpg6@google.com>
 <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz>
 <CAJD7tka0CmRvcvB0k8DZuid1vC9OK_mFriHHbXNTUkVE7OjaTA@mail.gmail.com>
 <ZCU+8lSi+e4WgT3F@dhcp22.suse.cz>
 <CAJD7tkaKd9Bcb2-e83Q-kzF7G+crr1U+7uqUPBARXWq-LpyKvw@mail.gmail.com>
 <ZCVFA78lDj2/Uy0C@dhcp22.suse.cz>
 <CAJD7tkbjmBaXghQ+14Hy28r2LoWSim+LEjOPxaamYeA_kr2uVw@mail.gmail.com>
 <ZCVKqN2nDkkQFvO0@dhcp22.suse.cz>
 <CAJD7tkYEOVRcXs-Ag3mWn69EwE4rjFt9j5MAcTGCNE8BuhTd+A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680260531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0zDTOEUPULEGTHHet0jierMbFRNofOx53s0jqkmUViU=;
        b=HY3rQeqY7ZYxCtE7IltnkV70FG6bzf+eC2dVHeBUl0Ix0NV5AMTkt2PnHLgO0HoYkselg9
        FJM6tpSacuKTSFybHXv8XqOmvrDIEq19voIlNLCwx4PK2cYEThOmXr4TsfsCj5iEWMy7f0
        /dNhN0nFa1o0VyS++jEgrgkknTvPXaU=
Content-Disposition: inline
In-Reply-To: <CAJD7tkYEOVRcXs-Ag3mWn69EwE4rjFt9j5MAcTGCNE8BuhTd+A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu 30-03-23 01:53:38, Yosry Ahmed wrote:
[...]
> Maybe we can add a primitive like might_sleep() for this, just food for thought.

I do not think it is the correct to abuse might_sleep if the function
itself doesn't sleep. If it does might_sleep is already involved.
-- 
Michal Hocko
SUSE Labs
