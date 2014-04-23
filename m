From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Wed, 23 Apr 2014 13:01:41 -0400
Message-ID: <20140423170141.GJ4781@htj.dyndns.org>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zrsQ9yH06dGSBuQ/6ezFfLfxmF8EY0zJhgT4Z2YRYww=;
        b=XnagRxQ5hTAl83nkt6DBzz2CcMXB8S91v00OTbc4AQsDedBGmlBzsS7y8YFhfTjzqz
         dxLG43xtzr3uX/4ejfZQlyHg1kp7kPiiBmFMRAqvfyAoY24TFeTKhZbROBdG8pql7lCm
         aX5dTK/r4MOFlTLV+c7vlT3GJuh9/wm5FJnufUSSYK1aTo2fxAvVPlFfbtd4oUk9Kdpx
         qFogz8+DzkzpuPjkA3BeADiAhKOMwZArVHvZYFy7qcNhbJXH+O9PKrgP8z/kgZO5j+At
         2AV7xpEl2YuRFZz3pEGofwNz5kLVcNq90LRrl7j50ZAkAkhm/UZAgmDdQzgdG5ZKE0xb
         uU4w==
Content-Disposition: inline
In-Reply-To: <20140415141826.GB17018-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 15, 2014 at 10:18:26AM -0400, Vivek Goyal wrote:
> Ok, that's fine. Let us just document the knobs well so that people can
> find which knob is giving what information and make cfq names better at
> the expense of inconsistency of names with throttling layer.

I've been thinking about it more.  Why do we even have separate stats
for common things like bytes transferred?  It doesn't serve any
purpose to do double accounting and reporting on everything, does it?
Shouldn't we just have single set of common stats for things like
requests / bytes serviced?

Thanks.

-- 
tejun
