From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] capabilities: audit capability use
Date: Mon, 11 Jul 2016 13:09:37 -0400
Message-ID: <20160711170711.GB3337@htj.duckdns.org>
References: <1468235672-3745-1-git-send-email-toiwoton@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DahK5vWCVI+QVovZ5OZnNRhRQGkiB36NFSZiDGLjOMQ=;
        b=WyafTqjD45OWbmNqNZ4II21uDp7aD0GZaPSPrl67tu7vqdrFgiXAKPFitDB3JE1uRw
         jdj2oD5ugBFKpjnzslEt+VOSOIDiUoT0i50r2KX7SuIuEy0JeJ92TFTFuzWN0hyqYZAh
         P51OeRM3IxA10SIe21f1k+X83+Vom8IUng1Hr64eltxlMO8oBgBkcCP2OahqgyX4Wcth
         +cgootAsa9Ftl07f2WubaU88K5oWOSZGMb45CkHJFLriKE0QKodlvqLiXRXn0o7Uxt2x
         jkA+N0Fs0nvsdQaojRYm9Ebn9q8uzq49k3KxORTlOP0ghFVmjm3pKlPaVu9omYoT24um
         9Jsw==
Content-Disposition: inline
In-Reply-To: <1468235672-3745-1-git-send-email-toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, mladek-IBi9RG/b67k@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "moderated list:AUDIT SUBSYSTEM" <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CAPABILITIES" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Mon, Jul 11, 2016 at 02:14:31PM +0300, Topi Miettinen wrote:
> [   28.443674] audit: type=1327 audit(1468234333.144:520): proctitle=6D6B6E6F64002F6465762F7A5F343639006300310032
> [   28.465888] audit: type=1330 audit(1468234333.144:520): cap_used=0000000008000000
> [   28.482080] audit: type=1331 audit(1468234333.144:520): cgroups=:/test;

Please don't put additions of the two different audit types into one
patch and I don't think the cgroup audit logging makes much sense.
Without logging all migrations, it doesn't help auditing all that
much.  Also, printing all cgroup membership like that can be
problematic for audit it can be arbitrarily long.

Thanks.

-- 
tejun
