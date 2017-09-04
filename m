From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Mon, 4 Sep 2017 10:32:37 -0700
Message-ID: <CALvZod4TtA8myYSqCL87dDXfyk1qkYx+v-MO6nt-cA+bKTcGUA@mail.gmail.com>
References: <20170904142108.7165-1-guro@fb.com> <20170904142108.7165-6-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=a1EbU4b2Ehh1MrL4JXlWfz+/G147l9t9ct1wQbCDN7s=;
        b=YuEL18l86PtqPme537AVSvfK18wtSlPcK0+jTu4iJXPAeZ8GEAYEJV7SJOFSz2KehF
         pvGfjba6bas80PuV2zcsIWZYiOj6WGIPZMKqNv7hGdfJNDKn1Hu/EjzWZNaSOFjeDP4R
         LxUPbEUqOJENZDJQ6OpgkbdguX7Wk/y+0sAfrLFzfSKKCCs4O4NDvFIIfTUokogiHr/q
         hJaf9iBAj6gBmKDU3rF9ikBYqUQ0yUHc5Hecjiiz6Phcdhty2E/6Vg3EfPZY9/SvpNan
         tAAT5y4WWigfazEHpNY+H5i4FINgL7v9YzTvqtyFdhL2APy6tHlFKA29JND7hs0bCf1x
         tQqQ==
In-Reply-To: <20170904142108.7165-6-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Sep 4, 2017 at 7:21 AM, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> Introducing of cgroup-aware OOM killer changes the victim selection
> algorithm used by default: instead of picking the largest process,
> it will pick the largest memcg and then the largest process inside.
>
> This affects only cgroup v2 users.
>
> To provide a way to use cgroups v2 if the old OOM victim selection
> algorithm is preferred for some reason, the nogroupoom mount option
> is added.

Is this mount option or boot parameter? From the code, it seems like a
boot parameter.
