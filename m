From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/8] blkcg: make sure blkg_lookup() returns %NULL if @q
 is bypassing
Date: Fri, 13 Apr 2012 10:28:41 -0700
Message-ID: <20120413172841.GC12233@google.com>
References: <1334273380-30233-1-git-send-email-tj@kernel.org>
 <1334273380-30233-6-git-send-email-tj@kernel.org>
 <20120413160053.GE26383@redhat.com>
 <20120413170334.GB12233@google.com>
 <20120413172336.GF26383@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=AzvJ1hBE0fEmuCgY6fyVv5oCTdOEH5cC80rvC7UrMz4=;
        b=Q2KsiYjxuZ3rLp1yACorTFYn0gqbpxq+vGpMsW1KXDQSbP0gAlQI/rGoHLhpCQrVnj
         jqaGtjClUFjD0xtkc3xayU/5qJNmtm5BtOts9KMQuqrd2xkKVMWj+Iv+W58zJu4qplWu
         fYEe8X7DWylCo+XCzBQzmFhixTjmSC29mqdwSyr794BAdSqcPhHtSupfRbvcFadpFl3k
         S3lI8v42lWzYFBUPGUTvLopjU5yhBtBgzMlDgIfdbjMHxkUbZv3OXtapII2yqMqO2zML
         xrmH92zaImf2QT0nsCaOgJBK/Bp8tWpGVKaFekbRWtGCifUbM8FLZJ+aT8OXldPrbGPl
         iK9Q==
Content-Disposition: inline
In-Reply-To: <20120413172336.GF26383-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Fri, Apr 13, 2012 at 01:23:36PM -0400, Vivek Goyal wrote:
> I think now synchronize_rcu() has become part of cfq_init_queue()
> effectively and that will slow down boot. In the past I had to remove
> it.

Eh... crap.  You're right.  Forgot about that.  Maybe we need to
special case initial queue setup.  I'll look into it.

Thanks.

-- 
tejun
