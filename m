From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET block/for-4.3] blkcg: implement interface for the
 unified hierarchy
Date: Mon, 27 Jul 2015 14:13:18 -0400
Message-ID: <20150727181318.GA16393@mtj.duckdns.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
 <20150727161209.GB16064@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=8Yx+LNnMsBzgGjWjoKyCaNO3mQtZdSjKcI8OnIvhuSA=;
        b=xqyIkJCO5blVDsO3YwI5kSMJyUT3v8GaxS3zttmyKrs2RuRDafZWBJr9/iAvGYPKaE
         XjrKVbe0bPiNLamr93YnxjCalLd8Nu1t7kc1ruWmQ1Vfq2b/SdL2T5yGsvPLuHud8i9j
         slLvErG0tBdV36dIKk5RoAFyDIVlBCicw6rGk6p5TeM5Lb60bQQH40YDR1TTiLzPYt3/
         76f1uOQkhTKt6SIxH+z2qZKWogefgnn3bpGgVqgKH5jYrdimC+tkKXWn4Ba/YSugt5ce
         2zKYejqB8HCeeW5UcfhLI+QVZs7BWwvTqP7QYRF2LDVM2wBDKFTgkq0yPqMKlQ3z63F1
         ROyQ==
Content-Disposition: inline
In-Reply-To: <20150727161209.GB16064-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Jul 27, 2015 at 12:12:09PM -0400, Vivek Goyal wrote:
> I browsed though the details of above knobs and it sounds great. It is
> clean and much less number of knobs and files. You got rid of all the
> debug CFQ knobs which is good. I was not happy with these either. Glad

Yeah, especially given that CFQ may be replaced by BFQ.

> to see that all the magic about leaf weight is gone. That was really
> mind bending. Knob for reset stats is gone and instead of mutiple files
> for configuration now we are using single file for R/W BPS/IOPS
> configuration.
> 
> I will do some basic testing and see if something pops up.
> 
> Userspace will need to understand these new files but that's the
> understanding anyway that unified hierarchy is different and needs
> to be handled differently.

For blkcg (and memory too), the usage model changes so drastically
that I don't think blkcg interface changes would matter much.
Everything is changed anyway.

Thanks.

-- 
tejun
