From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: Question about disallowing rename(2) in cgroup v2
Date: Fri, 15 Jul 2022 14:45:38 +0200
Message-ID: <20220715124538.GB8646@blackbody.suse.cz>
References: <1c9d5118-25fa-e791-8aed-b1430cf23d36@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657889139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZa4+jMpT3rkbUbFtzmtQFirgHMD5Uw1UtC1qekP12c=;
        b=H/DS2GYvkohsGsKHCbE2JLE/fFca54l4n/YuYnlwfn7LbkXkOfRLUSOVMtiWaF2+M2ap9p
        PGgCQW4eGeRbY0Rr2U62vWbmYtwaXYpW2IqdNxA55FmUBpznKKthHc0YqBcd3QNHaOs/e/
        wZgU2xHoStzDXp+AVK8+/kgt3ZgDup4=
Content-Disposition: inline
In-Reply-To: <1c9d5118-25fa-e791-8aed-b1430cf23d36-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "taoyi.ty" <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Escape.

On Tue, Jun 28, 2022 at 09:09:48PM +0800, "taoyi.ty" <escape-KPsoFbNs7GizrG=
E5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
> I found that rename(2) can be used in cgroup v1 but is disallowed in cgro=
up
> v2, what's the reason for this design?

There's some info in the commit 6db8e85c5c1f89cd0183b76dab027c81009f129f.

> rename(2) is critical when managing a cgroup pool in userspace, which uses
> rename to reuse cgroup rather than mkdir to create a new one=EF=BC=8C

Strictly speaking, it's not critical if you decouple your job and cgroup
naming scheme (i.e. use the cgroup with the old name).

> this can improve the performance of container concurrent startup,
> because renaming cgroup is much more lightweight compared with
> creating cgroup.

Do you have some numbers for this?
You can save work with not rmdir/mkdir'ing but you mention
concurrent startup specifically. And you still need to (re)setup
the cgroups after reuse and that also isn't parallelizable (at least you
need to (re)populate each reused cgroup, which is mostly under one
lock). (Even cgroup1_rename() has an exclusive section under
cgroup_mutex but it looks relatively simply.)


Michal
