From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix the return in mem_cgroup_margin
Date: Thu, 19 May 2016 09:44:53 +0800
Message-ID: <CAJFZqHwFtZa-Ec_0bie6ORTrgoW1kqGsq49-=ojsT-uyNUBhwg@mail.gmail.com>
References: <1463556255-31892-1-git-send-email-roy.qing.li@gmail.com>
	<20160518073253.GC21654@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=z7nwa+NME6zt7qOKA8UWSsDWjepG2XyguxIp1Xe+0R8=;
        b=hWIpMOUIoel4oF5pFSKYZXOo4USkHFiJnDcx54HtSunDbvUikCsKc4UX3ijIWn505n
         xojdopEzXP730BcR/1lqSPVULcnj5Lmny2Y0Seu+AEQlAbAhhPGQ6mirHBoO354ShpwM
         stMaYhfsI5EmdXBC07GV/q810VZeViuIJ8m1d1g1a66h06sP+S9AVQbAMuuAvLyopiIv
         HbrbsespyP3++PIn+8aDAvQch0UzErZXiySh4JQblVtFxJj1goIw2cdkkffS3jc0v0ZN
         AcFI8z+SKolp7V80JjlEciftM+hhqXS/D3+3APRH0e+k3yCgoZu5TotX6sS2IEKm0TjF
         0hHA==
In-Reply-To: <20160518073253.GC21654-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

On Wed, May 18, 2016 at 3:32 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> count should always be smaller than memsw.limit (this is a hard limit).
> Even if we have some temporary breach then the code should work as
> expected because margin is initialized to 0 and memsw.limit >= limit.

is it possible for this case? for example

memory count is 500, memory limit is 600; the margin is set to 100 firstly,
then check memory+swap limit, its count(1100) is bigger than its limit(1000),
then the margin 100 is returned wrongly.


-Roy
