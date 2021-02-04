From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 6/7] mm: memcontrol: switch to rstat
Date: Thu, 4 Feb 2021 15:05:53 -0500
Message-ID: <YBxToaRrlRUXfIod@cmpxchg.org>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-7-hannes@cmpxchg.org>
 <20210203014726.GE1812008@carbon.dhcp.thefacebook.com>
 <YBwgOHL8dTjJpnKU@cmpxchg.org>
 <20210204184520.GC1837780@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PNpabScqAJL/H2mjmh5glVW/nkx6cWA4Jun5NHUQOrM=;
        b=rpVczFjAy+Eo1fHw1BDYqgKj2CQrvpHaS52itpgYB9u+R9fd0OhJLGQIGcLuIThgmO
         1EtEXj/HZXv0cMrN3wwlbjmxFv0no8HWWMeBsQOOozyuyAktfcg83i2gOzL6ta27x3jZ
         fcYwOlWIODDKif1RHsWfYyVzyy7fGIJFXDzn99yB7VC74nQEq23Y/RURT9mndO8E2/ea
         lgGcPE4IFkvVV1lL135khk1YP8UB8EI2+F7IoJqlBqN4rYvkp8AZoq05eM+aOdE9R0tT
         IcJk3AlHMA4eXi43FufTKxW8GKY3BaUaqYy7gBV8GBlAwhvBG0lGamR6wHXHPGv6HXg6
         vkjw==
Content-Disposition: inline
In-Reply-To: <20210204184520.GC1837780-lLJQVQxiE4uLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Feb 04, 2021 at 10:45:20AM -0800, Roman Gushchin wrote:
> On Thu, Feb 04, 2021 at 11:26:32AM -0500, Johannes Weiner wrote:
> > On Tue, Feb 02, 2021 at 05:47:26PM -0800, Roman Gushchin wrote:
> > > On Tue, Feb 02, 2021 at 01:47:45PM -0500, Johannes Weiner wrote:
> > > >  	for_each_node(node) {
> > > >  		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
> > > > +		unsigned long stat[NR_VM_NODE_STAT_ITEMS] = {0, };
> > >                                                               ^^
> > > I'd drop the comma here. It seems that "{0}" version is way more popular
> > > over the mm code and in the kernel in general.
> > 
> > Is there a downside to the comma? I'm finding more { 0, } than { 0 }
> > in mm code, and at least kernel-wide it seems both are acceptable
> > (although { 0 } is more popular overall).
> 
> { 0 } is more obvious and saves a character.

The comma signals that the author is aware that the array or structure
has more elements than specified, and that they expect the rest to be
zeroed. We use it extensively to initialize structures (like struct
cgroup_subsys inits, cftypes, struct address_space_operations, etc.)

So I'd say "more obvious" is subjective. I find the comma version a
bit more obvious.

> The "problem" with comma version is that { 1, } and { 0, } have a
> different meaning.

...which is? They both mean set the first element to x and zerofill
the rest, no?

Again, I don't really care too much either way, I'm just wondering if
I'm missing something bigger here.
