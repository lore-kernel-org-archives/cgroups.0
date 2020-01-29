From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/2] cgroup: seq_file .next functions should increase
 position index
Date: Wed, 29 Jan 2020 13:39:39 +0300
Message-ID: <6d044e01-9794-fe22-ac74-fd01b024a5f1@virtuozzo.com>
References: <195bf4c6-2246-b816-f18f-110b156a9341@virtuozzo.com>
 <20200128172737.GA21791@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200128172737.GA21791-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 1/28/20 8:27 PM, Michal Koutn=C3=BD wrote:
> I agree with your changes, however, I have some suggestions:
>=20
> 1) squash [PATCH 2/2] "cgroup_procs_next should increase position index"
>    and [PATCH] "__cgroup_procs_start cleanup"
>    - make it clear in the commit message that it's fixing the small
>      buffer listing, it's not a mere cleanup(!)
> 2) for completeness, I propose squashing also this change (IOW,
>    cgroup_procs_start should only initialize the iterator, not move it):

got it

> 3) I was not able to reproduce the corrupted listing into small buffer
>    on v1 hierarchy, i.e. the [PATCH 1/2] "cgroup_pidlist_next should upda=
te
>    position index" log message should just explain the change is to
>    satisfy seq_file iterator requirements.

[root@localhost ~]# uname -a
Linux localhost.localdomain 5.4.7-200.fc31.x86_64 #1 SMP Tue Dec 31 22:25:1=
2 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
[root@localhost ~]# mount | grep cgroup
cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,sec=
label,nsdelegate)
cgroup on /mnt type cgroup (rw,relatime,seclabel,cpu)

[root@localhost ~]# dd if=3D/mnt/cgroup.procs bs=3D1  # normal output
...
1294
1295
1296
1304
1382
584+0 records in
584+0 records out
584 bytes copied, 0.00281916 s, 207 kB/s

[root@localhost ~]# dd if=3D/mnt/cgroup.procs bs=3D581 skip=3D1  # read aft=
er lseek in middle of last line
dd: /mnt/cgroup.procs: cannot skip to specified offset
83  <<< generates end of last line
1383  <<< ... and whole last line once again
0+1 records in
0+1 records out
8 bytes copied, 0.000171759 s, 46.6 kB/s

[root@localhost ~]# dd if=3D/mnt/cgroup.procs bs=3D1000 skip=3D1  # read af=
ter lseek beyond end of file
dd: /mnt/cgroup.procs: cannot skip to specified offset
1386  <<< generates last line anyway
0+1 records in
0+1 records out
5 bytes copied, 0.000198117 s, 25.2 kB/s

   =20
> I can send my complete diffs if the suggestions are unclear.
>=20
> Michal
>=20
> P.S. I really recommend using `git send-email` for sending out the
> patches, it makes mail threading more readable.

thank you, will resent v2=20
   Vasily Averin
