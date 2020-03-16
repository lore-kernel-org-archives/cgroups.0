From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/2] mm, memcg: Fix corruption on 64-bit divisor in
 memory.high throttling
Date: Mon, 16 Mar 2020 12:19:07 -0400
Message-ID: <20200316161907.GE67986@cmpxchg.org>
References: <80780887060514967d414b3cd91f9a316a16ab98.1584036142.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FGmHo0X0ug88xLxL5VEMvKfeQgO1Bzc/6oEObLpalt0=;
        b=SHgvwS9ZQXVqWJj5Zg/whvmP0uVvCvk7nB+wXhoy06AICUCarPw4d95BS7CJvG67UU
         NX8wP9DEQJ0mgCrwGOWKtNK59MMqvFI00+RHuh0T+yO1RTHxBEtxCbEK2FT8r+V2tB9h
         Mk1bzFa1SvwjUcS6Q7GSk61qqUhraymSLxN7La1EGmsw+Qxumbbns6Wb1kYMHPlLtkxe
         9JEk6yL6bHZszcytqNRZZSfQAp498YTvNeyQjFBVRM6Ckt1osk3zGZvEMoaGp9qkKZvP
         0ILeErzkPHYfFxCPj9zcFZL6pVv34cuxBMBtFOMl/RegHfvHd5bpoXm8eLeqMpNhP21R
         C0Uw==
Content-Disposition: inline
In-Reply-To: <80780887060514967d414b3cd91f9a316a16ab98.1584036142.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Mar 12, 2020 at 06:02:54PM +0000, Chris Down wrote:
> 0e4b01df8659 had a bunch of fixups to use the right division method.
> However, it seems that after all that it still wasn't right -- div_u64
> takes a 32-bit divisor.
> 
> The headroom is still large (2^32 pages), so on mundane systems you
> won't hit this, but this should definitely be fixed.
> 
> Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
> Reported-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: kernel-team-b10kYP2dOMg@public.gmane.org
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.4.x

div_u64 versus div64_u64 is really a handgrenade. We just fixed a
bunch of those in psi as well.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
