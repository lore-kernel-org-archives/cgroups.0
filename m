From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3 5/5] mm/memcg: Protect memcg_stock with a local_lock_t
Date: Mon, 21 Feb 2022 18:25:12 +0100
Message-ID: <YhPK+Ht4I4MTFI+m@linutronix.de>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
 <20220217094802.3644569-6-bigeasy@linutronix.de>
 <YhOlxsLOOU/OVSzu@dhcp22.suse.cz>
 <YhOtmPQUcqZCKodH@linutronix.de>
 <YhO8yQrdVX04T8/n@dhcp22.suse.cz>
 <YhPBXUmIIHeXI/Gz@linutronix.de>
 <YhPJM4RjqklanVLE@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645464314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QNtNFdJSacVr39E6Cf/B3S4hi9OzOvHCrXZBSJUBNek=;
        b=job64lGFLs88tgOC58oUnEjLgmTTN/A9J2cmQ5n3f8mbEc1EDx5jPctWkm4a6GYNgpaesK
        q2f73rvblIG506aBx6r+RteEm500eFneFthRRXuneboc+NtM+DbzrViKnc/aRpTwoqVQFX
        3h93qN07kfg6iqj2bw7BDieWZy2VjChQp5/OlFZZ5DiQgUBHcOU4apyzZ0E9r8QCcfcp/v
        DRwo1t8PVH+WGk5TcPOYpXRPx8mi4CsfU3KobPXDQ8nS4/ARZwSj4Ogb7aG97Qx9ysrCYl
        c73RrA3JxZrUx2PWrpm0AyjE1uCIjgvnp6obFNDBmDOa/P0Zj4CX0ISHmGAepQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645464314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QNtNFdJSacVr39E6Cf/B3S4hi9OzOvHCrXZBSJUBNek=;
        b=kvY/S3SYQUccFr25pdL1pEqU7UlLkvE9bEmvzwN5lEqUVOSwODkgGYnINgGgTZCzfw9FtH
        9j6IFmyjlNHdBpAg==
Content-Disposition: inline
In-Reply-To: <YhPJM4RjqklanVLE-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On 2022-02-21 18:17:39 [+0100], Michal Hocko wrote:
> > What about if replace get_cpu() with migrate_disable()? 
> 
> Yeah, that would be a better option. I am just not used to think in RT
> so migrate_disable didn't really come to my mind.

Good.
Let me rebase accordingly, new version is coming soon.

Side note: migrate_disable() is by now implemented in !RT and used in
highmem for instance (kmap_atomic()).

Sebastian
