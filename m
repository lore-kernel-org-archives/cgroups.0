From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 6/6] blkcg, memcg: make blkcg depend on memcg on the
 default hierarchy
Date: Tue, 8 Jul 2014 17:53:51 -0400
Message-ID: <20140708215351.GJ4979@htj.dyndns.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
 <1403917392-32555-7-git-send-email-tj@kernel.org>
 <20140628114907.GA10829@htj.dyndns.org>
 <20140708194226.GA18382@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=//s0Nf09+yE5HcR2FXCp7kMNYb2Tx3bU2vdts6g1qfo=;
        b=XjslkEFGKxVr/NrJ7f/8XJy+O0LpDmLQTRyeI4r+fFxAFMx9JCtzYT6WJ30yE0v8W/
         FLmgdxGvl+10pUV9Y9K2H939YqCl2NQ5Qv86HZrRjbzyy8F0aFmWUeVeAF5Ui9brtNSF
         umZN3e8LlhwB/Iz0QCi7hj8BYHtDZ42+KBUG9fHYqg3lkOPENiNWFMznWCTfaMlqL+bk
         R/9PICFZGa4TVyWD52RZ/oGc7tzvMqw+Vl7vRECQ9K9f5e/8P8H0tGFzj7Nix6AiuW+z
         tC81G5l0Fe1c7AS59HbTIjMlJj+/HU9UNrDCYzZd8ocYJi2A2Olrvh8OOvLbSCv7NmXC
         L1sg==
Content-Disposition: inline
In-Reply-To: <20140708194226.GA18382-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

Hello, Vivek.

On Tue, Jul 08, 2014 at 03:42:26PM -0400, Vivek Goyal wrote:
> I have couple questions about new semantics. Following is my
> understanding. Is it right?
> 
> - So after this change one can not use blkio controller on unified
>   hiearchy if memory controller is mounted on some other hierarchy
>   and is not available for mounting unified hiearchy.

Hmmm?  No, the only behavior which changes is when both blkcg and
memcg are mounted on the unified hierarchy.  Nothing else changes.
The dependency behavior kicks in iff memcg is available on the unified
hierarchy.

> - If blkio controller is enabled on unified hiearchy (memory controller
>   implicitly enabled), then one can't mount memory controller on other
>   hierarchies without first disabling blkio controller on unified hiearchy.

Yes, blkio needs to be disabled to the root for memcg to be able to
become free.  This is an extra restriction but I don't think it's
anything drastic.  Once a controller starts being actively used on any
hierarchy, nothing has been guaranteed about when the controller would
become free again even if the whole hierarchy is reduced to the root.

Thanks.

-- 
tejun
