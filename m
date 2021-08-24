From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix occasional OOMs due to proportional
 memory.low reclaim
Date: Tue, 24 Aug 2021 15:01:56 +0200
Message-ID: <20210824130156.GB7802@blackbody.suse.cz>
References: <20210817180506.220056-1-hannes@cmpxchg.org>
 <YSPIOZOVG2qplLIW@blackbook>
 <YSPfe4yf2fRdzijh@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629810118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gwH5bbr1n2NZef7C9Wwr43FBq6nYcyZU+iVjKru+rro=;
        b=Zphsll3UPQ8JZnXmkRt+VpNc5eh3bi0B29d1VWjPCEuibIhHnPN6iZfH5RD5r6ehB311i2
        1lmvIysI56YO3YycS2hsn4QTO6ylJyEAVYR38Q/Cqi/qREqfvIwCBG2ypjRSJukQz24vLT
        8Lwj7blexzosNMuZrwtcRpBAxnDHAFk=
Content-Disposition: inline
In-Reply-To: <YSPfe4yf2fRdzijh-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Aug 23, 2021 at 01:48:43PM -0400, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> Note that this isn't new behavior.

Understood, there may be a difference between:
a) a cgroup where the protected reserve was detected (this changed),
b) a cgroup where the protected memory is reclaimed.

> "The number of times the cgroup's memory.low-protected memory was
> reclaimed in order to avoid OOM during high memory pressure."

Yes, this is what I meant (i.e. events for the case b) above).

Michal
