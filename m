From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 33/33] blk-throttle: implement proper hierarchy support
Date: Tue, 7 May 2013 09:14:12 -0700
Message-ID: <20130507161412.GA4948@mtj.dyndns.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
 <1367880372-28312-34-git-send-email-tj@kernel.org>
 <20130507135511.GA7082@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=TVdr18KCFN7Vmg8SnqKJMd/LYroe3Z79eWG2aMu037w=;
        b=yt+TOGlXmwlCOlgaUV4CDdpcWJJa0g2xLkd2GPRTWMA2me/JyO4/HLdiS1RcdOeqiU
         kH4rkvA0zBMchRjWmk/ZQ8OobSS4GUpiBCc5fjYSk2CqJjOfKvNkGV7DPeW5EbhFJ8jU
         xIbGycaRgs9e1kaIm8axlNCmFf15Nm24JVY94ATSAJOegd+SePYUW9NdeIqxpKxUvNRZ
         xDCzlcdCtZaBVoO21nnFZLu3w7x++7DWbLt9HSbUGoH/Wfu13Hq9Ps0vXMQNCvl/cYvx
         RAzqUoAjTdgAVzuM4tAHo5kTvaNPccuH4rEXFG64GQ2QEBVliwNkYYRq4X4whN49/+nX
         PyCA==
Content-Disposition: inline
In-Reply-To: <20130507135511.GA7082-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Vivek.

On Tue, May 07, 2013 at 09:55:11AM -0400, Vivek Goyal wrote:
> So if somebody does not specify __DEVEL_sane_behavior, hierarchy is
> still broken. Should we continue to display the message in that case?

The message is to warn people of possible behavior changes.  For
blk-throttle, the behaviors are settled now.  Whetner sane_behavior or
not, the hierarchy behaviors aren't gonna change anymore.  The
hindsight is 20/20 and it would probably have been better if we had
done the same for cfq but I was thinking that we could probably do
away with interface versioning at the time.  Ah well... it isn't
optimal but that's what we ended up with.

Thanks.

-- 
tejun
