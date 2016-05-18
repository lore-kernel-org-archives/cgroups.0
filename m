From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix the return in mem_cgroup_margin
Date: Wed, 18 May 2016 15:39:07 +0800
Message-ID: <CAJFZqHw0HZ_H8Ax0TSn_Aor41DL4U9Yzx9+Oz342O6Y0nub8HQ@mail.gmail.com>
References: <1463556255-31892-1-git-send-email-roy.qing.li@gmail.com>
	<20160518073253.GC21654@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=P0c0MY5rj4HpNjLT9rhZfuNjxi1WcuVrn9cdqgA7dqw=;
        b=W1vUanRMudP20Zn79ydrVGDdzY/oOTUpLzIVtcxBlpX3/x2YnGhAYX+AbgnV4DqBnm
         KQjCUIpeuu1EqwxXhhPVlQP34KWowF5YroC+mVdrvS2ZxHF/7KYFR9JKugk+TXbO1ASU
         4xtkK3TSLyCObcSar8VO4211foiWx9/BVD+SMNcsy0KDRyeEREcHagcSuR9TuPUn4gbU
         ie5Ep08vzybWmoKJ57EZ3Z0ETMm+bMMxdBKvsfBtTiEu0o86ZeAZmOJtyWlIUh0kPSyE
         uJbc7Covzy6VNjsZ5/aLzWu6qemd7eD4zysB2kxdFWkZPtjuFKdAQXjThX6LfJQtQ3dG
         GaIA==
In-Reply-To: <20160518073253.GC21654-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

On Wed, May 18, 2016 at 3:32 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Or have you seen any real problem with this code path?


not;
I read the codes, think it is more reasonable to set margin to 0 here

-Roy
