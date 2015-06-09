From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v13 4/5] cgroup: allow a cgroup subsystem to reject a fork
Date: Tue, 9 Jun 2015 16:23:07 +0900
Message-ID: <CAOS58YM9nUYGP_f3_CE4EoaFGJ=aB3EJC43xrJwc_iymLf+rXQ@mail.gmail.com>
References: <1433547736-11707-1-git-send-email-cyphar@cyphar.com>
	<1433548938-32560-4-git-send-email-cyphar@cyphar.com>
	<20150609044133.GQ21465@mtj.duckdns.org>
	<CAOviyai2LMkFJuOhc=ZEckuackTnfPBwCsB6aLxTBJD3-vb1=w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=c8UDNyXK8/FUd68QCUjKqFGOvKnWgH6p8lhDVQul8i8=;
        b=AJz81Yfv1HVRXxL0meOOUIJurcwXDjP6FQ7QxHOO2A1Nm0K0w0yy364cYqSQ0DToy4
         VPamHgs8IY6LgNho/AyngQL4CcKsWdMlYEYA5lQuuSdQwqjh+wakiSSBerxE4i3mleIa
         7QDE+z3oiPBlt+YiRlv63RWt5F+3P0iOgST85rcxA9jHHbZbCM+2T995B+se515JSOOb
         YiVwzOKkJIwMU0D8bvW+dnci1Mn+WsH6zUZk8AZx8S4EWe7TD/k9Sd8aFoJ8t5Az52JJ
         GslbLUgDN1yfCtO1758a/QDhC3HjGpvuQNB7258szBIcEI3ghWRFaeohCKTLfwwx0vDQ
         QBhQ==
In-Reply-To: <CAOviyai2LMkFJuOhc=ZEckuackTnfPBwCsB6aLxTBJD3-vb1=w@mail.gmail.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Tue, Jun 9, 2015 at 4:20 PM, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org> wrote:
> CGROUP_CANFORK_{START,END,COUNT} aren't used to restrict the
> iteration. They're used for restricting the size of the @ss_priv
> array. If you want, I can use CANFORK_{START,END} to restrict the
> iteration -- I just prefer using the for_each_subsys_which API for
> iterating over active cgroups. :/

Ah, I see.  Hmm... yeah, let's keep the code for now, but I think it'd
be cheaper / cleaner to use those macro tags to restrict iteration and
drop all the masks in the future.

Thanks.

-- 
tejun
