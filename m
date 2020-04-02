From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: Bypass high reclaim iteration for cgroup
 hierarchy root
Date: Thu, 2 Apr 2020 11:18:52 -0400
Message-ID: <20200402151852.GD2089@cmpxchg.org>
References: <20200312164137.GA1753625@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X4md8GfFb/AZLlmWivRcEwSCP4uBimc7oKbXY4Cuzbs=;
        b=L/SnQjBfnp5fEn4nBLMR6OIrZCUsqaFG32VM3D8P0P8Lj/uoYnjkRyEnuYvXsJsAKt
         c4igzrWSnvwBSj3E7mr0QbuhFJhboCmmv66EkfRKM8dykWur9UCs7QjwYmhFzRp4O+A4
         SnrLBfG8ir/Oio7mvh4OgFCEi2cahY9VIyMpFSkHRdm41lB0/v0GSq1mKWVd2TiCyBlN
         hI6cIgvd6bBViEDgjTfBgb3PQnim/I28LCR10Uk8FN4kj7u9VdBwqKzsszZNJndU/ap/
         B/jD43fEcMR1E7yUPLdB4B9rCGNhvxza6rn5dvPkZt/C61cv9D6z0rzi3GwPV+Lp5T9D
         VM4g==
Content-Disposition: inline
In-Reply-To: <20200312164137.GA1753625-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Mar 12, 2020 at 04:41:37PM +0000, Chris Down wrote:
> The root of the hierarchy cannot have high set, so we will never reclaim
> based on it. This makes that clearer and avoids another entry.
> 
> Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: kernel-team-b10kYP2dOMg@public.gmane.org

This makes sense, memory.high doesn't exist on the root.

And the mem_cgroup_is_root() check, a simple pointer comparison, is
cheaper than reading the page_counter atomic and memcg->high (which we
already know to be PAGE_COUNTER_MAX).

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
