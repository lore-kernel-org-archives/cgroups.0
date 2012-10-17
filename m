From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
Date: Wed, 17 Oct 2012 15:26:26 +0800
Message-ID: <507E5DA2.7080902@huawei.com>
References: <20121008020000.GB2575@localhost> <20121008020138.GA4188@localhost> <507268AA.8050509@huawei.com> <20121008065752.GA5931@localhost> <20121016193428.GE16166@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121016193428.GE16166-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

=E4=BA=8E 2012/10/17 3:34, Tejun Heo =E5=86=99=E9=81=93:
> On Mon, Oct 08, 2012 at 03:57:52PM +0900, Tejun Heo wrote:
>> Hello, Li, Frederic.
>>
>> On Mon, Oct 08, 2012 at 01:46:18PM +0800, Li Zefan wrote:
>>> You're right. threadgroup lock is held unconditionally in attach_ta=
sk_py_pid(),
>>> but it's held only for CLONE_THREAD in fork path, which I guess I o=
verlooked
>>> when reviewing the patch.
>>>
>>>> Also, please note that task_lock is likely to be hot on local CPU =
at
>>>> that point and avoiding it there might not really buy much.
>>>
>>> Reverting that commit should be fine.
>>
>> There are other commits which perform similar optimization
>>
>>  7e3aa30ac8 ("cgroup: Remove task_lock() from cgroup_post_fork()")
>>  c84cdf75cc ("cgroup: Remove unnecessary task_lock before fetching c=
ss_set on migration")
>>
>> Are they wrong too?
>=20
> Frederic, Li, Ping?
>=20

Yes, they're wrong. I sugguest we revert those commits, and then fix cg=
roup_attach_task_all()
and others if still any.
