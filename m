From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Date: Tue, 22 Jan 2013 16:27:54 -0800
Message-ID: <20130123002754.GB5359@htj.dyndns.org>
References: <50F7B040.2020906@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=/IDDTOUBNyyRhkV7bKFP3NDYXJchTEJ7gD7/Cj/NR34=;
        b=D4893yKdeePToB+NItSx89yNrsngqup00zItkedp+mW949kNKyzTDFCBraW0PdHYoW
         2PzKfaToIxI+PAlr/MaofR59j+Et0UHPpbX4QfADAGPJbbVn0Fd6fwsDbTFToPg/uS39
         h0kLkB6ylv8Mlc0QHl7ZGkHKu21HgQp72mtaD/Ggfu/NcwqDAUoYIHleUSpAE7vfoPpJ
         ru+VvgG1MvtIRXP1cmREsn2utwXuwgejPWzg7YFq2OiCcDTG4PGV7s29XVqXxV4jm7Xw
         yLh/I1aMV77emW8As4rWXIi9uGwlHgZmAmKPfTnYa9V5f9IXENxPokogpCpcPC0LQpix
         /pWw==
Content-Disposition: inline
In-Reply-To: <50F7B040.2020906-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

(cc'ing Andrew as scheduler folks are difficult to get response from
 these days and I can't think of anyone else to bother :)

Hello, Li.

The cgroup part looks good to me but it would be great if the
descriptions are more detailed, especially, about why the change is
beneficial or what it's aiming at.  I take it that the shed changes
are necessary to facilitate the later cgroup changes?  Can you please
elaborate how?

The scheduler part of changes are mostly mechanical, so it would be
great if we can get ack from scheduler people and route these together.

Thanks.

-- 
tejun
