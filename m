From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3 cgroup/for-5.20] cgroup: Add "no" prefixed mount
 options
Date: Tue, 26 Jul 2022 13:30:40 -1000
Message-ID: <YuB5ICv3bXsy5Xuh@slm.duckdns.org>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <20220726143246.GA23794@blackbody.suse.cz>
 <YuBIACfZDk72yjI3@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=IWWxn3X0jnsR94h+cZ81QPmnOmsG3z0u/cykcxbxqQk=;
        b=mBWyIaZ3887OTEur8s1YPqKZsGf3UyXWCMl0JX9K3rbdQIfEVIfq7cXTx+hHgeTbZh
         y+BDnqiaRAskVnICRetNJsy1UwxxhRBSXodYVrU0KQfsBRGBgteG70kVZUzn6S3E+I5w
         Yj1zjv47GCl2+goVzhJOurXm2jzYz0LE0tYMuknKI5Q0YDf4bR0VCvz5pEwIjsewZ9wN
         5lmV1e+mi/vZKP2Z3Rjdoprfv+pJQYEkwuFPTr/h8jOYv8Dp7v84HHL9z2sAKqdLNXW5
         sShwmNi+AOPBVMv9CS8oWE/LuMcWJ6Xbl+roqNA369ALlbqRf6BtaTnbAeQHxwK19vAc
         ZbDg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YuBIACfZDk72yjI3@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>, John Stultz <john.stultz@linaro.org>, Dmitry Shmidt <dimitrysh@google.com>, Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Tue, Jul 26, 2022 at 10:01:04AM -1000, Tejun Heo wrote:
> On Tue, Jul 26, 2022 at 04:32:46PM +0200, Michal Koutn=FD wrote:
> > On Thu, Jul 14, 2022 at 06:38:43PM -1000, Tejun Heo <tj@kernel.org> wro=
te:
> > > We allow modifying these mount options via remount. Let's add "no" pr=
efixed
> > > variants so that they can be turned off too.
> >=20
> > They can be turned off:
> >=20
> > > // on v5.19-rc?
> > > :~ # grep cg /proc/mounts
> > > cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdele=
gate 0 0
> > > :~ # mount -t cgroup2 cgroup2 /sys/fs/cgroup/ -oremount
> > > :~ # grep cg /proc/mounts
> > > cgroup2 /sys/fs/cgroup cgroup2 rw,relatime 0 0

  root@test ~# grep cgroup /proc/mounts
  cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate=
,memory_recursiveprot 0 0
  root@test ~# mount -o remount,exec /sys/fs/cgroup
  root@test ~# grep cgroup /proc/mounts
  cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,relatime,nsdelegate,memory=
_recursiveprot 0 0
  root@test ~# mount -o remount /sys/fs/cgroup
  root@test ~# grep cgroup /proc/mounts
  cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,relatime,nsdelegate,memory=
_recursiveprot 0 0
  root@test ~# mount -o remount,nsdelegate,memory_recursiveprot cgroup2 /sy=
s/fs/cgroup
  root@test ~# grep cgroup /proc/mounts
  cgroup2 /sys/fs/cgroup cgroup2 rw,relatime,nsdelegate,memory_recursivepro=
t 0 0
  root@test ~# mount -o remount,memory_recursiveprot cgroup2 /sys/fs/cgroup
  root@test ~# grep cgroup /proc/mounts
  cgroup2 /sys/fs/cgroup cgroup2 rw,relatime,memory_recursiveprot 0 0
  root@test ~# mount -o remount cgroup2 /sys/fs/cgroup
  root@test ~# grep cgroup /proc/mounts
  cgroup2 /sys/fs/cgroup cgroup2 rw,relatime 0 0

Man, I had no idea that `mount -o remount,$OPTS $MOUNT_POINT` and `mount -o
remount,$OPTS $SRC $MOUNT_POINT` behave completely differently in how they
handle existing options. I wonder why other filesystems are implementing
explicit no prefixed options.

Anyways, will soon post a patch to remove the no prefixed options.

Thanks for pointing it out.

--=20
tejun
