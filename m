From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Remove unnecessary call to strstrip()
Date: Thu, 14 Jan 2021 12:35:02 -0500
Message-ID: <87pn27v2ux.fsf@oracle.com>
References: <20210103024846.GA15337@haolee.github.io>
 <YAA8qyBUAurgCeEz@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=c+LBoDh/DLOh8njoOTcgBp+JfS0k3t69g3Yr58Vbk9M=;
 b=L8l12Bm39XlQmb0LlpmpPgOlqUr3qL2detwnM4HdHuRMlzWNMDVw2hfmrp2vNeCj/BfN
 dF8qxNGrV8mzTf3i8ge0MXKqmQ2xsPONp6Ksb+KZNDYNVEH2IudER86puQyRgSXgTqXo
 vvJ4SiFDYVbUJm0nCrb2I9K/1LKzPflEtLCxyck0vt+KKGLXA5/su1vWfj8T7nNJW+xz
 SAxDzoEvYDgihbyPi8lXYPn0dxijwsZVLgYGp5CHTwKQxsnL+mK2SE8qXOY/CXeZdEzJ
 b/9/oqBocu/fnc0YFUl2d7u+2mzpzBG1YqtJS4357RbU293HQJ/z5BTguURH2SijsxY9 TA== 
In-Reply-To: <YAA8qyBUAurgCeEz@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Michal,

Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> writes:
> On Sun, Jan 03, 2021 at 02:50:01AM +0000, Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
>> The string buf will be stripped in cgroup_procs_write_start() before it
>> is converted to int, so remove this unnecessary call to strstrip().
> Good catch, Hao.
>
> Perhaps the code be then simplified a bit
>
> -- >8 --
> From: =3D?UTF-8?q?Michal=3D20Koutn=3DC3=3DBD?=3D <mkoutny-IBi9RG/b67k@public.gmane.org>
> Date: Thu, 14 Jan 2021 13:23:39 +0100
> Subject: [PATCH] cgroup: cgroup.{procs,threads} factor out common parts
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> The functions cgroup_threads_start and cgroup_procs_start are almost

You meant cgroup_threads_write and cgroup_procs_write.

>  kernel/cgroup/cgroup.c | 55 +++++++++++-------------------------------
>  1 file changed, 14 insertions(+), 41 deletions(-)

Ok, sure, that's a good thing.

Reviewed-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
