From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] mm: migrate: do not touch page->mem_cgroup of live
 pages
Date: Wed, 3 Feb 2016 17:39:08 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1602031648050.1497@eggly.anvils>
References: <1454109573-29235-1-git-send-email-hannes@cmpxchg.org> <1454109573-29235-2-git-send-email-hannes@cmpxchg.org> <20160203131748.GB15520@mguzik> <20160203140824.GJ21016@esperanza> <20160203183547.GA4007@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=1D4O6jcs8CzskxnL9wUc+2m5hN0jrLJfL/eB4a2MUQ4=;
        b=bJQ6L35wh/mqtyfQn1UiC3oMtMMv8CAtVpVTVf75jPa6rZDSCzX7JVW7nUQEIo7Sm7
         aQ2NG9ii1LkROhgTUTB9Qr5j3QvrQkfHzUr8dCZcsmnD5+tX5HtOQCqHj5tTNywyZAzg
         ae2sho7wtZqa4l8Z+KOjO6EZGlM63Wq/hHpNDTU5D5uoP/C2KW6azZZ6LbjHlM4LJu3h
         bLO9QMUFNF6yj9haVgJZYBCIeOhrQaiY63yRib5n2A70eufyCdN3QYr7r954WOMvine6
         ftdJgbe+rbHR8CIsQlCJc/zjVUUMP41a9W19zyo/Z5IzjWK3pDIXWDeiFLlYL6fj8g79
         WOKQ==
In-Reply-To: <20160203183547.GA4007-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, 3 Feb 2016, Johannes Weiner wrote:

> CCing Hugh and Greg, they have worked on the memcg migration code most
> recently. AFAIK the only reason newpage->mem_cgroup had to be set up
> that early in migration was because of the way dirty accounting used
> to work. But Hugh took memcg out of the equation there, so moving
> mem_cgroup_migrate() to the end should be safe, as long as the pages
> are still locked and off the LRU.

Yes, that should be safe now: Vladimir's patch looks okay to me,
fixing the immediate irq issue.

But it would be nicer, if mem_cgroup_migrate() were called solely
from migrate_page_copy() - deleting the other calls in mm/migrate.c,
including that from migrate_misplaced_transhuge_page() (which does
some rewinding on error after its migrate_page_copy(): but just as
you now let a successfully migrated old page be uncharged when it's
freed, so you can leave a failed new_page to be uncharged when it's
freed, no extra code needed).

And (even more off-topic), I'm slightly sad to see that the lrucare
arg which mem_cgroup_migrate() used to have (before I renamed it and
you renamed it back!) has gone, so mem_cgroup_migrate() now always
demands lrucare of commit_charge().  I'd hoped that with your
separation of new from old charge, mem_cgroup_migrate() would never
need lrucare; but that's not true for the fuse case, though true
for everyone else.  Maybe just not worth bothering about?  Or the
reintroduction of some unnecessary zone->lru_lock-ing in page
migration, which we ought to try to avoid?

Or am I wrong, and even fuse doesn't need it?  That early return
"if (newpage->mem_cgroup)": isn't mem_cgroup_migrate() a no-op for
fuse, or is there some corner case by which newpage can be on LRU
but its mem_cgroup unset?

Hugh
