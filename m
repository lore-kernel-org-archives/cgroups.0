From: Kristijan =?UTF-8?Q?Le=C4=8Dnik?= <janez3k@gmail.com>
Subject: Bug#731715: can't add process PID to group/tasks
Date: Mon, 9 Dec 2013 23:19:48 +0100
Message-ID: <CACC+8CThEa82hdrcqsh8sjQJqGy7gHuvQweN7trTfm90cc=PKA@mail.gmail.com>
Reply-To: Kristijan =?UTF-8?Q?Le=C4=8Dnik?= <janez3k@gmail.com>, 731715@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=001a1133dee6d8c05804ed21644a
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.731715.B731715.13866275958130@bugs.debian.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=/XZ+/DZST8ZpfUA2ycJdM70K3gi+ScMPNhL0bBY+2+Q=;
        b=y2ldzYKX4XvTL5Iagv0SK//ZMEwOSpqVG4ndSfUAvceaGvzTL68CFa6lveqM7hZYCu
         qFQPkzpqMG6Uuqf/sbeypQR0ATJdTx5fasa/KIuT/Y/Y6IOQ0gaWPc7ZUB1bMDp6LTRh
         F+zx39FuPwaszUeqOxa2KVDQntH1rEMFAXYHqzOowTOh6EFZW/D8J/LEW34jr4I2HBFT
         /d5TS98DI0FGZTIziWpxuHiWD63+ZJ96LZxGC4lJ7Lj3YPMtwKa5+dB7Z4STo4VXiZ4Z
         qRg0+sMrP9ASkasCgfc//XRtt3BZJizqWuzNceEClx5KA1twYt98bBI3+lPFVsclL67r
         GByQ==
List-Id: <cgroups.vger.kernel.org>
List-URL: <http://lists.debian.org/debian-kernel/>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
To: cgroups@vger.kernel.org
Cc: 731715@bugs.debian.org

--001a1133dee6d8c05804ed21644a
Content-Type: text/plain; charset=ISO-8859-1

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

--001a1133dee6d8c05804ed21644a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>i am running few debian 7 servers a=
nd tried to use cgorups and get an error when trying to add PID to tasks.</=
div><div><br></div><div style>i have try diffrent kernels,=A0different cgro=
up-bin libcgroup1 versions ( 0.38-1, 0.38-3, 0.40~rc1-5 )</div>
<div style>Linux server 3.10-0.bpo.3-amd64 #1 SMP Debian 3.10.11-1~bpo70+1 =
(2013-09-24) x86_64 GNU/Linux<br></div><div style>Linux server 3.2.0-4-amd6=
4 #1 SMP Debian 3.2.46-1 x86_64 GNU/Linux</div><div style><br></div><div st=
yle>
how:<br></div><div>
<p class=3D"">apt-get install cgroup-bin libcgroup1<br>add to fstab<br>cgro=
up=A0 /sys/fs/cgroup=A0 cgroup=A0 defaults=A0 0 =A0 0<br>create group manua=
lly or thru cgrules.conf<br>started cgconfig<br>edit some values for cpu, i=
o - ok<br>
<br>root@testp:/sys/fs/cgroup/io-test# /bin/echo 5298 &gt; tasks<br>/bin/ec=
ho: write error: No space left on device<br><br>root@backup:/sys/fs/cgroup/=
io-test# echo $$ &gt; tasks<br>/bin/echo: write error: No space left on dev=
ice</p>
<div style>i have try the same configuration on centos and works as expecte=
d.</div><div style><div style>centos kernel, libcgroup:</div><div>libcgroup=
-0.37-4.el6.x86_64</div><div>Linux server 3.4.68-9.el6.centos.alt.x86_64 #1=
 SMP Wed Nov 6 19:38:46 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux<br>
</div></div><div style><br></div><div style>libcgroup-0.40.rc1-5.el6.x86_64=
<br></div><div style><div>Linux server 2.6.32-358.11.1.el6.x86_64 #1 SMP We=
d Jun 12 03:34:52 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux</div><div><br>
</div><div style>any ideas?</div><div><br></div></div><div style>Regards,</=
div><div style>Kristijan Lecnik</div>
</div></div>

--001a1133dee6d8c05804ed21644a--

