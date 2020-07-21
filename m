From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: PROBLEM: cgroup cost too much memory when transfer small files
 to tmpfs
Date: Tue, 21 Jul 2020 13:41:26 -0400
Message-ID: <20200721174126.GA271870@cmpxchg.org>
References: <2E04DD7753BE0E4ABABF0B664610AD6F2620CAF7@dggeml528-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iXpIXavlE/ZwGIdQyg7+BwcjDDLZaRfVGWyFGkObed4=;
        b=0zguSQRpifWOIMc3Wxbvdk6Bwwn9eip+C034+tkTuBiaMTd1zFjdRoq+3omx245Aa4
         DZQGmwSGRpqWcyMnsjpDTupp7W5/t7+i65WcuXWio/xYmvM2eFB5Gs0/xWXYIa0nNvnp
         Z+kFKIXI/Twm0g0qpTVJcdRYzmdtv4LO+2463GownoC4rx5Wz05xJ0t5s0YL9Ibdqury
         jIAzJ0f7OdzeN7hMBcGhP25hDNUuULtxA07UfeyertHuveci290NT2L0Falns7sr1XN0
         82pwykAKX3K75CZfB+/1uJ4E2Cf3ywWAfZNDPzzqoKiTM6V4aHDgbcyTwASq7WP5g/cV
         1P4w==
Content-Disposition: inline
In-Reply-To: <2E04DD7753BE0E4ABABF0B664610AD6F2620CAF7-vMFu1QFWtjo1LvNSbZiozgK1hpo4iccwjNknBlVQO8k@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: jingrui <jingrui-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lizefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, caihaomin <caihaomin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Weiwei (N)" <wick.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, guro-druUgvl0LCNAfugRpC6u6w@public.gmane.org

On Tue, Jul 21, 2020 at 11:19:52AM +0000, jingrui wrote:
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> ; Mi=
chal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Vladimir Davyd=
ov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> Thanks.
>=20
> ---
> PROBLEM: cgroup cost too much memory when transfer small files to tmpfs.
>=20
> keywords: cgroup PERCPU/memory cost too much.
>=20
> description:
>=20
> We send small files from node-A to node-B tmpfs /tmp directory using sftp=
. On
> node-B the systemd configured with pam on like below.
>=20
> cat /etc/pam.d/password-auth | grep systemd
> -session=A0=A0=A0=A0 optional=A0=A0=A0=A0=A0 pam_systemd.so
>=20
> So when transfer a file, a systemd session is created, that means a cgrou=
p is
> created, then file saved at /tmp will associated with a cgroup object. Af=
ter
> file transferred, session and cgroup-dir will be removed, but the file in=
 /tmp
> still associated with the cgroup object. The PERCPU memory in cgroup/css =
object
> cost a lot(about 0.5MB/per-cgroup-object) on 200/cpus machine.

CC Roman who had a patch series to free all this extended (percpu)
memory upon cgroup deletion:

https://lore.kernel.org/patchwork/cover/1050508/

It looks like it never got merged for some reason.
