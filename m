From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3 cgroup/for-5.20] cgroup: Add "no" prefixed mount
 options
Date: Tue, 26 Jul 2022 10:01:04 -1000
Message-ID: <YuBIACfZDk72yjI3@slm.duckdns.org>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <20220726143246.GA23794@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yv3KulA6SXC2d8qM1b4VH3vnSrCIQuVcceAGzMpyLq8=;
        b=WbRPhU62l5iVyr4AcFYCotiJR0a3zh4yuvzp5Pd70CDeFQKGfrxYJbWXPGYF6U77pc
         h5Xmz9Dx5kcvff7vnNyIjlyxmGcdBUEi/f/SeyWO3qqTx+jnReUp57Sg5fkReqxh+3Q+
         sUUp3ZGpYVjB27BiFwPry4pwxt2+Jdo28gB3WuTk0BYAtVge24qHNPNGAPZeKZZNuOez
         xorfG80VYE2snEUfiEvGCLZHBc20QLBe0gjtW3e7PuYRDH9f62HUnO2qsNdTIYT8igpI
         2BvIX5HHGwgInkdtHjsrpWV+HMu4nzq3YnxNOarw1Mbmh9sBvPPd2gr54eaPXvm5qXCR
         tPtg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220726143246.GA23794-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Jul 26, 2022 at 04:32:46PM +0200, Michal Koutn=FD wrote:
> On Thu, Jul 14, 2022 at 06:38:43PM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yR=
OfE0A@public.gmane.org> wrote:
> > We allow modifying these mount options via remount. Let's add "no" pref=
ixed
> > variants so that they can be turned off too.
>=20
> They can be turned off:
>=20
> > // on v5.19-rc?
> > :~ # grep cg /proc/mounts
> > cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelega=
te 0 0
> > :~ # mount -t cgroup2 cgroup2 /sys/fs/cgroup/ -oremount
> > :~ # grep cg /proc/mounts
> > cgroup2 /sys/fs/cgroup cgroup2 rw,relatime 0 0
>=20
> The mount(2) says about remounting:
> > The  mountflags  and  data  arguments should match the values used in
> > the original mount() call, except for those parameters that are being
> > deliberately changed.
>
> Or is this a provision for the fsconfig(2) API?

It's just me not knowing how these things work. I just looked at other real
filesystems and copied.

> > +	fsparam_flag("memory_nolocalevents",	Opt_memory_nolocalevents),
> > +	fsparam_flag("memory_norecursiveprot",	Opt_memory_norecursiveprot),
>=20
> These are not 'no' prefixes of the option :-)

Oh, I tried that first but nomemory_recursiveprot looked really weird. The
thing is that the underbar is added to separate the subsystem from the
actual option and we're now prepending no to the subsystem part of the name.
I'm not super attached to the current names tho.

> I.e. it seem more consistent to prefix whole boolean option name (in
> accordance with other FS options but I know limited subset of them).
> In the end, this should be handled generically for boolean options in
> the VFS and not via custom options.
>=20
> Also, this allows both
> 	'nsdelegate,nonsdelegate'
> and
> 	'nonsdelegate,nsdelegate'
> (nsdelegate is just an example) where the 'no' always overrides being a
> hidden implementation detail.
>=20
> I find this patch a bit weird.

It is a bit weird. Lemme play a bit with turning off the options and I'll
remove the no options if they can be turned off without explicitly
specifying them.

Thanks.

--=20
tejun
