From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 5 Sep 2012 02:56:06 -0700
Message-ID: <20120905095606.GN3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346835993.2600.9.camel@twins>
 <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50471782.6060800@parallels.com>
 <1346837209.2600.14.camel@twins>
 <50471C0C.7050600@parallels.com>
 <20120905094520.GM3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50471FEE.8060408@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2TSOsKhRWAGGUDwoAQJnsZ3uLJ3dbvTdWvYCOvZsOg4=;
        b=tDRgl5IXQ3/AutYUQ3KjD7aiIwdb16tF2PbDLJpG3Jl35n8EnRSnpWotBpH2W1ui+9
         VF9O+1WNFDBIvBwCJQ6HcKyuIIZLmI3QLpTWr8QjhpLdTBrppLiL1CkdRajIVzYpPNbp
         m7Fcv2ORiX7Obp+a6/HBXmOQcMKMeXcaLgf6AYKgYZwgERyMeHouejy8mP/MWaCPSt+1
         CVqZ4IN0Fykd94kMNwTIwSHDA2Av3HoOGoShV7e0M7iFMLuzowKqIhcSiVaPMqfWazZf
         GwLDRsT7clNCEcnyw4bo5XsGizpPyzBsB4/uTsiEzRwnVEB/7TPzZs5h+j/W8YEpSxRi
         4Njg==
Content-Disposition: inline
In-Reply-To: <50471FEE.8060408@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com, ben@decadent.org.uk, pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org

On Wed, Sep 05, 2012 at 01:48:30PM +0400, Glauber Costa wrote:
> > Nope, as I wrote in the other reply, 
> 
> Would you mind, then, stopping for a moment and telling us what it is,
> then, that you envision?

I thought I already explained it a couple times in this thread (also
in the big thread from several months ago).  It's nearing three in the
morning here.  I'll try to explain it better tomorrow.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
