From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix occasional OOMs due to proportional
 memory.low reclaim
Date: Tue, 17 Aug 2021 12:45:18 -0700
Message-ID: <YRwRzjOexeXbkirV@carbon.dhcp.thefacebook.com>
References: <20210817180506.220056-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=u0SQVVB/trLb/pW3zgaBGvbhvPEFJ/S9wGtYDmX4jRA=;
 b=HV5DcxG7VxrnM1IWeIk02uhU9+HdjCA2KAEyZsdn22Zhi3LToIvrWP5VzlGxMUfCKXyE
 8v2m4NfSDrLnSZv+UkVOcP+QvLXvBX8XDg7NSg33wgI7Gw+M4NHmKFOXBQChdq0h3Rgc
 rpGX87zv6mmYbnNAMvdmV8fbgmq5pr6Kt7U= 
Content-Disposition: inline
In-Reply-To: <20210817180506.220056-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Aug 17, 2021 at 02:05:06PM -0400, Johannes Weiner wrote:
> We've noticed occasional OOM killing when memory.low settings are in
> effect for cgroups. This is unexpected and undesirable as memory.low
> is supposed to express non-OOMing memory priorities between cgroups.
> 
> The reason for this is proportional memory.low reclaim. When cgroups
> are below their memory.low threshold, reclaim passes them over in the
> first round, and then retries if it couldn't find pages anywhere else.
> But when cgroups are slighly above their memory.low setting, page scan
> force is scaled down and diminished in proportion to the overage, to
> the point where it can cause reclaim to fail as well - only in that
> case we currently don't retry, and instead trigger OOM.
> 
> To fix this, hook proportional reclaim into the same retry logic we
> have in place for when cgroups are skipped entirely. This way if
> reclaim fails and some cgroups were scanned with dimished pressure,
> we'll try another full-force cycle before giving up and OOMing.
> 
> Reported-by: Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

I guess it's a stable material, so maybe adding:
Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")

?


Thanks!
