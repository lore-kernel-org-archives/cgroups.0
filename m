From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Cgroup v2 thread mode oddity: "domain invalid" cgroup with threaded
 controller enabled
Date: Thu, 4 Oct 2018 21:40:57 +0200
Message-ID: <a4912516-8c6b-d8d3-b714-5c03bcfc5e91@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=zwsVKiAtZBpj9PhL9Hne0q0mlWGysGOGmVnhkIa7q2Y=;
        b=OyFRb5Vvh33JAV4Hot6/vcTWtTqmZUd8J0o45bO8BRICmghGsY/BpZiFJZbqNCsZ0W
         lQJ212F7cQIC9Hdl1qcjCV4TqputnK/29lASXGobgb5BXAeaVb8APk31pPBf0ieuLTBX
         dABlLu8bkXQiDsybChVj6M/mVifVYUkkVrjczZ0yyD+X9NfhC0C0leKnu23JhDuIaXQc
         Voe34RyTYT6+UHw0QZGYIe1yk7/ZdreY00gmqFQ8dBmSEg0oj9tuJhYu76wTIt5Ihr/1
         ZPNUxn3G9RAs9yzBwbSaKbJro+PkUfcZMdF1sQGT/CkvjirPgFL4hHU8u/VXY8oiHqSV
         ASwA==
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: mtk.manpages@gmail.com, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, lkml <linux-kernel@vger.kernel.org>

Hello Tejun,

Suppose we have the following scenario:

x [d]    (pids)
    y [dt]    (pids)
        p [t]
        q [t]
        r [t]
    z [d]

Here, x/y is a "domain threaded root" with a threaded controller
(the 'pids' controller) enabled. (In this scenario, there are no
member processes in any of the cgroups.)

Suppose we now convert x/z to "threaded" type:

     # echo threaded > x/z/cgroup.type

Now we end up in the following state:

x [dt]    (pids)
    y [inv]    (pids)
        p [t]
        q [t]
        r [t]
    z [t]

This seems odd. x/y is now of "domain invalid" type with a controller
enabled! This feels like a violation of the rules, since we can't
in other circumstances do anything with a "domain invalid" cgroup
except convert it to "threaded". In particular, we can't create
child cgroups under a "domain invalid" cgroup, or add member processes
to the cgroup, or *enable controllers in the cgroup*. In fact, when
doing the 

    # echo threaded > x/z/cgroup.type

I had expected a write(2) error because the state of x/y should
(I thought) not be permitted.

Your thoughts?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
