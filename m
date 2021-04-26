From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 1/2] ipc sem: use kvmalloc for sem_undo allocation
Date: Mon, 26 Apr 2021 13:29:20 -0700
Message-ID: <YIcioHGrtjFHoDej@carbon.dhcp.thefacebook.com>
References: <e67f2a95-4b01-9db2-fe47-0b2210f0b138@virtuozzo.com>
 <722774d8-d46b-f8a6-a88e-3c56b4968622@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ry//vdskWCikoDYDP/MqQBfvu56aeeQCMaM0+qLdlI4=;
 b=KXyePZeIkiSeeSNIKpP3Q3TmZ6l0s+DpKJ0TB/y9AuzZzm1k1NgQFJHdoDEF6Cl/NsK9
 g8OXzSvkGU6SKJjtjwa2lEPVuTM2u9Syw9/I5JkgUypowxcuEIvOS+9/OJ5Nw3Xgb8Zn
 JcPIG3xJR4cxs9VH7YpBGNewnjY03dfuDNo= 
Content-Disposition: inline
In-Reply-To: <722774d8-d46b-f8a6-a88e-3c56b4968622-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Apr 26, 2021 at 01:18:09PM +0300, Vasily Averin wrote:
> size of sem_undo can exceed one page and with the maximum possible
> nsems = 32000 it can grow up to 64Kb. Let's switch its allocation
> to kvmalloc to avoid user-triggered disruptive actions like OOM killer
> in case of high-order memory shortage.
> 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
