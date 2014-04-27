From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Use more current logging style
Date: Sun, 27 Apr 2014 07:30:37 -0400
Message-ID: <20140427113037.GA20040@htj.dyndns.org>
References: <1397748555-6647-1-git-send-email-nasa4836@gmail.com>
 <20140417153800.GO15326@htj.dyndns.org>
 <1397757955.3104.11.camel@joe-AO725>
 <20140417191416.GS15326@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QqsbBNZw/llN/MSAq+jnbT6wQTA8Bxxetw6HLrOHXVw=;
        b=u+NCgfi2jXRaD1R8JOElP4Uhr1pAAru4Ylt6/1tbtQ3MCjkuRvuv1We3E5TJfEuLUr
         sY4wkM4QzGMjHeO6rpR8gkbGkpmiOZUMpXeXmLQUNB3/6kkucS76rlc/2rU2+LAJM0e5
         QrZVNxf4HN+V5eifRERcHO9gxj3NYG4uTSvuS3zILLAFvWoFRxgOQXwVARhDMbwwlwkN
         ry57pheB9g2X21bAYaD/mfpiAfyIHF2J/YrU/OcfHPsoZjmrcyUpvegQd0WCABSiLcgp
         jOtl6hTERDYGavG7D4obvovCqplGOwhh5KILdSKYmq1SIyTCwcz4D12diKMIB3IkloAo
         KjZQ==
Content-Disposition: inline
In-Reply-To: <20140417191416.GS15326-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 17, 2014 at 03:14:16PM -0400, Tejun Heo wrote:
> On Thu, Apr 17, 2014 at 11:05:55AM -0700, Joe Perches wrote:
> > Use pr_fmt and remove embedded prefixes.
> > Realign modified multi-line statements to open parenthesis.
> > Convert embedded function name to "%s: ", __func__
> > 
> > Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> 
> Rolled into the series.  Will be applied after Jianyu's patch.

All patches applied to cgroup/for-3.16.

Thanks.

-- 
tejun
