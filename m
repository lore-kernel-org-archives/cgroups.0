From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 3/4] mm/page_owner: Print memcg information
Date: Tue, 8 Feb 2022 16:15:05 +0100
Message-ID: <YgKI+Y1/AKgJbpem@dhcp22.suse.cz>
References: <20220208000532.1054311-1-longman@redhat.com>
 <20220208000532.1054311-4-longman@redhat.com>
 <YgJeWth50eP9L0PK@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644333306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iIBn4Rav1LBR3y1c5hDMynQtqqgJZkX7I4kc9wq3uRs=;
        b=GsdnHU3cwdGn8OVGCJqWUbt20HF/QLQRsCFXZSmYmHY+SdULFqDf9IupBsQHpwsFqVyVQN
        Gf+fXxoyvKtpXIKaNdc14frKvMo3qSkwkkXPgfEDDToghZmni984WZ8/2vUDKVj61efMNJ
        iq6cAZzQVWGnl0xMx12l/0sRp5UgpnA=
Content-Disposition: inline
In-Reply-To: <YgJeWth50eP9L0PK-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

On Tue 08-02-22 13:13:15, Michal Hocko wrote:
> On Mon 07-02-22 19:05:31, Waiman Long wrote:
[...]
> > +	ret += scnprintf(kbuf + ret, count - ret, "\n");
> 
> I do not see any overflow prevention here. I believe you really need to
> check ret >= count after each scnprintf/cgroup_name.

OK, I have only now realized that scnprintf would return size - 1 on
overflow so explicitly checking for the overlow shouldn't be reallu
necessary.
-- 
Michal Hocko
SUSE Labs
