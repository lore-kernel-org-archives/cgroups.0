From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: Regression from 5.7.17 to 5.9.9 with memory.low cgroup
 constraints
Date: Wed, 25 Nov 2020 14:37:40 +0100
Message-ID: <20201125133740.GE31550@dhcp22.suse.cz>
References: <20201125123956.61d9e16a@hemera>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1606311461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1g24Rgp6aqa6Ka3pxmGa5G0dKc6hKcPeknu8BPGfcI4=;
        b=KRSsdr+NVduHNlWpHMcDky+6b+1SginL8vAJp2N/Syqhw+rPnjhccnUhw2OXVNSc7mt9nj
        GrNUI1h/tfiB0lpQjhRgGBhZZbEQjaAfXwHG7o+Oc9Bkb48GbOmjjD9qK6ix095ZgeYA9F
        IvWKwuwQHAcFIfsj47r3r1NCkeJOghQ=
Content-Disposition: inline
In-Reply-To: <20201125123956.61d9e16a@hemera>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi,
thanks for the detailed report.

On Wed 25-11-20 12:39:56, Bruno Pr=E9mont wrote:
[...]
> Did memory.low meaning change between 5.7 and 5.9?

The latest semantic change in the low limit protection semantic was
introduced in 5.7 (recursive protection) but it requires an explicit
enablinig.

> From behavior it
> feels as if inodes are not accounted to cgroup at all and kernel pushes
> cgroups down to their memory.low by killing file cache if there is not
> enough free memory to hold all promises (and not only when a cgroup
> tries to use up to its promised amount of memory).

Your counters indeed show that the low protection has been breached,
most likely because the reclaim couldn't make any progress. Considering
that this is the case for all/most of your cgroups it suggests that the
memory pressure was global rather than limit imposed. In fact even top
level cgroups got reclaimed below the low limit.

This suggests that this is not likely to be memcg specific. It is
more likely that this is a general memory reclaim regression for your
workload. There were larger changes in that area. Be it lru balancing
based on cost model by Johannes or working set tracking for anonymous
pages by Joonsoo. Maybe even more. Both of them can influence page cache
reclaim but you are suggesting that slab accounted memory is not
reclaimed properly. I am not sure sure there were considerable changes
there. Would it be possible to collect /prov/vmstat as well?

--=20
Michal Hocko
SUSE Labs
