From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 2/4] cgroups: replace explicit ss_mask checking with
 for_each_subsys_which
Date: Wed, 22 Apr 2015 11:31:21 -0400
Message-ID: <20150422153121.GC10738@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-3-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QF/wj/Di9QyE7OvhnBowQ5UfHWpsx7y3Euqkx7nYG1E=;
        b=vEEER9YBCqWZ23nZWXiHlPHGMF+jIi7y+648/rG8XxE/xzqO8HY2U7niZtIEg/Br3+
         UEAUd9JQ1WE13mMhP1oaX6+jOiGFBw64KeQ6Wmb7lbK50Xps1yEXP6CgCnIOl4HkiCoo
         V6dG2hI/E3hS6m/zie12QotyzSU3/Ejxt7hQ8NQcNZtqdxQGJFISlq60CPjuwEv+QpMz
         IdxrgG1VcEPI2wMgqbOfs6Kbb1xpyi5oB3g09Z3Hixpu3xEtOgYbIiIAar8R9KmlzxMd
         1R6sqNLc9LFFOns9Tch4SYOKV/S63OSoB2b5R+jDl38b1NABj0EsWXohPPsYcGr4TD/w
         geYw==
Content-Disposition: inline
In-Reply-To: <1429446154-10660-3-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Apr 19, 2015 at 10:22:32PM +1000, Aleksa Sarai wrote:
> Replace the explicit checking against ss_masks inside a for_each_subsys
> block with for_each_subsys_which(ss_mask, ...), to take advantage of the
> more readable macro.
> 
> Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Looks good to me.

Thanks.

-- 
tejun
