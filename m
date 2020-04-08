From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: CLONE_INTO_CGROUP documentation?
Date: Wed, 8 Apr 2020 13:12:01 +0200
Message-ID: <CAKgNAkhL0zCj11LS9vfae872YVeRsxdz20sZWuXdi+UjH21=0g@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=y6GvbrxPWO38NZY2qniHG/bjP2NH5oiIBjc+DHthlNY=;
        b=VC5psAUsa1U2CjvoshCFasg2IK8FzsljYRvZ/5QS60xwoyvFBFXQqmt8BkfUpV3HhM
         wkeRFEaLVqKQIOoZDyHNzLICNc4pgkurJGaKqWSZfacFmPdK86yd+dxBZVQCpzJjJOcA
         nPceEZnTYX6NJHBHq5pJAT/x9+LSQWopr7Q1En9TwCbD3g2D35OpQY+2TajCjUF+FN1e
         1nx+MN0TVjZJqCRqNbYlmm5rP8MdMkc4y6G74Frt5V7HwMBNMWLyd3BYzC8p66tFBOa3
         x+m/N/xyM5Zel3thnTh3qMXI0vUG6+MDW4TbGn4BkVcNFBi01WQ7mnKcOKPmwSSniwZC
         8YFw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Christian,

I see that CLONE_INTO_CGROUP has been merged? WOuld you be able to
send a man-pages patch documenting this please?

Thanks,

Michael

