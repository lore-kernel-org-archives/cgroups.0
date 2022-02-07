From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v4 3/4] mm/page_owner: Print memcg information
Date: Mon, 7 Feb 2022 18:20:04 +0100
Message-ID: <YgFUxFI5bMbc42j4@dhcp22.suse.cz>
References: <20220131192308.608837-5-longman@redhat.com>
 <20220202203036.744010-4-longman@redhat.com>
 <YfvOp5VXrxy9IW1w@dhcp22.suse.cz>
 <3f042edb-3769-afea-17a7-899578cd5c69@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644254409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WgeOunKZPWr1u7CmKBkIn3aI6IvIjxAaiaRIxKsTWU4=;
        b=oJXyY0lg033cJKb3vjdcvI1hPZc0gH3NGf+1IsuEJ2ysu4j/U4GQMpA/uH+PHT9ObqH4c3
        /ifMCTOMsZOAoJluh2kAlCYa+QIjE9Jlssbw6yrsZiFNwdqn5cHqm8RNt6f4GoH3hPvEjk
        GOdslupORGgeUQ8/DjTm1kwISSSRba0=
Content-Disposition: inline
In-Reply-To: <3f042edb-3769-afea-17a7-899578cd5c69@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Mike Rapoport <rppt@kernel.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <guro@fb.com>, Rafael Aquini <aquini@redhat.com>

On Thu 03-02-22 14:03:58, Waiman Long wrote:
> On 2/3/22 07:46, Michal Hocko wrote:
> > On Wed 02-02-22 15:30:35, Waiman Long wrote:
> > [...]
> > > +#ifdef CONFIG_MEMCG
> > > +	unsigned long memcg_data;
> > > +	struct mem_cgroup *memcg;
> > > +	bool online;
> > > +	char name[80];
> > > +
> > > +	rcu_read_lock();
> > > +	memcg_data = READ_ONCE(page->memcg_data);
> > > +	if (!memcg_data)
> > > +		goto out_unlock;
> > > +
> > > +	if (memcg_data & MEMCG_DATA_OBJCGS)
> > > +		ret += scnprintf(kbuf + ret, count - ret,
> > > +				"Slab cache page\n");
> > > +
> > > +	memcg = page_memcg_check(page);
> > > +	if (!memcg)
> > > +		goto out_unlock;
> > > +
> > > +	online = (memcg->css.flags & CSS_ONLINE);
> > > +	cgroup_name(memcg->css.cgroup, name, sizeof(name));
> > Is there any specific reason to use another buffer allocated on the
> > stack? Also 80B seems too short to cover NAME_MAX.
> > 
> > Nothing else jumped at me.
> 
> I suppose we can print directly into kbuf with cgroup_name(), but using a
> separate buffer is easier to read and understand. 79 characters should be
> enough for most cgroup names. Some auto-generated names with some kind of
> embedded uuids may be longer than that, but the random sequence of hex
> digits that may be missing do not convey much information for identification
> purpose. We can always increase the buffer length later if it turns out to
> be an issue.

Cutting a name short sounds like a source of confusion and there doesn't
seem to be any good reason for that.
-- 
Michal Hocko
SUSE Labs
