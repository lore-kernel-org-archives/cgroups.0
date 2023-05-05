From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 3/3] cgroup: Do not take css_set_lock in
 cgroup_show_path
Date: Fri, 5 May 2023 08:17:10 -1000
Message-ID: <ZFVIJlAMyzTh3QTP@slm.duckdns.org>
References: <20230502133847.14570-1-mkoutny@suse.com>
 <20230502133847.14570-4-mkoutny@suse.com>
 <ZFUktg4Yxa30jRBX@slm.duckdns.org>
 <ta7bilcvc7lzt5tvs44y5wxqt6i3gdmvzwcr5h2vxhjhshmivk@3mecui76fxvy>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683310632; x=1685902632;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hQHYPlEOPVX2QdptzuBIqeiKD9YF9ynx2rWgtCguSI8=;
        b=GATLJaLXKGT4UkAZCszdVSnAxGdXekLCDA78/LXvLjMCrf0gMpGYAkPJRHrMm0efTx
         2AM0YfRkyInaP8G4IZNRe8myyYOaXG5+TuMqRchxZEwR9sTQCmwEF4avYnvLkXRb0lXu
         ZshUyzcCLOseMwGIi5mw2rXGsskJBuqqTZRnN6UkR7zZub+q9aiBuh3FpMqLNkZUP7KI
         BTdvqQlkE1CsXOaAfreOSuXojjPs3gqE52ZkWkmQuFz8wYaw1ctggUDUAoX3BGqn+nzM
         IFKIvUYSxV1GPI2RQJ0y+DCJy+DHy7Y/zHqZ2b9RsvjJufRA8dGuYr0hlB18YDukodzy
         N2XA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ta7bilcvc7lzt5tvs44y5wxqt6i3gdmvzwcr5h2vxhjhshmivk@3mecui76fxvy>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <dchinner@redhat.com>, Rik van Riel <riel@surriel.com>, Jiri Wiesner <jwiesner@suse.de>

Hello,

On Fri, May 05, 2023 at 07:32:40PM +0200, Michal Koutn=FD wrote:
> On Fri, May 05, 2023 at 05:45:58AM -1000, Tejun Heo <tj@kernel.org> wrote:
> > > There are three relevant nodes for each cgroupfs entry:
> > >=20
> > >         R ... cgroup hierarchy root
> > >         M ... mount root
> > >         C ... reader's cgroup NS root
> > >=20
> > > mountinfo is supposed to show path from C to M.
> >=20
> > At least for cgroup2, the path from C to M isn't gonna change once NS is
> > established, right?
>=20
> Right. Although, the argument about M (when C above M or when C and M in
> different subtrees) implicitly relies on the namespace_sem.

I don't follow. Can you please elaborate a bit more?

Thanks.

--=20
tejun
