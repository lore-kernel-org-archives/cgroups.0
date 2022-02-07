From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4 3/4] mm/page_owner: Print memcg information
Date: Mon, 7 Feb 2022 11:09:47 -0800
Message-ID: <20220207110947.f07b58898d91c02090f9aacf@linux-foundation.org>
References: <20220131192308.608837-5-longman@redhat.com>
        <20220202203036.744010-4-longman@redhat.com>
        <YfvOp5VXrxy9IW1w@dhcp22.suse.cz>
        <3f042edb-3769-afea-17a7-899578cd5c69@redhat.com>
        <YgFUxFI5bMbc42j4@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644260988;
        bh=1RclloxgFVd2RY/SeAe+aZcV9sRA2fEBnErBCQ5PRjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FFY2E0gZcn+hlSYQnpefUNBA1l5rE11wEoXKl40YqV1L1HpuqhxmQ+kJNZu2t373W
         AjoDjYCQxy2ZubNzmVoAB4s6o/jE/wIg65oRrZ4Gg/7IbWTaQBO1slEgGnuCXBGRd7
         L+OKUzs+E87cP4vkY5QndLicBOgQ4Yc4qujZ4vsU=
In-Reply-To: <YgFUxFI5bMbc42j4-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, 7 Feb 2022 18:20:04 +0100 Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:

> On Thu 03-02-22 14:03:58, Waiman Long wrote:
> > On 2/3/22 07:46, Michal Hocko wrote:
> > > On Wed 02-02-22 15:30:35, Waiman Long wrote:
> > > [...]
> ...
> > > > +	online = (memcg->css.flags & CSS_ONLINE);
> > > > +	cgroup_name(memcg->css.cgroup, name, sizeof(name));
> > > Is there any specific reason to use another buffer allocated on the
> > > stack? Also 80B seems too short to cover NAME_MAX.
> > > 
> > > Nothing else jumped at me.
> > 
> > I suppose we can print directly into kbuf with cgroup_name(), but using a
> > separate buffer is easier to read and understand. 79 characters should be
> > enough for most cgroup names. Some auto-generated names with some kind of
> > embedded uuids may be longer than that, but the random sequence of hex
> > digits that may be missing do not convey much information for identification
> > purpose. We can always increase the buffer length later if it turns out to
> > be an issue.
> 
> Cutting a name short sounds like a source of confusion and there doesn't
> seem to be any good reason for that.

Yes.  If we give them 79 characters, someone will go and want 94.  If
we can prevent this once and for ever, let's please do so.

