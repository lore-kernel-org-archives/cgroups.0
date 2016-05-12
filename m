From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] kernel: cgroup: fix compile warning:
Date: Thu, 12 May 2016 11:04:49 -0400
Message-ID: <20160512150449.GQ4775@htj.duckdns.org>
References: <1463045678-32436-1-git-send-email-felipe.balbi@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Iiz1Kubxm2zTi8EtAz3v9fuFZ2uvUIWFISBqsyogpVk=;
        b=tEMh/1buwM1hdfV5A+hGtEgzAeQ4RtjZYw1p5aSwLE4/xLz+fXN+XBODkrvUb4Yigv
         tl8WU3nEgLCZOtOuCrJT1JVh/+OUbWND9PsEFfc+WJ1gMi1a8MFFrAxmblFwLQcPNFtd
         UqnRip1efT8AXZTGipTFWCVuiJWAvxO3tvx+Tc432YNgjkinPxzdZ8kQSpZLFwS8F94w
         t3kWEiVB1WFtlUghuySgyuBQp1Ogy2Hr9FfQNtbRHvpZewT5rKFXHRZ3XogBlapxapDg
         5xXw/kHP046FX+wG/gNuBsOzv+qcu7KBCx0MGq2xGLp25Q3hED+t81NnGA88pXYBl4LI
         8ieA==
Content-Disposition: inline
In-Reply-To: <1463045678-32436-1-git-send-email-felipe.balbi-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Felipe Balbi <felipe.balbi-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 12, 2016 at 12:34:38PM +0300, Felipe Balbi wrote:
> commit 4f41fc59620f ("cgroup, kernfs: make mountinfo
>  show properly scoped path for cgroup namespaces")
>  added the following compile warning:
>=20
> kernel/cgroup.c: In function =E2=80=98cgroup_show_path=E2=80=99:
> kernel/cgroup.c:1634:15: warning: unused variable =E2=80=98ret=E2=80=99=
 [-Wunused-variable]
>   int len =3D 0, ret =3D 0;
>                ^
> fix it.
>=20
> Fixes: 4f41fc59620f ("cgroup, kernfs: make mountinfo
> 	show properly scoped path for cgroup
> 	namespaces")
> Signed-off-by: Felipe Balbi <felipe.balbi-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Applied to cgroup/for-4.6-fixes.

Thanks.

--=20
tejun
