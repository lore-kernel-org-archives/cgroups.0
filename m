From: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: What's the progress of per cgroup background reclaim?
Date: Wed, 14 Mar 2012 15:53:10 +0800
Message-ID: <CAC8teKW9Yry114+B06XiFbOtamwS6fNLzrKYo8PZazjEzMCiNQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=LYoPs+rIzdcrkwMyHV1Feqz/KljVndm9ymJyHmRJSM8=;
        b=dqR0Lrpvnk/Wp8YaIrd+l316V0D0ACB/t8eDx2vC2EYURrQBKcWbh91o6/kwHEF9LV
         IKMHugAZtNSw0xhiYfq7+rP3FCGXrS0sYa4bbnDDdIS3DUPNboSh42zFyaFyLmkP5VhK
         xalQi3GIpBar6NfO7mGU8jZF+sfI85X5o6YodKZ1arcnHV9UcFRN3rAPFCZMg7G+DsPA
         g9ngHqytbkPWnss65XSiAFUv0woDJl3KmAZ9yzo8wKD1Cwl9U14Af/fezP980TzFW0V0
         wPIRon5YADVwcz0xzNft7a5H9m9Uieb3Am+jF3E/Icx4d5YwOk7xlur5Job8MT+KNPom
         8Pag==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Hi all,
Just a quick question, could you please tell me what's the current
status of the development of per cgroup background reclaim? This topic
seems to be silent after Han Ying's patchset V7
(http://lwn.net/Articles/440073/) and Kame's async reclaim patchset V3
(https://lkml.org/lkml/2011/5/26/20), and I can't find it in
memcg-devel tree either.
Is anyone still working on this?

Thanks,
Zhu Yanhai
