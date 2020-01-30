From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v2 0/2 RESEND] cgroup: seq_file .next functions should
 increase position index
Date: Thu, 30 Jan 2020 13:34:36 +0300
Message-ID: <91c15d7c-a831-e409-2fba-93ecfef5e85c@virtuozzo.com>
References: <20200128172737.GA21791@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200128172737.GA21791-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

v2 changes:
- improved patch description
- cgroupv2 patch includes fix for __cgroup_procs_start(), advised by Michal=
 Koutn=C3=BD

In Aug 2018 NeilBrown noticed=20
commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and i=
nterface")
"Some ->next functions do not increment *pos when they return NULL...
Note that such ->next functions are buggy and should be fixed.=20
A simple demonstration is
  =20
dd if=3D/proc/swaps bs=3D1000 skip=3D1
   =20
Choose any block size larger than the size of /proc/swaps.  This will
always show the whole last line of /proc/swaps"

Described problem is still actual. If you make lseek into middle of last ou=
tput line=20
following read will output end of last line and whole last line once again.

$ dd if=3D/proc/swaps bs=3D1  # usual output
Filename				Type		Size	Used	Priority
/dev/dm-0                               partition	4194812	97536	-2
104+0 records in
104+0 records out
104 bytes copied

$ dd if=3D/proc/swaps bs=3D40 skip=3D1    # last line was generated twice
dd: /proc/swaps: cannot skip to specified offset
v/dm-0                               partition	4194812	97536	-2
/dev/dm-0                               partition	4194812	97536	-2=20
3+1 records in
3+1 records out
131 bytes copied

There are lot of other affected files, I've found 30+ including
/proc/net/ip_tables_matches and /proc/sysvipc/*

This patch set fixes the problem in cgroup-related files

Vasily Averin (2):
  cgroup-v1: cgroup_pidlist_next should update position index
  cgroup: cgroup_procs_next should increase position index

 kernel/cgroup/cgroup-v1.c |  1 +
 kernel/cgroup/cgroup.c    | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

--=20
1.8.3.1

