From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: legacy mode
Date: Thu, 27 Aug 2015 16:27:22 -0400
Message-ID: <20150827202722.GH26785@mtj.duckdns.org>
References: <20150827202137.GA4221@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jmJ5/apcEwdXLz5cfZljVDKCHJLVFht8cUtcoFAOM9g=;
        b=Ri9B7KszUk9ZGO3S8ZXMfCu3/Vj7DjJnh5Ye5RElnSWEJp4IIZ+/KDDb2cjcfBRoMw
         wkzJUdZpkd4pPVCejiUVctZMg/CV24MyIpRfuwk6yFSehPTnMGG6bvoiLe0230miOArW
         50GoydGuK959FI27gQk0DMLFfMAhXXq/sXrV6+zb0ckDgDs5/Pm1BFDqKru+RuTzNeWA
         a50qmtDBV4yutzAHxqrG08CqeX9er0szGqdx2FfG2F1b9peESre2pE8A6bap4fGeAQy0
         QOZJdlrBDVE+l85g1LQ92gVxa2zwCNGS3zpbdqtjGXOv3Ai6x/5aHZhpKg6+9dKU0Qyo
         a1HQ==
Content-Disposition: inline
In-Reply-To: <20150827202137.GA4221-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Aug 27, 2015 at 03:21:37PM -0500, Serge E. Hallyn wrote:
> The problem this would solve is running older userspace (i.e. libvirt in
> a container running an older distro) on a newer kernel which has unified
> hierarchy mounted.

But the leaf restriction isn't the only change.  The interface files
are different too and for some controllers the basic operation model
is different, so I don't see how just adding .leaf would do much good.

If the legacy userspace doesn't do any resource control, the leaf rule
restriction doesn't apply anyway, so nothing to worry about.

Thanks.

-- 
tejun
