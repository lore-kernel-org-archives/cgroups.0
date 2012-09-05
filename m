From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 5 Sep 2012 02:22:16 -0700
Message-ID: <20120905092216.GK3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
 <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346835993.2600.9.camel@twins>
 <1346836041.2600.10.camel@twins>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=OpBbMZDBvbXui/W34c1T178X/Wfoq5tWXpVEia65tlo=;
        b=V1nWHVq/Q6y6rea3Tye8P5BhrSvQ9W4wJNdZ787Q1kbJg9aw8wVM3OcOGOsInyZrzc
         HrxtWJ/exSW2EtMWlBNXzSDF7IWh3WmFa1HI90CmdBfgWN0pfGSWJnae/z0W3O1CamBG
         Evi6xSUWVQtvBj11SbB/aaDetjDa45iLVrxT9qHnADZjNg5sCYfjOhbRMlEjJh/yfGRK
         h+WgNXA1+jl42F+Y+F6oZ4GDI7oXnKd5gf/fTVAzx5OEFDtBnCeG5g+Sb6VB7ixFv6wm
         pXQCLEtLUMcz7BnB0lZCsg621pw8QxQYhLiCdy7HPqtvYfZ7ULpTKX3GX/pM1tJoL0sg
         HkIg==
Content-Disposition: inline
In-Reply-To: <1346836041.2600.10.camel@twins>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com, ben@decadent.org.uk, pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org

Hey,

On Wed, Sep 05, 2012 at 11:07:21AM +0200, Peter Zijlstra wrote:
> Glauber, the other approach is sending a patch that doesn't touch
> cgroup.c but only the controllers and I'll merge it regardless of what
> tj thinks.
> 
> We need some movement here.

Peter, I don't think the proposed patch is helpful at this point.
While movement is necessary, it's not like moving towards any
direction is helpful.  They might just become another cruft which
needs to be maintained.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
