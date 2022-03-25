From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce proportional protection on memcg
Date: Fri, 25 Mar 2022 13:49:59 +0100
Message-ID: <Yj26d7eQ2DHXqiE4@dhcp22.suse.cz>
References: <1648113743-32622-1-git-send-email-zhaoyang.huang@unisoc.com>
 <Yjx/3yi7BfH7wLPz@chrisdown.name>
 <CAGWkznGLO7xpQK7E07dLv7ZfO53nx2fn54tVNw7-b46QnzKwkA@mail.gmail.com>
 <CAGWkznGAmML4XB0t5jOZEoafQrFk=gXvP96Lmgh221Y22bUuyw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648212604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A9k72q4nGxTZAjXFEZ3O4X+oiukJzFsmhEYIKREvjY4=;
        b=Orc9+Oa8vO07QT9vWpudH/xLJRCJV4ACZ1UzXBWsZ075CvmEEv9RklCIYYfU8tpcvGlSfs
        wQrd7Gr3sORgQ9cdVHZLTMTm7X/EehcTpc8lkeim5gbrdGP7E7qK/Aw61CuJ3rh48/eMjY
        lopuxx+qN2k8ovkkWyPfVAHjtYQMadg=
Content-Disposition: inline
In-Reply-To: <CAGWkznGAmML4XB0t5jOZEoafQrFk=gXvP96Lmgh221Y22bUuyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ke wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 25-03-22 11:08:00, Zhaoyang Huang wrote:
> On Fri, Mar 25, 2022 at 11:02 AM Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Thu, Mar 24, 2022 at 10:27 PM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
> > >
> > > I'm confused by the aims of this patch. We already have proportional reclaim
> > > for memory.min and memory.low, and memory.high is already "proportional" by its
> > > nature to drive memory back down behind the configured threshold.
> > >
> > > Could you please be more clear about what you're trying to achieve and in what
> > > way the existing proportional reclaim mechanisms are insufficient for you?
> 
> sorry for the bad formatting of previous reply, resend it in new format
> 
>  What I am trying to solve is that, the memcg's protection judgment[1]
>  is based on a set of fixed value on current design, while the real
>  scan and reclaim number[2] is based on the proportional min/low on the
>  real memory usage which you mentioned above. Fixed value setting has
>  some constraints as
>  1. It is an experienced value based on observation, which could be inaccurate.
>  2. working load is various from scenarios.
>  3. fixed value from [1] could be against the dynamic cgroup_size in [2].

Could you elaborate some more about those points. I guess providing an
example how you are using the new interface instead would be helpful.
-- 
Michal Hocko
SUSE Labs
