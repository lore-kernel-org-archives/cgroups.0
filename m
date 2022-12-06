From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: speedup memory cgroup resize
Date: Tue, 6 Dec 2022 11:33:12 +0100
Message-ID: <Y48aaCkgonOlMwNu@dhcp22.suse.cz>
References: <1670240992-28563-1-git-send-email-lirongqing@baidu.com>
 <CALvZod7_1oq1D73EKJHG1zQpeUp+QTPHmMRsL3Ka0f6XUfO4Eg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670322793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sXtB0LJ1gZ5Q2aHoxbN5D+rA1BRGWLH2LRyfAy0cNtA=;
        b=dMNGtYEU6bdKskTmQkpt4FcDRN92UcqQjVVtK9/Njg6YZcuhQ+6Hth69Qy2QWb6OjdEWXT
        r9M9rpzPKXzw3R5xaI5oSFSnd2bJKb/MkktHhJOec2h9PlWH/SejxdQyOXcdWRB6HLWHWa
        hVn+9lcsEhdTy/Y0D2XAsxyz9mYV+f0=
Content-Disposition: inline
In-Reply-To: <CALvZod7_1oq1D73EKJHG1zQpeUp+QTPHmMRsL3Ka0f6XUfO4Eg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Mon 05-12-22 08:32:41, Shakeel Butt wrote:
> On Mon, Dec 5, 2022 at 3:49 AM <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org> wrote:
> >
> > From: Li RongQing <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
> >
> > when resize memory cgroup, avoid to free memory cgroup page
> > one by one, and try to free needed number pages once
> >
> 
> It's not really one by one but SWAP_CLUSTER_MAX. Also can you share
> some experiment results on how much this patch is improving setting
> limits?

Besides a clear performance gain you should also think about a potential
over reclaim when the limit is reduced by a lot (there might be parallel
reclaimers competing with the limit resize).

-- 
Michal Hocko
SUSE Labs
