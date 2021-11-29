From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Mon, 29 Nov 2021 09:39:16 +0100
Message-ID: <YaSRtKwTCOj7JnR6@dhcp22.suse.cz>
References: <YZ5o/VmU59evp65J@dhcp22.suse.cz>
 <CA+PpKPmy-u_BxYMCQOFyz78t2+3uM6nR9mQeX+MPyH6H2tOOHA@mail.gmail.com>
 <YZ8DZHERun6Fej2P@casper.infradead.org>
 <20211125080238.GA7356@haolee.io>
 <YZ9e3pzHKmn5nev0@dhcp22.suse.cz>
 <20211125123133.GA7758@haolee.io>
 <YZ+bI1fNpKar0bSU@dhcp22.suse.cz>
 <CA+PpKP=hsuBmvv09OcD2Nct8B8Cqa03UfKFHAHzKxwE0SXGP4g@mail.gmail.com>
 <YaC7BcTSijFj+bxR@dhcp22.suse.cz>
 <20211126162623.GA10277@haolee.io>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638175157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y1/HRvQWe5bupilVHXWVZDusBm8nr9LZt0uqBedKdKA=;
        b=J4qijL9j7NKJC0s4vnqOlrDs2BSFPsMfOKHgq75fzXUbUMmG6kDFsHC446/t8l9HnhxQGi
        1X48f8fJWJ9sQfbIUtxwtWBvay0Vz0aMdUE83pfyyc4cYhcZsz7fW82PhBT10czrrivQxi
        qE3pMx7MyDOyufnfhAhM+rP1LoUdXcM=
Content-Disposition: inline
In-Reply-To: <20211126162623.GA10277@haolee.io>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Lee <haolee.swjtu@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Linux MM <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, vdavydov.dev@gmail.com, Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Fri 26-11-21 16:26:23, Hao Lee wrote:
[...]
> I will try Matthew's idea to use semaphore or mutex to limit the number of BE
> jobs that are in the exiting path. This sounds like a feasible approach for
> our scenario...

I am not really sure this is something that would be acceptable. Your
problem is resource partitioning. Papering that over by a lock is not
the right way to go. Besides that you will likely hit a hard question on
how many tasks to allow to run concurrently. Whatever the value some
workload will very likely going to suffer. We cannot assume admin to
chose the right value because there is no clear answer for that. Not to
mention other potential problems - e.g. even more priority inversions
etc.
-- 
Michal Hocko
SUSE Labs
