From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: Deadlock due to "cpuset: Make cpuset hotplug synchronous"
Date: Wed, 1 Apr 2020 22:00:31 -0400
Message-ID: <6AD62381-394F-4742-816B-12DE67DE9788@lca.pw>
References: <F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC@lca.pw>
 <20200325191922.GM162390@mtj.duckdns.org>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qfoLXrnqNbdNMc/qg2fQn2VjZnT5IOOCPmT892IlYdk=;
        b=cKiCEtpAG53uMWAllPIubuUVMZlkf3zGEeenWXGZmNb+BHlxsZBGyKew+FTU9oQ0DK
         McD3eNpxPXKTXQPqLWrgQdam04yznD9HI+ZfpUVD4+6oU/EnkDneahxLSct/AcGOF4gG
         uheCdgHsaoKysYe8jmBDL5RQYET+jwYiCS8TGbjMxhAArzztsmCasWUrhDVQx5cbzEiC
         46MaPsstwXUfybIOU50IHy4Ix+1AtX+LmS7afvx+O+PlAXsZ+jUibdRobmcBTI6f7Jxi
         MgjCUnelx9ep+I9n1ADEJjzAxCwlrKMWRT47dVTrQnjx7fRr/mKa6yMLmmnXJqb/GFsW
         Zg4g==
In-Reply-To: <20200325191922.GM162390-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>



> On Mar 25, 2020, at 3:19 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>=20
> On Wed, Mar 25, 2020 at 03:16:56PM -0400, Qian Cai wrote:
>> The linux-next commit a49e4629b5ed (=E2=80=9Ccpuset: Make cpuset =
hotplug synchronous=E2=80=9D)
>> introduced real deadlocks with CPU hotplug as showed in the lockdep =
splat, since it is
>> now making a relation from cpu_hotplug_lock =E2=80=94> cgroup_mutex.
>=20
> Prateek, can you please take a look? Given that the merge window is =
just around
> the corner, we might have to revert and retry later if it can't be =
resolved
> quickly.

Tejun, can you back off this commit now given it seems nobody is trying =
to rescue it?

