From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 5 Sep 2012 01:14:39 -0700
Message-ID: <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
 <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=3tn6Nx4MAcupcur17xfDrRjSqPp/+xoUm3uB6OjQAM8=;
        b=WfBsZ9aGYtPaQEqMTPtskEDSc05j6VB0c56hLirGZ8xlXB4Oj1xoUFa5L0mMyvZWKl
         wv36sIPZsuZ4LFs40aMDuvUy6g+dmVrHhFd7QSmsJYX+3K0ooGzI6xAD6lNPkPG68k7T
         epAz+slujSmdbQTyxQzls2vwbYGe7MzNfWZXsBOr0pqtbJfC9W0VQKIG40lP78aSZxaS
         EH4uVYFgnByAuVkvyak7wne/XG4gvXlO4U7hS7JBmYkbTqMSc23hqvlI86DmIrntzdSn
         hSljr1Oy3+XAVqVDcTnyj3j7/6f2XUwvA1AvzaWR2bBgVH8T7h5YW7pmqoNTYPrPIxuo
         UrbQ==
Content-Disposition: inline
In-Reply-To: <5047074D.1030104@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com, ben@decadent.org.uk, a.p.zijlstra@chello.nl, pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org

Hello, Glauber.

On Wed, Sep 05, 2012 at 12:03:25PM +0400, Glauber Costa wrote:
> The goal here is to have distributions to do it, because they tend to
> have a well defined lifecycle management, much more than upstream. Whoever
> sets this option, can coordinate with upstream.

Distros can just co-mount them during boot.  What's the point of the
config options?

> > Also, I really don't see much point in enforcing this almost arbitrary
> > grouping of controllers.  It doesn't simplify anything and using
> > cpuacct in more granular way than cpu actually is one of the better
> > justified use of multiple hierarchies.  Also, what about memcg and
> > blkcg?  Do they *really* coincide?  Note that both blkcg and memcg
> > involve non-trivial overhead and blkcg is essentially broken
> > hierarchy-wise.
> 
> Where did I mention memcg or blkcg in this patch ?

Differing hierarchies in memcg and blkcg currently is the most
prominent case where the intersection in writeback is problematic and
your proposed solution doesn't help one way or the other.  What's the
point?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
