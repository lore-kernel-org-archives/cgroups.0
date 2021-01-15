From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: Remove unnecessary call to strstrip()
Date: Fri, 15 Jan 2021 10:19:25 +0800
Message-ID: <CA+PpKPnmzzdH4Wbb5LWT0+cjbS9=cwcxuPRMHf7GuukWdTfVuA@mail.gmail.com>
References: <20210103024846.GA15337@haolee.github.io> <YAA8qyBUAurgCeEz@blackbook>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fI/1lXfnira7lqXCcxJnPYuJ/g5t5oZZRm+ZWpb4+FI=;
        b=VGOuUg1lWUtN6AREorPyWbQWKGBcytb/F+GaLsKenHyIPlKz+HUKMT4Kl4Sge2dUhU
         XDNiOD0jPt6rr8C4CQXlUqloEimlDqMXEXjAeGQcC4Mi9pvz2iAcvpwxXsf3RoarjE9g
         +nMD/72CnC2OUF7s+FLt6PGhxn+wwoM3/vQdujxJtk8wq0a7ZSfkuch8wQrI+asDCEw6
         mUVOzy/QttEfGvP0E9sY5arphfqahtgBM15jB9KRzqTMJLlCC2Qcnt0Wq3MI/7NflSOI
         055r+5Rb0saSZyD2c/kNmdFKtGwkEVQCyH3zEsKJed0QYiGMO0fERnbthvJYK9O07bIO
         bNdA==
In-Reply-To: <YAA8qyBUAurgCeEz@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> Perhaps the code be then simplified a bit
>
> -- >8 --
> From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
> Date: Thu, 14 Jan 2021 13:23:39 +0100
> Subject: [PATCH] cgroup: cgroup.{procs,threads} factor out common parts
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>
> The functions cgroup_threads_start and cgroup_procs_start are almost
> identical. In order to reduce duplication, factor out the common code in
> similar fashion we already do for other threadgroup/task functions. No
> functional changes are intended.

Nice work. I didn't realize this simplification :)

Regards,
Hao Lee
