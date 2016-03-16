From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 16 Mar 2016 13:40:02 -0700
Message-ID: <20160316204002.GG21104@mtj.duckdns.org>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
 <1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
 <20160302173949.GG29826@mtj.duckdns.org>
 <CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
 <CAG53R5VYnTMzG4DchY2DKgveeeXbKcjUWQpOOjCNQuY-f7g9bg@mail.gmail.com>
 <CAG53R5Wwr41Ma4AbTG==4VcOGvdO=t=be8z0Lkfq0YukuBtCzg@mail.gmail.com>
 <20160305125215.GC3567@htj.duckdns.org>
 <CAG53R5V-fhbVqZWroAkvDpgjNWchnO87G47-iXqSGg41sY1A5Q@mail.gmail.com>
 <CAG53R5XPFJn-gKvr-WtJy-+zv=APK0DWTBY96fo47XUD9h1FcQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SCHPgRzXBc1p0yLSDuHjdQVRwLjkIHtUBqUFCMHHhYg=;
        b=rho0EVGSkj8eAx0GfUswpLvcdiCc2Z3bJGfaKvFjDAhIEaJOO8830SKoQvgdX0Y1ik
         h9nkhTbwvl2zvyo1Nn0RzFXCJYj2NovmwJ2xnrckH04yP5DQZ8bYcDuWsZlbQB4INXkK
         wgcRFmDZLtLE/ro6CUD7pM/9etQ1IwqrxR+FZ05ekW9T6+5AR4CC9GfgO619gfgG1YXl
         44Crsov3zMkMcPKGkP58S1+wWj1hc6yu8n6YAQ6SH0Y+LnVGYyxwIMIQQmgBeVvufASB
         TdYm0N5XlZSkDa0Rgj4AlvoKMCBepd9Bvm7Tk1SvffdqIrhJV4i+TA8HkTkAjhBcO4nq
         mn7A==
Content-Disposition: inline
In-Reply-To: <CAG53R5XPFJn-gKvr-WtJy-+zv=APK0DWTBY96fo47XUD9h1FcQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello, Parav.

Sorry about the delay.

On Sat, Mar 12, 2016 at 11:49:03AM +0530, Parav Pandit wrote:
> > For (1) shall I have one spin lock that is uses across multiple
> > hierarchy and multiple cgroup.
> > Essentially one global lock among all cgroup. During hierarchical
> > charging, continue to use same lock it at each level.
> > Would that work in this first release?
> 
> I am waiting for your reply.
> Shall one lock for all cgroup is ok with you?

Yes, when you're locking up to the root each time, splitting locks at
the bottom doesn't really achieve anything.  It just makes things more
expensive.

> If this is ok. I will keep the code as it is, because it uses common
> helper functions for max and current files.

Hmmm... can you please try to refactor the common part to helpers?
It's not a big thing but there were both styles across different
controllers and helper based ones tend to be easier to follow.

> >> 3 is fine but resource [un]charging is not hot path?
> > charge/uncharge is hot path from cgroup perspective.
> > Considering 1 to 4 devices in system rpool list would grow upto 4
> > entry deep at each cgroup level.
> > I believe this is good enough to start with. O complexity wise its
> > O(N). where N is number of devices in system.

I see, but if that's the case, please drop the fine locking.  The fine
locking doesn't make much sense - as implemented it's slower and the
whole thing is not hot.

Thanks.

-- 
tejun
