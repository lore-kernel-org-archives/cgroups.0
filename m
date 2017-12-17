From: Bronek Kozicki <brok-CgwIDsGnGWjby3iVrkZq2A@public.gmane.org>
Subject: Re: PROBLEM: NULL pointer dereference in kernel 4.14.6
Date: Sun, 17 Dec 2017 18:48:16 +0000
Message-ID: <1513536496.3754736.1207944032.00C6D43E@webmail.messagingengine.com>
References: <1513512885.3653140.1207725096.395A9CCC@webmail.messagingengine.com>
 <eccdc57d-d5ea-ddc5-9f07-269e4a6786ae@incorrekt.com>
 <08995310-d853-ee77-ed1f-26cc336a4a30@incorrekt.com>
 <54a16e07-70e6-adda-ebdb-06349b4f8e86@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=incorrekt.com;
         h=cc:content-transfer-encoding:content-type:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FYOnix8xibNOgpyGN
        Fs8eANbWwNgAjOTPKurzIgwe8E=; b=ZsC91Tb0ea8vh4+EYQO2VKAMnfd/jJSUW
        UV/CztjaiCv9ozqUq68XMCWf6re6cb+eETZWU1lbm6tcD+C1WG4MCp9z6r07RPbU
        OTqTUjVCs3nUDyTuyt3Tr8mZE/AYXl9cp3ZElBrHrQR6gk2+nhLlwd2oF0qVwDuO
        kgfp/pbois3u7VrJafWVrKeZ2lLeG8d9/p0iK5wnIha27MxOyXlyLSNsIipZ3Zhv
        UghzfUihVHu25IyKLJdSf3wNMjoTo2TE8TZQl0795KTFpoN5FyENynUdF4Zz4PyE
        wsfrGIgOB27kTimRywhDUZze/gk5kWW6P9JfQlNRCUR8uL/PpAAaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FYOnix
        8xibNOgpyGNFs8eANbWwNgAjOTPKurzIgwe8E=; b=Kl05Zy6ST7AoWBOJAuL6gh
        /mvur5LvJ06Vw98qygFLqx7TghEjntd53wWrZW8IXuu3SfKPBYrGYHADpmtS/ST9
        mS59w4mTARB8/YHJPsD8OUT6ZQ1naOX2pbIAipJBaPffylKhdxxQrl+56ye/mrug
        EBXXJorYuZnD0MUlzLk6YohliN2cA/Zp04cWWBmSqrgEIkbGwZ5ZyQjRlIRiFn51
        D+qhGhzMsaEjUHJbZnJAYSAWmHBaPxw0h95iviQeQIo/+MvV3G+qnpdLkVWSZ8uD
        Laf/nuePQXJvL7I8NVgF5XmRIXsbn8o58E/LlZSzwi66PlMQ8KibQ5DJFEe1CwJA
        ==
In-Reply-To: <54a16e07-70e6-adda-ebdb-06349b4f8e86-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

FWIW, I can do "cat" . I get a single number seemingly followed by an
infinite stream of 0s (I tried wc -l, but did not want to wait very long
and killed it). Here is what it looks like, if limited by "head":

root@gdansk ~ # cat
'/sys/fs/cgroup/unified/machine.slice/machine-qemu\x2d1\x2dkartuzy\x2dspice.scope/cgroup.procs'
| head
10649
0
0
0
0
0
0
0
0
0
root@gdansk ~ #

PID 10649 is indeed qemu process running the virtual machine in
question:

root@gdansk ~ # ps lw 10649
F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME
COMMAND
6     0 10649     1  20   0 4815836 60252 -     Sl   ?          2:56
/usr/bin/qemu-system-x86_64 -name
guest=kartuzy-spice,process=qemu:kartuzy-spice,debug-threads=on -S
-object se


Sorry about taint by ZFS, but there is nothing I can do, it is my root
filesystem. Since I am the only user of the package in question I could
cheat and replace the license for the build of the ZFS module, but I do
not see how that might help.


B.
