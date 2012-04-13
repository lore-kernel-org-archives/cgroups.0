From: gaoqiang <gaoqiangscut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: question about memsw of memory cgroup-subsystem
Date: Fri, 13 Apr 2012 18:00:10 +0800
Message-ID: <op.wco7ekvhn27o5l@gaoqiang-d1.corp.qihoo.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=content-type:to:subject:date:mime-version:content-transfer-encoding
         :from:organization:message-id:user-agent;
        bh=JIxribUp+afxqpglcPKBCSukw1lnmLGF0qnA1TI5DR0=;
        b=Y0k8thWlzbwzBL8A5ZzcL2+S6Nl9+nNBeN2fmilVqMLR/6cWi99xGhuEm+jIVTA3Tr
         125fDLwYe0dXquWblEbys/tzTD86bmi+z4xo/gRvvhaKHHCsFUZveM0V2L/CBjsis37v
         gEO9nkUq/Pmk+G6vxiExQCZq4kYF0mxMarM8g7HHvu1gm4t2oxAB6eEEm3D9N+JPns7o
         8+bco26WvfZUI9hjRLVESPmksk7wYLkTkpwWjuXX+TyGLM+79nmPzv9Uagc73RnFcRMz
         NUuVkOthsvOHTm9h7zLwzxlJKMVfY3dqDv8Hkelr8poqT5SYxsf96vp24DaMBuj/+nIW
         Nr8w==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="gb2312"; format="flowed	delsp=yes"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



I put a single process into a cgroup and set memory.limit_in_bytes to =20
100M,and memory.memsw.limit_in_bytes to 1G.

howevery,the process was oom-killed before mem+swap hit 1G. I tried man=
y =20
times,and it was killed randomly when memory+swap

exceed 100M but less than 1G.  what is the matter ?

--=20
=CA=B9=D3=C3 Opera =B8=EF=C3=FC=D0=D4=B5=C4=B5=E7=D7=D3=D3=CA=BC=FE=BF=CD=
=BB=A7=B3=CC=D0=F2: http://www.opera.com/mail/
