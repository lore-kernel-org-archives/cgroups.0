From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix the return in mem_cgroup_margin
Date: Tue, 24 May 2016 11:07:16 +0800
Message-ID: <CAJFZqHzwqjzRriawoP92_v2VYxamCiVg2QjGpP7mmL1A1f9Cnw@mail.gmail.com>
References: <1463556255-31892-1-git-send-email-roy.qing.li@gmail.com>
	<20160518073253.GC21654@dhcp22.suse.cz>
	<CAJFZqHwFtZa-Ec_0bie6ORTrgoW1kqGsq49-=ojsT-uyNUBhwg@mail.gmail.com>
	<20160523103758.GB7917@esperanza>
	<20160523120620.GP2278@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=W521ztuZtxlt/+F0a0xgcyT27wwOy2yJmSm95uqtRuE=;
        b=R45Oovao4Pjyule5WraKSkbSqWH+jlnvrZXkDN8jLrhTKpJE6ZNkBlvtY0udqgO+jQ
         t4aDSICgZ8/t+Smmg0HU59rLfpNtHKUf1n2+NfeHNQ2IxtAxlHy+30K2f2YSDxbADrv1
         kJAjv90LaXD/ehq/65+6gWWnXvGoG47dUtliKLH7myGPzNLEtcpfcxOPsdpeGMCQwMz/
         cVKLbCDEMhCiDikqhvtkKMCFPFeHhUzAgJB9Sam15jTQLl76GwK0ul4HYxZ0LFgUp3Gq
         pYswno2KXMfWLRGeToLthdgzUQERFRT07NBtFYdKP1p2zboIAaXYMeP9XgJOWXJW0J75
         T1HA==
In-Reply-To: <20160523120620.GP2278-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, May 23, 2016 at 8:06 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Can we have updated patch with all this useful information in the
> changelog, please?


Ok, I will update this patch

-Roy
