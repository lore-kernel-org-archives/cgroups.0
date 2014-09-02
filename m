From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: Delay the clearing of cgrp->kn->priv
Date: Tue, 2 Sep 2014 11:33:01 -0400
Message-ID: <20140902153301.GA17424@htj.dyndns.org>
References: <5405A27A.3090605@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=V5BOBHywZWO1UIoM7Ok63l7HIccjv0oHZ+y3r9caczo=;
        b=SAZUIqzOlzycruQ7mrLZPXnoyXlIwzW55eFZSOvtXjLsEOgWGOjKlETJNvC9XGdnZ3
         ZvGApx6azcueNCwkt2mj1vsQ0lfpQplQs2tmHPGqoebMaVwisNlaE8NdRqKkChWHxdWv
         lizxbTGee4pfHyCXFIeYauUVuDyxN0WVYQE+mLeaKIJCwi5ySURyUi/bd1cv2MZ5T1yE
         wK3p4jt5CynBib+7FHxL/a+pt8IqqhnJtIFG4dDNLhYNUeoqBKXOKmvzmxWzRteXwxdl
         y/RxbwsbtMwxQ94P/a3xf10yN/Z8P79xFrrD9nHi8SfVekukx+LG+Ju/nmTW7a2nHwvH
         27jQ==
Content-Disposition: inline
In-Reply-To: <5405A27A.3090605-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Tue, Sep 02, 2014 at 06:56:58PM +0800, Li Zefan wrote:
>     for ((; ;))
>     {
>         echo $$ > /cgroup/sub/cgroup.procs
>         ech $$ > /cgce 6f2e0c38c2108a74 ]---
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
          copy & paste error?
=2E..
> Reported-by: Toralf F=F6rster <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>=20
> Toralf, Thanks for reporting the bug. I'm not able to repy to your em=
ail,
> because I was kicked out of the cgroup mailing list so didn't receive
> emails from mailing list for a week.
>=20
> ---
>  kernel/cgroup.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>=20
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 1c56924..e03fc62 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4185,6 +4185,15 @@ static void css_release_work_fn(struct work_st=
ruct *work)
> =20
>  	mutex_unlock(&cgroup_mutex);
> =20
> +	/*
> +	 * There are two control paths which try to determine cgroup from
> +	 * dentry without going through kernfs - cgroupstats_build() and
> +	 * css_tryget_online_from_dir().  Those are supported by RCU
> +	 * protecting clearing of cgrp->kn->priv backpointer.
> +	 */
> +	if (!ss && cgroup_parent(cgrp))
> +		RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);

Can we move the above into the preceding else block?  I don't think
holding cgroup_mutex or not makes any difference here.  Also, why do
we need the cgroup_parent() check?  Do we deref root's kn->priv in the
destruction path?  If so, can you please note that in the comment?

Thanks.

--=20
tejun
