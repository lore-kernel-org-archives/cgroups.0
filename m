From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Fri, 10 Sep 2021 10:16:46 -0700
Message-ID: <CAHVum0ezWW=4x2YgXHhEUFQOkFGBpP+R1Uc-KedHr+r0LGibwA@mail.gmail.com>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com>
 <20210909143720.GA14709@blackbody.suse.cz> <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA@mail.gmail.com>
 <YTpY0G3+IJYmGbdd@blackbook> <478e986c-bc69-62b8-936e-5b075f9270b4@gmail.com>
 <20210910092310.GA18084@blackbody.suse.cz> <1679f995-5a6f-11b8-7870-54318db07d0d@gmail.com>
 <20210910153609.GC24156@blackbody.suse.cz> <YTuH9fULTx+pLuuH@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nVQhctFDZ494oNwBH6gZ4cbrFJOKVOXq8XesRbY6VI8=;
        b=X3ZeLOv7Q89I9RQFoFeRBRpC6KFK599HOifkIv4mt+CDHlTcxp+0UZzQfGIac7s/WU
         su9klzfHpoo2JCuO5V6sdmD9Pjv0Son2DzEwAUYK1Fb8fESck+P/K3BB3zpVFrrzbqoq
         fWiP8VjGyW5ujY+25dO79xLu0fCjv0GYy1PM7qxJAFJmxBfOetkWzo/gjjGwE3rxVHqq
         CoLWcgmrUkPIZI87CrcDasqd8fwS5E5jtPfD9rUiYU7zpGP7aHBwySf4Ahj2YzofjZT3
         sXJTf1zEDcGFkN25gOgJHiiScjdCRPauxVCQ+ZXyuaflxySs2RuMdOyrppCWX6Yp1rkc
         Zjcw==
In-Reply-To: <YTuH9fULTx+pLuuH-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "brookxu.cn" <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 10, 2021 at 9:29 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, Sep 10, 2021 at 05:36:09PM +0200, Michal Koutn=C4=B1 wrote:
> > If there's a limit on certain level with otherwise unconstrained cgroup
> > structure below (a valid config too), the 'fail' counter would help
> > determining what the affected cgroup is. Does that make sense to you?
>
> While the desire to make the interface complete is understandable, I don'=
t
> think we need to go too far in that direction given that debugging these
> configuration issues requires human intervention anyway and providing
> overall information is often enough of aid especially for simple controll=
ers
> like misc/pid. So, let's stick to something consistent and simple even if
> not complete and definitely not name them "fail" even if we add them.
>

I understand what Michal is proposing regarding fail vs max and local
vs hierarchical. I think this will provide complete information but it
will be too many interfaces for a simple controller like misc and
might not even get used by anyone.

Chunguang's case was to avoid printing so many messages, I agree we
should remove the log message and add a file event.

For now, I think we can just have one file, events.local
(non-hierarchical) which has %s.max type entries. This will tell us
which cgroup is under pressure and I believe this is helpful.

Regarding the original cgroup which started the charge should be
easier to identify because those processes will not be able to proceed
or will use some alternate logic, and the job owner should be able to
notice it.

If in future there is a need to find the originating cgroup we can
resume this discussion during that time.
