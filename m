From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/15] cfq-iosched: Rename "service_tree" to "st"
Date: Wed, 3 Oct 2012 09:59:39 +0900
Message-ID: <20121003005939.GB15806@localhost>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
 <1349119976-26837-4-git-send-email-vgoyal@redhat.com>
 <x49ipatj4oy.fsf@segfault.boston.devel.redhat.com>
 <20121002132603.GB758@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Y3ANsZ0bSFJAqe/XQXlcWucr8A/1LlVJ0AHKX4K/THk=;
        b=se3er83Ia1t1ypeJHWCZBzFGtALfe1Os5miAPDfcv6VWXcwELrni6g6DlBsMS/SdQ7
         xJXsaSC1rG9GDlF2AvhO2VTWTn0jIA0rV4PQ2USAVaSe5dvRTPLNEK2wcTw3aUwZtb1k
         JmoUe7FKyUwVGlqzH4S8DH7oE4xubL/Y23d4C012Yj5T2n2H3hQMB4Io8K2h9YaZ4yce
         OC3ZnQINIns8xdlEvPiVUL+7RKe14VBM5mCEojzHRprKuZqPwgkbO7vzpHOrbKQvQqsr
         UPJpj05mH9x75QBwWcb/PYyADKhIo5foCr+cVfD2QRI4dRniBvdTgmZnUvEYIElnfMjf
         ZEEA==
Content-Disposition: inline
In-Reply-To: <20121002132603.GB758-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Oct 02, 2012 at 09:26:03AM -0400, Vivek Goyal wrote:
> Yes this one is little odd. Ok, I will change it back to "service_tree"
> and only use "st" for local variables and in some function names.

Yes, please do that.  In general, it's beneficial to use at least
somewhat descriptive names for globals / struct fields and use
consistent shorthands for local variables dealing with them.

Thanks.

-- 
tejun
