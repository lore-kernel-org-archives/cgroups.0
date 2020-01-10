From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3 cgroup/for-5.2-fixes] cgroup: Include dying leaders
 with live threads in PROCS iterations
Date: Fri, 10 Jan 2020 14:15:53 -0800
Message-ID: <20200110221553.GD2677547@devbig004.ftw2.facebook.com>
References: <20190529003601.GN374014@devbig004.ftw2.facebook.com>
 <e45d974b-5eff-f781-291f-ddf5e9679e4c@gmail.com>
 <20190530183556.GR374014@devbig004.ftw2.facebook.com>
 <20190530183637.GS374014@devbig004.ftw2.facebook.com>
 <20190530183700.GT374014@devbig004.ftw2.facebook.com>
 <20190607170952.GE30727@blackbody.suse.cz>
 <20190611185742.GH3341036@devbig004.ftw2.facebook.com>
 <CAJuCfpGkAsmp5B=fNz38fLE8pYaMCG=uLDSSBFByNOtWD20zVQ@mail.gmail.com>
 <20200110215648.GC2677547@devbig004.ftw2.facebook.com>
 <CAJuCfpHPRfV5KDM74JtDepdUJ2G+-3-A3XV+Fzr3Lkbj9nR-Cg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yXIVe2dTLc7Z63wJAa51lMa4i7IcmWqKH3GK/I4PfiA=;
        b=NhOpxDYQeVJJNEAquPQAe5JMywSLk/WrXx228nGhCAAj7I0pdgHEdLYEIFbpyBnBwk
         Sdw+g408KW3Q7oIl+smVnnPwx0ddixJXLiAyQMnPvLXy+yqKcQ09qXOcb85JHxnfF1WW
         vJctDD1q0qb398FOcN3Pb5fRNQF7YpujJgNPJBAelD3lWyVifUtyAAHF3UWuG6bBTuSH
         7J7gC8GAEXB6Nb6ddSUWg/ZKv2GreQshOqclrkgt05xyy6/P1IBzIteV4tQ6Mb4OL3eE
         IowUaH8J8qP9Fv+pnJr29ma29v9VArC6/0JJrNWsKCUz/cfXzz/m6NkkZLCdlgDlTPiq
         zo8A==
Content-Disposition: inline
In-Reply-To: <CAJuCfpHPRfV5KDM74JtDepdUJ2G+-3-A3XV+Fzr3Lkbj9nR-Cg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, security-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org, Security Officers <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, james.hsu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linger.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Tom Cherry <tomcherry-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Fri, Jan 10, 2020 at 02:14:19PM -0800, Suren Baghdasaryan wrote:
> > Yeah, the current behavior isn't quite consistent with the
> > documentation and what we prolly wanna do is allowing destroying a
> > cgroup with only dead processes in it.  That said, the correct (or at
> > least workable) signal which indicates that a cgroup is ready for
> > removal is cgroup.events::populated being zero, which is a poll(2)able
> > event.
> 
> Unfortunately it would not be workable for us as it's only available
> for cgroup v2 controllers.
> I can think of other ways to fix it in the userspace but there might
> be other cgroup API users which are be broken after this change. I
> would prefer to fix it in the kernel if at all possible rather than
> chasing all possible users.

Yeah, the right thing to do is allowing destruction of cgroups w/ only
dead processes in it.

-- 
tejun
