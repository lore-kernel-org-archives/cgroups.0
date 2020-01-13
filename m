From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 00/10] per lruvec lru_lock for memcg
Date: Mon, 13 Jan 2020 12:20:48 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2001131157500.1084@eggly.anvils>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com> <20191231150514.61c2b8c8354320f09b09f377@linux-foundation.org> <944f0f6a-466a-7ce3-524c-f6db86fd0891@linux.alibaba.com> <d2efad94-750b-3298-8859-84bccc6ecf06@linux.alibaba.com>
 <alpine.LSU.2.11.2001130032170.1103@eggly.anvils> <24d671ac-36ef-8883-ad94-1bd497d46783@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1359013247-1578946865=:1084"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=bIaxZyK0QJpQTL/WgrEd8VP6JHOxc9uUiVT69OkfGfs=;
        b=Cho5Xgy5zKREtQuKz+/bSZ0g+gIyHdz2p24Yfmsxr7CAccjr5kcYpqbgOvKvI1tvOi
         0Pw3+2nxm7aPkD+pmpl/OIX7moakvPw2GOjM30vb5vz5mSO0dN7irc5zX92k8ZNLh5FZ
         C+9K7yYtuDy4lOut09g3xyF2lbu0OFZDC34OWJr2lBCTa1hJaiygNIy2lV4Jj8HzXOkA
         lE1ma7JDpwMYDBQyQSniSv3xsKGxjIIbQCruULLZa0ItRSSKET5yRX8Vl3N174N8zYr1
         Ixn4VH4adsnqXjKH5qgXYxbPbyK5p0X3/nAOowu2RukAy8WC22V/2K4DHpY87DfNUPGr
         zJDw==
In-Reply-To: <24d671ac-36ef-8883-ad94-1bd497d46783-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1359013247-1578946865=:1084
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 13 Jan 2020, Alex Shi wrote:
> =E5=9C=A8 2020/1/13 =E4=B8=8B=E5=8D=884:48, Hugh Dickins =E5=86=99=E9=81=
=93:
> >=20
> > I (Hugh) tried to test it on v5.5-rc5, but did not get very far at all =
-
> > perhaps because my particular interest tends towards tmpfs and swap,
> > and swap always made trouble for lruvec lock - one of the reasons why
> > our patches were more complicated than you thought necessary.
> >=20
> > Booted a smallish kernel in mem=3D700M with 1.5G of swap, with intentio=
n
> > of running small kernel builds in tmpfs and in ext4-on-loop-on-tmpfs
> > (losetup was the last command started but I doubt it played much part):
> >=20
> > mount -t tmpfs -o size=3D470M tmpfs /tst
> > cp /dev/zero /tst
> > losetup /dev/loop0 /tst/zero
>=20
> Hi Hugh,
>=20
> Many thanks for the testing!
>=20
> I am trying to reproduce your testing, do above 3 steps, then build kerne=
l with 'make -j 8' on my qemu. but cannot reproduce the problem with this v=
7 version or with v8 version, https://github.com/alexshi/linux/tree/lru-nex=
t, which fixed the bug KK mentioned, like the following.=20
> my qemu vmm like this:
>=20
> [root@debug010000002015 ~]# mount -t tmpfs -o size=3D470M tmpfs /tst
> [root@debug010000002015 ~]# cp /dev/zero /tst
> cp: error writing =E2=80=98/tst/zero=E2=80=99: No space left on device
> cp: failed to extend =E2=80=98/tst/zero=E2=80=99: No space left on device
> [root@debug010000002015 ~]# losetup /dev/loop0 /tst/zero
> [root@debug010000002015 ~]# cat /proc/cmdline
> earlyprintk=3DttyS0 root=3D/dev/sda1 console=3DttyS0 debug crashkernel=3D=
128M printk.devkmsg=3Don
>=20
> my kernel configed with MEMCG/MEMCG_SWAP with xfs rootimage, and compilin=
g kernel under ext4. Could you like to share your kernel config and detaile=
d reproduce steps with me? And would you like to try my new version from ab=
ove github link in your convenient?

I tried with the mods you had appended, from [PATCH v7 02/10]
discussion with Konstantion: no, still crashes in a similar way.

Does your github tree have other changes too?  I see it says "Latest
commit e05d0dd 22 days ago", which doesn't seem to fit.  Afraid I
don't have time to test many variations.

It looks like, in my case, systemd was usually jumping in and doing
something with shmem (perhaps via memfd) that read back from swap
and triggered the crash without any further intervention from me.

So please try booting with mem=3D700M and 1.5G swap,
mount -t tmpfs -o size=3D470M tmpfs /tst
cp /dev/zero /tst; cp /tst/zero /dev/null

That's enough to crash it for me, without getting into any losetup or
systemd complications. But you might have to adjust the numbers to be
sure of writing out and reading back from swap.

It's swap to SSD in my case, don't think that matters. I happen to
run with swappiness 100 (precisely to help generate swap problems),
but swappiness 60 is good enough to get these crashes.

Hugh
--0-1359013247-1578946865=:1084--
