From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 3/3] make 'none' field a flag
Date: Wed, 14 Dec 2011 10:09:40 +0800
Message-ID: <4EE80564.7030608@cn.fujitsu.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-5-git-send-email-glommer@parallels.com> <20111213154108.GF25802@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111213154108.GF25802-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

=E4=BA=8E 2011=E5=B9=B412=E6=9C=8813=E6=97=A5 23:41, Tejun Heo =E5=86=99=
=E9=81=93:
> On Sun, Dec 11, 2011 at 03:45:38PM +0100, Glauber Costa wrote:
>> There is no reason to have a flags field, and then a separate
>> bool field just to indicate if 'none' subsystem were explicitly
>> requested.
>>
>> Make it a flag
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>=20
> Same as the previous patch.  Doesn't this change how remount
> conditions are checked?
>=20

Right. The patch prevents us from doing:

	# mount -t cgroup -o none,name=3Dtmp xxx /mnt
	# mount -o remount,cpuset xxx /mnt
	(failed)
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
