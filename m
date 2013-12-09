From: =?UTF-8?Q?Kristijan_Le=C4=8Dnik?= <janez3k-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: can't add process PID to group/tasks
Date: Mon, 9 Dec 2013 23:25:32 +0100
Message-ID: <CACC+8CR8CEFf30CEfEHY98ZpNDRf40q_4qx_H4LUr8+nDO31vg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=0e24QG276/I4b98QaN+sCLCHcx2DH3DxcpvIQ/2Eyug=;
        b=0H5ZL4vZLvJIe+qZobePiOcVGo4tbfc6U90BXYS/8OGG3J14rs8RHucDDfXEZsjUZr
         bcLydK2jvTUvzVaBAbBXaIG74Af4JgBodjvXJXh+aQZlBfI5HHQZIkmP4GEooIbxBXLY
         /z20/FM6hjqbtylwJzLBDCA8wSk3Ag5cBu2Q81oSANObVdJQWxiV/jwNw/7sSmXExH8Y
         I2PZzSNZ2Omp9SdemP8rax9nQwUOuJVVC672tJzs291iKkQsdgSjmkUPNpcbDMjuXTav
         Ogsy7bQuqt8ouxwyBL+iQo7t5o4bXB0NWPKuPgB/g/melVaAGZ+wHtFrmPir0gOLnjJB
         FXKQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

i am running few debian 7 servers and tried to use cgorups and get an error
when trying to add PID to tasks.

i have try diffrent kernels, different cgroup-bin libcgroup1 versions (
0.38-1, 0.38-3, 0.40~rc1-5 )
Linux server 3.10-0.bpo.3-amd64 #1 SMP Debian 3.10.11-1~bpo70+1
(2013-09-24) x86_64 GNU/Linux
Linux server 3.2.0-4-amd64 #1 SMP Debian 3.2.46-1 x86_64 GNU/Linux

how:

apt-get install cgroup-bin libcgroup1
add to fstab
cgroup  /sys/fs/cgroup  cgroup  defaults  0   0
create group manually or thru cgrules.conf
started cgconfig
edit some values for cpu, io - ok

root@testp:/sys/fs/cgroup/io-test# /bin/echo 5298 > tasks
/bin/echo: write error: No space left on device

root@backup:/sys/fs/cgroup/io-test# echo $$ > tasks
/bin/echo: write error: No space left on device
i have try the same configuration on centos and works as expected.
centos kernel, libcgroup:
libcgroup-0.37-4.el6.x86_64
Linux server 3.4.68-9.el6.centos.alt.x86_64 #1 SMP Wed Nov 6 19:38:46 UTC
2013 x86_64 x86_64 x86_64 GNU/Linux

libcgroup-0.40.rc1-5.el6.x86_64
Linux server 2.6.32-358.11.1.el6.x86_64 #1 SMP Wed Jun 12 03:34:52 UTC 2013
x86_64 x86_64 x86_64 GNU/Linux

any ideas?

Regards,
Kristijan Lecnik
