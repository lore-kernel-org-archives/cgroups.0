From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/2] cgroups: add documentation on extended
 attributes and simple_xattr functions
Date: Tue, 11 Sep 2012 14:31:33 -0700
Message-ID: <20120911213133.GE7677@google.com>
References: <20120911202809.988739953@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=bDhmwmvAJBT3N+U1qwUv/sVgQXwqVtyxIKsg9C59CKQ=;
        b=PHMY3Kcb/qMO2zmsD9efXZLqd+g2HRj/C64H4whDkELRaXLec9y/j70+O0U0C7h6e6
         w8jH3IxEBpaEv++/ZIx7/RGiqozCQ4C4B1pM59DPwv2q9oEML9GPVfu/IECRzpjfIrpK
         hscXNuSK/fn7ezKbTYBpNy1d/CwR0ClBlEEdrbIJWkxm4X1guzCcOIWK6pNfemPNtenE
         O74jRLqHpUwsuFz4P9lKimmuI9tR10BkWn1e4/YBCpThezYkp+oII40ZHhmoc22aGutw
         SLmr2GD9NJrQmtfsMpj3ghQx5TBnQ6HdCfxz/XWszXZMlugr4DJ8c+D1YAekf6jHH8Ar
         10aw==
Content-Disposition: inline
In-Reply-To: <20120911202809.988739953-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Sep 11, 2012 at 04:28:09PM -0400, Aristeu Rozanski wrote:
> cgroups: add documentation on extended attributes and simple_xattr functions
> 
> These patches add documentation on the new functions and current specific
> cgroup usage.
> 
> v2: include Li Zefan's requested changes

Applied to for-3.7.  Thanks!

-- 
tejun
