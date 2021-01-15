From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Remove unnecessary call to strstrip()
Date: Fri, 15 Jan 2021 15:31:48 -0500
Message-ID: <YAH7tIWhfolU6EzM@mtj.duckdns.org>
References: <20210103024846.GA15337@haolee.github.io>
 <YAA8qyBUAurgCeEz@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DZutw0Fwx8a+IIzb1YBWXpa8GKgVuQAFbe/fVJQB0Ps=;
        b=jVJdbkknWSYllAadoPc9Oy1txnskyomnVDMqBHvc2sZDhifPs0SUcyQf2fk9LvmiFo
         0orrMluvStZK49mX/Vn0roCZHVneqQt5UXix5BVwB1bdpUcmsO0pvx/9R4u5ACiL+xX8
         Cx99+k0xhFvAa6davOP6vhdJ07pKYsZ6raS7j4mb0gKnyQkN9WWXe4/3AidyzfSX+s1s
         fTRnLIu5nwcKx0vE3HZB6lyqH0kMIyFrTOoAb3Tb5kDJBy9VnTqKBj7+TL9mrfxZ5vr0
         v1u2xbqatdluGdM478vbBXnN6QhFnlPAKEbxVHXBhgJGxf7X3871nTvXe1n0frlSroRl
         iGeA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YAA8qyBUAurgCeEz@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 14, 2021 at 01:44:27PM +0100, Michal Koutn=FD wrote:
> Hello.
>=20
> On Sun, Jan 03, 2021 at 02:50:01AM +0000, Hao Lee <haolee.swjtu-Re5JQEeQq=
e8AvxtiuMwx3w@public.gmane.org> wrote:
> > The string buf will be stripped in cgroup_procs_write_start() before it
> > is converted to int, so remove this unnecessary call to strstrip().
> Good catch, Hao.
>=20
> Perhaps the code be then simplified a bit
>=20
> -- >8 --
> From: =3D?UTF-8?q?Michal=3D20Koutn=3DC3=3DBD?=3D <mkoutny-IBi9RG/b67k@pub=
lic.gmane.org>
> Date: Thu, 14 Jan 2021 13:23:39 +0100
> Subject: [PATCH] cgroup: cgroup.{procs,threads} factor out common parts
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> The functions cgroup_threads_start and cgroup_procs_start are almost
> identical. In order to reduce duplication, factor out the common code in
> similar fashion we already do for other threadgroup/task functions. No
> functional changes are intended.
>=20
> Suggested-by: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.o=
rg>
> Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

Applied to cgroup/for-5.12 w/ minor description update suggested by Daniel.

Thanks.

--=20
tejun
