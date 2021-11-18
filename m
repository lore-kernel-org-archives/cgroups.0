From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 2/4] mm/oom: handle remote ooms
Date: Thu, 18 Nov 2021 09:47:47 +0100
Message-ID: <YZYTMxjItztiTyld@dhcp22.suse.cz>
References: <YY4dHPu/bcVdoJ4R@dhcp22.suse.cz>
 <CAHS8izNMTcctY7NLL9+qQN8+WVztJod2TfBHp85NqOCvHsjFwQ@mail.gmail.com>
 <YY4nm9Kvkt2FJPph@dhcp22.suse.cz>
 <CAHS8izMjfwgiNEoJWGSub6iqgPKyyoMZK5ONrMV2=MeMJsM5sg@mail.gmail.com>
 <YZI9ZbRVdRtE2m70@dhcp22.suse.cz>
 <CAHS8izPcnwOqf8bjfrEd9VFxdA6yX3+a-TeHsxGgpAR+_bRdNA@mail.gmail.com>
 <YZN5tkhHomj6HSb2@dhcp22.suse.cz>
 <CAHS8izNTbvhjEEb=ZrH2_4ECkVhxnCLzyd=78uWmHA_02iiA9Q@mail.gmail.com>
 <YZOWD8hP2WpqyXvI@dhcp22.suse.cz>
 <CAHS8izPyCDucFBa9ZKz09g3QVqSWLmAyOmwN+vr=X2y7yZjRQA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637225269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iVpxbvqJVQzGe+qqFvlCjjmqBPnBIHY2kdyMMjv1vGs=;
        b=Y/D/oT03gnHxiHxvFiKgyaMMnwYDDxYEue+ZRaR8LqaCuE+sMOwCLLHTIWJyJO6X1/K+ze
        Bzn/NRVOQCTZHyurUKyki6nk39IOOUvKeAao0LQFCKVZwNO5dp/LRm+VrDyuaN2lGj9Rg9
        J7usjyCezBX3RYKInimignX0+Df3cTg=
Content-Disposition: inline
In-Reply-To: <CAHS8izPyCDucFBa9ZKz09g3QVqSWLmAyOmwN+vr=X2y7yZjRQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 16-11-21 13:27:34, Mina Almasry wrote:
> On Tue, Nov 16, 2021 at 3:29 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
[...]
> > Can you elaborate some more? How do you enforce that the mount point
> > cannot be accessed by anybody outside of that constraint?
> 
> So if I'm a bad actor that wants to intentionally DoS random memcgs on
> the system I can:
> 
> mount -t tmpfs -o memcg=/sys/fs/cgroup/unified/memcg-to-dos tmpfs /mnt/tmpfs
> cat /dev/random > /mnt/tmpfs

If you can mount tmpfs then you do not need to fiddle with memcgs at
all. You just DoS the whole machine. That is not what I was asking
though.

My question was more towards a difference scenario. How do you
prevent random processes to _write_ to those mount points? User/group
permissions might be just too coarse to describe memcg relation. Without
memcg in place somebody could cause ENOSPC to the mount point users
and that is not great either but that should be recoverable to some
degree. With memcg configuration this would cause the memcg OOM which
would be harder to recover from because it affects all memcg charges in
that cgroup - not just that specific fs access. See what I mean? This is
a completely new failure mode. 

The only reasonable way would be to reduce the visibility of that mount
point. This is certainly possible but it seems rather awkward when it
should be accessible from multiple resource domains.

I cannot really shake off feeling that this is potentially adding more
problems than it solves.
-- 
Michal Hocko
SUSE Labs
