From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 3/4] mm/page_owner: Print memcg information
Date: Thu, 3 Feb 2022 14:03:58 -0500
Message-ID: <3f042edb-3769-afea-17a7-899578cd5c69@redhat.com>
References: <20220131192308.608837-5-longman@redhat.com>
 <20220202203036.744010-4-longman@redhat.com>
 <YfvOp5VXrxy9IW1w@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643915059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8WFk5VazJGj78aF3vcRFOwWn7//j5v/p/zsICay1c+U=;
        b=QnmwVovOe8JgvKk//Z1TR+qKjK9KVJ14DqYScYfV5FSIL9ikrAvXBikxsH8kFiU0rmGaYa
        PvbWIrICYM1J9navU9T3ojLdQBi085agBt/BVVfhv0Z5RCcwDmMu9hcgYVnD83UT7vxlQq
        uwMhjmLM4Fxz6jbU8hkgz5UR5CXWTQw=
Content-Language: en-US
In-Reply-To: <YfvOp5VXrxy9IW1w-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2/3/22 07:46, Michal Hocko wrote:
> On Wed 02-02-22 15:30:35, Waiman Long wrote:
> [...]
>> +#ifdef CONFIG_MEMCG
>> +	unsigned long memcg_data;
>> +	struct mem_cgroup *memcg;
>> +	bool online;
>> +	char name[80];
>> +
>> +	rcu_read_lock();
>> +	memcg_data = READ_ONCE(page->memcg_data);
>> +	if (!memcg_data)
>> +		goto out_unlock;
>> +
>> +	if (memcg_data & MEMCG_DATA_OBJCGS)
>> +		ret += scnprintf(kbuf + ret, count - ret,
>> +				"Slab cache page\n");
>> +
>> +	memcg = page_memcg_check(page);
>> +	if (!memcg)
>> +		goto out_unlock;
>> +
>> +	online = (memcg->css.flags & CSS_ONLINE);
>> +	cgroup_name(memcg->css.cgroup, name, sizeof(name));
> Is there any specific reason to use another buffer allocated on the
> stack? Also 80B seems too short to cover NAME_MAX.
>
> Nothing else jumped at me.

I suppose we can print directly into kbuf with cgroup_name(), but using 
a separate buffer is easier to read and understand. 79 characters should 
be enough for most cgroup names. Some auto-generated names with some 
kind of embedded uuids may be longer than that, but the random sequence 
of hex digits that may be missing do not convey much information for 
identification purpose. We can always increase the buffer length later 
if it turns out to be an issue.

Cheers,
Longman

