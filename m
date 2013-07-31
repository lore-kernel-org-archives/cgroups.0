From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 5/5] cgroup: remove struct cgroup_seqfile_state
Date: Wed, 31 Jul 2013 07:36:19 -0400
Message-ID: <20130731113619.GL2810@htj.dyndns.org>
References: <51F8DA99.3010303@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iAWkRcUd8i4+jT3i9sz6T1ig4usdNEwd/cVsw8Z2y8Y=;
        b=dQsZDngjN0RSMoWQcYrJRQdVNGFUEGzRgZ91YHUNkFWgg28u/HYa6oJYZTbViSA0gX
         Md4b+/f8wc4JJ4Fq6r7d+T71NZcFwWQULVhQZhWOuWxPSlrciImVZeH7SfTNUMjPvwAf
         A0E56csnmZXMygS4ndT7O4/H0niaptPkoe89KUs43iLzEqvnyWE/5ZPoBhFDv7HM+9y6
         wp2y969XaCoUnnRrPZYgRyQ7pcyrJ2rtb/Y+xC3yRgF5sHm/eBr3wsQreUVtyEWWAsJF
         l8XhjJcMXJOg+8BersU97NgWCqtSJsBOmJPW/Aj/uWiJktjDLQRYC6JH2XT4P2CSYCtN
         vlDA==
Content-Disposition: inline
In-Reply-To: <51F8DA99.3010303-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 31, 2013 at 05:36:25PM +0800, Li Zefan wrote:
> We can use struct cfent instead.
> 
> v2:
> - remove cgroup_seqfile_release().
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to libata/for-3.12.

Thanks.

-- 
tejun
