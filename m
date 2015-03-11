From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Thu, 12 Mar 2015 10:47:11 +1100
Message-ID: <CAOviyaj55Yqahz75Gy5=yjFteeKFp7746=80-Ufww2E62Ads_Q@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
	<1425010639-16492-1-git-send-email-cyphar@cyphar.com>
	<1425010639-16492-2-git-send-email-cyphar@cyphar.com>
	<20150309030636.GC13283@htj.duckdns.org>
	<CAOviyaip7Faz98YWzGoTaXGYVb72sfD+ZL4Xa89reU9+=43jFA@mail.gmail.com>
	<20150309065902.GP13283@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150309065902.GP13283-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Hi Tejun,

> You can charge the parent's at can_attach(), remember which one you
> charged, and at post_fork() if the parent's has changed inbetween, fix
> it up. [...]

Did you mean can_fork() instead of can_attach() here?

--
Aleksa Sarai (cyphar)
www.cyphar.com
