From: Zhan Jianyu <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: print pretty format in /proc/cgroups
Date: Tue, 15 Apr 2014 20:55:31 +0800
Message-ID: <CAHz2CGXimrWPjOshDDbJ2xjuFgzYxEOm43w+zmfXXqxxLSwGsA@mail.gmail.com>
References: <1397566065-3028-1-git-send-email-nasa4836@gmail.com> <20140415125111.GG1863@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=cVP8sIqQFgrjfHWc5sx5IxSR2G5cp608AM+Rqt2N/oM=;
        b=XzxxYW/8WiC8DmBd66xVdH9exaLGEE28OQrqud8ocB9E8ObVpD4fuK0w7V2QxuLQT8
         T06ih17XjddzZL1LaNS5uCiTQaeQSc7FdGolR5d8Glr2Rbj7zIe3CKmwFYO685P86Zh8
         aiXXTY6BlYFwWhxegTWn59mPj6OoJm79oUjIXiQ2u8SfdNJYLppJxT68MILOweouCJAA
         6HG7kiVDex/YE8a10iBy+xIKf1VU73lE3DTZUVab+C+WX8jQwtL6dpSjgZpVHP89CeAt
         tH5sduXnSVLlqZ6Xb7p+zizMgL5k0E1eGy94OcyV1rWBo0CLdAU5MCw3AbF8aChaN/7m
         vY9A==
In-Reply-To: <20140415125111.GG1863-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Apr 15, 2014 at 8:51 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> The problem there is that there could be programs / scripts parsing it
> assuming single tab between entries.  It surely is ugly but do we
> care?

Oh, you are right. It is an exposed user interface. This will make lots of
administrator unhappy ;-(

Thanks,
Jianyu Zhan
