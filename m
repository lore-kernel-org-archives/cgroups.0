From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 cgroup/for-3.15-fixes 1/2] cgroup: introduce task_css_is_root()
Date: Thu, 8 May 2014 09:22:29 +0800
Message-ID: <536ADC55.6080105@huawei.com>
References: <20140505223557.GU11231@htj.dyndns.org> <20140507130627.GA16702@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140507130627.GA16702-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

=E4=BA=8E 2014/5/7 21:06, Tejun Heo =E5=86=99=E9=81=93:
> Determining the css of a task usually requires RCU read lock as that'=
s
> the only thing which keeps the returned css accessible till its
> reference is acquired; however, testing whether a task belongs to the
> root can be performed without dereferencing the returned css by
> comparing the returned pointer against the root one in init_css_set[]
> which never changes.
>=20
> Implement task_css_is_root() which can be invoked in any context.
> This will be used by the scheduled cgroup_freezer change.
>=20
> v2: cgroup no longer supports modular controllers.  No need to export
>     init_css_set.  Pointed out by Li.
>=20
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
