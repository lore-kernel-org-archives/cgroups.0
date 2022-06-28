From: "taoyi.ty" <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Question about disallowing rename(2) in cgroup v2
Date: Tue, 28 Jun 2022 21:09:48 +0800
Message-ID: <1c9d5118-25fa-e791-8aed-b1430cf23d36@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

hi all,

I found that rename(2) can be used in cgroup v1 but is disallowed in=20
cgroup v2, what's the reason for this design?

rename(2) is critical when managing a cgroup pool in userspace, which=20
uses rename to reuse cgroup rather than mkdir to create a new one=EF=BC=8Ct=
his=20
can improve the performance of container concurrent startup, because=20
renaming cgroup is much more lightweight compared with creating cgroup.

For new features in cgroup v2, I switch to cgroup v2 and meet this=20
problem, I think renaming cgroup in v2 is similar to v1 and realizing it=20
is not a hard problem, so I send this mail to learn the initial design.

Thanks,
-escape
