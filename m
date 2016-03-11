From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] cpuacct: rename parameter in cpuusage_write for
 readability
Date: Fri, 11 Mar 2016 12:42:58 -0500
Message-ID: <20160311174258.GI24046@htj.duckdns.org>
References: <cover.1457082730.git.zhaolei@cn.fujitsu.com>
 <874fad2881cb09366a618093a05141847ad9a9fa.1457082730.git.zhaolei@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S4Gpg5C7teRGr4+O3HFnBPmdgmK5oKnUpcfq1gnOd+4=;
        b=GHmfdKEsE52E7cHY8kcZetLI3EVV4ABssVHeZXV7EeOtowOy0R3T9hJuhsFoJ518Z1
         TsvMbIqMrGpgWX8FG18L10U3qc8X/p9jk7IWxQSOwKh442mI0ZtxGVTO+ffHljRPsC9Q
         M/cI9tAP9n0K39ZCsOX6dHi1m+9HAe/MuqAuQ+sVCcJ4qiStx3iRJpOg8bmub0Vqv75t
         Jka/NaCSBqqTjeKCKKZ7KydBP5vDDF+xfgIHRaxebBxiJoQN1ZToHk8oL32hcGDb1SLh
         Qc/jgdklEn94TCRSnYV2Iln6/vr8+fALu/d5z84naLplsHz3iGmvZ6k7d4+uoGDrUXRZ
         AS1w==
Content-Disposition: inline
In-Reply-To: <874fad2881cb09366a618093a05141847ad9a9fa.1457082730.git.zhaolei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhao Lei <zhaolei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Yang Dongsheng <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

On Fri, Mar 04, 2016 at 05:47:05PM +0800, Zhao Lei wrote:
> From: Yang Dongsheng <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> 
> The name of 'reset' makes a little confusion in reading, we would
> say, if we want to reset usage, return -EINVAL. That's not true.
> 
> Actually, we want to say, we only allow user to do a reset. This
> patch rename reset to val and add a comment here, making the code
> more readable.
> 
> From: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> Signed-off-by: Zhao Lei <zhaolei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
