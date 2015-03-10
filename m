From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Wed, 11 Mar 2015 01:51:06 +1100
Message-ID: <CAOviyai7yJrbGb+uYpK35tw7R-KM0jWQ-BmhpyTqnRFJsVYdUA@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
	<1425010639-16492-1-git-send-email-cyphar@cyphar.com>
	<1425010639-16492-2-git-send-email-cyphar@cyphar.com>
	<20150309030636.GC13283@htj.duckdns.org>
	<CAOviyaip7Faz98YWzGoTaXGYVb72sfD+ZL4Xa89reU9+=43jFA@mail.gmail.com>
	<20150309065902.GP13283@htj.duckdns.org>
	<CAOviyaj3mf66ho15WrD8qB=ECxKWYTAkWodxWaFVMWeZG4d0FQ@mail.gmail.com>
	<20150310124701.GB28730@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150310124701.GB28730-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Tejun,

On Tue, Mar 10, 2015 at 11:47 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> of doing a charge that stops if you hit a certain `css` (unless we start
>> passing `css_set`s to the fork/exit callbacks -- and then we can uncharge the
>> old css_set and charge the new one).
>
> We'll have to pass the pointer from can_fork side to post_fork.  I'm
> not sure how that should be done either.

Actually, I'm fairly sure we can do it all inside cgroup_post_fork() because
inside cgroup_post_fork() we have access to both the old css_set and the new
one. Then it's just a matter of reverting and re-applying the charge to the
hierarchies.

I'll send a patch in a few days, I need to make sure that this method
*actually* works. :P

--
Aleksa Sarai (cyphar)
www.cyphar.com
