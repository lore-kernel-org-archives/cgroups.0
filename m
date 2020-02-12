From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] cgroup/pids: Separate semantics of
 pids.events related to pids.max
Date: Wed, 12 Feb 2020 18:03:07 -0500
Message-ID: <20200212230307.GB88887@mtj.thefacebook.com>
References: <20191128172612.10259-1-mkoutny@suse.com>
 <20200205134426.10570-1-mkoutny@suse.com>
 <20200205134426.10570-2-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=h0k/SZhy37SnuN8KJidHabKu5pvAsxYyNUGMmuRSfDg=;
        b=tftmUFzF0KyV09ppAzS+euVqTcoxJSUxBn+2PzjFhtOrQnhrlkLo7hs/q/cj7aLfKG
         vHyAYb64po/qFI9SgO7D2JRpddg/qxZleL5GPfdLH8ZHbm1sRMJp92aBI1/dwLNfIKZH
         kq9qtNIKy8tSXfaYHBpczb0volZ3yx0mgw/5bYX17wqE5qfrc/DXG0c4t5y59BSXWhkT
         dEgxxKVyXS8PJDhVnw3G5mn6RYVtlbMolwloM0KjLKS36shfX52NeoBdOBvIucejJeLv
         bPtRu9V5A1wqcsPkrBRlQEIimcLJNa4anWWLPYkTCfCRi2cPvaZqHuoh/moejqJMgK/9
         MX9A==
Content-Disposition: inline
In-Reply-To: <20200205134426.10570-2-mkoutny-IBi9RG/b67k@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 05, 2020 at 02:44:24PM +0100, Michal Koutn=FD wrote:
> Currently, when pids.max limit is breached in the hierarchy, the event
> is counted and reported in the cgroup where the forking task resides.
>=20
> This decouples the limit and the notification caused by the limit making
> it hard to detect when the actual limit was effected.
>=20
> Let's introduce new events:
> 	  max
> 		The number of times the limit of the cgroup was hit.
>=20
> 	  max.imposed
> 		The number of times fork failed in the cgroup because of self
> 		or ancestor limit.

Can you please follow the same convention as memory.events and
memory.events.local?

Thanks.

--=20
tejun
