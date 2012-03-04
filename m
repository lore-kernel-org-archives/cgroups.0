From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/3] cgroup: add xattr support
Date: Sun, 4 Mar 2012 10:05:16 -0800
Message-ID: <20120304180516.GB20787@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F4F1459.4080300@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6+1ab2nzgZoq01kmZWgR8wXo7JZIn9pFon/MB0Ww3SQ=;
        b=qljUAUhq1Xd8pUKSiQXsWlUlTDbH5I8AKjUpC3dGS8l8sLrqaTIxCNmwQZYsFayXcG
         VtWa/mtlTXUU56vkV8XqbRjfNzmKLvP/nggMElZNNIFg55VdqOdi/v/CwNBXVIWERHih
         lT3JwH/vBiugvPxk8EmeZEoQpjkHj6HAbhO+0ugWOk4WpewuenC/xpkA1cdsDDHww1II
         KapQpMzPU42VHf0MUjQb5nliuW0YxNN1bhEWyyTJ75Ex7yyBEANtr2aK2/oxxWLkLcBV
         w4M7iR2ZeZoAv5ZrTV/Tw9I4BbxelZXZvb1hPCtMae9BWNbJiOtw3E9zFvM8MtjpaOnD
         cYtg==
Content-Disposition: inline
In-Reply-To: <4F4F1459.4080300-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Li.

Sorry about the delay.  Was on vacation.

On Thu, Mar 01, 2012 at 02:16:57PM +0800, Li Zefan wrote:
> This can be used to attach metadata to a cgroup, which is required
> by systemd.
> 
> As lazy as I am, here just quoted from Lennart for the detailed use
> cases:

I much prefer this version but would prefer to deal with this in the
next merge window as we're already on rc6.  On a cursory look...

* I'm not sure kmem_ is a good prefix.  It sucks that xattr values are
  stored in kmem w/o size limit and we probably want to improve on
  both fronts in the future.  Wouldn't it be better to name them
  simple_*() and put them in fs/libfs.c?

* I don't think we want CONFIG option for cgroupfs xattr.  Let's just
  add a mount option.

Thanks.

-- 
tejun
