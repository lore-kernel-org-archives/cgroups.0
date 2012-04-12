From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 0/7] memcg remove pre_destroy
Date: Thu, 12 Apr 2012 09:06:42 -0700
Message-ID: <20120412160642.GA13069@google.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=M/ADfApD7rYBWDP+1lU72+qm2+stJ+wDyA8FBMZ/Oxk=;
        b=Fp4KRXGE2ww2KUp15w0x/9FTL4LuNQOkOxWIV7tV4tL4wLQgLlwxAJiaLm250Ucvtd
         1s94Ldij8C+UT219uSIQZGpHZfPZujnyR7wQflGgDZd0ZTBsMO5XGSj3q+LXoeiv22Ol
         lTxMrJFcPHqwgu2Zr5AS6MtBNLxcmgXUmCpTW6Y1quYniqYtYJv0ZPtT0eM3JOV94WmX
         okd7Ov6otQ1km/CCwzdSdkVlO3A+AlqLN0lw6X2VICp6BQP89s7TV2aZaugS+oebBDwy
         IozmZx085bm5BCfHXW+ViBaqZ/tGXXVekOf9WApPsH2ceo6329tAyydFWs0D364xaE9c
         iBFQ==
Content-Disposition: inline
In-Reply-To: <4F86B9BE.8000105-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, KAMEZAWA.

Thanks a lot for doing this.

On Thu, Apr 12, 2012 at 08:17:18PM +0900, KAMEZAWA Hiroyuki wrote:
> In recent discussion, Tejun Heo, cgroup maintainer, has a plan to remove
> ->pre_destroy(). And now, in cgroup tree, pre_destroy() failure cause WARNING.

Just to clarify, I'm not intending to ->pre_destroy() per-se but the
retry behavior of it, so ->pre_destroy() will be converted to return
void and called once on rmdir and rmdir will proceed no matter what.
Also, with the deprecated behavior flag set, pre_destroy() doesn't
trigger the warning message.

Other than that, if memcg people are fine with the change, I'll be
happy to route the changes through cgroup/for-3.5 and stack rmdir
simplification patches on top.

Thanks.

-- 
tejun
