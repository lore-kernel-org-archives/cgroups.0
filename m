From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct
 page
Date: Mon, 03 Nov 2014 11:42:35 -0500 (EST)
Message-ID: <20141103.114235.2147567115691592307.davem@davemloft.net>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
	<20141103080208.GA7052@js1304-P5Q-DELUXE>
	<20141103150942.GA32052@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141103150942.GA32052-HTCKtW7iVlxqnrmGgq4/JMIURNUf+fel@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date: Mon, 3 Nov 2014 10:09:42 -0500

> Please re-introduce this code when your new usecase is ready to be
> upstreamed.  There is little reason to burden an unrelated feature
> with a sizable chunk of dead code for a vague future user.

+1
