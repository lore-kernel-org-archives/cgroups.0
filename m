From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 0/8] mm: memcg fixlets for 3.3
Date: Thu, 24 Nov 2011 11:39:39 +0530
Message-ID: <CAKTCnzk0Jzq+o1Qv9hOO5ssO7U_xe1ZqUaWDhWEeJAQQPjPudg@mail.gmail.com>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=9w9OueaOLDTvPHoeC8qtRC0dWz8hZ1cKVD3GrW67SjY=;
        b=e4nuHMRuSbY44so4IT5ppbLBI49ckrJdVJpqibKX95u0ZV9GxHh9MPaz0D6wtjsG6B
         hzB4FDBLkFFM5oZ6KdJPQWWXaIKR38tqB5+wX/KAVCL8QL1VIimAPIdTlx1QfH+3Aw58
         fqSMSTAKBbi0ah7H2GfwTf3n8qHArg5MWYrw0=
In-Reply-To: <1322062951-1756-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> w=
rote:
>
> Here are some minor memcg-related cleanups and optimizations, nothing
> too exciting. =A0The bulk of the diffstat comes from renaming the
> remaining variables to describe a (struct mem_cgroup *) to "memcg".
> The rest cuts down on the (un)charge fastpaths, as people start to ge=
t
> annoyed by those functions showing up in the profiles of their their
> non-memcg workloads. =A0More is to come, but I wanted to get the more
> obvious bits out of the way.

Hi, Johannes

The renaming was a separate patch sent from Raghavendra as well, not
sure if you've seen it. What tests are you using to test these
patches?

Balbir
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
