From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 4/9] devcg: expand may_access() logic
Date: Tue, 29 Jan 2013 11:47:08 -0800
Message-ID: <20130129194708.GE6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.857103871@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=fFWeb8cW3BzjXZFB0svb9qpsvs2MhZXbfXiUFdoOHKc=;
        b=rHAXeP17sVZ3jMnZmG2IFc5LOtcANJKKu0oKFiBEH6EXqIExdFC4U65bZfqYB7o35L
         D9FYwOGKKujSHbV8YJr/2/KF17X9AHtglNVrWD4S6lbVC+OK9FY9MiNw8QAksereGMJD
         bPO1DtwyPWJh+VAYZHZmbsa7aMl8538N0uMLxpTzX3oGiu4vbClHgHrxjDS579IOe03H
         8zdFpn5jR5klu29h/guJk5jf2dFGRX2+sbAA6ThyZ5duGzGZmoLB6QV0qYhUj0QAKDLW
         RhXcCam7vOFpilgtluvKutvJX8tNbY3p2PnnjBBDWR7sICgfN1j+609DvBywT43R9g5L
         tE2g==
Content-Disposition: inline
In-Reply-To: <20130129190759.857103871-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Jan 29, 2013 at 02:08:03PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> In order to make the next patch more clear, expand may_access() logic.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Maybe convert the function to return bool while at it?

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

-- 
tejun
