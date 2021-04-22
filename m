From: Michal Hocko <mhocko@suse.com>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Thu, 22 Apr 2021 15:08:31 +0200
Message-ID: <YIF1T21wiPq9eeOW@dhcp22.suse.cz>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <699e51ba-825d-b243-8205-4d8cff478a66@sony.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619096911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ziDd39JRIdWlI/ZncRHR4tPeHFque6IN9ySODF6A6RA=;
        b=ASiXiYpuhQJ/g3mUwmNQ88KUW3PYI8bbiUz8frlVc4HfAQOrx6zcEuPvAWLydBPThzX1G2
        mZw1c82Q3w+yMMZ8mF25AIjIRzZApPejrKxB7Dsc17Ce3QtjfOdmwhrc1q8d63JSizP5iT
        EVok/PSjPGn9pOzVtaBHjrwaBxnCJgs=
Content-Disposition: inline
In-Reply-To: <699e51ba-825d-b243-8205-4d8cff478a66@sony.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: peter enderborg <peter.enderborg@sony.com>
Cc: Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>, Greg Thelen <gthelen@google.com>, Dragos Sbirlea <dragoss@google.com>, Priya Duraisamy <padmapriyad@google.com>

On Wed 21-04-21 19:05:49, peter enderborg wrote:
[...]
> I think this is the wrong way to go.
>=20
> I sent a patch for android lowmemorykiller some years ago.
>=20
> http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2017-Fe=
bruary/100319.html
>=20
> It has been improved since than, so it can act handle oom callbacks, it c=
an act on vmpressure and psi
> and as a shrinker. The patches has not been ported to resent kernels thou=
gh.
>=20
> I don't think vmpressure and psi is that relevant now. (They are what use=
rspace act on)=A0 But the basic idea is to have a priority queue
> within the kernel. It need pick up new processes and dying process.=A0 An=
d then it has a order, and that
> is set with oom adj values by activity manager in android.=A0 I see this =
model can be reused for
> something that is between a standard oom and userspace.=A0 Instead of vmp=
ressure and psi
> a watchdog might be a better way.=A0 If userspace (in android the activit=
y manager or lmkd) does not kick the watchdog,
> the watchdog bite the task according to the priority and kills it.=A0 Thi=
s priority list does not have to be a list generated=A0
> within kernel. But it has the advantage that you inherent parents propert=
ies.=A0 We use a rb-tree for that.
>=20
> All that is missing is the watchdog.

And this is off topic to the discussion as well. We are not discussing
how to handle OOM situation best. Shakeel has brought up challenges that
some userspace based OOM killer implementations are facing. Like it or
not but different workloads have different requirements and what you are
using in Android might not be the best fit for everybody. I will not
comment on the android approach but it doesn't address any of the
concerns that have been brought up.
--=20
Michal Hocko
SUSE Labs
