From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3] memcg: schedule high reclaim for remote memcgs on
 high_work
Date: Fri, 11 Jan 2019 15:59:48 -0500
Message-ID: <20190111205948.GA4591@cmpxchg.org>
References: <20190110174432.82064-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=njp5vf4IquyG7FjzRfZTdEcdSKU/h4oc8yA5MyBHjJU=;
        b=1Cc/BB7ZTijZh8NgENDs+quiQLlsEB/RwXggD4otkGLiHnJNDrVCCl3zYsoaDzvVJE
         +kqROyhrKEReL7V4qE3RIHvcbnPgA6qWFBficRDtwx0fqbeqaiup3nZaeKzTjyXnV9+f
         zXo7Z8+ujHOnljGOxOAF//foOnPw0C55Qjts3m/7lSZlQY9KLyljSuWiooQ1yz9rkx6V
         kwMm8VfiThxj6ETEQ9t+DN5IbEjM6PN8mO1dUWmbP7u+yH5uUIs7hMPbljfI8faq/OjP
         3oXOXWLghhFr762GNmV/3a812f5OtS2SwHYLKOgJtMHSgBVae8e3Yt8kt2erYBCxfvKx
         +i9Q==
Content-Disposition: inline
In-Reply-To: <20190110174432.82064-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hi Shakeel,

On Thu, Jan 10, 2019 at 09:44:32AM -0800, Shakeel Butt wrote:
> If a memcg is over high limit, memory reclaim is scheduled to run on
> return-to-userland.  However it is assumed that the memcg is the current
> process's memcg.  With remote memcg charging for kmem or swapping in a
> page charged to remote memcg, current process can trigger reclaim on
> remote memcg.  So, schduling reclaim on return-to-userland for remote
> memcgs will ignore the high reclaim altogether. So, record the memcg
> needing high reclaim and trigger high reclaim for that memcg on
> return-to-userland.  However if the memcg is already recorded for high
> reclaim and the recorded memcg is not the descendant of the the memcg
> needing high reclaim, punt the high reclaim to the work queue.

The idea behind remote charging is that the thread allocating the
memory is not responsible for that memory, but a different cgroup
is. Why would the same thread then have to work off any high excess
this could produce in that unrelated group?

Say you have a inotify/dnotify listener that is restricted in its
memory use - now everybody sending notification events from outside
that listener's group would get throttled on a cgroup over which it
has no control. That sounds like a recipe for priority inversions.

It seems to me we should only do reclaim-on-return when current is in
the ill-behaved cgroup, and punt everything else - interrupts and
remote charges - to the workqueue.
