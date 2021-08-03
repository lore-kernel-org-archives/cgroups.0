From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/5] mm, memcg: narrow the scope of percpu_charge_mutex
Date: Tue, 3 Aug 2021 09:27:52 +0200
Message-ID: <YQjv+DzdX3CuVfIo@dhcp22.suse.cz>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-3-linmiaohe@huawei.com>
 <YQNsxVPsRSBZcfGG@carbon.lan>
 <YQOhGs3k9rHx3mmT@dhcp22.suse.cz>
 <4a3c23c4-054c-2896-29c5-8cf9a4deee98@huawei.com>
 <YQi6lOT6j2DtOGlT@carbon.dhcp.thefacebook.com>
 <95629d91-6ae8-b445-e7fc-b51c888cad59@huawei.com>
 <YQjsHTW+46bG9XsV@dhcp22.suse.cz>
 <898130C3-FDF2-41C2-81DD-D33721C977C6@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627975674; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wuIGTu+T5iM4gV2NreSfqAlufJJUZ957ha88L+oyogc=;
        b=ffPnT6IT5q1xKUJXVgjcL901Ov2a69NYiPyHx1+Bs4Cbr4VGwvsntpN35cb37aoIkc3Ve7
        XCP50BxcQfHCaDDVkfzq2BtntlqQVlQJxBA6jMJ8GH4XRw8lbKAoPq8r0B4SWLIiS5PFQ1
        Mc+vR8f9wGNEVeByrJnEV2bgBgs2Z6I=
Content-Disposition: inline
In-Reply-To: <898130C3-FDF2-41C2-81DD-D33721C977C6-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue 03-08-21 07:13:35, Roman Gushchin wrote:
> I=E2=80=99d go with atomic_dec().

which is not implying memory barriers either. You would need
atomic_dec_return or some other explicit barrier IIRC.
--=20
Michal Hocko
SUSE Labs
