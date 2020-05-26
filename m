From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Remove stale comments
Date: Tue, 26 May 2020 13:20:37 -0400
Message-ID: <20200526172037.GC83516@mtj.thefacebook.com>
References: <0ce73f20-6b19-38c7-81c5-b0b71013fcb7@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5UGKXExeW+nhU16EFqfK9RzsDWq/8Qsk6MN8cmfOs4Q=;
        b=fXVsQMGLbf3AGbHuPnQtv+E7wUV4PZgjmSB3XiMW5ldzvsV92NRJW0zZtBOWLkeWxg
         itvONAkOSfEdL3l2EReMxObAhPx0DcObj7M8JTns9pgVP0V61MG3hM55v+dwzjjuMo01
         zalrBdHDedUYhutoQlCSWg1o4Wc4WAlZgmbmXVbkZXBA1ELtSJ45Y5u/0fctnVJam8NM
         IATgAm6VsAqHaPRC/MtWQTdDMcNPcDBMzHm7bfXZsW2IOHYLh4Dbu4bjtdYoEIXvjk9P
         4rlmEoAjHS9+4V6WynMOk5TqiUnjVSE14QWM/3stzi476R5dxuxz1XjoygTNE2vP/XWd
         3n8w==
Content-Disposition: inline
In-Reply-To: <0ce73f20-6b19-38c7-81c5-b0b71013fcb7-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, May 13, 2020 at 10:13:11AM +0800, Zefan Li wrote:
> - The default root is where we can create v2 cgroups.
> - The __DEVEL__sane_behavior mount option has been removed long long ago.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.8.

Thanks.

-- 
tejun
