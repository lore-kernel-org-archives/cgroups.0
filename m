From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blkcg: add plugging support for punt bio
Date: Tue, 8 Sep 2020 14:03:02 -0400
Message-ID: <20200908180302.GE4295@mtj.thefacebook.com>
References: <1596722082-31817-1-git-send-email-xianting_tian@126.com>
 <8f84e1fe-9fa5-b7e7-1f2f-b0c4a40614e2@kernel.dk>
 <42b939c2.e08.173c6f79af9.Coremail.xianting_tian@126.com>
 <1ded6246.2c67.17458ce4300.Coremail.xianting_tian@126.com>
 <65e1e040da644ed9a05edd166d06b5e3@h3c.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9mmDYx8WrU8rvHetKafuDvQNZNEWur0WVQdCgfEZspw=;
        b=SPoVuP8Q6WzCw4D9NfkuXnNEptqRql+J4fajBqQc2kYsIhfgOYk0tEnacAbvowX1iH
         2HgdyOoKtpvck6By0pNhFJcCOunkqWjl1JRzB0GS2+WGlkYvhTBUzobypXqZwLPOYibT
         xt8Zl3up/YriK4ErSIiCCMeyzZTRfS3d4j3xIaFGJZbVBrYfKR4wOZkZXYMQ1AYpuiU7
         8b6dAZPZMG5ggCV7UZI9MBPStx8lOwxR0DxqFyfvocgsBQy18+BFgkiSxtRpL4KUFzOM
         UnZoy5BRkMnhnH5ejxOYYoUIK1COU05dLo0PqODWfSyByRIY7crPD5mm0SSR7OTFb536
         Vzjw==
Content-Disposition: inline
In-Reply-To: <65e1e040da644ed9a05edd166d06b5e3-vVzyEvZLFYE@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tianxianting <tian.xianting-vVzyEvZLFYE@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, Sep 05, 2020 at 11:25:03AM +0000, Tianxianting wrote:
> Hi jens,tj
> Could you share a couple of  minutes to comment it?
> I really appreciate it

The result looks fine to me but can you please summarize that in the commit
message of the patch?

Thanks.

-- 
tejun
