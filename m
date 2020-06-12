From: Markus Elfring <Markus.Elfring-S0/GAf8tV78@public.gmane.org>
Subject: Re: [PATCH] Fix code style in css_task_iter_next_css_set()
Date: Fri, 12 Jun 2020 21:56:26 +0200
Message-ID: <52681580-7ab4-a73c-6c86-bc9872de4fe8@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1591991788;
        bh=7m9D9uhJfOvU9oe94bssZb6aR8Jdd/LzEcEotEJw5yk=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=jydBlfmeg01uwJWgOzAOuRWcCTz6EvIm3Q8XbSAAS/l3/6eHbylqiY8da+ZZoRes3
         f86KaY6beCOIQcv2M9MFBP7VuFWmzgK/8WDNllH8OcXuOuUJxB3QUgv4CTkA+aOFH/
         y1zKL+ipnjX8uVVC8ZXnvW/E9Z+v3EoMXoZvCtKg=
Content-Language: en-GB
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: weifenghai <zzuedu2000-9Onoh4P/yGk@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> One line similar code before in this function

I suggest to improve the commit message.
How do you think about a wording variant like the following?

   Combine two assignments for the variable =E2=80=9Cl=E2=80=9D into one s=
tatement.

Regards,
Markus
