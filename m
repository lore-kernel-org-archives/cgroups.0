From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/7] cgroup: fix a leak when percpu_ref_init() fails
Date: Wed, 31 Jul 2013 06:14:18 -0400
Message-ID: <20130731101418.GB2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C7DC.8060306@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xzt2lJQPvnger1pZC/l8iPHYfOEKG9ydnaBj08D+crc=;
        b=ztvzUcJ0Eu19WX7A5TxdoAQ2Wk76Slh1L4DCsCr4pynfXhLX+xbPSNwLFAkrQqT9pr
         GL0Bfaa07dnSMSfR73/aNodTPbwSsGrAflXGh6O20PyMmKgv5hb7ScqFM4naBY8EC4Ge
         aAeWNCGhWPaqc1XXaU9+wF/RMOTskTB7lxugZ/FEEWfS+WiAByKGJcP3eco/MYCAW+u7
         0DVpUgF2eAjrPMdTCW45LVssMY6DzM08KPkzdh5J+8I7mVwNupglrRojd5XoMaXoW2qV
         nG6U8fWMYoZ7sAsI5tb4Sj8mTp++UMzUNjt1BOxfQKeZ1RwG+j+OK1ZDiCTWGK4cG8Z6
         Cc0Q==
Content-Disposition: inline
In-Reply-To: <51F8C7DC.8060306-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 31, 2013 at 04:16:28PM +0800, Li Zefan wrote:
> ss->css_free() is not called when perfcpu_ref_init() fails.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.11-fixes.

Thanks.

-- 
tejun
