From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] provide a version of cpuacct statistics inside cpu cgroup
Date: Thu, 17 Nov 2011 12:42:25 +0530
Message-ID: <CAKTCnz=FxTbNcV4HmZtDqCf09kq3Aw20QBK0-KKy-n1Obef_Bg@mail.gmail.com>
References: <1321372757-1581-1-git-send-email-glommer@parallels.com>
	<1321372757-1581-5-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=S12hDCpGBebqthHILzxrfPBl3oKpys5mveCT57T1Gkc=;
        b=H2JxRSln5ZQNSYTW0ed3LcwPBf3zWWcUFqlM/85h8H9UdlWrufOJX1RxLO43DCtdaB
         Zxf8MGwtPzIu4BdpsRaZEGDkrQk1bX+amb4VdiL+eD5SK7ME4ogXagB1D6ZNjQ2t5/Sy
         4/PWfL/2rCGqWfkRrDe/QxNmIZkE4cJZxyYbw=
In-Reply-To: <1321372757-1581-5-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 15, 2011 at 9:29 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> For users interested in using the information currently displayed
> at cpuacct.stat, we provide it inside the cpu cgroup.

I presume I need to mount cpu to see these stats and cpu implies
control today - no? Can I only monitor statistics without implementing
control? Please see the other thread as well.

Balbir
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
