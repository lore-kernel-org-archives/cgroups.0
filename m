From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH memcg] mm/page_alloc.c: avoid statistic update with 0
Date: Tue, 12 Oct 2021 13:02:01 +0100
Message-ID: <YWV5OY5I0MhTtsn1@chrisdown.name>
References: <b2371951-bb8a-e62e-8d33-10830bbf6275@virtuozzo.com>
 <29155011-f884-b0e5-218e-911039568acb@suse.cz>
 <f52c5cd3-9b74-0fd5-2b7b-83ca21c52b2a@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jAcPXDzhn5XqOaTwDcEtw2GqEA7kUJwUT0gZY1JmW2E=;
        b=DPbfSiPVobJV2Q4NaUz4Zx8nPPKhVu6lJzZlNHK5+NGhnm7VVxJM15ZtYtoouecq+T
         I2rMiguacPD+JNJXmaQYRwqmIh90Lz06EG2Go8VBTHdd2K2Co3HcWaaBp2EMy/kY7cEy
         f1i0P0hEAeI6wW+/WCP3FKhW8YU873ZrRuk5s=
Content-Disposition: inline
In-Reply-To: <f52c5cd3-9b74-0fd5-2b7b-83ca21c52b2a-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Vasily Averin writes:
>Yes, it's not a bug, it just makes the kernel a bit more efficient in a very unlikely case.
>However, it looks strange and makes uninformed code reviewers like me worry about possible
>problems inside the affected functions. No one else calls these functions from 0.

This statement is meaningless without data. If you have proof that it makes the 
kernel more efficient, then please provide the profiles.

As it is I'd be surprised if this improved things. Either the code is hot 
enough that the additional branch is cumbersome, or it's cold enough that it 
doesn't even matter.
