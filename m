From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] block: modularize blkcg config and stat file
 handling
Date: Mon, 2 Apr 2012 15:33:04 -0700
Message-ID: <20120402223304.GC21017@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <4F741AED.6090901@kernel.dk>
 <20120402200233.GB17175@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F7A1F52.50706@kernel.dk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Ug3/t++LNvgpHR81WW6ahr1FyIaFLCD5bnW4EUodG+g=;
        b=PBXqgKOAM/+uy2q+fStqc8XamvM5SGy0Pzfk+fIhrxcd4vCSDvZeyoxdoS9EdlZhnU
         46GFzzearBCJuS+W1NZEfYs+5rDoC7v/qjJHYoufvT1+JE7jt1zs+F6eD8n5JC4b/Ysq
         dkQxQAIMbpTnJZ5NGESK2THxZwrQW8+OW4euyMsvaqsHyXvWWRF+Lj5gRHodgYl7Mc7u
         9f6h+L3avil6u2LcCb2bamFN/7TTZ+htBM2u0xIf/cwj6oZz8Aorx7XFjC7rpDMqm+nr
         +OoJk/Z1kK2igDbxyhgecGHzDBYqlnx8vuZ5UPbkds3xnCvmrYZaUFl7aOWdlQPY05be
         /A3w==
Content-Disposition: inline
In-Reply-To: <4F7A1F52.50706-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Mon, Apr 02, 2012 at 02:51:14PM -0700, Jens Axboe wrote:
> > Other than $SUBJ update on the eigth patch from "blkcg:
> > blkg_conf_prep()" to "blkcg: simplify blkg_conf_prep()", the patchset
> > can be applied as-is on top of the current block/for-3.5/core.
> 
> Alright, pulled in as well. I'm glad we pushed this to 3.5 :-)

Yeah, I'm fairly sure if we had shoved this through 3.4, we would be
having another round of f**k you's from Linus.

I'll probably send one or two more rounds of patches to clean up
in-place blkg updates and make active policy selection per
request_queue, but I'm glad to finally have the end in sight.

Thanks.

-- 
tejun
