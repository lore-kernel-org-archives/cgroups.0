From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-5.20] cgroup: remove "no" prefixed mount
 options options
Date: Wed, 27 Jul 2022 07:55:58 -1000
Message-ID: <YuF8LrDcd9tpYLnX@slm.duckdns.org>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <20220726143246.GA23794@blackbody.suse.cz>
 <YuBIACfZDk72yjI3@slm.duckdns.org>
 <YuB5ICv3bXsy5Xuh@slm.duckdns.org>
 <YuB9QXapVUy1t8TZ@slm.duckdns.org>
 <20220727092715.GA1569@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=FNJqWOgunTysXo2x6MYgmJbijH0daSpLu5NGEZRQviE=;
        b=A/u3Wjgc6Pq6XfpcsLe9ZPc/0GNdFxt8A6JJ8VmjPhGMKdLSNN0EOiS3dWtui4azMj
         jn+/Al0U4PLfPbF/zMf5d86WrI52ysytboMjjFBBeB648qMEb8Aqz+lZbCbQyc57iKpo
         oKudOAu9TkIAt9p86u7HAMxUvTwWdKk1L1IUsue7nMeXmd15oOllnyTw3zhykckM7Y+U
         FIJSVm1SxY6FrxyjbHs06eOwTeYNwwU5vX0hJdD170g4TLSKUb2BEfS6OdC0gHLwKLNE
         qnf4v73uF3y43EfbJUa8wb/VLBO59ynVFHOdiixIpZXo/amlH+T+In2IblGizPkTzNh+
         MXkQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220727092715.GA1569-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 27, 2022 at 11:27:15AM +0200, Michal Koutn=FD wrote:
> On Tue, Jul 26, 2022 at 01:48:17PM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yR=
OfE0A@public.gmane.org> wrote:
> Thanks.
>=20
> > While a bit confusing, given that there is a way to turn off the option=
s,
> > there's no reason to have the explicit "no" prefixed options. Let's rem=
ove
> > them.
>=20
> This is sensible...
>=20
> >  Documentation/admin-guide/cgroup-v2.rst |    8 ++++----
> >  kernel/cgroup/cgroup.c                  |   24 ++++--------------------
> >  2 files changed, 8 insertions(+), 24 deletions(-)
>=20
> ...and cleaner.

Alright, applied to cgroup/for-5.20.

Thanks.

--=20
tejun
