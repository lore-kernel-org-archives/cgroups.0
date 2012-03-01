From: C Anthony Risinger <anthony-iwZaZ8Eb++w@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Thu, 1 Mar 2012 16:38:37 -0600
Message-ID: <CAGAVQTE8JSPNimS_HU9-p8dCz2jw40YUEDwkU0BSn_ZZg_PhRA@mail.gmail.com>
References: <20120221211938.GE12236@google.com> <20120222163858.GB4128@redhat.com>
 <20120222165714.GC4128@redhat.com> <1329990094.24994.64.camel@twins>
 <1330006399.11248.20.camel@twins> <4F4FAF89.3090706@redhat.com>
 <1330633603.7414.49.camel@marge.simpson.net> <20120301210213.GF13533@redhat.com>
 <1330639448.7414.97.camel@marge.simpson.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=xtfx.me; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        bh=YbdlmwsMNJl5tPxrGIkOhcrreGa6mQhH7ZVRdGnabK8=;
        b=IxtQXdvb6dlSjm63+zmJQsNoueMWsrEdLzpTdWw8PtV2SYonRcl91k168L/RIunP/c
         sUP6RgDihUkSuxyuF+qUTUyGxWP8BU5rBg1b7gCVZSVuFY7wCraqnZRPJ/NkT5boYjzC
         8ehc8hZd8Xwo6xV5FdheTL/pPyaJSQ3mAHvbo=
In-Reply-To: <1330639448.7414.97.camel-YqMYhexLQo31wTEvPJ5Q0F6hYfS7NtTn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Mar 1, 2012 at 4:04 PM, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org> wrote:
> On Thu, 2012-03-01 at 16:02 -0500, Vivek Goyal wrote:
>> On Thu, Mar 01, 2012 at 09:26:43PM +0100, Mike Galbraith wrote:
>
>> > Q: you say systemd requires CONFIG_CGROUPS=3Dy. =C2=A0Why is that?=
 =C2=A0It's taking
>> > over sysvinits job afaiui, what does that have to do with cgroups?
>>
>> I think they were using it to track all the children forked by a ser=
vice
>> and cleanup all of them if need be. So they just need it for logical
>> grouping functionality and don't require any controllers as such.
>
> Hm. =C2=A0Controllers are perhaps not required, but cpu controller wa=
s
> configured and used without consent. =C2=A0I didn't receive an offer.

AFAIK it does in fact only require `name` cgroup for it's own
monitoring purposes.  i believe the systemd folks also tried (and are
trying? see TODO) to get PR_SET_ANCHOR merged upstream:

https://lkml.org/lkml/2010/2/2/165

=2E.. which is a sort of recursive/persistent parenting flag; without
that or cgroups, there is no way to reliably supervise processes under
Linux.

the other problem is there is no way for a process to enumerate the
available cgroups -- IIRC a list had to be hard-coded in systemd
sources -- and mounting the cgroupfs without specifying a specific
subsystem simply mounts everything in one whack.

you should be able to tell systemd to ignore that specific controller,
or tell it to use existing mounts.  i for one have been using it
*exclusively* on my personal machines/home servers [archlinux] and am
very pleased ... it's very flexible and gives you an unprecedented
level of control and introspection into the system (man systemd.*) ...
i can create new services in about 3-5 lines.

=2E.. obviously this thread is not about systemd, but since it makes
such extensive use of cgroup facilities it only proves to highlight
it's deficiencies.  i think the notes and practices systemd has
established should be viewed as a good reference for what's clumsy, at
the very least, and should not be attributed to systemd, but to
cgroups.

--=20

C Anthony
