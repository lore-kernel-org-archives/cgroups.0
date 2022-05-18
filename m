From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm/mempolicy: fix uninit-value in mpol_rebind_policy()
Date: Tue, 17 May 2022 17:08:17 -0700
Message-ID: <20220517170817.94ca21558bbe035ae06bf6fa@linux-foundation.org>
References: <20220512123428.fq3wofedp6oiotd4@ppc.localdomain>
        <20220516094726.b5rrsjg7rvei2od5@ppc.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652832498;
        bh=dGo2DK/jcDFeW9OzAZX7pYd8dKE594MPgxl0d5vf08o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PuAzQ1xUkMYyjYcicOstd9P9trgynYqqBU+B/c2c5XLaLyMpG8ZFb7oTGcEHuLm28
         PoiyLQqVLCv4fnNH7dDRn/aAktE47o9fUzo2OtiJyKNlMCgfG01RkCwloZu+jdbZ8T
         kAcGMpVpaQVVKEem6L1nUmerTDe80ZYkF+mRm8Rw=
In-Reply-To: <20220516094726.b5rrsjg7rvei2od5-EN706goElQQmYvmMESoHnA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wang Cheng <wanngchenng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, syzbot+ad1b8c404f0959c4bfcc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

On Mon, 16 May 2022 17:47:26 +0800 Wang Cheng <wanngchenng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 
> ...
>
> This patch seems to fix below bug too.
> KMSAN: uninit-value in mpol_rebind_mm (2)
> https://syzkaller.appspot.com/bug?id=f2fecd0d7013f54ec4162f60743a2b28df40926b
> 
> The uninit-value is pol->w.cpuset_mems_allowed in mpol_rebind_policy().
> When syzkaller reproducer runs to the beginning of mpol_new(),
> 
> 	    mpol_new() mm/mempolicy.c
> 	  do_mbind() mm/mempolicy.c
> 	kernel_mbind() mm/mempolicy.c
> 
> `mode` is 1(MPOL_PREFERRED), nodes_empty(*nodes) is `true` and `flags`
> is 0. Then
> 
> 	mode = MPOL_LOCAL;
> 	...
> 	policy->mode = mode;
> 	policy->flags = flags;
> 
> will be executed. So in mpol_set_nodemask(),
> 
> 	    mpol_set_nodemask() mm/mempolicy.c
> 	  do_mbind()
> 	kernel_mbind()
> 
> pol->mode is 4(MPOL_LOCAL), that `nodemask` in `pol` is not initialized,
> which will be accessed in mpol_rebind_policy().

Thanks, I added the above to the changelog and I plan to import the
result into mm-stable later this week.

> IIUC, "#syz fix: mm/mempolicy: fix uninit-value in mpol_rebind_policy()"
> could be sent to syzbot+ad1b8c404f0959c4bfcc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> to attach the fixing commit to the bug. WDYT?

Could be.  The "syz fix" isn't a thing I've paid much attention to. 
I'll start doing so ;)

