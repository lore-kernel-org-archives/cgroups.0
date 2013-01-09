From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3.4 0/2] 2 bug fixes for the 3.4 cgroup code
Date: Wed, 9 Jan 2013 06:38:50 -0800
Message-ID: <20130109143850.GG3926@htj.dyndns.org>
References: <1357733486-1742-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=517evANIwb0rVqEqcUmNeQyRYbJ85zu+5habPFfVPoo=;
        b=PkTZl7TAV1MENnmIBCxB4bf2/ln990O+V1vaNkxcQPZ1++blCJHm8O/7uzhio2zsH6
         Wi+hPpER34CBEn+qbSB9XW0MsF9ip4IEH5X4FE8oTrSbW1o2tcDwsuiEIJfFW3VM+kCB
         88koql3WiLtMpkKMMPJaWgii9d3x9V9ZOfRExItYAD2/bpcpPfjfhd+7mP4lIBszbNlS
         VbbVxQoLi9feCb8W0TR85UfmVGvxO0in/ei7luFOC5jrKlq2d+qzHKgAptOJQoy5YAQQ
         QFHNistpta60d83dQjzv9BhPAjUNs5XDk/7dbQ1Mc0Gj0MHAZPPsi3gsgk439dsSEIlb
         3R5g==
Content-Disposition: inline
In-Reply-To: <1357733486-1742-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Hans.

On Wed, Jan 09, 2013 at 01:11:24PM +0100, Hans de Goede wrote:
> Allthough I know everyone dislikes looking back at old code once it has
> been rewritten in a better fashion, I hope you are still willing to make
> some time to review these 2 simple patches, as a first step in getting
> them into 3.4.xx.

Well, the problem is that -stable doesn't take any patch which isn't
already upstream, so with upstream already diverted from the 3.4 code
base, there isn't any way to feed these patches to -stable.

Thanks.

-- 
tejun
