From: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: use uninitialized_var() for may-be uninitialized variable
Date: Tue, 22 Apr 2014 15:52:34 +0800
Message-ID: <CAHz2CGU53gq_ouB-0M9bOJjW0FWHSzeT3ju8Y7oMsnsQJjXLWA@mail.gmail.com>
References: <1398145479-11400-1-git-send-email-nasa4836@gmail.com> <53560BA3.40501@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=98hPgeKdTqkVcFaOPkwQJaMBCYZQLcWGyQop4V3PJ1I=;
        b=N0i1dOWWcWrgqnUelsYDLHI6k9N1wBv4fPkie7rM5e437p6WJyfsVGTiuy2sM6nfjk
         MUPV4m8H2doxKeX/IVugQ80kBZBbibLoMS7JkgbPjTXf5br00ADczB421LNDoPL1ndg3
         1b7q0F3/KLR4wvUU6wOLFdop/6kpT5n4aQJHaw47arhuk3RkkltrYm4l4lxTzOnqFAlC
         kwTOSDRZhO4tb2Q8L+fwBinXlf3hWWg6Gb1wR2XbaAOJF428+IizjLIDRi96E5BvJKGZ
         UjrvPupURmaHJF6deHMrgmwtt5UplYItWHJiEygH8Tj0FgRm/scdh1BnHtanZPBIJvbX
         aH5A==
In-Reply-To: <53560BA3.40501-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi, Li,


On Tue, Apr 22, 2014 at 2:26 PM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> I don't see this warning, and I don't see how this is possible.

You are right.  No such warning.
It is triggered by the other patch, should be fixed in that patch.



Thanks,
Jianyu Zhan
