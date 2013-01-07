From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] block: implement blkcg hierarchy support in cfq,
 take#2
Date: Mon, 7 Jan 2013 08:34:37 -0800
Message-ID: <20130107163437.GF3926@htj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <20130102182037.GC4306@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=pig4YssUUKNXwXq2qpEjgS7W000vkbf70JUTvLcIufA=;
        b=qAXG2zh8ZzCfRiIHB70R3psctOHy7/YKIFf3cVoUrMfLWI4GrJzXnfao6pMa0zQKe5
         tUqKsjilQeHWySuKc8Rv16Ms56T01/N2H/Ccqhkv52bFIP0rSH8EBBPj/De346gif+0R
         /ECsfd1vtyHP1h6qsG1vrEVyrYuVcIvcoEkmVPHnCkFj7fl5aYY7PE4uK4qBkQCRdaHk
         X260H0mfgsoZtxt2ueQZCAMP0etYVw1iPRDJihT5n/0qB4xg+GLq2bfgENkRe4XSskCO
         +P2A1wy/Oxf0/TC07Qnc1qoYrzTDuPDfeOy5YoU7Y0r+h7iCxGEd4XDbwU5XnGw56i6J
         eM8g==
Content-Disposition: inline
In-Reply-To: <20130102182037.GC4306-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Wed, Jan 02, 2013 at 01:20:38PM -0500, Vivek Goyal wrote:
> On Fri, Dec 28, 2012 at 12:35:22PM -0800, Tejun Heo wrote:
> 
> [..]
> > 
> > * Updated to reflect Vivek's reviews - renames & documentation.
> 
> Hi Tejun,
> 
> You forgot to update blkio-controller.txt.

Just updated.  Does everything else look okay to you?

Thanks.

-- 
tejun
